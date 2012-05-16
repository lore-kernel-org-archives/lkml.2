Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760710Ab2EPWfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 18:35:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:41725 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430Ab2EPWfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 18:35:13 -0400
Date: Thu, 17 May 2012 00:35:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [WARNING] at kernel/irq/manage.c:421 __enable_irq
In-Reply-To: <1337169432.6724.30.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1205162354310.3231@ionos>
References: <1337131823.6724.11.camel@gandalf.stny.rr.com>  <alpine.LFD.2.02.1205161001500.3231@ionos> <1337169432.6724.30.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012, Steven Rostedt wrote:
> On Wed, 2012-05-16 at 13:27 +0200, Thomas Gleixner wrote:
> > I have an idea how to fix that proper. Will send out patches later.
> 
> I'll test them, but it's a bit of a pain, as it would require me
> shutting down evolution, xchat, firefox, chrome and all my emacs
> windows :-)  This is why I don't reboot this box often.

Ok. Here you go. Compile tested only.

--------------->
Subject: ide: Request irq before calling irq_probe_port
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 16 May 2012 15:53:41 +0200

Steven reported that the warning in __enable_irq(), which yells about
an unbalanced enable_irq() call, is triggered in context of
ide_probe_port().

What happens is:

CPU0               CPU1
disable_irq(X);
ide_do_probe();    request_irq(X, ....);
enable_irq(X)

request_irq() which happens on a non used interrupt undoes nested
disables and enables the interrupt immediately. So the magic probe
code in ide_probe_port() will trigger the unbalanced warning when
enabling the irq at the end of the probe routine. A similar problem
exists when a concurrent device init uses the irq auto probe
functions.

The only solution for this is to request the interrupt _BEFORE_
calling the probe code. That prevents a parallel request_irq for the
same irq line to unconditionally undo the disabled state.

The code contains a few magics which are - as far as I understand the
current code - simply leftovers of the historic ide implementation.

The following comment is completely bogus:
 /*
  * Use cached IRQ number. It might be (and is...) changed by probe
  * code above
  */

hwif->irq is set up _BEFORE_ the probe code is called. There is no
function which modifies it in the context of the probe code.

Sigh, why can't people just clean up the mess when they change the
code flow?

Also the check for hwif->irq != 0 there in the probe code is backwards
as well. Why should we do probing first and then discard the hw
interface because the function which installs the irq handler disables
the interface when hwif->irq == 0 ???

There is nothing wrong with installing the interrupt handler before
calling the probe code. All it takes is a check in the interrupt
handler, so it can nicely coexist with another shared interrupt
handler on the same irq line. 

Famous last words: This shouldn't break anything as the code needs to
deal with shared interrupts anyway.

While at it remove the host.irq_handler member as it is unused and
just adds extra confusion. TBH, I can't be bothered to split that into
a separate patch. I wasted enough time already staring into that
trainwreck.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1337131823.6724.11.camel@gandalf.stny.rr.com
---
 drivers/ide/ide-io.c    |    3 +++
 drivers/ide/ide-probe.c |   46 +++++++++++++++++-----------------------------
 include/linux/ide.h     |    3 +--
 3 files changed, 21 insertions(+), 31 deletions(-)

Index: linux-2.6/drivers/ide/ide-io.c
===================================================================
--- linux-2.6.orig/drivers/ide/ide-io.c
+++ linux-2.6/drivers/ide/ide-io.c
@@ -779,6 +779,9 @@ irqreturn_t ide_intr (int irq, void *dev
 	int plug_device = 0;
 	struct request *uninitialized_var(rq_in_flight);
 
+	if (!(hwif->port_flags & IDE_PFLAG_IRQENA))
+		return IRQ_NONE;
+
 	if (host->host_flags & IDE_HFLAG_SERIALIZE) {
 		if (hwif != host->cur_port)
 			goto out_early;
Index: linux-2.6/drivers/ide/ide-probe.c
===================================================================
--- linux-2.6.orig/drivers/ide/ide-probe.c
+++ linux-2.6/drivers/ide/ide-probe.c
@@ -678,7 +678,6 @@ EXPORT_SYMBOL_GPL(ide_undecoded_slave);
 static int ide_probe_port(ide_hwif_t *hwif)
 {
 	ide_drive_t *drive;
-	unsigned int irqd;
 	int i, rc = -ENODEV;
 
 	BUG_ON(hwif->present);
@@ -688,12 +687,12 @@ static int ide_probe_port(ide_hwif_t *hw
 		return -EACCES;
 
 	/*
-	 * We must always disable IRQ, as probe_for_drive will assert IRQ, but
-	 * we'll install our IRQ driver much later...
+	 * Sigh. The probe code want's to be alone, so we have to
+	 * disable the interrupt line. We cannot disable it reliably
+	 * at the device level, so we have to disable it at the irq
+	 * line level.
 	 */
-	irqd = hwif->irq;
-	if (irqd)
-		disable_irq(hwif->irq);
+	disable_irq(hwif->irq);
 
 	if (ide_port_wait_ready(hwif) == -EBUSY)
 		printk(KERN_DEBUG "%s: Wait for ready failed before probe !\n", hwif->name);
@@ -708,13 +707,8 @@ static int ide_probe_port(ide_hwif_t *hw
 			rc = 0;
 	}
 
-	/*
-	 * Use cached IRQ number. It might be (and is...) changed by probe
-	 * code above
-	 */
-	if (irqd)
-		enable_irq(irqd);
-
+	/* Reenable the interrupt line. */
+	enable_irq(hwif->irq);
 	return rc;
 }
 
@@ -847,13 +841,9 @@ static int init_irq (ide_hwif_t *hwif)
 {
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	struct ide_host *host = hwif->host;
-	irq_handler_t irq_handler = host->irq_handler;
 	int sa = host->irq_flags;
 
-	if (irq_handler == NULL)
-		irq_handler = ide_intr;
-
-	if (request_irq(hwif->irq, irq_handler, sa, hwif->name, hwif))
+	if (request_irq(hwif->irq, ide_intr, sa, hwif->name, hwif))
 		goto out_up;
 
 #if !defined(__mc68000__)
@@ -961,11 +951,6 @@ static void drive_release_dev (struct de
 
 static int hwif_init(ide_hwif_t *hwif)
 {
-	if (!hwif->irq) {
-		printk(KERN_ERR "%s: disabled, no IRQ\n", hwif->name);
-		return 0;
-	}
-
 	if (register_blkdev(hwif->major, hwif->name))
 		return 0;
 
@@ -980,12 +965,6 @@ static int hwif_init(ide_hwif_t *hwif)
 	}
 
 	sg_init_table(hwif->sg_table, hwif->sg_max_nents);
-	
-	if (init_irq(hwif)) {
-		printk(KERN_ERR "%s: disabled, unable to get IRQ %d\n",
-			hwif->name, hwif->irq);
-		goto out;
-	}
 
 	blk_register_region(MKDEV(hwif->major, 0), MAX_DRIVES << PARTN_BITS,
 			    THIS_MODULE, ata_probe, ata_lock, hwif);
@@ -1398,6 +1377,12 @@ int ide_host_register(struct ide_host *h
 	ide_host_for_each_port(i, hwif, host) {
 		if (hwif == NULL)
 			continue;
+		if (!hwif->irq || init_irq(hwif)) {
+			pr_err("%s: disabled, unable to request irq %d\n",
+			       hwif->name, hwif->irq);
+			ide_disable_port(hwif);
+			continue;
+		}
 
 		if (ide_probe_port(hwif) == 0)
 			hwif->present = 1;
@@ -1407,6 +1392,7 @@ int ide_host_register(struct ide_host *h
 		if ((hwif->host_flags & IDE_HFLAG_4DRIVES) == 0 ||
 		    hwif->mate == NULL || hwif->mate->present == 0) {
 			if (ide_register_port(hwif)) {
+				free_irq(hwif->irq, hwif);
 				ide_disable_port(hwif);
 				continue;
 			}
@@ -1425,10 +1411,12 @@ int ide_host_register(struct ide_host *h
 		if (hwif_init(hwif) == 0) {
 			printk(KERN_INFO "%s: failed to initialize IDE "
 					 "interface\n", hwif->name);
+			free_irq(hwif->irq, hwif);
 			device_unregister(&hwif->gendev);
 			ide_disable_port(hwif);
 			continue;
 		}
+		hwif->port_flags |= IDE_PFLAG_IRQENA;
 
 		if (hwif->present)
 			if (ide_port_setup_devices(hwif) == 0) {
Index: linux-2.6/include/linux/ide.h
===================================================================
--- linux-2.6.orig/include/linux/ide.h
+++ linux-2.6/include/linux/ide.h
@@ -660,6 +660,7 @@ struct ide_dma_ops {
 
 enum {
 	IDE_PFLAG_PROBING		= (1 << 0),
+	IDE_PFLAG_IRQENA		= (1 << 1),
 };
 
 struct ide_host;
@@ -782,8 +783,6 @@ struct ide_host {
 	void		(*get_lock)(irq_handler_t, void *);
 	void		(*release_lock)(void);
 
-	irq_handler_t	irq_handler;
-
 	unsigned long	host_flags;
 
 	int		irq_flags;

