Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0JRF2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 01:28:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40048 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab0JRF2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 01:28:49 -0400
Date: Mon, 18 Oct 2010 16:28:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Alex Nixon <alex.nixon@citrix.com>
Subject: linux-next: manual merge of the tip tree with the swiotlb-xen tree
Message-Id: <20101018162835.5077fa3d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/xen/events.c between commits
c21c96b81d9fbe7b2f8e5531792a79fe5d62e737 ("xen: identity map gsi->irqs")
and 4c0acdf07475c087a49262bc69efdf8e68037e39 ("xen: Find an unbound irq
number in reverse order (high to low)") from the swiotlb-xen tree and
commit 77dff1c755c3218691e95e7e38ee14323b35dbdb ("x86: xen: Sanitise
sparse_irq handling") from the tip tree.

I did my best here (including "fixing" other introduced calls to
dynamic_irq_cleanup() - see below).  I can carry this (or some better)
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/xen/events.c
index adad3a9,7d24b0d..0000000
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@@ -354,297 -336,33 +354,296 @@@ static void unmask_evtchn(int port
  	put_cpu();
  }
  
 +static int get_nr_hw_irqs(void)
 +{
 +	int ret = 1;
 +
 +#ifdef CONFIG_X86_IO_APIC
 +	ret = get_nr_irqs_gsi();
 +#endif
 +
 +	return ret;
 +}
 +
  static int find_unbound_irq(void)
  {
- 	int irq;
- 	struct irq_desc *desc;
+ 	struct irq_data *data;
+ 	int irq, res;
 +	int start = get_nr_hw_irqs();
  
 -	for (irq = 0; irq < nr_irqs; irq++) {
 +	if (start == nr_irqs)
 +		goto no_irqs;
 +
 +	/* nr_irqs is a magic value. Must not use it.*/
 +	for (irq = nr_irqs-1; irq > start; irq--) {
- 		desc = irq_to_desc(irq);
+ 		data = irq_get_irq_data(irq);
  		/* only 0->15 have init'd desc; handle irq > 16 */
- 		if (desc == NULL)
+ 		if (!data)
  			break;
- 		if (desc->chip == &no_irq_chip)
+ 		if (data->chip == &no_irq_chip)
  			break;
- 		if (desc->chip != &xen_dynamic_chip)
+ 		if (data->chip != &xen_dynamic_chip)
  			continue;
  		if (irq_info[irq].type == IRQT_UNBOUND)
- 			break;
+ 			return irq;
  	}
  
 -	if (irq == nr_irqs)
 -		panic("No available IRQ to bind to: increase nr_irqs!\n");
 +	if (irq == start)
 +		goto no_irqs;
  
- 	desc = irq_to_desc_alloc_node(irq, 0);
- 	if (WARN_ON(desc == NULL))
- 		return -1;
+ 	res = irq_alloc_desc_at(irq, 0);
  
- 	dynamic_irq_init_keep_chip_data(irq);
+ 	if (WARN_ON(res != irq))
+ 		return -1;
  
  	return irq;
 +
 +no_irqs:
 +	panic("No available IRQ to bind to: increase nr_irqs!\n");
 +}
 +
 +static bool identity_mapped_irq(unsigned irq)
 +{
 +	/* identity map all the hardware irqs */
 +	return irq < get_nr_hw_irqs();
 +}
 +
 +static void pirq_unmask_notify(int irq)
 +{
 +	struct physdev_eoi eoi = { .irq = irq };
 +
 +	if (unlikely(pirq_needs_eoi(irq))) {
 +		int rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
 +		WARN_ON(rc);
 +	}
 +}
 +
 +static void pirq_query_unmask(int irq)
 +{
 +	struct physdev_irq_status_query irq_status;
 +	struct irq_info *info = info_for_irq(irq);
 +
 +	BUG_ON(info->type != IRQT_PIRQ);
 +
 +	irq_status.irq = irq;
 +	if (HYPERVISOR_physdev_op(PHYSDEVOP_irq_status_query, &irq_status))
 +		irq_status.flags = 0;
 +
 +	info->u.pirq.flags &= ~PIRQ_NEEDS_EOI;
 +	if (irq_status.flags & XENIRQSTAT_needs_eoi)
 +		info->u.pirq.flags |= PIRQ_NEEDS_EOI;
 +}
 +
 +static bool probing_irq(int irq)
 +{
 +	struct irq_desc *desc = irq_to_desc(irq);
 +
 +	return desc && desc->action == NULL;
 +}
 +
 +static unsigned int startup_pirq(unsigned int irq)
 +{
 +	struct evtchn_bind_pirq bind_pirq;
 +	struct irq_info *info = info_for_irq(irq);
 +	int evtchn = evtchn_from_irq(irq);
 +	int rc;
 +
 +	BUG_ON(info->type != IRQT_PIRQ);
 +
 +	if (VALID_EVTCHN(evtchn))
 +		goto out;
 +
 +	bind_pirq.pirq = irq;
 +	/* NB. We are happy to share unless we are probing. */
 +	bind_pirq.flags = info->u.pirq.flags & PIRQ_SHAREABLE ?
 +					BIND_PIRQ__WILL_SHARE : 0;
 +	rc = HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq);
 +	if (rc != 0) {
 +		if (!probing_irq(irq))
 +			printk(KERN_INFO "Failed to obtain physical IRQ %d\n",
 +			       irq);
 +		return 0;
 +	}
 +	evtchn = bind_pirq.port;
 +
 +	pirq_query_unmask(irq);
 +
 +	evtchn_to_irq[evtchn] = irq;
 +	bind_evtchn_to_cpu(evtchn, 0);
 +	info->evtchn = evtchn;
 +
 +out:
 +	unmask_evtchn(evtchn);
 +	pirq_unmask_notify(irq);
 +
 +	return 0;
 +}
 +
 +static void shutdown_pirq(unsigned int irq)
 +{
 +	struct evtchn_close close;
 +	struct irq_info *info = info_for_irq(irq);
 +	int evtchn = evtchn_from_irq(irq);
 +
 +	BUG_ON(info->type != IRQT_PIRQ);
 +
 +	if (!VALID_EVTCHN(evtchn))
 +		return;
 +
 +	mask_evtchn(evtchn);
 +
 +	close.port = evtchn;
 +	if (HYPERVISOR_event_channel_op(EVTCHNOP_close, &close) != 0)
 +		BUG();
 +
 +	bind_evtchn_to_cpu(evtchn, 0);
 +	evtchn_to_irq[evtchn] = -1;
 +	info->evtchn = 0;
 +}
 +
 +static void enable_pirq(unsigned int irq)
 +{
 +	startup_pirq(irq);
 +}
 +
 +static void disable_pirq(unsigned int irq)
 +{
 +}
 +
 +static void ack_pirq(unsigned int irq)
 +{
 +	int evtchn = evtchn_from_irq(irq);
 +
 +	move_native_irq(irq);
 +
 +	if (VALID_EVTCHN(evtchn)) {
 +		mask_evtchn(evtchn);
 +		clear_evtchn(evtchn);
 +	}
 +}
 +
 +static void end_pirq(unsigned int irq)
 +{
 +	int evtchn = evtchn_from_irq(irq);
 +	struct irq_desc *desc = irq_to_desc(irq);
 +
 +	if (WARN_ON(!desc))
 +		return;
 +
 +	if ((desc->status & (IRQ_DISABLED|IRQ_PENDING)) ==
 +	    (IRQ_DISABLED|IRQ_PENDING)) {
 +		shutdown_pirq(irq);
 +	} else if (VALID_EVTCHN(evtchn)) {
 +		unmask_evtchn(evtchn);
 +		pirq_unmask_notify(irq);
 +	}
 +}
 +
 +static int find_irq_by_gsi(unsigned gsi)
 +{
 +	int irq;
 +
 +	for (irq = 0; irq < nr_irqs; irq++) {
 +		struct irq_info *info = info_for_irq(irq);
 +
 +		if (info == NULL || info->type != IRQT_PIRQ)
 +			continue;
 +
 +		if (gsi_from_irq(irq) == gsi)
 +			return irq;
 +	}
 +
 +	return -1;
 +}
 +
 +/* xen_allocate_irq might allocate irqs from the top down, as a
 + * consequence don't assume that the irq number returned has a low value
 + * or can be used as a pirq number unless you know otherwise.
 + *
 + * One notable exception is when xen_allocate_irq is called passing an
 + * hardware gsi as argument, in that case the irq number returned
 + * matches the gsi number passed as first argument.
 +
 + * Note: We don't assign an
 + * event channel until the irq actually started up.  Return an
 + * existing irq if we've already got one for the gsi.
 + */
 +int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
 +{
 +	int irq;
 +	struct physdev_irq irq_op;
 +
 +	spin_lock(&irq_mapping_update_lock);
 +
 +	irq = find_irq_by_gsi(gsi);
 +	if (irq != -1) {
 +		printk(KERN_INFO "xen_allocate_pirq: returning irq %d for gsi %u\n",
 +		       irq, gsi);
 +		goto out;	/* XXX need refcount? */
 +	}
 +
 +	/* If we are a PV guest, we don't have GSIs (no ACPI passed). Therefore
 +	 * we are using the !xen_initial_domain() to drop in the function.*/
 +	if (identity_mapped_irq(gsi) || !xen_initial_domain()) {
 +		irq = gsi;
 +		irq_to_desc_alloc_node(irq, 0);
 +		dynamic_irq_init(irq);
 +	} else
 +		irq = find_unbound_irq();
 +
 +	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
 +				      handle_level_irq, name);
 +
 +	irq_op.irq = irq;
 +	irq_op.vector = 0;
 +
 +	/* Only the privileged domain can do this. For non-priv, the pcifront
 +	 * driver provides a PCI bus that does the call to do exactly
 +	 * this in the priv domain. */
 +	if (xen_initial_domain() &&
 +	    HYPERVISOR_physdev_op(PHYSDEVOP_alloc_irq_vector, &irq_op)) {
- 		dynamic_irq_cleanup(irq);
++		irq_free_desc(irq);
 +		irq = -ENOSPC;
 +		goto out;
 +	}
 +
 +	irq_info[irq] = mk_pirq_info(0, gsi, irq_op.vector);
 +	irq_info[irq].u.pirq.flags |= shareable ? PIRQ_SHAREABLE : 0;
 +
 +out:
 +	spin_unlock(&irq_mapping_update_lock);
 +
 +	return irq;
 +}
 +
 +int xen_destroy_irq(int irq)
 +{
 +	struct irq_desc *desc;
 +	int rc = -ENOENT;
 +
 +	spin_lock(&irq_mapping_update_lock);
 +
 +	desc = irq_to_desc(irq);
 +	if (!desc)
 +		goto out;
 +
 +	irq_info[irq] = mk_unbound_info();
 +
- 	dynamic_irq_cleanup(irq);
++	irq_free_desc(irq);
 +
 +out:
 +	spin_unlock(&irq_mapping_update_lock);
 +	return rc;
 +}
 +
 +int xen_vector_from_irq(unsigned irq)
 +{
 +	return vector_from_irq(irq);
 +}
 +
 +int xen_gsi_from_irq(unsigned irq)
 +{
 +	return gsi_from_irq(irq);
  }
  
  int bind_evtchn_to_irq(unsigned int evtchn)
