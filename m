Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2LNLBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:01:37 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:47571 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab2LNLBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:01:34 -0500
Subject: [PATCH] x86/hpet: initialize hpet event_handler to noop
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 14 Dec 2012 15:01:28 +0400
Message-ID: <20121214110128.8712.83290.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir Davydov <vdavydov@parallels.com>

Timer interrupt can be delivered right after altering global_clock_event in
hpet_legacy_clockevent_register(). For example during rebooting via kexec
hpet might be armed by previous kernel. This spurious interrupt leads to
kernel panic, because global_clock_event->event_handler is NULL.
Probably this also might happen in less extraordinary situations.

This patch initializes hpet's event_handler to noop in its definition.

Stack-trace:

hpet_late_init()
  hpet_address = force_hpet_address
  hpet_enable()
    hpet_clocksource_register()
      hpet_legacy_clockevent_register()
        hpet_enable_legacy_int()
        clockevents_config_and_register()
        | clockevents_register_device()
        |   clockevents_do_notify()
        |     tick_check_new_device()
        |       tick_check_broadcast_device()
        |         if (!cpumask_empty(tick_get_broadcast_mask()))
        |         <mask is empty -> dev->event_handler stays NULL>
        global_clock_event = &hpet_clockevent;
        printk(KERN_DEBUG "hpet clockevent registered\n")

					timer_interrupt()
					  global_clock_event->event_handler()
					  <OOPS>

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Thomas Gleixner <tglx@linutronix.de>

---

previous (failed) attempt of submitting this patch:
http://thread.gmane.org/gmane.linux.kernel/1286990/focus=1296551
I hope the new decription is not so bad.

---

kernel panic right after rebooting via kexec:

[    0.597148] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
...
[    0.735269] hpet clockevent registered
[    0.735012] BUG: unable to handle kernel NULL pointer dereference at (null)
[    0.735022] IP: [<(null)>] (null)
[    0.735026] PGD 0
[    0.735029] Oops: 0010 [#1] SMP
[    0.735032] last sysfs file:
[    0.735036] CPU 4
[    0.735037] Modules linked in:
[    0.735049]
[    0.735053] Pid: 0, comm: swapper veid: 0 Not tainted 2.6.32-042stab054.4 #1 042stab054_4 System manufacturer System Product Name/DSBV-D
[    0.735060] RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
[    0.735071] RSP: 0018:ffff880028303ec0  EFLAGS: 00010002
[    0.735074] RAX: ffffffff81a941c0 RBX: ffffffff81a8ee20 RCX: 0000000000000000
[    0.735077] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81a941c0
[    0.735080] RBP: ffff880028303ec8 R08: ffff88043e278000 R09: ffff88043e279ee8
[    0.735084] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[    0.735087] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    0.735091] FS:  0000000000000000(0000) GS:ffff880028300000(0000) knlGS:0000000000000000
[    0.735095] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    0.735098] CR2: 0000000000000000 CR3: 0000000001a85000 CR4: 00000000000006e0
[    0.735101] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.735105] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.735109] Process swapper (pid: 0, veid: 0, threadinfo ffff88043e278000, task ffff88043e276e10)
[    0.735112] Stack:
[    0.735114]  ffffffff8100e81e ffff880028303f18 ffffffff810e8f50 ffff880028303ef8
[    0.735119] <0> 0000000000000000 ffff880028303f18 ffffffff81a83240 ffffffff81a832ac
[    0.735124] <0> 0000000000000000 ffff88043e279e38 0000000000000000 ffff880028303f58
[    0.735129] Call Trace:
[    0.735132]  <IRQ>
[    0.735142]  [<ffffffff8100e81e>] ? timer_interrupt+0x1e/0x30
[    0.735149]  [<ffffffff810e8f50>] handle_IRQ_event+0x60/0x170
[    0.735154]  [<ffffffff810eb67e>] handle_edge_irq+0xde/0x180
[    0.735160]  [<ffffffff810a590b>] ? tick_check_idle+0xdb/0xe0
[    0.735164]  [<ffffffff8100dfc9>] handle_irq+0x49/0xa0
[    0.735171]  [<ffffffff814ef64c>] do_IRQ+0x6c/0xf0
[    0.735175]  [<ffffffff8100bb13>] ret_from_intr+0x0/0x11
[    0.735178]  <EOI>
[    0.735183]  [<ffffffff81014677>] ? mwait_idle+0x77/0xd0
[    0.735187]  [<ffffffff814eceea>] ? atomic_notifier_call_chain+0x1a/0x20
[    0.735193]  [<ffffffff81009e76>] cpu_idle+0xb6/0x110
[    0.735199]  [<ffffffff814e07bc>] start_secondary+0x202/0x245
[    0.735202] Code:  Bad RIP value.
[    0.735209] RIP  [<(null)>] (null)
[    0.735212]  RSP <ffff880028303ec0>
[    0.735214] CR2: 0000000000000000

at successful boot this machine also prints:

[    0.725005] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.726006] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.728300] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.735037] Switching to clocksource hpet
---
 arch/x86/kernel/hpet.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index e28670f..4036076 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -243,6 +243,7 @@ static struct clock_event_device hpet_clockevent = {
 	.set_next_event = hpet_legacy_next_event,
 	.irq		= 0,
 	.rating		= 50,
+	.event_handler	= clockevents_handle_noop,
 };
 
 static void hpet_stop_counter(void)

