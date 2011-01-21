Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1AUW1C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 17:27:02 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:51384 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab1AUW06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 17:26:58 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: sparclinux <sparclinux@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 3/5] sparc64: all pointers to irq_handler_data renamed to handler_data
Date: Fri, 21 Jan 2011 23:26:54 +0100
Message-Id: <1295648816-29516-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20110121222451.GA29468@merkur.ravnborg.org>
References: <20110121222451.GA29468@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation of moving to use irq_data.handler_data rename
all pointers to irq_handler_data "handler_data".
This will also prevent name clash when we introduce the
new irq methods.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/sparc/kernel/irq_64.c |   78 ++++++++++++++++++++++----------------------
 1 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index d4d1233..a763f9a 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -277,15 +277,15 @@ static int irq_choose_cpu(unsigned int virt_irq, const struct cpumask *affinity)
 
 static void sun4u_irq_enable(unsigned int virt_irq)
 {
-	struct irq_handler_data *data = get_irq_chip_data(virt_irq);
+	struct irq_handler_data *handler_data = get_irq_chip_data(virt_irq);
 
-	if (likely(data)) {
+	if (likely(handler_data)) {
 		unsigned long cpuid, imap, val;
 		unsigned int tid;
 
 		cpuid = irq_choose_cpu(virt_irq,
 				       irq_desc[virt_irq].irq_data.affinity);
-		imap = data->imap;
+		imap = handler_data->imap;
 
 		tid = sun4u_compute_tid(imap, cpuid);
 
@@ -294,21 +294,21 @@ static void sun4u_irq_enable(unsigned int virt_irq)
 			 IMAP_AID_SAFARI | IMAP_NID_SAFARI);
 		val |= tid | IMAP_VALID;
 		upa_writeq(val, imap);
-		upa_writeq(ICLR_IDLE, data->iclr);
+		upa_writeq(ICLR_IDLE, handler_data->iclr);
 	}
 }
 
 static int sun4u_set_affinity(unsigned int virt_irq,
 			       const struct cpumask *mask)
 {
-	struct irq_handler_data *data = get_irq_chip_data(virt_irq);
+	struct irq_handler_data *handler_data = get_irq_chip_data(virt_irq);
 
-	if (likely(data)) {
+	if (likely(handler_data)) {
 		unsigned long cpuid, imap, val;
 		unsigned int tid;
 
 		cpuid = irq_choose_cpu(virt_irq, mask);
-		imap = data->imap;
+		imap = handler_data->imap;
 
 		tid = sun4u_compute_tid(imap, cpuid);
 
@@ -317,7 +317,7 @@ static int sun4u_set_affinity(unsigned int virt_irq,
 			 IMAP_AID_SAFARI | IMAP_NID_SAFARI);
 		val |= tid | IMAP_VALID;
 		upa_writeq(val, imap);
-		upa_writeq(ICLR_IDLE, data->iclr);
+		upa_writeq(ICLR_IDLE, handler_data->iclr);
 	}
 
 	return 0;
@@ -346,14 +346,14 @@ static void sun4u_irq_disable(unsigned int virt_irq)
 
 static void sun4u_irq_eoi(unsigned int virt_irq)
 {
-	struct irq_handler_data *data = get_irq_chip_data(virt_irq);
+	struct irq_handler_data *handler_data = get_irq_chip_data(virt_irq);
 	struct irq_desc *desc = irq_desc + virt_irq;
 
 	if (unlikely(desc->status & (IRQ_DISABLED|IRQ_INPROGRESS)))
 		return;
 
-	if (likely(data))
-		upa_writeq(ICLR_IDLE, data->iclr);
+	if (likely(handler_data))
+		upa_writeq(ICLR_IDLE, handler_data->iclr);
 }
 
 static void sun4v_irq_enable(unsigned int virt_irq)
@@ -530,10 +530,10 @@ static struct irq_chip sun4v_virq = {
 static void pre_flow_handler(unsigned int virt_irq,
 				      struct irq_desc *desc)
 {
-	struct irq_handler_data *data = get_irq_chip_data(virt_irq);
+	struct irq_handler_data *handler_data = get_irq_chip_data(virt_irq);
 	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
 
-	data->pre_handler(ino, data->arg1, data->arg2);
+	handler_data->pre_handler(ino, handler_data->arg1, handler_data->arg2);
 
 	handle_fasteoi_irq(virt_irq, desc);
 }
@@ -542,12 +542,12 @@ void irq_install_pre_handler(int virt_irq,
 			     void (*func)(unsigned int, void *, void *),
 			     void *arg1, void *arg2)
 {
-	struct irq_handler_data *data = get_irq_chip_data(virt_irq);
+	struct irq_handler_data *handler_data = get_irq_chip_data(virt_irq);
 	struct irq_desc *desc = irq_desc + virt_irq;
 
-	data->pre_handler = func;
-	data->arg1 = arg1;
-	data->arg2 = arg2;
+	handler_data->pre_handler = func;
+	handler_data->arg1 = arg1;
+	handler_data->arg2 = arg2;
 
 	desc->handle_irq = pre_flow_handler;
 }
@@ -555,7 +555,7 @@ void irq_install_pre_handler(int virt_irq,
 unsigned int build_irq(int inofixup, unsigned long iclr, unsigned long imap)
 {
 	struct ino_bucket *bucket;
-	struct irq_handler_data *data;
+	struct irq_handler_data *handler_data;
 	unsigned int virt_irq;
 	int ino;
 
@@ -573,19 +573,19 @@ unsigned int build_irq(int inofixup, unsigned long iclr, unsigned long imap)
 					      "IVEC");
 	}
 
-	data = get_irq_chip_data(virt_irq);
-	if (unlikely(data))
+	handler_data = get_irq_chip_data(virt_irq);
+	if (unlikely(handler_data))
 		goto out;
 
-	data = kzalloc(sizeof(struct irq_handler_data), GFP_ATOMIC);
-	if (unlikely(!data)) {
+	handler_data = kzalloc(sizeof(struct irq_handler_data), GFP_ATOMIC);
+	if (unlikely(!handler_data)) {
 		prom_printf("IRQ: kzalloc(irq_handler_data) failed.\n");
 		prom_halt();
 	}
-	set_irq_chip_data(virt_irq, data);
+	set_irq_chip_data(virt_irq, handler_data);
 
-	data->imap  = imap;
-	data->iclr  = iclr;
+	handler_data->imap  = imap;
+	handler_data->iclr  = iclr;
 
 out:
 	return virt_irq;
@@ -595,7 +595,7 @@ static unsigned int sun4v_build_common(unsigned long sysino,
 				       struct irq_chip *chip)
 {
 	struct ino_bucket *bucket;
-	struct irq_handler_data *data;
+	struct irq_handler_data *handler_data;
 	unsigned int virt_irq;
 
 	BUG_ON(tlb_type != hypervisor);
@@ -610,23 +610,23 @@ static unsigned int sun4v_build_common(unsigned long sysino,
 					      "IVEC");
 	}
 
-	data = get_irq_chip_data(virt_irq);
-	if (unlikely(data))
+	handler_data = get_irq_chip_data(virt_irq);
+	if (unlikely(handler_data))
 		goto out;
 
-	data = kzalloc(sizeof(struct irq_handler_data), GFP_ATOMIC);
-	if (unlikely(!data)) {
+	handler_data = kzalloc(sizeof(struct irq_handler_data), GFP_ATOMIC);
+	if (unlikely(!handler_data)) {
 		prom_printf("IRQ: kzalloc(irq_handler_data) failed.\n");
 		prom_halt();
 	}
-	set_irq_chip_data(virt_irq, data);
+	set_irq_chip_data(virt_irq, handler_data);
 
 	/* Catch accidental accesses to these things.  IMAP/ICLR handling
 	 * is done by hypervisor calls on sun4v platforms, not by direct
 	 * register accesses.
 	 */
-	data->imap = ~0UL;
-	data->iclr = ~0UL;
+	handler_data->imap = ~0UL;
+	handler_data->iclr = ~0UL;
 
 out:
 	return virt_irq;
@@ -641,7 +641,7 @@ unsigned int sun4v_build_irq(u32 devhandle, unsigned int devino)
 
 unsigned int sun4v_build_virq(u32 devhandle, unsigned int devino)
 {
-	struct irq_handler_data *data;
+	struct irq_handler_data *handler_data;
 	unsigned long hv_err, cookie;
 	struct ino_bucket *bucket;
 	struct irq_desc *desc;
@@ -669,8 +669,8 @@ unsigned int sun4v_build_virq(u32 devhandle, unsigned int devino)
 				      handle_fasteoi_irq,
 				      "IVEC");
 
-	data = kzalloc(sizeof(struct irq_handler_data), GFP_ATOMIC);
-	if (unlikely(!data))
+	handler_data = kzalloc(sizeof(struct irq_handler_data), GFP_ATOMIC);
+	if (unlikely(!handler_data))
 		return 0;
 
 	/* In order to make the LDC channel startup sequence easier,
@@ -680,14 +680,14 @@ unsigned int sun4v_build_virq(u32 devhandle, unsigned int devino)
 	desc = irq_desc + virt_irq;
 	desc->status |= IRQ_NOAUTOEN;
 
-	set_irq_chip_data(virt_irq, data);
+	set_irq_chip_data(virt_irq, handler_data);
 
 	/* Catch accidental accesses to these things.  IMAP/ICLR handling
 	 * is done by hypervisor calls on sun4v platforms, not by direct
 	 * register accesses.
 	 */
-	data->imap = ~0UL;
-	data->iclr = ~0UL;
+	handler_data->imap = ~0UL;
+	handler_data->iclr = ~0UL;
 
 	cookie = ~__pa(bucket);
 	hv_err = sun4v_vintr_set_cookie(devhandle, devino, cookie);
-- 
1.6.0.6

