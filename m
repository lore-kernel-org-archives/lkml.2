Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2EYJSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:18:23 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:11827 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab2EYJSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:18:21 -0400
X-IronPort-AV: E=Sophos;i="4.75,655,1330905600"; 
   d="scan'208";a="12665656"
Date: Fri, 25 May 2012 10:18:05 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 4/4] xen/events: Add WARN_ON when quick lookup
 found invalid type.
In-Reply-To: <20120524182817.GM24934@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.00.1205251016370.26786@kaball-desktop>
References: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com> <1337795222-29946-5-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.00.1205241154150.26786@kaball-desktop> <20120524182817.GM24934@phenom.dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012, Konrad Rzeszutek Wilk wrote:
> On Thu, May 24, 2012 at 11:58:11AM +0100, Stefano Stabellini wrote:
> > On Wed, 23 May 2012, Konrad Rzeszutek Wilk wrote:
> > > All of the bind_XYZ_to_irq do a quick lookup to see if the
> > > event exists. And if they that value is returned instead of
> > 
> >                            ^
> 
> ... snip. How about this:
> 
> >From 5963cc2699db7b2893e7925bd2e68ada9d97e8ef Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Wed, 23 May 2012 13:28:44 -0400
> Subject: [PATCH] xen/events: Add WARN_ON when quick lookup found invalid
>  type.
> 
> All of the bind_XYZ_to_irq do a quick lookup to see if the
> event exists. And if it does, then the initialized IRQ number
> is returned instead of initializing a new IRQ number.
> 
> This patch adds an extra logic to check that the type returned
> is proper one and that there is an IRQ handler setup for it.
> 
> This patch has the benefit of being able to find drivers that
> are doing something naught.
> 
> [v1: Enhanced based on Stefano's review]
>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>  drivers/xen/events.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index faae2f9..81f338a 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -827,6 +827,9 @@ int bind_evtchn_to_irq(unsigned int evtchn)
>  					      handle_edge_irq, "event");
>  
>  		xen_irq_info_evtchn_init(irq, evtchn);
> +	} else {
> +		struct irq_info *info = info_for_irq(irq);
> +		WARN_ON(info == NULL || info->type != IRQT_EVTCHN);
>  	}
>  
>  out:
> @@ -862,8 +865,10 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
>  		xen_irq_info_ipi_init(cpu, irq, evtchn, ipi);
>  
>  		bind_evtchn_to_cpu(evtchn, cpu);
> +	} else {
> +		struct irq_info *info = info_for_irq(irq);
> +		WARN_ON(info == NULL || info->type != IRQT_IPI);
>  	}
> -
>   out:
>  	mutex_unlock(&irq_mapping_update_lock);
>  	return irq;
> @@ -939,8 +944,10 @@ int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
>  		xen_irq_info_virq_init(cpu, irq, evtchn, virq);
>  
>  		bind_evtchn_to_cpu(evtchn, cpu);
> +	} else {
> +		struct irq_info *info = info_for_irq(irq);
> +		WARN_ON(info == NULL || info->type != IRQT_VIRQ);
>  	}
> -
>  out:
>  	mutex_unlock(&irq_mapping_update_lock);
>  

I don't want to nitpick but you removed 2 out of 3 spaced before the out
label.
In any case:

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
