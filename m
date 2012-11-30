Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab2K3Otd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 09:49:33 -0500
Received: from lnx141.hrz.tu-darmstadt.de ([130.83.156.236]:34871 "EHLO
	lnx141.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643Ab2K3Otb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 09:49:31 -0500
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 09:49:31 EST
From: Tim Sander <tim01@vlsi.informatik.tu-darmstadt.de>
Organization: Integrierte Schaltungen und Systeme
To: linux-kernel@vger.kernel.org
Subject: bugsplat 3.6.7-rt18
Date: Fri, 30 Nov 2012 15:43:32 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201211301543.32874.tim01@vlsi.informatik.tu-darmstadt.de>
X-PMX-TU: seen v1.2 by 5.6.1.2065439, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2012.11.30.143324
X-PMX-RELAY: outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

After Frank posted a patch i managed the 3.6.7-rt18 kernel to boot:
There are some local platform modifications for arm mach-pcm043 but nothing which should 
cause this. The kernel got renamed so that the hw debugger works. HR_TIMERS are disabled in my config.

The kernel continues to work after that but it fails later on more below on that.

Best regards
Tim


NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations

=================================
[ INFO: inconsistent lock state ]
2.6.42pmx-rt18-00015-gdc97b0a-dirty #48 Not tainted <-- this is really 3.6.7-rt18 changed for hw debugger
---------------------------------
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
kworker/u:0/13 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (rcu_kthread_wq.lock.lock.wait_lock){?.+...}, at: [<c0259720>] rt_spin_lock_slowlock+0x44/0x208
{HARDIRQ-ON-W} state was registered at:
  [<c004faac>] mark_lock+0x274/0x3c8
  [<c004fd1c>] mark_irqflags+0x11c/0x1a4
  [<c0050380>] __lock_acquire+0x5dc/0x814
  [<c0050abc>] lock_acquire+0x68/0x7c
  [<c025a35c>] _raw_spin_lock+0x40/0x50
  [<c0259720>] rt_spin_lock_slowlock+0x44/0x208
  [<c0259c9c>] rt_spin_lock+0x1c/0x44
  [<c0039038>] prepare_to_wait+0x28/0x70
  [<c0063694>] rcu_kthread+0x68/0x1b0
  [<c0038a88>] kthread+0x90/0x9c
  [<c0020e38>] do_exit+0x0/0x2e0
irq event stamp: 46
hardirqs last  enabled at (45): [<c025a5f4>] _raw_spin_unlock_irqrestore+0x44/0x7c
hardirqs last disabled at (46): [<c000dad4>] __irq_svc+0x34/0x98
softirqs last  enabled at (0): [<c001a1e4>] copy_process+0x1f4/0xb78
softirqs last disabled at (0): [<  (null)>]   (null)

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(rcu_kthread_wq.lock.lock.wait_lock);
  <Interrupt>
    lock(rcu_kthread_wq.lock.lock.wait_lock);

 *** DEADLOCK ***

2 locks held by kworker/u:0/13:
 #0:  (&p->alloc_lock){+.+...}, at: [<c0019e9c>] mm_release+0xd0/0xf8
 #1:  (&(&(&q->lock)->lock)->wait_lock){+.+...}, at: [<c025997c>] rt_spin_lock_slowunlock+0x14/0x70

stack backtrace:
Backtrace: 
[<c00114e8>] (dump_backtrace+0x0/0x110) from [<c025793c>] (dump_stack+0x18/0x1c)
 r6:c041e414 r5:c78735d0 r4:c7873200 r3:c7873200
[<c0257924>] (dump_stack+0x0/0x1c) from [<c004f584>] (print_usage_bug+0x180/0x1c8)
[<c004f404>] (print_usage_bug+0x0/0x1c8) from [<c004f68c>] (mark_lock_irq+0xc0/0x26c)
[<c004f5cc>] (mark_lock_irq+0x0/0x26c) from [<c004fad8>] (mark_lock+0x2a0/0x3c8)
[<c004f838>] (mark_lock+0x0/0x3c8) from [<c004fc84>] (mark_irqflags+0x84/0x1a4)
[<c004fc00>] (mark_irqflags+0x0/0x1a4) from [<c0050380>] (__lock_acquire+0x5dc/0x814)
 r5:c7873200 r4:c036499c
[<c004fda4>] (__lock_acquire+0x0/0x814) from [<c0050abc>] (lock_acquire+0x68/0x7c)
[<c0050a54>] (lock_acquire+0x0/0x7c) from [<c025a35c>] (_raw_spin_lock+0x40/0x50)
 r6:00000003 r5:c0259720 r4:c036498c
[<c025a31c>] (_raw_spin_lock+0x0/0x50) from [<c0259720>] (rt_spin_lock_slowlock+0x44/0x208)
 r5:c7873200 r4:c036498c
[<c02596dc>] (rt_spin_lock_slowlock+0x0/0x208) from [<c0259c9c>] (rt_spin_lock+0x1c/0x44)
[<c0259c80>] (rt_spin_lock+0x0/0x44) from [<c00405ec>] (__wake_up+0x24/0x4c)
 r5:00000001 r4:c036498c
[<c00405c8>] (__wake_up+0x0/0x4c) from [<c0063824>] (invoke_rcu_callbacks+0x34/0x40)
 r7:00000000 r6:00000000 r5:00000000 r4:c7873200
[<c00637f0>] (invoke_rcu_callbacks+0x0/0x40) from [<c006443c>] (rcu_check_callbacks+0x8c/0xc8)
[<c00643b0>] (rcu_check_callbacks+0x0/0xc8) from [<c0029724>] (update_process_times+0x48/0x54)
 r4:c7873200 r3:c7873200
[<c00296dc>] (update_process_times+0x0/0x54) from [<c004b5cc>] (tick_periodic+0xbc/0xd4)
 r6:c0360740 r5:c78090c0 r4:c037cd24 r3:20000013
[<c004b510>] (tick_periodic+0x0/0xd4) from [<c004b604>] (tick_handle_periodic+0x20/0x90)
 r4:c03607c0 r3:c7874000
[<c004b5e4>] (tick_handle_periodic+0x0/0x90) from [<c0018894>] (mxc_timer_interrupt+0x28/0x38)
[<c001886c>] (mxc_timer_interrupt+0x0/0x38) from [<c005e750>] (handle_irq_event_percpu+0x60/0x1b0)
[<c005e6f0>] (handle_irq_event_percpu+0x0/0x1b0) from [<c005e8e4>] (handle_irq_event+0x44/0x64)
[<c005e8a0>] (handle_irq_event+0x0/0x64) from [<c0061074>] (handle_level_irq+0xd0/0xe8)
 r6:c7875e78 r5:c7809118 r4:c78090c0 r3:00020000
[<c0060fa4>] (handle_level_irq+0x0/0xe8) from [<c005e0b0>] (generic_handle_irq+0x28/0x38)
 r5:00000000 r4:0000002d
[<c005e088>] (generic_handle_irq+0x0/0x38) from [<c000e76c>] (handle_IRQ+0x68/0x8c)
 r4:0000002d r3:00000050
[<c000e704>] (handle_IRQ+0x0/0x8c) from [<c00084c8>] (avic_handle_irq+0x3c/0x48)
 r5:0000ffff r4:c0375c10
[<c000848c>] (avic_handle_irq+0x0/0x48) from [<c000dae4>] (__irq_svc+0x44/0x98)
Exception stack(0xc7875e78 to 0xc7875ec0)
5e60:                                                       00000001 c78735b8
5e80: 00000000 00000000 20000013 c7840388 20000013 0000000f 00000008 00000000
5ea0: 00000000 c7875ed4 c7875e58 c7875ec0 c005129c c025a5f8 20000013 ffffffff
 r6:ffffffff r5:20000013 r4:c025a5f8 r3:c7873200
[<c025a5b0>] (_raw_spin_unlock_irqrestore+0x0/0x7c) from [<c0040ffc>] (try_to_wake_up+0x140/0x164)
 r5:c7840388 r4:00000001
[<c0040ebc>] (try_to_wake_up+0x0/0x164) from [<c004106c>] (wake_up_lock_sleeper+0x18/0x1c)
 r8:80000013 r7:00000001 r6:c7847cc8 r5:c7874000 r4:c7847dcc
r3:00000001
[<c0041054>] (wake_up_lock_sleeper+0x0/0x1c) from [<c0055a20>] (rt_mutex_wake_waiter+0x20/0x30)
[<c0055a00>] (rt_mutex_wake_waiter+0x0/0x30) from [<c0055ad4>] (wakeup_next_waiter+0xa4/0xac)
[<c0055a30>] (wakeup_next_waiter+0x0/0xac) from [<c02599c4>] (rt_spin_lock_slowunlock+0x5c/0x70)
 r8:00000000 r7:00000013 r6:00000000 r5:c7874000 r4:c7847dcc
r3:c7847dec
[<c0259968>] (rt_spin_lock_slowunlock+0x0/0x70) from [<c0259d00>] (rt_spin_unlock+0x28/0x2c)
 r5:c7847dc8 r4:c7847dcc
[<c0259cd8>] (rt_spin_unlock+0x0/0x2c) from [<c0040554>] (complete+0x4c/0x54)
 r4:c7847dcc r3:00000000
[<c0040508>] (complete+0x0/0x54) from [<c0019eb4>] (mm_release+0xe8/0xf8)
 r5:c78734d4 r4:c7873200
[<c0019dcc>] (mm_release+0x0/0xf8) from [<c001f69c>] (exit_mm+0x20/0x110)
 r6:00000001 r5:c7873200 r4:00000000
[<c001f67c>] (exit_mm+0x0/0x110) from [<c0020ff8>] (do_exit+0x1c0/0x2e0)
 r7:00000013 r6:00000001 r5:00000000 r4:c7873200
[<c0020e38>] (do_exit+0x0/0x2e0) from [<c008ce74>] (unlock_slab_and_free_delayed.clone.47+0xc0/0xd0)
L210 cache controller enabled
l2x0: 8 ways, CACHE_ID 0x4100004b, AUX_CTRL 0x00030024, Cache size: 131072 B
bio: create slab <bio-0> at 0
SCSI subsystem initialized
Switching to clocksource mxc_timer1
NET: Registered protocol family 2
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 6, 360448 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP: reno registered
UDP hash table entries: 256 (order: 3, 49152 bytes)
UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
NET: Registered protocol family 1
msgmni has been set to 236
io scheduler noop registered (default)
start plist test

--- snip


Later on the kernel locks up without any output on serial console. The hardware debugger gives me the following call stack:
Transcribed by hand after the panic stuff:

BUG_ON(rt_mutex_owner(lock) == self))
rt_spint_lock_fastlock(...
__wake_up(
invoke_rcu_callbacks
rcu_check_callbacks
update_process_times
tick_periodic
tick_handle_periodic
handle_irq_event_percpu
handle_irq_event


