Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab1COLP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:15:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36487 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab1COLOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:14:35 -0400
Message-Id: <20110315111427.129527408@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 15 Mar 2011 07:13:12 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
Subject: [patch 5/8] tpm_tis: Fix the probing for interrupts
References: <20110315111307.895085413@linux.vnet.ibm.com>
Content-Disposition: inline; filename=tpm_fix_irq_probe.v4.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes several aspects of the probing for interrupts.

I am reading the TPM's timeouts before probing for the interrupts. The
tpm_get_timeouts() function is invoked in polling mode and gets the proper
timeouts from the TPM so that we don't need to fall back to 2 minutes timeouts
for short duration commands while the interrupt probing is happening.

I am introducing a variable probed_irq into the vendor structure that gets the
irq number if an interrupt is received while the the tpm_gen_interrupt()
function is run in polling mode during interrupt probing. Previously some
parts of tpm_gen_interrupt() were run in polling mode, then the irq variable 
was set in the interrupt handler when an interrupt was received and execution
of tpm_gen_interrupt() ended up switching over to interrupt mode.
tpm_gen_interrupt() execution ended up on an event queue where it eventually
timed out since the probing handler doesn't wake any queues.

Before calling into free_irq() I am clearing all interrupt flags that may have
been set by the TPM. The reason is that free_irq() will call into the probing
interrupt handler and may otherwise fool us into thinking that a real interrupt
happened (because we see the flags as being set) while the TPM's interrupt line
is not even connected to anything on the motherboard. This solves a problem
one one machine I did testing.

Further, if a TPM claims to use a specifc interrupt, also make sure that that
interrupt is working by running the probing on it as well. If a TPM indicates
that it does not use a specific interrupt (returns '0'), probe all interrupts
from 3 to 15.

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

---
 drivers/char/tpm/tpm.h     |    1 +
 drivers/char/tpm/tpm_tis.c |   33 +++++++++++++++++++++++++++------
 2 files changed, 28 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
+++ linux-2.6/drivers/char/tpm/tpm_tis.c
@@ -436,7 +436,7 @@ static irqreturn_t tis_int_probe(int irq
 	if (interrupt == 0)
 		return IRQ_NONE;
 
-	chip->vendor.irq = irq;
+	chip->vendor.probed_irq = irq;
 
 	/* Clear interrupts handled with TPM_EOI */
 	iowrite32(interrupt,
@@ -484,7 +484,7 @@ static int tpm_tis_init(struct device *d
 			resource_size_t len, unsigned int irq)
 {
 	u32 vendor, intfcaps, intmask;
-	int rc, i;
+	int rc, i, irq_s, irq_e;
 	struct tpm_chip *chip;
 
 	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
@@ -542,6 +542,9 @@ static int tpm_tis_init(struct device *d
 	if (intfcaps & TPM_INTF_DATA_AVAIL_INT)
 		dev_dbg(dev, "\tData Avail Int Support\n");
 
+	/* get the timeouts before testing for irqs */
+	tpm_get_timeouts(chip);
+
 	/* INTERRUPT Setup */
 	init_waitqueue_head(&chip->vendor.read_queue);
 	init_waitqueue_head(&chip->vendor.int_queue);
@@ -560,13 +563,19 @@ static int tpm_tis_init(struct device *d
 	if (interrupts)
 		chip->vendor.irq = irq;
 	if (interrupts && !chip->vendor.irq) {
-		chip->vendor.irq =
+		irq_s =
 		    ioread8(chip->vendor.iobase +
 			    TPM_INT_VECTOR(chip->vendor.locality));
+		if (irq_s) {
+			irq_e = irq_s;
+		} else {
+			irq_s = 3;
+			irq_e = 15;
+		}
 
-		for (i = 3; i < 16 && chip->vendor.irq == 0; i++) {
+		for (i = irq_s; i <= irq_e && chip->vendor.irq == 0; i++) {
 			iowrite8(i, chip->vendor.iobase +
-				    TPM_INT_VECTOR(chip->vendor.locality));
+				 TPM_INT_VECTOR(chip->vendor.locality));
 			if (request_irq
 			    (i, tis_int_probe, IRQF_SHARED,
 			     chip->vendor.miscdev.name, chip) != 0) {
@@ -588,9 +597,22 @@ static int tpm_tis_init(struct device *d
 				  chip->vendor.iobase +
 				  TPM_INT_ENABLE(chip->vendor.locality));
 
+			chip->vendor.probed_irq = 0;
+
 			/* Generate Interrupts */
 			tpm_gen_interrupt(chip);
 
+			chip->vendor.irq = chip->vendor.probed_irq;
+
+			/* free_irq will call into tis_int_probe;
+			   clear all irqs we haven't seen while doing
+			   tpm_gen_interrupt */
+			iowrite32(ioread32
+				  (chip->vendor.iobase +
+				   TPM_INT_STATUS(chip->vendor.locality)),
+				  chip->vendor.iobase +
+				  TPM_INT_STATUS(chip->vendor.locality));
+
 			/* Turn off */
 			iowrite32(intmask,
 				  chip->vendor.iobase +
@@ -629,7 +651,6 @@ static int tpm_tis_init(struct device *d
 	list_add(&chip->vendor.list, &tis_chips);
 	spin_unlock(&tis_lock);
 
-	tpm_get_timeouts(chip);
 	tpm_continue_selftest(chip);
 
 	return 0;
Index: linux-2.6/drivers/char/tpm/tpm.h
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm.h
+++ linux-2.6/drivers/char/tpm/tpm.h
@@ -69,6 +69,7 @@ struct tpm_vendor_specific {
 	unsigned long base;		/* TPM base address */
 
 	int irq;
+	int probed_irq;
 
 	int region_size;
 	int have_region;

