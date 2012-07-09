Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2GIOiY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:38:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38267 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754288Ab2GIOiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:38:20 -0400
Message-Id: <20120709143120.752484885@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:31:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 28/48] ARM: fix rcu stalls on SMP platforms
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 7deabca0acfe02b8e18f59a4c95676012f49a304 upstream.

We can stall RCU processing on SMP platforms if a CPU sits in its idle
loop for a long time.  This happens because we don't call irq_enter()
and irq_exit() around generic_smp_call_function_interrupt() and
friends.  Add the necessary calls, and remove the one from within
ipi_timer(), so that they're all in a common place.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/kernel/smp.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 57db122..26cdc49 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -443,9 +443,7 @@ static DEFINE_PER_CPU(struct clock_event_device, percpu_clockevent);
 static void ipi_timer(void)
 {
 	struct clock_event_device *evt = &__get_cpu_var(percpu_clockevent);
-	irq_enter();
 	evt->event_handler(evt);
-	irq_exit();
 }
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
@@ -548,7 +546,9 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 
 	switch (ipinr) {
 	case IPI_TIMER:
+		irq_enter();
 		ipi_timer();
+		irq_exit();
 		break;
 
 	case IPI_RESCHEDULE:
@@ -556,15 +556,21 @@ void handle_IPI(int ipinr, struct pt_regs *regs)
 		break;
 
 	case IPI_CALL_FUNC:
+		irq_enter();
 		generic_smp_call_function_interrupt();
+		irq_exit();
 		break;
 
 	case IPI_CALL_FUNC_SINGLE:
+		irq_enter();
 		generic_smp_call_function_single_interrupt();
+		irq_exit();
 		break;
 
 	case IPI_CPU_STOP:
+		irq_enter();
 		ipi_cpu_stop(cpu);
+		irq_exit();
 		break;
 
 	default:


