Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab2DWMSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:18:25 -0400
Received: from relay.parallels.com ([195.214.232.42]:40367 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab2DWMSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:18:23 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andy Lutomirski <luto@mit.edu>, Jan Beulich <jbeulich@suse.com>
CC: Vladimir Davydov <vdavydov@parallels.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: x86: take precautions against spurious timer interrupts
Date: Mon, 23 Apr 2012 16:18:14 +0400
Message-ID: <1335183494-19645-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If hpet is enabled by hpet_late_init() - this usually occurs on systems
with buggy BIOS, which does not report about hpet presence through ACPI,
hpet_clockevent's event_handler can be left uninitialized by
clockevents_register_device() because of hpet_clockevent low rating (by
the time hpet_late_init() is called, high prio apic timers have already
been setup). The event_handler is then initialized a bit later by the
clocksource_done_booting() procedure.

Normally, timer interrupts should not be delivered between these two
calls, but if e.g. the kernel is booted using kexec, there might be some
pending interrupts from the previous kernel's context, which can lead to
a NULL pointer dereference.

So, take precautions against spurious timer interrupts by checking the
event_handler value before calling it.
---
 arch/x86/kernel/time.c |   18 +++++++++++++++++-
 1 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index c6eba2b..43bdd3a 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -57,7 +57,23 @@ EXPORT_SYMBOL(profile_pc);
  */
 static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
-	global_clock_event->event_handler(global_clock_event);
+	/*
+	 * If hpet is enabled by hpet_late_init(), event_handler can be left
+	 * uninitialized by clockevents_register_device() because of
+	 * hpet_clockevent low rating (by the time hpet_late_init() is called,
+	 * high prio apic timers have already been setup). The event_handler is
+	 * then initialized a bit later by the clocksource_done_booting()
+	 * procedure.
+	 *
+	 * Normally, timer interrupts should not be delivered between these two
+	 * calls, but if e.g. the kernel is booted using kexec, there might be
+	 * some pending interrupts from the previous kernel's context, which
+	 * can lead to a NULL pointer dereference.
+	 *
+	 * So, take precautions against spurious timer interrupts.
+	 */
+	if (global_clock_event->event_handler)
+		global_clock_event->event_handler(global_clock_event);
 
 	/* MCA bus quirk: Acknowledge irq0 by setting bit 7 in port 0x61 */
 	if (MCA_bus)
-- 
1.7.1

