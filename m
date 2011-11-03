Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987Ab1KCQOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:14:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35442 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933739Ab1KCQOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:14:42 -0400
Date: Thu, 3 Nov 2011 09:14:36 -0700
From: Tejun Heo <tj@kernel.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: NULL ptr deref at elv_drain_elevator
Message-ID: <20111103161436.GJ4417@google.com>
References: <4EB2BC88.3070105@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB2BC88.3070105@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 05:08:40PM +0100, Jiri Slaby wrote:
> Hi,
> 
> I'm seeing the NULL ptr dereference below on each boot of KVM virtual
> machine. q->elevator is NULL. This is next-20111025.
> 
> I tried to apply Tejun's patch from:
>  https://lkml.org/lkml/2011/4/30/87
> but it doesn't help. Maybe I should revert something?
> 
> Scanning for LVM volume groups...
> Reading all physical volumes.  This may take a while...
> No volume groups found
> BUG: unable to handle kernel NULL pointer dereference at           (null)
> IP: [<ffffffff8125a69c>] elv_drain_elevator+0x1c/0x70
> PGD 46176067 PUD 452b5067 PMD 0
> Oops: 0000 [#1] SMP
> CPU 0
> Modules linked in:
> 
> Pid: 830, comm: kworker/0:2 Not tainted 3.1.0-next-20111025_64+ #1590
> Bochs Bochs
> RIP: 0010:[<ffffffff8125a69c>]  [<ffffffff8125a69c>]
> elv_drain_elevator+0x1c/0x70

Heh, probably md is tearing down a queue which isn't fully setup.
Does the following fix the problem?

Thanks.

diff --git a/block/blk-core.c b/block/blk-core.c
index f658711..5292e31 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -408,7 +408,8 @@ void blk_cleanup_queue(struct request_queue *q)
 	mutex_unlock(&q->sysfs_lock);
 
 	/* drain all requests queued before DEAD marking */
-	blk_drain_queue(q, true);
+	if (q->elevator)
+		blk_drain_queue(q, true);
 
 	/* @q won't process any more request, flush async actions */
 	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);


-- 
tejun
