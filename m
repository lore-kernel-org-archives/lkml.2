Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab1IAB2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 21:28:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45702 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab1IAB2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 21:28:01 -0400
From: Shan Hai <haishan.bai@gmail.com>
To: akpm@linux-foundation.org
Cc: eric.dumazet@gmail.com, vapier@gentoo.org, asharma@fb.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] lib:atomic64 using raw_spin_lock_irq[save|resotre] for atomicity
Date: Thu,  1 Sep 2011 09:27:59 +0800
Message-Id: <1314840480-25182-1-git-send-email-haishan.bai@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The command 'perf top -e L1-dcache-loads' causes OOPS and hang up in the
following configuration.

Powerpc e500 core
OOPS on: 		2.6.34.9 PREEMPT-RT
Whole system hangs up:	3.0.3 PREEMPT-RT

Listed the panic info. below. 

Cause of the problem is that the atomic64_add_return is interrupted by the 
performence counter interrupt, the interrupt handler calls atomic64_read,
failed at /build/linux/kernel/rtmutex.c:832! for the reason trying to hold the
same lock twice in the same context. 

Replace the spin_lock_irq[save|restore] with raw_spin_lock_irq[save|restore] 
could guarantee the atomicity of atomic64_* because the raw variant of the spin
lock disables interrupts during atomic64_* operations.

---
 lib/atomic64.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)
---

OOPS on 2.6.34.9+PREEMPT-RT:
------------[ cut here ]------------
kernel BUG at /build/linux/kernel/rtmutex.c:832!
Oops: Exception in kernel mode, sig: 5 [#2]
PREEMPT SMP NR_CPUS=8 LTT NESTING LEVEL : 0
P4080 DS
last sysfs file: /sys/devices/system/cpu/online
Modules linked in: ipv6(+) [last unloaded: scsi_wait_scan]
NIP: c068b218 LR: c068b1e0 CTR: 00000000
REGS: eb459ae0 TRAP: 0700   Tainted: G      D     (2.6.34.9-rt)
MSR: 00021002 <ME,CE>  CR: 28000488  XER: 00000000
TASK = ea43d3b0[968] 'perf' THREAD: eb458000 CPU: 0
GPR00: 00000001 eb459b90 ea43d3b0 00021002 00000000 00000000 00000000 00000001
GPR08: 00000001 ea43d3b0 c068b1e0 00000000 28000482 10092c4c 7fffffff 80000000
GPR16: eb459d40 eb459c68 00000001 c2fa2098 eb459ec0 eac5a8e8 eac5a900 c0906308
GPR24: c0906334 00000000 eb459b9c c090d0ec 00021002 c09062e0 c09062e0 eb459b90
NIP [c068b218] rt_spin_lock_slowlock+0x78/0x3a8
LR [c068b1e0] rt_spin_lock_slowlock+0x40/0x3a8
Call Trace:
[eb459b90] [c068b1e0] rt_spin_lock_slowlock+0x40/0x3a8 (unreliable)
[eb459c20] [c068bdb0] rt_spin_lock+0x40/0x98
[eb459c40] [c03d2a14] atomic64_read+0x48/0x84
[eb459c60] [c001aaf4] perf_event_interrupt+0xec/0x28c
[eb459d10] [c0010138] performance_monitor_exception+0x7c/0x150
[eb459d30] [c0014170] ret_from_except_full+0x0/0x4c
--- Exception: 2060 at lock_acquire+0x94/0x130
    LR = lock_acquire+0x8c/0x130
[eb459e30] [c068bdf0] rt_spin_lock+0x80/0x98
[eb459e50] [c03d2884] atomic64_add_return+0x50/0x98
[eb459e70] [c00ff888] T.902+0x150/0x4f8
[eb459eb0] [c00ffedc] sys_perf_event_open+0x2ac/0x508
[eb459f40] [c0013b6c] ret_from_syscall+0x0/0x4
--- Exception: c00 at 0xfa8abe4
    LR = 0x10016034

