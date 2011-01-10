Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab1AJPuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 10:50:23 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:48499 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab1AJPuV (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 10 Jan 2011 10:50:21 -0500
Date: Mon, 10 Jan 2011 10:49:40 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: joe.jin@oracle.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/bug-fixes
Message-ID: <20110110154940.GA25694@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linus,

Please git pull since commit cf7d7e5a1980d1116ee152d25dac382b112b9c17
Linus Torvalds (1):
    Linux 2.6.37-rc5

patches from:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug-fixes


The fixes (except the NUMA one) are pretty light and were found during
heavy migration testing. The NUMA fix was bootup issues and has already
been merged in Debian distro.

Ian Campbell (1):
      xen: disable ACPI NUMA for PV guests

Joe Jin (3):
      xen/fb: fix xenfb suspend/resume race.
      xen/fb: fix potential memory leak
      xen/event: validate irq before get evtchn by irq

Konrad Rzeszutek Wilk (1):
      xen/irq: Cleanup the find_unbound_irq


 arch/x86/xen/enlighten.c    |    9 +++++++++
 drivers/video/xen-fbfront.c |   19 +++++++++++--------
 drivers/xen/events.c        |   21 +++++++++++++++------
 3 files changed, 35 insertions(+), 14 deletions(-)


diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 44dcad4..ed47d12 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1174,6 +1174,15 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_smp_init();
 
+#ifdef CONFIG_ACPI_NUMA
+	/*
+	 * The pages we from Xen are not related to machine pages, so
+	 * any NUMA information the kernel tries to get from ACPI will
+	 * be meaningless.  Prevent it from trying.
+	 */
+	acpi_numa = -1;
+#endif
+
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
 	if (!xen_initial_domain())
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 428d273..95bbd0a 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -562,26 +562,24 @@ static void xenfb_init_shared_page(struct xenfb_info *info,
 static int xenfb_connect_backend(struct xenbus_device *dev,
 				 struct xenfb_info *info)
 {
-	int ret, evtchn;
+	int ret, evtchn, irq;
 	struct xenbus_transaction xbt;
 
 	ret = xenbus_alloc_evtchn(dev, &evtchn);
 	if (ret)
 		return ret;
-	ret = bind_evtchn_to_irqhandler(evtchn, xenfb_event_handler,
+	irq = bind_evtchn_to_irqhandler(evtchn, xenfb_event_handler,
 					0, dev->devicetype, info);
-	if (ret < 0) {
+	if (irq < 0) {
 		xenbus_free_evtchn(dev, evtchn);
 		xenbus_dev_fatal(dev, ret, "bind_evtchn_to_irqhandler");
-		return ret;
+		return irq;
 	}
-	info->irq = ret;
-
  again:
 	ret = xenbus_transaction_start(&xbt);
 	if (ret) {
 		xenbus_dev_fatal(dev, ret, "starting transaction");
-		return ret;
+		goto unbind_irq;
 	}
 	ret = xenbus_printf(xbt, dev->nodename, "page-ref", "%lu",
 			    virt_to_mfn(info->page));
@@ -603,20 +601,25 @@ static int xenfb_connect_backend(struct xenbus_device *dev,
 		if (ret == -EAGAIN)
 			goto again;
 		xenbus_dev_fatal(dev, ret, "completing transaction");
-		return ret;
+		goto unbind_irq;
 	}
 
 	xenbus_switch_state(dev, XenbusStateInitialised);
+	info->irq = irq;
 	return 0;
 
  error_xenbus:
 	xenbus_transaction_end(xbt, 1);
 	xenbus_dev_fatal(dev, ret, "writing xenstore");
+ unbind_irq:
+	unbind_from_irqhandler(irq, info);
 	return ret;
 }
 
 static void xenfb_disconnect_backend(struct xenfb_info *info)
 {
+	/* Prevent xenfb refresh */
+	info->update_wanted = 0;
 	if (info->irq >= 0)
 		unbind_from_irqhandler(info->irq, info);
 	info->irq = -1;
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 31af0ac..3df7e47 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -170,6 +170,9 @@ static struct irq_info *info_for_irq(unsigned irq)
 
 static unsigned int evtchn_from_irq(unsigned irq)
 {
+	if (unlikely(WARN(irq < 0 || irq >= nr_irqs, "Invalid irq %d!\n", irq)))
+		return 0;
+
 	return info_for_irq(irq)->evtchn;
 }
 
@@ -405,15 +408,21 @@ static int find_unbound_irq(void)
 {
 	struct irq_data *data;
 	int irq, res;
-	int start = get_nr_hw_irqs();
+	int bottom = get_nr_hw_irqs();
+	int top = nr_irqs-1;
 
-	if (start == nr_irqs)
+	if (bottom == nr_irqs)
 		goto no_irqs;
 
-	/* nr_irqs is a magic value. Must not use it.*/
-	for (irq = nr_irqs-1; irq > start; irq--) {
+	/* This loop starts from the top of IRQ space and goes down.
+	 * We need this b/c if we have a PCI device in a Xen PV guest
+	 * we do not have an IO-APIC (though the backend might have them)
+	 * mapped in. To not have a collision of physical IRQs with the Xen
+	 * event channels start at the top of the IRQ space for virtual IRQs.
+	 */
+	for (irq = top; irq > bottom; irq--) {
 		data = irq_get_irq_data(irq);
-		/* only 0->15 have init'd desc; handle irq > 16 */
+		/* only 15->0 have init'd desc; handle irq > 16 */
 		if (!data)
 			break;
 		if (data->chip == &no_irq_chip)
@@ -424,7 +433,7 @@ static int find_unbound_irq(void)
 			return irq;
 	}
 
-	if (irq == start)
+	if (irq == bottom)
 		goto no_irqs;
 
 	res = irq_alloc_desc_at(irq, -1);
