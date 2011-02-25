Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab1BYQmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 11:42:44 -0500
Received: from adelie.canonical.com ([91.189.90.139]:49361 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab1BYQmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 11:42:43 -0500
Date: Fri, 25 Feb 2011 10:42:39 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Performance/resume issues on Toshiba NB305
Message-ID: <20110225164239.GA24686@thinkpad-t410>
Mail-Followup-To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been looking into a couple of problems with this machine that have
me a bit stumped at the moment. The two problems may or may not be
related, so I'm including details about both issues below. If anyone has
any ideas, I'd love to hear them. Note that these are not recent
regressions; they've been around since at least 2.6.32.

The CPU in this machine is an Atom N450.

When booted normally the performance on this machine is very poor, but
when booted with any of nohz=off, nolapic, or nohpet it improves
significantly. The performance also improves if I use the patch below to
force the hpet to remain in periodic mode (with hpet=periodic on the
command line).

One other thing I noticed when I had added some logging related to hpet
rearming is 3-5 second periods of no log activity occurring fairly
frequently, whereas such inactive periods are infrequent when
performance is good and are also infrequent on another machine with very
similar hardware and no performance issues.

The machine also hangs for 5 minutes during resume, unless booted with
both nohz=off and highres=off, or with hpet=periodic using the patch
below. I've traced this down to hanging in an SMI handler during the
ACPI _WAK method execution. The 5 minutes corresponds to how long it
takes for the low 32 bits of the hpet to wrap in this machine, and since
the options that eliminate the hang result in the hpet being in periodic
mode during _WAK method execution I suspect that the SMI handler is
hanging until a timer interrupt happens.

One possible explanation here is that the performance problems are also
related to hangs in SMI handlers until there's a timer interrupt,
although I don't know how that explains why some of the command line
options eliminate the performance issues.

Note also that I've already looked into the triggering for IRQ0, and it
seems to be correct.

Thanks,
Seth


diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 4ff5968..ab10012 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -87,6 +87,7 @@ static inline void hpet_clear_mapping(void)
 static int boot_hpet_disable;
 int hpet_force_user;
 static int hpet_verbose;
+static int hpet_oneshot_disable;
 
 static int __init hpet_setup(char *str)
 {
@@ -97,6 +98,8 @@ static int __init hpet_setup(char *str)
 			hpet_force_user = 1;
 		if (!strncmp("verbose", str, 7))
 			hpet_verbose = 1;
+		if (!strncmp("periodic", str, 8))
+			hpet_oneshot_disable = 1;
 	}
 	return 1;
 }
@@ -306,6 +309,10 @@ static void hpet_legacy_clockevent_register(void)
 	hpet_clockevent.min_delta_ns = clockevent_delta2ns(HPET_MIN_PROG_DELTA,
 							   &hpet_clockevent);
 
+	/* Disable one-shot mode if requested */
+	if (hpet_oneshot_disable)
+		hpet_clockevent.features &= ~CLOCK_EVT_FEAT_ONESHOT;
+
 	/*
 	 * Start hpet with the boot cpu mask and make it
 	 * global after the IO_APIC has been initialized.
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 48b2761..8e84c11 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -565,10 +565,15 @@ void tick_broadcast_switch_to_oneshot(void)
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
-	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
 	bc = tick_broadcast_device.evtdev;
+	if (bc && !(bc->features & CLOCK_EVT_FEAT_ONESHOT))
+		goto unlock;
+
+	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
 	if (bc)
 		tick_broadcast_setup_oneshot(bc);
+
+unlock:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
