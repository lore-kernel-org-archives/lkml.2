Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab0K2SAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:00:46 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:34120 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab0K2SAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:00:44 -0500
X-IronPort-AV: E=Sophos;i="4.59,276,1288569600"; 
   d="scan'208";a="3097356"
Date: Mon, 29 Nov 2010 18:00:39 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH] xen: fix MSI setup and teardown for PV on HVM guests
In-Reply-To: <20101129170351.GA20952@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1011291738520.14723@kaball-desktop>
References: <alpine.DEB.2.00.1011251904370.2373@kaball-desktop> <20101129170351.GA20952@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010, Konrad Rzeszutek Wilk wrote:
> On Fri, Nov 26, 2010 at 02:59:10PM +0000, Stefano Stabellini wrote:
> > xen: fix MSI setup and teardown for PV on HVM guests
> > 
> > When remapping MSIs into pirqs for PV on HVM guests, qemu is responsible
> > for doing the actual mapping and unmapping.
> 
> Is this QEMU version dependent? 

It depends on both qemu and xen: the presence of this feature (pirq
remapping for hvm guests) is signaled by the flag
XENFEAT_hvm_pirqs that we check in pci_xen_hvm_init.


> > We only give qemu the desired pirq number when we ask to do the mapping
> > the first time, after that we should be reading back the pirq number
> > from qemu every time we want to re-enable the MSI.
> 
> What about IRQ migration from CPU to CPU?

that should follow the normal pirq/evtchn migration code paths in
drivers/xen/event.c


> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> > index d7b5109..ff81d67 100644
> > --- a/arch/x86/pci/xen.c
> > +++ b/arch/x86/pci/xen.c
> > @@ -98,8 +98,26 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> >  	struct msi_msg msg;
> >  
> >  	list_for_each_entry(msidesc, &dev->msi_list, list) {
> > +		__read_msi_msg(msidesc, &msg);
> > +		pirq = MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
> > +			((msg.address_lo >> MSI_ADDR_DEST_ID_SHIFT) & 0xff);
> > +		if (xen_irq_from_pirq(pirq) >= 0 &&
> > +			msg.data == (MSI_DATA_TRIGGER_EDGE |
> > +					     MSI_DATA_LEVEL_ASSERT |
> > +						 (3 << 8) |
> > +						 MSI_DATA_VECTOR(0))) {
> 
> A similar construct is used in xen_msi_compose_msg function. Could you
> make this an #define?

yes, good idea.


> > +			xen_allocate_pirq_msi((type == PCI_CAP_ID_MSIX) ?
> > +					"msi-x" : "msi", &irq, &pirq, XEN_ALLOC_IRQ);
> > +			if (irq < 0 || pirq < 0)
> 
> The pirq value won't be touched at all, since you are passing in XEN_ALLOC_IRQ.
> Is there any sense in checking the pirq value here?
> 

not really, just legacy. I'll fix it.


> > +				goto error;
> > +			ret = set_irq_msi(irq, msidesc);
> > +			if (ret < 0)
> > +				goto error_while;
> > +			printk(KERN_DEBUG "xen: msi already setup: pirq=%d\n", pirq);
> 
> While that is technically correct, would it make sense to add a comment
> about setting the IRQ value since the printk "xen: msi-->irq=%d" is not going
> to be reached?

you mean printing the irq value as well? Sure.

---


diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index d7b5109..25cd4a0 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -70,6 +70,9 @@ static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
 struct xen_pci_frontend_ops *xen_pci_frontend;
 EXPORT_SYMBOL_GPL(xen_pci_frontend);
 
+#define XEN_PIRQ_MSI_DATA  (MSI_DATA_TRIGGER_EDGE | \
+		MSI_DATA_LEVEL_ASSERT | (3 << 8) | MSI_DATA_VECTOR(0))
+
 static void xen_msi_compose_msg(struct pci_dev *pdev, unsigned int pirq,
 		struct msi_msg *msg)
 {
@@ -83,12 +86,7 @@ static void xen_msi_compose_msg(struct pci_dev *pdev, unsigned int pirq,
 		MSI_ADDR_REDIRECTION_CPU |
 		MSI_ADDR_DEST_ID(pirq);
 
-	msg->data =
-		MSI_DATA_TRIGGER_EDGE |
-		MSI_DATA_LEVEL_ASSERT |
-		/* delivery mode reserved */
-		(3 << 8) |
-		MSI_DATA_VECTOR(0);
+	msg->data = XEN_PIRQ_MSI_DATA;
 }
 
 static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
@@ -98,8 +96,23 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 	struct msi_msg msg;
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
+		__read_msi_msg(msidesc, &msg);
+		pirq = MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
+			((msg.address_lo >> MSI_ADDR_DEST_ID_SHIFT) & 0xff);
+		if (xen_irq_from_pirq(pirq) >= 0 && msg.data == XEN_PIRQ_MSI_DATA) {
+			xen_allocate_pirq_msi((type == PCI_CAP_ID_MSIX) ?
+					"msi-x" : "msi", &irq, &pirq, XEN_ALLOC_IRQ);
+			if (irq < 0)
+				goto error;
+			ret = set_irq_msi(irq, msidesc);
+			if (ret < 0)
+				goto error_while;
+			printk(KERN_DEBUG "xen: msi already setup: msi --> irq=%d"
+					" pirq=%d\n", irq, pirq);
+			return 0;
+		}
 		xen_allocate_pirq_msi((type == PCI_CAP_ID_MSIX) ?
-				"msi-x" : "msi", &irq, &pirq);
+				"msi-x" : "msi", &irq, &pirq, (XEN_ALLOC_IRQ | XEN_ALLOC_PIRQ));
 		if (irq < 0 || pirq < 0)
 			goto error;
 		printk(KERN_DEBUG "xen: msi --> irq=%d, pirq=%d\n", irq, pirq);
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 7ab43c3..f78945c 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -668,17 +668,21 @@ out:
 #include <linux/msi.h>
 #include "../pci/msi.h"
 
-void xen_allocate_pirq_msi(char *name, int *irq, int *pirq)
+void xen_allocate_pirq_msi(char *name, int *irq, int *pirq, int alloc)
 {
 	spin_lock(&irq_mapping_update_lock);
 
-	*irq = find_unbound_irq();
-	if (*irq == -1)
-		goto out;
+	if (alloc & XEN_ALLOC_IRQ) {
+		*irq = find_unbound_irq();
+		if (*irq == -1)
+			goto out;
+	}
 
-	*pirq = find_unbound_pirq(MAP_PIRQ_TYPE_MSI);
-	if (*pirq == -1)
-		goto out;
+	if (alloc & XEN_ALLOC_PIRQ) {
+		*pirq = find_unbound_pirq(MAP_PIRQ_TYPE_MSI);
+		if (*pirq == -1)
+			goto out;
+	}
 
 	set_irq_chip_and_handler_name(*irq, &xen_pirq_chip,
 				      handle_level_irq, name);
@@ -766,6 +770,7 @@ int xen_destroy_irq(int irq)
 			printk(KERN_WARNING "unmap irq failed %d\n", rc);
 			goto out;
 		}
+		pirq_to_irq[info->u.pirq.pirq] = -1;
 	}
 	irq_info[irq] = mk_unbound_info();
 
@@ -786,6 +791,11 @@ int xen_gsi_from_irq(unsigned irq)
 	return gsi_from_irq(irq);
 }
 
+int xen_irq_from_pirq(unsigned pirq)
+{
+	return pirq_to_irq[pirq];
+}
+
 int bind_evtchn_to_irq(unsigned int evtchn)
 {
 	int irq;
diff --git a/include/xen/events.h b/include/xen/events.h
index 646dd17..00f53dd 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -76,7 +76,9 @@ int xen_map_pirq_gsi(unsigned pirq, unsigned gsi, int shareable, char *name);
 
 #ifdef CONFIG_PCI_MSI
 /* Allocate an irq and a pirq to be used with MSIs. */
-void xen_allocate_pirq_msi(char *name, int *irq, int *pirq);
+#define XEN_ALLOC_PIRQ (1 << 0)
+#define XEN_ALLOC_IRQ  (1 << 1)
+void xen_allocate_pirq_msi(char *name, int *irq, int *pirq, int alloc_mask);
 int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type);
 #endif
 
@@ -89,4 +91,7 @@ int xen_vector_from_irq(unsigned pirq);
 /* Return gsi allocated to pirq */
 int xen_gsi_from_irq(unsigned pirq);
 
+/* Return irq from pirq */
+int xen_irq_from_pirq(unsigned pirq);
+
 #endif	/* _XEN_EVENTS_H */
