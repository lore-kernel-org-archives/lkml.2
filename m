Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1KXTEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 14:04:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab1KXTET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 14:04:19 -0500
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] printk: fix recursion of logbuf_lock spinlock
Date: Thu, 24 Nov 2011 20:04:15 +0100
Message-Id: <1322161455-21242-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With flooding printks over (virtual|physical) serial console I've been
noticing hangs. The problem is a recursive deadlock that then hangs
any console output ("recursion" is also shown in the params to
spin_bug below with lockdep enabled but the nested vprintk at #7 hangs
on the same lock as it needs to take that too).

 gdb> bt
 #0  0xffffffff811fe17a in rdtsc_barrier (loops=0x1) at arch/x86/lib/delay.c:57
 #1  delay_tsc (loops=0x1) at arch/x86/lib/delay.c:58
 #2  0xffffffff811fe0ca in __delay (loops=<value optimized out>) at arch/x86/lib/delay.c:112
 #3  0xffffffff81204ff3 in __spin_lock_debug (lock=0xffffffff81686220) at lib/spinlock_debug.c:116
 #4  do_raw_spin_lock (lock=0xffffffff81686220) at lib/spinlock_debug.c:133
 #5  0xffffffff8147cba4 in __raw_spin_lock (lock=0xffffffff81686220) at include/linux/spinlock_api_smp.h:144
 #6  _raw_spin_lock (lock=0xffffffff81686220) at kernel/spinlock.c:137
 #7  0xffffffff8104d4df in vprintk (fmt=0xffffffff815ee3c8 "<0>BUG: spinlock %s on CPU#%d, %s/%d\n", args=0xffff88003b0d fb68) at kernel/printk.c:867
 #8  0xffffffff81479565 in printk (fmt=<value optimized out>) at kernel/printk.c:752
 #9  0xffffffff81204d96 in spin_dump (lock=0xffffffff81686220, msg=<value optimized out>) at lib/spinlock_debug.c:58
 #10 0xffffffff81204e3b in spin_bug (lock=0xffffffff81686220, msg=0xffffffff815ee13a "recursion") at lib/spinlock_debug.c:75
 #11 0xffffffff81205018 in debug_spin_lock_before (lock=0xffffffff81686220) at lib/spinlock_debug.c:84
 #12 do_raw_spin_lock (lock=0xffffffff81686220) at lib/spinlock_debug.c:131
 #13 0xffffffff8147cb5c in __raw_spin_lock_irqsave (lock=0xffffffff81686220) at include/linux/spinlock_api_smp.h:117
 #14 _raw_spin_lock_irqsave (lock=0xffffffff81686220) at kernel/spinlock.c:145
 #15 0xffffffff8104d104 in console_unlock () at kernel/printk.c:1264
 #16 0xffffffff81290602 in do_con_write (tty=0xffff88003c055000, buf=0xffffffff815fe051 "", count=<value optimized out>)  at drivers/tty/vt/vt.c:2368
 #17 0xffffffff81292169 in con_write (tty=0xffff88003c055000, buf=<value optimized out>, count=<value optimized out>) at drivers/tty/vt/vt.c:2704
 #18 0xffffffff8127b72b in do_output_char (c=<value optimized out>, tty=<value optimized out>, space=<value optimized out>) at drivers/tty/n_tty.c:310
 #19 0xffffffff8127b7a1 in process_output (c=0xa, tty=0xffff88003c055000) at drivers/tty/n_tty.c:376
 #20 0xffffffff8127d77b in n_tty_write (tty=0xffff88003c055000, file=0xffff88003c73e440, buf=0xffff88003c3d9400 "Nov 24 19:36:40 kvm kernel: migrate_pages 0\n 240215\npfn 240183, end_pfn 241152\ner root by LOGIN(uid=0)\nput/input2\nIDE ports\n, 504k init)\n4 19:28:49 CET 2011\n", nr=0x1) at drivers/tty/n_tty.c:1983
 #21 0xffffffff81278af5 in do_tty_write (file=0xffff88003c73e440, buf=<value optimized out>, count=<value optimized out>, ppos=<value optimized out>) at drivers/tty/tty_io.c:1068
 #22 tty_write (file=0xffff88003c73e440, buf=<value optimized out>, count=<value optimized out>, ppos=<value optimized out>) at drivers/tty/tty_io.c:1156
 #23 0xffffffff81112036 in vfs_write (file=0xffff88003c73e440, buf=0x1f19780 "Nov 24 19:36:40 kvm kernel: migrate_pages 0\n", count=0x2c, pos=0xffff88003b0dff48) at fs/read_write.c:435
 #24 0xffffffff8111234c in sys_write (fd=<value optimized out>, buf=0x1f19780 "Nov 24 19:36:40 kvm kernel: migrate_pages 0\n", count=0x2c) at fs/read_write.c:487
 #25 <signal handler called>
 #26 0x00007f22d47887c0 in __brk_reservation_fn_dmi_alloc__ ()
 #27 0xffff88003b0de5c0 in __brk_reservation_fn_dmi_alloc__ ()
 #28 0xffffffff81685f20 in ?? ()
 #29 0x0000000000000000 in ?? ()

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 kernel/printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 1455a0d..fc3c831 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1259,9 +1259,9 @@ void console_unlock(void)
 
 	console_may_schedule = 0;
 
-again:
 	for ( ; ; ) {
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
+again:
 		wake_klogd |= log_start - log_end;
 		if (con_start == log_end)
 			break;			/* Nothing to print */
