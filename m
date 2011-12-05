Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab1LEScn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:32:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47696 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab1LEScm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:32:42 -0500
Date: Mon, 5 Dec 2011 10:32:36 -0800
From: Tejun Heo <tj@kernel.org>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [regression] WARNING: at drivers/block/floppy.c:2929
 do_fd_request+0xb7/0xb9() in 3.2.0-rc2 and 3
Message-ID: <20111205183236.GI627@google.com>
References: <20111125103420.GO4581@charite.de>
 <20111205202114.6457443b@sf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205202114.6457443b@sf.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 08:21:14PM +0300, Sergei Trofimovich wrote:
> Same here on 3.2.0-rc4-00077-g5983fe2
> 
> 'swapper' cmd looks suspicious.
> [ CCing someone who is familar with block layer, sorry in advance ]
> 
> [    3.792015] floppy0: no floppy controllers found
> [    3.792274] ------------[ cut here ]------------
> [    3.792434] WARNING: at drivers/block/floppy.c:2929 do_fd_request+0xbf/0xd0()
> [    3.792587] Hardware name: To Be Filled By O.E.M.
> [    3.792738] VFS: do_fd_request called on non-open device
> [    3.792889] Modules linked in:
> [    3.793008] Pid: 1, comm: swapper Not tainted 3.2.0-rc4-00077-g5983fe2 #2
> [    3.793008] Call Trace:
> [    3.793008]  [<ffffffff81039a6a>] warn_slowpath_common+0x7a/0xb0
> [    3.793008]  [<ffffffff81039b41>] warn_slowpath_fmt+0x41/0x50
> [    3.793008]  [<ffffffff813d657f>] do_fd_request+0xbf/0xd0
> [    3.793008]  [<ffffffff81322b95>] blk_drain_queue+0x65/0x80
> [    3.793008]  [<ffffffff81322c93>] blk_cleanup_queue+0xe3/0x1a0
> [    3.793008]  [<ffffffff818a809d>] floppy_init+0xdeb/0xe28
> [    3.793008]  [<ffffffff818a72b2>] ? daring+0x6b/0x6b
> [    3.793008]  [<ffffffff810002af>] do_one_initcall+0x3f/0x170
> [    3.793008]  [<ffffffff81884b34>] kernel_init+0x9d/0x11e
> [    3.793008]  [<ffffffff810317c2>] ? schedule_tail+0x22/0xa0
> [    3.793008]  [<ffffffff815dbb14>] kernel_thread_helper+0x4/0x10
> [    3.793008]  [<ffffffff81884a97>] ? start_kernel+0x2be/0x2be
> [    3.793008]  [<ffffffff815dbb10>] ? gs_change+0xb/0xb
> [    3.793008] ---[ end trace c5807061655fec8c ]---

Does the following patch make the warning go away?

Thanks.

 block/blk-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ea70e6c..653cc22 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -366,7 +366,8 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 		if (drain_all)
 			blk_throtl_drain(q);
 
-		__blk_run_queue(q);
+		if (!list_empty(&q->queue_head))
+			__blk_run_queue(q);
 
 		if (drain_all)
 			nr_rqs = q->rq.count[0] + q->rq.count[1];
