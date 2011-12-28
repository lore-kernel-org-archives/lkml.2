Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab1L1Vsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 16:48:38 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:11807 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754244Ab1L1Vsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 16:48:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoKAGyL+055LbVv/2dsb2JhbABEqyuBOoEGgXIBAQQBJxMcIwULCAMOCi4UJQMhE4d6tSMTi3wElQGKc4dW
Date: Thu, 29 Dec 2011 08:48:32 +1100
From: Dave Chinner <david@fromorbit.com>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs: blocked for more than 120 seconds, made worse by 3.2 rc7
Message-ID: <20111228214832.GG12731@dastard>
References: <4EFB6D4F.6070002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFB6D4F.6070002@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 09:26:07PM +0200, Konstantinos Skarlatos wrote:
> Hello all:
> I have two machines with btrfs, that give me the "blocked for more
> than 120 seconds" message. After that I cannot write anything to
> disk, i am unable to unmount the btrfs filesystem and i can only
> reboot with sysrq-trigger.
> 
> It always happens when i write many files with rsync over network.
> When i used 3.2rc6 it happened randomly on both machines after
> 50-500gb of writes. with rc7 it happens after much less writes,
> probably 10gb or so, but only on machine 1 for the time being.
> machine 2 has not crashed yet after 200gb of writes and I am still
> testing that.
> 
> machine 1: btrfs on a 6tb sparse file, mounted as loop, on a xfs
> filesystem that lies on a 10TB md raid5. mount options
> compress=zlib,compress-force
> 
> machine 2: btrfs over md raid 5 (4x2TB)=5.5TB filesystem. mount
> options compress=zlib,compress-force
> 
> pastebins:
> 
> machine1:
> 3.2rc7 http://pastebin.com/u583G7jK
> 3.2rc6 http://pastebin.com/L12TDaXa

These two are caused by it taking longer than 120s for XFS to fsync
the loop file. Writing a signficant chunk of a sparse 6TB file on a
software RAID5  volume is going to take some time.  However, if IO
is not occurring, then somewhere below XFS an IO has gone missing
(MD or hardware problem) because the fsync on the XFS file is
blocked waiting for an IO completion.

> machine2:
> 3.2rc6 http://pastebin.com/khD0wGXx
> 3.2rc7 (not crashed yet)

These don't have XFS in the picture, but also appear to be hung
waiting on IO completion with MD stuck in
make_request()->get_active_stripe(). That, to me, indicates an MD
problem.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
