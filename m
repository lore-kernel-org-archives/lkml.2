Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653Ab2KTF5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:57:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2KTF5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:57:36 -0500
Date: Mon, 19 Nov 2012 21:57:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Erwan Velu <erwanaliasr1@gmail.com>
Cc: ak@linux.intel.com, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: Unexpected latencies on lseek() SEEK_SET on block devices
Message-Id: <20121119215730.d346cefd.akpm@linux-foundation.org>
In-Reply-To: <509AC911.1040700@gmail.com>
References: <509AC911.1040700@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Nov 2012 21:48:17 +0100 Erwan Velu <erwanaliasr1@gmail.com> wrote:

> Hi fellows,
> 
> I'm been facing some lseek() troubles on a very light hardware (Atom E660) under heavy load (network + cpu  + disk IOs). I'm using 3.2.32 on a 32bit Os with a local SSD as mass storage.
> 
> If a do open a block device like sdb1 and lseek SEEK_SET in it, some unexpected latencies occurs.
> Using the same load, everything works perfectly by using contigous streams but once I do lseek it start to be laggy. I've been searching around for a while and finally found this message : https://lkml.org/lkml/2011/9/15/399 from Andy.
> 
> The description was very similar to what I experienced but the patch from Andy was on to the fs layer.
> 
> I've been looking the code for the block level layer and found the implementation is pretty different.
> http://lxr.linux.no/#linux+v3.2.33/fs/read_write.c#L69
> vs
> http://lxr.linux.no/#linux+v3.2.33/fs/block_dev.c#L353
> 
> As I can see, we do first put the mutex, then i_size_read and then considering the kind of SEEK we want.
> The semantic changes from the read_write implementation where it does the locking only for SEEK_CUR and i_size_read isn't executed for SEEK_SET.
> 
> So I really wonder if we shall rework this part to avoid the uncessary locking for all of them except SEEK_CUR and remove i_size_read from SEEK_SET. The i_size_read is also a matter as it does a memory barrier. On such low-end hardware I have, that could costs.
> 
> I can work on it and validate its performances unless the experts you are told me this is a mandatory feature.
> 
> Thanks for your attention and comments on this topic.

If your lseek()ing process is indeed blocking on i_mutex then something
else must be holding it.  ie: there's some heavy I/O happening against
that device at the same time?  Tell us more...

Another possibility is that the delay is not in lseek() but is actually
in the device open/close, doing lots of pagecache invalidation and/or
writeout.  It used to be the case that blockdev close() would do a
heavyweight flush/invalidate, but I haven't checked lately.

