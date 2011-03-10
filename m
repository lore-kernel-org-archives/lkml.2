Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab1CJFef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 00:34:35 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:31702 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1CJFed (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 10 Mar 2011 00:34:33 -0500
Date: Thu, 10 Mar 2011 00:33:05 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 12/14] xen: events: remove use of nr_irqs as upper
 bound on number of pirqs
Message-ID: <20110310053305.GD10574@dumpdata.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
 <1299692486-28634-12-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299692486-28634-12-git-send-email-ian.campbell@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D7862E1.00C3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  int xen_irq_from_pirq(unsigned pirq)
>  {
> -	return pirq_to_irq[pirq];
> +	int irq;
> +
> +	struct irq_info *info;
> +
> +	spin_lock(&irq_mapping_update_lock);
> +
> +	list_for_each_entry(info, &xen_irq_list_head, list) {
> +		if (info == NULL || info->type != IRQT_PIRQ)
> +			continue;
> +		irq = info->irq;
> +		if (info->u.pirq.pirq == pirq)
> +			goto out;
> +	}
> +	irq = -1;
> +out:
> +	spin_lock(&irq_mapping_update_lock);
> +
> +	return -1;

Shouldn't this be:

  return irq

?

How come you are using the spin_lock here, but not
in other places when iterating over the xen_irq_list_head?
