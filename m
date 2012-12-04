Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2LDNs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:48:29 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45554 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2LDNs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:48:28 -0500
MIME-Version: 1.0
Date: Tue, 4 Dec 2012 05:48:27 -0800
Message-ID: <CAAmnkz=gJ02Uad6bgbCAuE0EPjcWXK9VrWo-3C1yK_XbmA4Xow@mail.gmail.com>
Subject: BUG: wait_task_zombie NULL dereference
From: "Bill Huey (hui)" <bill.huey@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: ebiederm@xmission.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm hitting this under a heavy scheduler test load with SCHED_RR tasks
exiting normally after completion and the parent exiting with some of
the pthreads still running:

(gdb) bt
#0  no_context (regs=0xffff880018c55d58, error_code=0, address=4,
signal=signal@entry=11,
    si_code=si_code@entry=196609) at arch/x86/mm/fault.c:630
#1  0xffffffff816a02fe in __bad_area_nosemaphore
(regs=regs@entry=0xffff880018c55d58,
    error_code=error_code@entry=0, address=address@entry=4,
si_code=si_code@entry=196609)
    at arch/x86/mm/fault.c:767
#2  0xffffffff816a0565 in __bad_area (si_code=196609, address=4,
error_code=0, regs=0xffff880018c55d58)
    at arch/x86/mm/fault.c:789
#3  bad_area (regs=regs@entry=0xffff880018c55d58,
error_code=error_code@entry=0, address=address@entry=4)
    at arch/x86/mm/fault.c:795
#4  0xffffffff816b381c in do_page_fault
(regs=regs@entry=0xffff880018c55d58, error_code=error_code@entry=0)
    at arch/x86/mm/fault.c:1159
#5  0xffffffff816b2ff5 in do_async_page_fault
(regs=0xffff880018c55d58, error_code=0) at arch/x86/kernel/kvm.c:246
#6  <signal handler called>
#7  wait_task_zombie (p=0xffff88003a034500, wo=0xffff880018c55f00) at
kernel/exit.c:1224
#8  wait_consider_task (p=0xffff88003a034500, ptrace=0,
wo=0xffff880018c55f00) at kernel/exit.c:1591
#9  wait_consider_task (wo=0xffff880018c55f00, ptrace=0,
p=0xffff88003a034500) at kernel/exit.c:1544
#10 0xffffffff8105a910 in do_wait_thread (tsk=0xffff88002f510000,
wo=0xffff880018c55f00) at kernel/exit.c:1666
#11 do_wait (wo=wo@entry=0xffff880018c55f00) at kernel/exit.c:1735
#12 0xffffffff8105bd45 in sys_wait4 (upid=<optimized out>,
stat_addr=0x7fff40f4168c, options=<optimized out>,
    ru=0x0 <irq_stack_union>) at kernel/exit.c:1865
#13 <signal handler called>
#14 0x00007f58c4d7f4ea in ?? ()
#15 0xffff88000000001b in ?? ()
#16 0xdead4ead001e001e in ?? ()
#17 0x00000000ffffffff in ?? ()
#18 0xffffffffffffffff in ?? ()
#19 0xffffffff8280e5e8 in __key.30461 ()
#20 0xffffffff8205f850 in lock_classes ()
#21 0x0000000000000000 in ?? ()



(gdb) down
#7  wait_task_zombie (p=0xffff88003a034500, wo=0xffff880018c55f00) at
kernel/exit.c:1224
1224            kuid_t two= task_uid(p);


[   23.324284] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000004
[   23.324284] IP: [<ffffffff8105a1a0>] wait_consider_task+0x5b0/0xc20
[   23.324284] PGD 2fa48067 PUD 39ff4067 PMD 0
[   23.324284] Oops: 0000 [#1] SMP

......

It crashes at that point with a NULL dereference it looks like. I
expanded out the arguments for from_kuid_munged() so that gdb can get
at a specific line.

bill
