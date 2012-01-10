Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673Ab2AJXX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:23:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933782Ab2AJW7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:59:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:46:19 2012
Message-Id: <20120110214618.993768480@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:45:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [09/40] powerpc/time: Handle wrapping of decrementer
In-Reply-To: <20120110214630.GA14384@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 37fb9a0231ee43d42d069863bdfd567fca2b61af upstream.

When re-enabling interrupts we have code to handle edge sensitive
decrementers by resetting the decrementer to 1 whenever it is negative.
If interrupts were disabled long enough that the decrementer wrapped to
positive we do nothing. This means interrupts can be delayed for a long
time until it finally goes negative again.

While we hope interrupts are never be disabled long enough for the
decrementer to go positive, we have a very good test team that can
drive any kernel into the ground. The softlockup data we get back
from these fails could be seconds in the future, completely missing
the cause of the lockup.

We already keep track of the timebase of the next event so use that
to work out if we should trigger a decrementer exception.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/include/asm/time.h |    2 ++
 arch/powerpc/kernel/irq.c       |   15 ++++++---------
 arch/powerpc/kernel/time.c      |    9 +++++++++
 3 files changed, 17 insertions(+), 9 deletions(-)

--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -219,5 +219,7 @@ DECLARE_PER_CPU(struct cpu_usage, cpu_us
 extern void secondary_cpu_time_init(void);
 extern void iSeries_time_init_early(void);
 
+extern void decrementer_check_overflow(void);
+
 #endif /* __KERNEL__ */
 #endif /* __POWERPC_TIME_H */
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -170,16 +170,13 @@ notrace void arch_local_irq_restore(unsi
 	 */
 	local_paca->hard_enabled = en;
 
-#ifndef CONFIG_BOOKE
-	/* On server, re-trigger the decrementer if it went negative since
-	 * some processors only trigger on edge transitions of the sign bit.
-	 *
-	 * BookE has a level sensitive decrementer (latches in TSR) so we
-	 * don't need that
+	/*
+	 * Trigger the decrementer if we have a pending event. Some processors
+	 * only trigger on edge transitions of the sign bit. We might also
+	 * have disabled interrupts long enough that the decrementer wrapped
+	 * to positive.
 	 */
-	if ((int)mfspr(SPRN_DEC) < 0)
-		mtspr(SPRN_DEC, 1);
-#endif /* CONFIG_BOOKE */
+	decrementer_check_overflow();
 
 	/*
 	 * Force the delivery of pending soft-disabled interrupts on PS3.
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -889,6 +889,15 @@ static void __init clocksource_init(void
 	       clock->name, clock->mult, clock->shift);
 }
 
+void decrementer_check_overflow(void)
+{
+	u64 now = get_tb_or_rtc();
+	struct decrementer_clock *decrementer = &__get_cpu_var(decrementers);
+
+	if (now >= decrementer->next_tb)
+		set_dec(1);
+}
+
 static int decrementer_set_next_event(unsigned long evt,
 				      struct clock_event_device *dev)
 {


