Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab2EURdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:33:39 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20201 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808Ab2EURdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:33:37 -0400
Date: Mon, 21 May 2012 13:27:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: do not map the same GSI twice
Message-ID: <20120521172703.GA9988@phenom.dumpdata.com>
References: <1337615650-27911-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337615650-27911-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 04:54:10PM +0100, Stefano Stabellini wrote:
> PV on HVM guests map GSIs into event channels; at restore time the
> event channels are resumed by restore_pirqs.
> Device drivers might try to register the same GSI again through ACPI at
> restore time, but the GSI has already been mapped and bound by
> restore_pirqs.

Which means... what kind of error do we get without this patch?

> This patch detects these situations and avoid mapping the same GSI
> multiple times.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/pci/xen.c   |    4 ++++
>  drivers/xen/events.c |    5 +++--
>  include/xen/events.h |    3 +++
>  3 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 7415aa9..56ab749 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -64,6 +64,10 @@ static int xen_register_pirq(u32 gsi, int gsi_override, int triggering,
>  	int shareable = 0;
>  	char *name;
>  
> +	irq = xen_irq_from_gsi(gsi);
> +	if (irq > 0)
> +		return irq;
> +
>  	if (set_pirq)
>  		pirq = gsi;
>  
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 0a8a17c..6908e4c 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -611,7 +611,7 @@ static void disable_pirq(struct irq_data *data)
>  	disable_dynirq(data);
>  }
>  
> -static int find_irq_by_gsi(unsigned gsi)
> +int xen_irq_from_gsi(unsigned gsi)
>  {
>  	struct irq_info *info;
>  
> @@ -625,6 +625,7 @@ static int find_irq_by_gsi(unsigned gsi)
>  
>  	return -1;
>  }
> +EXPORT_SYMBOL_GPL(xen_irq_from_gsi);
>  
>  /*
>   * Do not make any assumptions regarding the relationship between the
> @@ -644,7 +645,7 @@ int xen_bind_pirq_gsi_to_irq(unsigned gsi,
>  
>  	mutex_lock(&irq_mapping_update_lock);
>  
> -	irq = find_irq_by_gsi(gsi);
> +	irq = xen_irq_from_gsi(gsi);
>  	if (irq != -1) {
>  		printk(KERN_INFO "xen_map_pirq_gsi: returning irq %d for gsi %u\n",
>  		       irq, gsi);
> diff --git a/include/xen/events.h b/include/xen/events.h
> index 0f77370..b332bd7 100644
> --- a/include/xen/events.h
> +++ b/include/xen/events.h
> @@ -103,6 +103,9 @@ int xen_irq_from_pirq(unsigned pirq);
>  /* Return the pirq allocated to the irq. */
>  int xen_pirq_from_irq(unsigned irq);
>  
> +/* Return the irq allocated to the gsi */
> +int xen_irq_from_gsi (unsigned gsi);
> +
>  /* Determine whether to ignore this IRQ if it is passed to a guest. */
>  int xen_test_irq_shared(int irq);
>  
> -- 
> 1.7.2.5
