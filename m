Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1HIJRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 05:17:47 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:57608 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1HIJRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 05:17:46 -0400
X-IronPort-AV: E=Sophos;i="4.67,342,1309737600"; 
   d="scan'208";a="7171996"
Subject: Re: [Xen-devel] [PATCH 2/3] xen/pv-on-hvm kexec: rebind virqs to
 existing eventchannel ports
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Konrad <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
In-Reply-To: <20110804162054.510901329@aepfle.de>
References: <20110804162053.723541930@aepfle.de>
	 <20110804162054.510901329@aepfle.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 9 Aug 2011 10:17:40 +0100
Message-ID: <1312881460.26263.46.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 17:20 +0100, Olaf Hering wrote:
> During a kexec boot some virqs such as timer and debugirq were already
> registered by the old kernel.  The hypervisor will return -EEXISTS from
> the new EVTCHNOP_bind_virq request and the BUG in bind_virq_to_irq()
> triggers.  Catch the -EEXISTS error and loop through all possible ports to find
> what port belongs to the virq/cpu combo.

Would it be better to proactively just query the status of all event
channels early on, like you do in find_virq, and setup the irq info
structures as appropriate? Rather than waiting for an -EEXISTS I mean.

> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> 
> ---
>  drivers/xen/events.c |   40 +++++++++++++++++++++++++++++++++++-----
>  1 file changed, 35 insertions(+), 5 deletions(-)
> 
> Index: linux-3.0/drivers/xen/events.c
> ===================================================================
> --- linux-3.0.orig/drivers/xen/events.c
> +++ linux-3.0/drivers/xen/events.c
> @@ -877,11 +877,35 @@ static int bind_interdomain_evtchn_to_ir
>  	return err ? : bind_evtchn_to_irq(bind_interdomain.local_port);
>  }
>  
> +/* BITS_PER_LONG is used in Xen */
> +#define MAX_EVTCHNS (64 * 64)
> +
> +static int find_virq(unsigned int virq, unsigned int cpu)
> +{
> +	struct evtchn_status status;
> +	int port, rc = -ENOENT;
> +
> +	memset(&status, 0, sizeof(status));
> +	for (port = 0; port <= MAX_EVTCHNS; port++) {
> +		status.dom = DOMID_SELF;
> +		status.port = port;
> +		rc = HYPERVISOR_event_channel_op(EVTCHNOP_status, &status);
> +		if (rc < 0)
> +			continue;
> +		if (status.status != EVTCHNSTAT_virq)
> +			continue;
> +		if (status.u.virq == virq && status.vcpu == cpu) {
> +			rc = port;
> +			break;
> +		}
> +	}
> +	return rc;
> +}
>  
>  int bind_virq_to_irq(unsigned int virq, unsigned int cpu)
>  {
>  	struct evtchn_bind_virq bind_virq;
> -	int evtchn, irq;
> +	int evtchn, irq, ret;
>  
>  	spin_lock(&irq_mapping_update_lock);
>  
> @@ -897,10 +921,16 @@ int bind_virq_to_irq(unsigned int virq,
>  
>  		bind_virq.virq = virq;
>  		bind_virq.vcpu = cpu;
> -		if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_virq,
> -						&bind_virq) != 0)
> -			BUG();
> -		evtchn = bind_virq.port;
> +		ret = HYPERVISOR_event_channel_op(EVTCHNOP_bind_virq,
> +						&bind_virq);
> +		if (ret == 0)
> +			evtchn = bind_virq.port;
> +		else {
> +			if (ret == -EEXIST)
> +				ret = find_virq(virq, cpu);
> +			BUG_ON(ret < 0);
> +			evtchn = ret;
> +		}
>  
>  		xen_irq_info_virq_init(cpu, irq, evtchn, virq);
>  
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel


