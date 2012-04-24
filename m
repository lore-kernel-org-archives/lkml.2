Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab2DXP6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 11:58:16 -0400
Received: from relay.parallels.com ([195.214.232.42]:42778 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab2DXP6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 11:58:15 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Vladimir Davydov <vdavydov@parallels.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: x86: init hpet event_handler to noop
Date: Tue, 24 Apr 2012 19:57:11 +0400
Message-ID: <1335283031-12942-1-git-send-email-vdavydov@parallels.com>
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
a NULL pointer dereference in timer_interrupt().

Avoid this by initializing hpet's event_handler to noop in its definition.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 arch/x86/kernel/hpet.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ad0de0c..a736a6e 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -238,6 +238,7 @@ static struct clock_event_device hpet_clockevent = {
 	.set_next_event = hpet_legacy_next_event,
 	.irq		= 0,
 	.rating		= 50,
+	.event_handler	= clockevents_handle_noop,
 };
 
 static void hpet_stop_counter(void)
-- 
1.7.1

