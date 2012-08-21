Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab2HUWfD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 18:35:03 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33374 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab2HUWet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 18:34:49 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: LKML <linux-kernel@vger.kernel.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        linux-fbdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] console: implement lockdep support for console_lock
Date: Wed, 22 Aug 2012 00:34:32 +0200
Message-Id: <1345588472-4055-3-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345588472-4055-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1345588472-4055-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie recently discovered a locking bug in the fbcon layer,
where a timer_del_sync (for the blinking cursor) deadlocks with the
timer itself, since both (want to) hold the console_lock:

https://lkml.org/lkml/2012/8/21/36

Unfortunately the console_lock isn't a plain mutex and hence has no
lockdep support. Which resulted in a few days wasted of tracking down
this bug (complicated by the fact that printk doesn't show anything
when the console is locked) instead of noticing the bug much earlier
with the lockdep splat.

Hence I've figured I need to fix that for the next deadlock involving
console_lock - and with kms/drm growing ever more complex locking
that'll eventually happen.

Now the console_lock has rather funky semantics, so after a quick irc
discussion with Thomas Gleixner and Dave Airlie I've quickly ditched
the original idead of switching to a real mutex (since it won't work)
and instead opted to annotate the console_lock with lockdep
information manually.

There are a few special cases:
- The console_lock state is protected by the console_sem, and usually
  grabbed/dropped at _lock/_unlock time. But the suspend/resume code
  drops the semaphore without dropping the console_lock (see
  suspend_console/resume_console). But since the same thread that did
  the suspend will do the resume, we don't need to fix up anything.

- In the printk code there's a special trylock, only used to kick off
  the logbuffer printk'ing in console_unlock. But all that happens
  while lockdep is disable (since printk does a few other evil
  tricks). So no issue there, either.

- The console_lock can also be acquired form irq context (but only
  with a trylock). lockdep already handles that.

This all leaves us with annotating the normal console_lock, _unlock
and _trylock functions.

And yes, it works - simply unloading a drm kms driver resulted in
lockdep complaining about the deadlock in fbcon_deinit:

======================================================
[ INFO: possible circular locking dependency detected ]
3.6.0-rc2+ #552 Not tainted
-------------------------------------------------------
kms-reload/3577 is trying to acquire lock:
 ((&info->queue)){+.+...}, at: [<ffffffff81058c70>] wait_on_work+0x0/0xa7

but task is already holding lock:
 (console_lock){+.+.+.}, at: [<ffffffff81264686>] bind_con_driver+0x38/0x263

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (console_lock){+.+.+.}:
       [<ffffffff81087440>] lock_acquire+0x95/0x105
       [<ffffffff81040190>] console_lock+0x59/0x5b
       [<ffffffff81209cb6>] fb_flashcursor+0x2e/0x12c
       [<ffffffff81057c3e>] process_one_work+0x1d9/0x3b4
       [<ffffffff810584a2>] worker_thread+0x1a7/0x24b
       [<ffffffff8105ca29>] kthread+0x7f/0x87
       [<ffffffff813b1204>] kernel_thread_helper+0x4/0x10

-> #0 ((&info->queue)){+.+...}:
       [<ffffffff81086cb3>] __lock_acquire+0x999/0xcf6
       [<ffffffff81087440>] lock_acquire+0x95/0x105
       [<ffffffff81058cab>] wait_on_work+0x3b/0xa7
       [<ffffffff81058dd6>] __cancel_work_timer+0xbf/0x102
       [<ffffffff81058e33>] cancel_work_sync+0xb/0xd
       [<ffffffff8120a3b3>] fbcon_deinit+0x11c/0x1dc
       [<ffffffff81264793>] bind_con_driver+0x145/0x263
       [<ffffffff81264a45>] unbind_con_driver+0x14f/0x195
       [<ffffffff8126540c>] store_bind+0x1ad/0x1c1
       [<ffffffff8127cbb7>] dev_attr_store+0x13/0x1f
       [<ffffffff8116d884>] sysfs_write_file+0xe9/0x121
       [<ffffffff811145b2>] vfs_write+0x9b/0xfd
       [<ffffffff811147b7>] sys_write+0x3e/0x6b
       [<ffffffff813b0039>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(console_lock);
                               lock((&info->queue));
                               lock(console_lock);
  lock((&info->queue));

 *** DEADLOCK ***

Cc: Dave Airlie <airlied@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 kernel/printk.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/printk.c b/kernel/printk.c
index ed9af6a..ab2ab24 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -87,6 +87,12 @@ static DEFINE_SEMAPHORE(console_sem);
 struct console *console_drivers;
 EXPORT_SYMBOL_GPL(console_drivers);
 
+#ifdef CONFIG_LOCKDEP
+struct lockdep_map console_lock_dep_map = {
+	.name = "console_lock"
+};
+#endif
+
 /*
  * This is used for debugging the mess that is the VT code by
  * keeping track if we have the console semaphore held. It's
@@ -1916,6 +1922,7 @@ void console_lock(void)
 		return;
 	console_locked = 1;
 	console_may_schedule = 1;
+	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
 }
 EXPORT_SYMBOL(console_lock);
 
@@ -1937,6 +1944,7 @@ int console_trylock(void)
 	}
 	console_locked = 1;
 	console_may_schedule = 0;
+	mutex_acquire(&console_lock_dep_map, 0, 1, _RET_IP_);
 	return 1;
 }
 EXPORT_SYMBOL(console_trylock);
@@ -2097,6 +2105,7 @@ skip:
 		local_irq_restore(flags);
 	}
 	console_locked = 0;
+	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 
 	/* Release the exclusive_console once it is used */
 	if (unlikely(exclusive_console))
-- 
1.7.10.4

