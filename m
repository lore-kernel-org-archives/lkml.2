Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab1CJFXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 00:23:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:63095 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab1CJFXT (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 10 Mar 2011 00:23:19 -0500
Date: Thu, 10 Mar 2011 00:22:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 10/14] xen: events: maintain a list of Xen
 interrupts
Message-ID: <20110310052218.GB10574@dumpdata.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
 <1299692486-28634-10-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299692486-28634-10-git-send-email-ian.campbell@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D78603F.00BF,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 05:41:22PM +0000, Ian Campbell wrote:
> In a PVHVM kernel not all interrupts are Xen interrupts (APIC interrupts can also be present).
> 
> Currently we get away with walking over all interrupts because the
> lookup in the irq_info array simply returns IRQT_UNBOUND and we ignore
> it. However this array will be going away in a future patch so we need
> to manually track which interrupts have been allocated by the Xen
> events infrastructure.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> ---
>  drivers/xen/events.c |   59 +++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 44 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index cf372d4..e119989 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -56,6 +56,8 @@
>   */
>  static DEFINE_SPINLOCK(irq_mapping_update_lock);
>  
> +static LIST_HEAD(xen_irq_list_head);
> +
>  /* IRQ <-> VIRQ mapping. */
>  static DEFINE_PER_CPU(int [NR_VIRQS], virq_to_irq) = {[0 ... NR_VIRQS-1] = -1};
>  
> @@ -85,7 +87,9 @@ enum xen_irq_type {
>   */
>  struct irq_info
>  {
> +	struct list_head list;
>  	enum xen_irq_type type;	/* type */
> +	unsigned irq;
>  	unsigned short evtchn;	/* event channel */
>  	unsigned short cpu;	/* cpu bound */
>  
> @@ -135,6 +139,7 @@ static void xen_irq_info_common_init(struct irq_info *info,
>  	BUG_ON(info->type != IRQT_UNBOUND && info->type != type);
>  
>  	info->type = type;
> +	info->irq = irq;
>  	info->evtchn = evtchn;
>  	info->cpu = cpu;
>  
> @@ -311,10 +316,11 @@ static void init_evtchn_cpu_bindings(void)
>  {
>  	int i;
>  #ifdef CONFIG_SMP
> -	struct irq_desc *desc;
> +	struct irq_info *info;
>  
>  	/* By default all event channels notify CPU#0. */
> -	for_each_irq_desc(i, desc) {
> +	list_for_each_entry(info, &xen_irq_list_head, list) {
> +		struct irq_desc *desc = irq_to_desc(info->irq);
>  		cpumask_copy(desc->irq_data.affinity, cpumask_of(0));
>  	}
>  #endif
> @@ -397,6 +403,21 @@ static void unmask_evtchn(int port)
>  	put_cpu();
>  }
>  
> +static void xen_irq_init(unsigned irq)
> +{
> +	struct irq_info *info;
> +	struct irq_desc *desc = irq_to_desc(irq);
> +
> +	/* By default all event channels notify CPU#0. */
> +	cpumask_copy(desc->irq_data.affinity, cpumask_of(0));
> +
> +	info = &irq_info[irq];
> +
> +	info->type = IRQT_UNBOUND;
> +
> +	list_add_tail(&info->list, &xen_irq_list_head);

Should we use some form of spinlock lock? Just in case
there are two drivers that are being unloaded?
