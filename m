Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab0ECNgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:36:37 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:43517 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab0ECNgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:36:35 -0400
Date: Mon, 03 May 2010 08:36:23 -0500
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 5/8] ipmi: Reduce polling when interrupts are available
Message-id: <20100503133623.GE8130@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

If we're not currently in the middle of a transaction, and if we have
interrupts, there's no real reason to poll the controller more frequently
than the core IPMI code does. Set the interrupt_disabled flag appropriately
as the interrupt state changes, and make the timeout code reset itself
only if the transaction is incomplete or we have no interrupts.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---

Index: linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
@@ -453,6 +453,9 @@ static inline void disable_si_irq(struct
 	if ((smi_info->irq) && (!smi_info->interrupt_disabled)) {
 		start_disable_irq(smi_info);
 		smi_info->interrupt_disabled = 1;
+		if (!atomic_read(&smi_info->stop_operation))
+			mod_timer(&smi_info->si_timer,
+				  jiffies + SI_TIMEOUT_JIFFIES);
 	}
 }
 
@@ -705,6 +708,8 @@ static void handle_transaction_done(stru
 			printk(KERN_WARNING
 			       "ipmi_si: Could not enable interrupts"
 			       ", failed set, using polled mode.\n");
+		} else {
+			smi_info->interrupt_disabled = 0;
 		}
 		smi_info->si_state = SI_NORMAL;
 		break;
@@ -885,6 +890,8 @@ static void sender(void                *
 	printk("**Enqueue: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
 
+	mod_timer(&smi_info->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
+
 	if (smi_info->run_to_completion) {
 		/*
 		 * If we are running to completion, then throw it in
@@ -1085,7 +1092,8 @@ static void smi_timeout(unsigned long da
 	}
 
  do_add_timer:
-	add_timer(&(smi_info->si_timer));
+	if ((smi_result != SI_SM_IDLE) || smi_info->interrupt_disabled)
+		add_timer(&(smi_info->si_timer));
 }
 
 static irqreturn_t si_irq_handler(int irq, void *data)
@@ -3115,7 +3123,7 @@ static int try_smi_init(struct smi_info 
 	for (i = 0; i < SI_NUM_STATS; i++)
 		atomic_set(&new_smi->stats[i], 0);
 
-	new_smi->interrupt_disabled = 0;
+	new_smi->interrupt_disabled = 1;
 	atomic_set(&new_smi->stop_operation, 0);
 	new_smi->intf_num = smi_num;
 	smi_num++;
