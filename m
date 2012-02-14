Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2BNQ3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:29:08 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44238 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab2BNQ3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:29:05 -0500
Date: Tue, 14 Feb 2012 08:28:58 -0800
From: Tejun Heo <tj@kernel.org>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Naveen Goswamy <naveen.goswamy@polymtl.ca>, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: Kernel crashing on eject SD card
Message-ID: <20120214162858.GM12117@google.com>
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca>
 <20120212220836.6aa7fa4d@stein>
 <20120212222027.71651e8b@stein>
 <20120213021813.GA589@redhat.com>
 <1329154831.4f394b0f3c69c@www.imp.polymtl.ca>
 <4F3A4220.4010901@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3A4220.4010901@ce.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 14, 2012 at 08:14:40PM +0900, Jun'ichi Nomura wrote:
> The following commit has changed __blkdev_get() to end up calling
> sd_revalidate_disk() without getting a refcount of scsi_device:
> 
>   commit 1196f8b814f32cd04df334abf47648c2a9fd8324
>   Author: Tejun Heo <tj@kernel.org>
>   Date:   Thu Apr 21 20:54:45 2011 +0200
> 
>     block: rescan partitions on invalidated devices on -ENOMEDIA too
> 
> that could lead to oops like this:
> 
>   process A                  process B
>   ----------------------------------------------
>   sys_open
>     __blkdev_get
>       sd_open
>         returns -ENOMEDIUM
>                              scsi_remove_device
>                                <scsi_device torn down>
>       rescan_partitions
>         sd_revalidate_disk
>           <oops>
> 
> Should "revalidate_disk" of block_device_operations work
> without successful open()?
> 
> If so, sd_revalidate_disk() (and possibly other drivers) needs to be
> fixed. (e.g. use scsi_disk_get/put by itself)
> 
> If not, __blkdev_get() or rescan_partision() should avoid calling
> "revalidate_disk" for -ENOMEDIUM case.

Hmmm... right, that's a problem.  Missed rescan_partitions() calling
into driver.  What we should probably do is separating out
invalidation & partition shoot down into a separate function, say
trucate_disk(), and call that on -ENOMEDIUM instead of
rescan_partitions().  All that's necessary is killing the partition
devices (and maybe zapping device size to zero).  Any one interested
in trying it?

Thanks.

-- 
tejun
