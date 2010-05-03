Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340Ab0ECNhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:37:12 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:56878 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab0ECNhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:37:10 -0400
Date: Mon, 03 May 2010 08:36:59 -0500
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 6/8] ipmi: Reduce polling
Message-id: <20100503133659.GF8130@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

We can reasonably alter the poll rate depending on whether we're performing a
transaction or merely waiting for an event.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---

Index: linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
@@ -893,6 +893,9 @@ static void sender(void                *
 
 	mod_timer(&smi_info->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
 
+	if (smi_info->thread)
+		wake_up_process(smi_info->thread);
+
 	if (smi_info->run_to_completion) {
 		/*
 		 * If we are running to completion, then throw it in
@@ -1013,6 +1016,8 @@ static int ipmi_thread(void *data)
 			; /* do nothing */
 		else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait)
 			schedule();
+		else if (smi_result == SI_SM_IDLE)
+			schedule_timeout_interruptible(100);
 		else
 			schedule_timeout_interruptible(0);
 	}
@@ -1055,6 +1060,7 @@ static void smi_timeout(unsigned long da
 	unsigned long     flags;
 	unsigned long     jiffies_now;
 	long              time_diff;
+	long		  timeout;
 #ifdef DEBUG_TIMING
 	struct timeval    t;
 #endif
@@ -1075,9 +1081,9 @@ static void smi_timeout(unsigned long da
 
 	if ((smi_info->irq) && (!smi_info->interrupt_disabled)) {
 		/* Running with interrupts, only do long timeouts. */
-		smi_info->si_timer.expires = jiffies + SI_TIMEOUT_JIFFIES;
+		timeout = jiffies + SI_TIMEOUT_JIFFIES;
 		smi_inc_stat(smi_info, long_timeouts);
-		goto do_add_timer;
+		goto do_mod_timer;
 	}
 
 	/*
@@ -1086,15 +1092,15 @@ static void smi_timeout(unsigned long da
 	 */
 	if (smi_result == SI_SM_CALL_WITH_DELAY) {
 		smi_inc_stat(smi_info, short_timeouts);
-		smi_info->si_timer.expires = jiffies + 1;
+		timeout = jiffies + 1;
 	} else {
 		smi_inc_stat(smi_info, long_timeouts);
-		smi_info->si_timer.expires = jiffies + SI_TIMEOUT_JIFFIES;
+		timeout = jiffies + SI_TIMEOUT_JIFFIES;
 	}
 
- do_add_timer:
-	if ((smi_result != SI_SM_IDLE) || smi_info->interrupt_disabled)
-		add_timer(&(smi_info->si_timer));
+ do_mod_timer:
+	if (smi_result != SI_SM_IDLE)
+		mod_timer(&(smi_info->si_timer), timeout);
 }
 
 static irqreturn_t si_irq_handler(int irq, void *data)
