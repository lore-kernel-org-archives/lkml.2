Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1DDQp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:45:27 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:37543 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1DDQpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:45:12 -0400
X-IronPort-AV: E=Sophos;i="4.63,298,1299456000"; 
   d="scan'208";a="5131407"
Date: Mon, 4 Apr 2011 17:46:17 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH] xen: do not clear and mask evtchns in
 __xen_evtchn_do_upcall
In-Reply-To: <20110330154630.GA17427@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1104041521370.16492@kaball-desktop>
References: <alpine.DEB.2.00.1103291505090.16492@kaball-desktop> <20110330154630.GA17427@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Konrad Rzeszutek Wilk wrote:
> On Tue, Mar 29, 2011 at 03:15:07PM +0100, Stefano Stabellini wrote:
> > xen: do not clear and mask evtchns in __xen_evtchn_do_upcall
> > 
> > Switch virqs and pirqs that don't need EOI (in Xen acktype ==
>    ^^                   ^^
> Swap                     irq sub-handlers? 
> > ACKTYPE_NONE, that means the machine irq is actually edge)
> 
> And where is the ACKTYPE_NONE? Is that a Xen hypervisor thing?
> Ah yes. It looks like soo. Perhaps you should rephrase that
> and explain what ACKTYPE_NONE is.
> 
> I think for these patches the more copious the comments are
> the better - in case we want to revisit this in next quarter.

I reworded this part of the commit message, see below updated patch.


> > to handle_edge_irq.
> > 
> > Use handle_fasteoi_irq for pirqs that need eoi (they generally
> > correspond to level triggered irqs), no risk in loosing interrupts
> > because we have to EOI the irq anyway.
> 
> Can you include an URL to explain what EOI/level/edge interrupts
> are? Maybe the correct page in the Intel manual?

I think the best docs we have are the genericirq docbook docs by tglx.


> I wish there was a table explaining when/or what type of eoi
> you need per different type of interrupts. B/c it looks like
> you can do EOI for edge-type interrupts (ISA), but not for
> MSI/MSI-X ones.

Indeed.


> > 
> > This change has the following benefits:
> > 
> > - it uses the very same handlers that Linux would use on native for the
> > same irqs;
> 
> Can you expand? As in for the GSI? Or for the MSI/MSI-X?

Linux on native would use handle_edge_irq for edge irqs and msis, and
handle_fasteoi_irq for everything else.
With this patch we are doing the same thing.


> > - it uses these handlers in the same way Linux would use them: it let
> > Linux mask\unmask and ack the irq when Linux want to mask\unmask and ack
> > the irq;
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index 02b5a9c..4f15dde 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -118,6 +118,8 @@ static DEFINE_PER_CPU(unsigned long [NR_EVENT_CHANNELS/BITS_PER_LONG],
> >  static struct irq_chip xen_dynamic_chip;
> >  static struct irq_chip xen_percpu_chip;
> >  static struct irq_chip xen_pirq_chip;
> > +static void enable_dynirq(struct irq_data *data);
> > +static void disable_dynirq(struct irq_data *data);
> >  
> >  /* Get info for IRQ */
> >  static struct irq_info *info_for_irq(unsigned irq)
> > @@ -473,16 +475,6 @@ static void xen_free_irq(unsigned irq)
> >  	irq_free_desc(irq);
> >  }
> >  
> > -static void pirq_unmask_notify(int irq)
> > -{
> > -	struct physdev_eoi eoi = { .irq = pirq_from_irq(irq) };
> > -
> > -	if (unlikely(pirq_needs_eoi(irq))) {
> > -		int rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
> > -		WARN_ON(rc);
> > -	}
> > -}
> > -
> >  static void pirq_query_unmask(int irq)
> >  {
> >  	struct physdev_irq_status_query irq_status;
> > @@ -506,6 +498,30 @@ static bool probing_irq(int irq)
> >  	return desc && desc->action == NULL;
> >  }
> >  
> > +static void eoi_pirq(struct irq_data *data)
> > +{
> > +	int evtchn = evtchn_from_irq(data->irq);
> > + 	struct irq_info *info = info_for_irq(data->irq);
> > + 	struct physdev_eoi eoi = { .irq = info->u.pirq.gsi };
> 
> No pirq?

great catch, thanks!


> > +	int rc = 0;
> > +
> > +	move_native_irq(data->irq);
> > +
> > +	if (VALID_EVTCHN(evtchn))
> > +		clear_evtchn(evtchn);
> > +
> > +	if (pirq_needs_eoi(data->irq)) {
> 
> Hm, you are using the Linux IRQ here, not the PIRQ value.

this one is correct, I believe


> > +		rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
> > +		WARN_ON(rc);
> > +	}
> > +}
> > +
> > +static void mask_ack_pirq(struct irq_data *data)
> > +{
> > +	disable_dynirq(data);
> > +	eoi_pirq(data);
> > +}
> > + 
> >  static unsigned int __startup_pirq(unsigned int irq)
> >  {
> >  	struct evtchn_bind_pirq bind_pirq;
> > @@ -539,7 +555,7 @@ static unsigned int __startup_pirq(unsigned int irq)
> >  
> >  out:
> >  	unmask_evtchn(evtchn);
> > -	pirq_unmask_notify(irq);
> > +	eoi_pirq(irq_get_irq_data(irq));
> >  
> >  	return 0;
> >  }
> > @@ -572,27 +588,6 @@ static void shutdown_pirq(struct irq_data *data)
> >  	info->evtchn = 0;
> >  }
> >  
> > -static void enable_pirq(struct irq_data *data)
> > -{
> > -	startup_pirq(data);
> > -}
> > -
> > -static void disable_pirq(struct irq_data *data)
> > -{
> > -}
> > -
> > -static void ack_pirq(struct irq_data *data)
> > -{
> > -	int evtchn = evtchn_from_irq(data->irq);
> > -
> > -	move_native_irq(data->irq);
> > -
> > -	if (VALID_EVTCHN(evtchn)) {
> > -		mask_evtchn(evtchn);
> > -		clear_evtchn(evtchn);
> > -	}
> > -}
> > -
> >  static int find_irq_by_gsi(unsigned gsi)
> >  {
> >  	struct irq_info *info;
> > @@ -639,9 +634,6 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
> >  	if (irq < 0)
> >  		goto out;
> >  
> > -	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
> > -				      handle_level_irq, name);
> > -
> >  	irq_op.irq = irq;
> >  	irq_op.vector = 0;
> >  
> > @@ -658,6 +650,14 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
> >  	xen_irq_info_pirq_init(irq, 0, pirq, gsi, irq_op.vector,
> >  			       shareable ? PIRQ_SHAREABLE : 0);
> >  
> > +	pirq_query_unmask(irq);
> > +	if (pirq_needs_eoi(irq))
> > +		set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
> > +				handle_fasteoi_irq, name);
> > +	else
> > +		set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
> > +				handle_edge_irq, name);
> 
> OK. You need a big comment about this in the code. Explain
> why this is happening. B/c if you look at this from code
> it seems like wrong thing to do for gsi's (as in you would
> think handle_level_irq would the right choice).

Except handle_level_irq is not used anymore anywhere in the kernel, give
a look at arch/x86/kernel/apic/io_apic.c:ioapic_register_intr.

Updated patch, rebased on 2.6.39-rc1 follows:

---


commit 6978531913b45abf3aff048475a2174a2cdaf288
Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Date:   Tue Mar 29 14:15:06 2011 +0000

    xen: do not clear and mask evtchns in __xen_evtchn_do_upcall
    
    Change the irq handler of virqs and pirqs that don't need EOI (pirqs
    that correspond to physical edge interrupts) to handle_edge_irq.
    
    Use handle_fasteoi_irq for pirqs that need eoi (they generally
    correspond to level triggered irqs), no risk in loosing interrupts
    because we have to EOI the irq anyway.
    
    This change has the following benefits:
    
    - it uses the very same handlers that Linux would use on native for the
    same irqs (handle_edge_irq for edge irqs and msis, and
    handle_fasteoi_irq for everything else);
    
    - it uses these handlers in the same way Linux would use them: it let
    Linux mask\unmask and ack the irq when Linux want to mask\unmask and ack
    the irq;
    
    See genericirq in the kernel docbook docs for more informations.
    
    Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 036343b..186eb1e 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -118,6 +118,8 @@ static DEFINE_PER_CPU(unsigned long [NR_EVENT_CHANNELS/BITS_PER_LONG],
 static struct irq_chip xen_dynamic_chip;
 static struct irq_chip xen_percpu_chip;
 static struct irq_chip xen_pirq_chip;
+static void enable_dynirq(struct irq_data *data);
+static void disable_dynirq(struct irq_data *data);
 
 /* Get info for IRQ */
 static struct irq_info *info_for_irq(unsigned irq)
@@ -473,16 +475,6 @@ static void xen_free_irq(unsigned irq)
 	irq_free_desc(irq);
 }
 
-static void pirq_unmask_notify(int irq)
-{
-	struct physdev_eoi eoi = { .irq = pirq_from_irq(irq) };
-
-	if (unlikely(pirq_needs_eoi(irq))) {
-		int rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
-		WARN_ON(rc);
-	}
-}
-
 static void pirq_query_unmask(int irq)
 {
 	struct physdev_irq_status_query irq_status;
@@ -506,6 +498,29 @@ static bool probing_irq(int irq)
 	return desc && desc->action == NULL;
 }
 
+static void eoi_pirq(struct irq_data *data)
+{
+	int evtchn = evtchn_from_irq(data->irq);
+ 	struct physdev_eoi eoi = { .irq = pirq_from_irq(data->irq) };
+	int rc = 0;
+
+	irq_move_irq(data);
+
+	if (VALID_EVTCHN(evtchn))
+		clear_evtchn(evtchn);
+
+	if (pirq_needs_eoi(data->irq)) {
+		rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
+		WARN_ON(rc);
+	}
+}
+
+static void mask_ack_pirq(struct irq_data *data)
+{
+	disable_dynirq(data);
+	eoi_pirq(data);
+}
+ 
 static unsigned int __startup_pirq(unsigned int irq)
 {
 	struct evtchn_bind_pirq bind_pirq;
@@ -539,7 +554,7 @@ static unsigned int __startup_pirq(unsigned int irq)
 
 out:
 	unmask_evtchn(evtchn);
-	pirq_unmask_notify(irq);
+	eoi_pirq(irq_get_irq_data(irq));
 
 	return 0;
 }
@@ -572,27 +587,6 @@ static void shutdown_pirq(struct irq_data *data)
 	info->evtchn = 0;
 }
 
-static void enable_pirq(struct irq_data *data)
-{
-	startup_pirq(data);
-}
-
-static void disable_pirq(struct irq_data *data)
-{
-}
-
-static void ack_pirq(struct irq_data *data)
-{
-	int evtchn = evtchn_from_irq(data->irq);
-
-	irq_move_irq(data);
-
-	if (VALID_EVTCHN(evtchn)) {
-		mask_evtchn(evtchn);
-		clear_evtchn(evtchn);
-	}
-}
-
 static int find_irq_by_gsi(unsigned gsi)
 {
 	struct irq_info *info;
@@ -639,9 +633,6 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 	if (irq < 0)
 		goto out;
 
-	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_level_irq,
-				      name);
-
 	irq_op.irq = irq;
 	irq_op.vector = 0;
 
@@ -658,6 +649,19 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
 	xen_irq_info_pirq_init(irq, 0, pirq, gsi, irq_op.vector,
 			       shareable ? PIRQ_SHAREABLE : 0);
 
+	pirq_query_unmask(irq);
+	/* we try to follow the same convention as Linux on native:
+	 * handle_edge_irq for edge irqs and handle_fasteoi_irq for level
+	 * irqs, see ioapic_register_intr (handle_level_irq is not used
+	 * anymore).
+	 */
+	if (pirq_needs_eoi(irq))
+		irq_set_chip_and_handler_name(irq, &xen_pirq_chip,
+				handle_fasteoi_irq, name);
+	else
+		irq_set_chip_and_handler_name(irq, &xen_pirq_chip,
+				handle_edge_irq, name);
+
 out:
 	spin_unlock(&irq_mapping_update_lock);
 
@@ -690,8 +694,8 @@ int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 	if (irq == -1)
 		goto out;
 
-	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_level_irq,
-				      name);
+	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_edge_irq,
+			name);
 
 	xen_irq_info_pirq_init(irq, 0, pirq, 0, vector, 0);
 	ret = irq_set_msi_desc(irq, msidesc);
@@ -773,7 +777,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 			goto out;
 
 		irq_set_chip_and_handler_name(irq, &xen_dynamic_chip,
-					      handle_fasteoi_irq, "event");
+					      handle_edge_irq, "event");
 
 		xen_irq_info_evtchn_init(irq, evtchn);
 	}
@@ -1181,9 +1185,6 @@ static void __xen_evtchn_do_upcall(void)
 				port = (word_idx * BITS_PER_LONG) + bit_idx;
 				irq = evtchn_to_irq[port];
 
-				mask_evtchn(port);
-				clear_evtchn(port);
-
 				if (irq != -1) {
 					desc = irq_to_desc(irq);
 					if (desc)
@@ -1339,12 +1340,18 @@ static void ack_dynirq(struct irq_data *data)
 {
 	int evtchn = evtchn_from_irq(data->irq);
 
-	irq_move_masked_irq(data);
+	irq_move_irq(data);
 
 	if (VALID_EVTCHN(evtchn))
-		unmask_evtchn(evtchn);
+		clear_evtchn(evtchn);
 }
 
+static void mask_ack_dynirq(struct irq_data *data)
+{
+	disable_dynirq(data);
+	ack_dynirq(data);
+}
+ 
 static int retrigger_dynirq(struct irq_data *data)
 {
 	int evtchn = evtchn_from_irq(data->irq);
@@ -1533,11 +1540,12 @@ void xen_irq_resume(void)
 static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.name			= "xen-dyn",
 
-	.irq_disable		= disable_dynirq,
 	.irq_mask		= disable_dynirq,
 	.irq_unmask		= enable_dynirq,
 
-	.irq_eoi		= ack_dynirq,
+	.irq_ack		= ack_dynirq,
+	.irq_mask_ack		= mask_ack_dynirq,
+
 	.irq_set_affinity	= set_affinity_irq,
 	.irq_retrigger		= retrigger_dynirq,
 };
@@ -1548,13 +1556,12 @@ static struct irq_chip xen_pirq_chip __read_mostly = {
 	.irq_startup		= startup_pirq,
 	.irq_shutdown		= shutdown_pirq,
 
-	.irq_enable		= enable_pirq,
-	.irq_unmask		= enable_pirq,
-
-	.irq_disable		= disable_pirq,
-	.irq_mask		= disable_pirq,
+	.irq_mask		= disable_dynirq,
+	.irq_unmask		= enable_dynirq,
 
-	.irq_ack		= ack_pirq,
+	.irq_ack		= eoi_pirq,
+	.irq_eoi		= eoi_pirq,
+	.irq_mask_ack		= mask_ack_pirq,
 
 	.irq_set_affinity	= set_affinity_irq,
 
