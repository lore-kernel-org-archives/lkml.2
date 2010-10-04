Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab0JDUab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:30:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:53353 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947Ab0JDUa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:30:29 -0400
Date: Mon, 4 Oct 2010 20:29:58 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121841.742126604@linutronix.de>
References: <20100927121841.742126604@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide advanced irq chip functions
Message-ID: <tip-f8822657e799b02c55556c99a601261e207a299d@git.kernel.org>
Git-Commit-ID: f8822657e799b02c55556c99a601261e207a299d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:29:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f8822657e799b02c55556c99a601261e207a299d
Gitweb:     http://git.kernel.org/tip/f8822657e799b02c55556c99a601261e207a299d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:44:32 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:43:32 +0200

genirq: Provide advanced irq chip functions

The low level irq chip functions want access to irq_desc->irq_data.
Provide new functions which hand down irq_data instead of the irq
number so these functions avoid to call irq_to_desc() which is a radix
tree lookup in case of sparse irq.

This provides all the old functions except one: end(). end() is a
relict of __do_IRQ() and will just go away with the __do_IRQ() code.

The replacement for set_affinity() has an extra argument "bool
force". The reason for this is to notify the low level code, that the
move has to be done right away and cannot be delayed until the next
interrupt happens. That's necessary to handle the irq fixup on cpu
unplug in the generic code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121841.742126604@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/irq.h |   66 ++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 002351d..0c83cbd 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -118,23 +118,38 @@ struct irq_data {
  * struct irq_chip - hardware interrupt chip descriptor
  *
  * @name:		name for /proc/interrupts
- * @startup:		start up the interrupt (defaults to ->enable if NULL)
- * @shutdown:		shut down the interrupt (defaults to ->disable if NULL)
- * @enable:		enable the interrupt (defaults to chip->unmask if NULL)
- * @disable:		disable the interrupt
- * @ack:		start of a new interrupt
- * @mask:		mask an interrupt source
- * @mask_ack:		ack and mask an interrupt source
- * @unmask:		unmask an interrupt source
- * @eoi:		end of interrupt - chip level
- * @end:		end of interrupt - flow level
- * @set_affinity:	set the CPU affinity on SMP machines
- * @retrigger:		resend an IRQ to the CPU
- * @set_type:		set the flow type (IRQ_TYPE_LEVEL/etc.) of an IRQ
- * @set_wake:		enable/disable power-management wake-on of an IRQ
+ * @startup:		deprecated, replaced by irq_startup
+ * @shutdown:		deprecated, replaced by irq_shutdown
+ * @enable:		deprecated, replaced by irq_enable
+ * @disable:		deprecated, replaced by irq_disable
+ * @ack:		deprecated, replaced by irq_ack
+ * @mask:		deprecated, replaced by irq_mask
+ * @mask_ack:		deprecated, replaced by irq_mask_ack
+ * @unmask:		deprecated, replaced by irq_unmask
+ * @eoi:		deprecated, replaced by irq_eoi
+ * @end:		deprecated, will go away with __do_IRQ()
+ * @set_affinity:	deprecated, replaced by irq_set_affinity
+ * @retrigger:		deprecated, replaced by irq_retrigger
+ * @set_type:		deprecated, replaced by irq_set_type
+ * @set_wake:		deprecated, replaced by irq_wake
+ * @bus_lock:		deprecated, replaced by irq_bus_lock
+ * @bus_sync_unlock:	deprecated, replaced by irq_bus_sync_unlock
  *
- * @bus_lock:		function to lock access to slow bus (i2c) chips
- * @bus_sync_unlock:	function to sync and unlock slow bus (i2c) chips
+ * @irq_startup:	start up the interrupt (defaults to ->enable if NULL)
+ * @irq_shutdown:	shut down the interrupt (defaults to ->disable if NULL)
+ * @irq_enable:		enable the interrupt (defaults to chip->unmask if NULL)
+ * @irq_disable:	disable the interrupt
+ * @irq_ack:		start of a new interrupt
+ * @irq_mask:		mask an interrupt source
+ * @irq_mask_ack:	ack and mask an interrupt source
+ * @irq_unmask:		unmask an interrupt source
+ * @irq_eoi:		end of interrupt
+ * @irq_set_affinity:	set the CPU affinity on SMP machines
+ * @irq_retrigger:	resend an IRQ to the CPU
+ * @irq_set_type:	set the flow type (IRQ_TYPE_LEVEL/etc.) of an IRQ
+ * @irq_set_wake:	enable/disable power-management wake-on of an IRQ
+ * @irq_bus_lock:	function to lock access to slow bus (i2c) chips
+ * @irq_bus_sync_unlock:function to sync and unlock slow bus (i2c) chips
  *
  * @release:		release function solely used by UML
  */
@@ -161,6 +176,25 @@ struct irq_chip {
 	void		(*bus_lock)(unsigned int irq);
 	void		(*bus_sync_unlock)(unsigned int irq);
 
+	unsigned int	(*irq_startup)(struct irq_data *data);
+	void		(*irq_shutdown)(struct irq_data *data);
+	void		(*irq_enable)(struct irq_data *data);
+	void		(*irq_disable)(struct irq_data *data);
+
+	void		(*irq_ack)(struct irq_data *data);
+	void		(*irq_mask)(struct irq_data *data);
+	void		(*irq_mask_ack)(struct irq_data *data);
+	void		(*irq_unmask)(struct irq_data *data);
+	void		(*irq_eoi)(struct irq_data *data);
+
+	int		(*irq_set_affinity)(struct irq_data *data, const struct cpumask *dest, bool force);
+	int		(*irq_retrigger)(struct irq_data *data);
+	int		(*irq_set_type)(struct irq_data *data, unsigned int flow_type);
+	int		(*irq_set_wake)(struct irq_data *data, unsigned int on);
+
+	void		(*irq_bus_lock)(struct irq_data *data);
+	void		(*irq_bus_sync_unlock)(struct irq_data *data);
+
 	/* Currently used only by UML, might disappear one day.*/
 #ifdef CONFIG_IRQ_RELEASE_METHOD
 	void		(*release)(unsigned int irq, void *dev_id);
