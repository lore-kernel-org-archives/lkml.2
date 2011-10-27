Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab1J0MRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:17:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52319 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab1J0MRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:17:03 -0400
Date: Thu, 27 Oct 2011 15:14:33 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] eventpoll: possible recursive locking detected
Message-ID: <20111027121432.GA3039@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
Hit this lockdep warning today (with 3.2-merge-window kernel). Below is my
naive approach.

------8<-------8<--------


Fix possible recursive locking, because both sys_epoll_ctl() and ep_scan_ready_list()
were trying to acquire the same ep->mtx mutex.

[   23.563357] systemd-logind/2373 is trying to acquire lock:
[   23.563568]  (&ep->mtx){+.+.+.}, at: [<ffffffff81146da5>] ep_scan_ready_list+0x3c/0x1a7
[   23.563922] 
[   23.563924] but task is already holding lock:
[   23.564155]  (&ep->mtx){+.+.+.}, at: [<ffffffff81147614>] sys_epoll_ctl+0x11e/0x20b
[   23.564504] 
[   23.565126] 2 locks held by systemd-logind/2373:
[   23.565130]  #0:  (epmutex){+.+.+.}, at: [<ffffffff811475cb>] sys_epoll_ctl+0xd5/0x20b
[   23.565152]  #1:  (&ep->mtx){+.+.+.}, at: [<ffffffff81147614>] sys_epoll_ctl+0x11e/0x20b
[   23.565165] 
[   23.565166] stack backtrace:
[   23.565174] Pid: 2373, comm: systemd-logind Not tainted 3.1.0-dbg-05709-g189f65b-dirty #759
[   23.565183] Call Trace:
[   23.565199]  [<ffffffff81072566>] print_deadlock_bug+0xea/0xf5
[   23.565210]  [<ffffffff81072696>] check_deadlock.isra.26+0x125/0x149
[   23.565220]  [<ffffffff81073af5>] validate_chain.isra.30+0x445/0x44f
[   23.565229]  [<ffffffff810746fd>] __lock_acquire+0x67e/0x6f5
[   23.565244]  [<ffffffff81146da5>] ? ep_scan_ready_list+0x3c/0x1a7
[   23.565252]  [<ffffffff81074d08>] lock_acquire+0x138/0x1b3
[   23.565259]  [<ffffffff81146da5>] ? ep_scan_ready_list+0x3c/0x1a7
[   23.565268]  [<ffffffff81146da5>] ? ep_scan_ready_list+0x3c/0x1a7
[   23.565287]  [<ffffffff814a4399>] mutex_lock_nested+0x5e/0x325
[   23.565296]  [<ffffffff81146da5>] ? ep_scan_ready_list+0x3c/0x1a7
[   23.565307]  [<ffffffff81146624>] ? sys_fanotify_mark+0x246/0x246
[   23.565314]  [<ffffffff81146da5>] ep_scan_ready_list+0x3c/0x1a7
[   23.565322]  [<ffffffff81146f10>] ? ep_scan_ready_list+0x1a7/0x1a7
[   23.565332]  [<ffffffff81146f22>] ep_poll_readyevents_proc+0x12/0x14
[   23.565340]  [<ffffffff81146b0a>] ep_call_nested.constprop.5+0x95/0xe1
[   23.565352]  [<ffffffff81146c35>] ep_eventpoll_poll+0x49/0x57
[   23.565363]  [<ffffffff814970c2>] ep_insert+0xd5/0x282
[   23.565373]  [<ffffffff81146b45>] ? ep_call_nested.constprop.5+0xd0/0xe1
[   23.565381]  [<ffffffff811467c6>] ? ep_poll_wakeup_proc+0x3c/0x3c
[   23.565396]  [<ffffffff81110f08>] ? drop_file_write_access+0x45/0x45
[   23.565407]  [<ffffffff81147673>] sys_epoll_ctl+0x17d/0x20b
[   23.565417]  [<ffffffff814ac3d2>] system_call_fastpath+0x16/0x1b


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 9026fc9..b5cf4a5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -481,7 +481,8 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	 * We need to lock this because we could be hit by
 	 * eventpoll_release_file() and epoll_ctl().
 	 */
-	mutex_lock(&ep->mtx);
+	if (!mutex_trylock(&ep->mtx))
+		return 0;
 
 	/*
 	 * Steal the ready list, and re-init the original one to the


