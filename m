Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2FPF61 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:58:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:60684 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab2FPF60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:58:26 -0400
Message-ID: <1339826277.9220.220.camel@pasglop>
Subject: Re: [PATCH 02/12] irqdomain: Always update revmap when setting up a
 virq
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Date: Sat, 16 Jun 2012 15:57:57 +1000
In-Reply-To: <1339822897-15840-3-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
	 <1339822897-15840-3-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-15 at 23:01 -0600, Grant Likely wrote:
> At irq_setup_virq() time all of the data needed to update the reverse
> map is available, but the current code ignores it and relies upon the
> slow path to insert revmap records.  This patch adds revmap updating
> to the setup path so the slow path will no longer be necessary.

See my comments in patch 4...

Cheers,
Ben.

> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Rob Herring <rob.herring@calxeda.com>
> ---
>  kernel/irq/irqdomain.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 4161d2a..5c36722 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -393,6 +393,16 @@ static int irq_setup_virq(struct irq_domain *domain, unsigned int virq,
>  		return -1;
>  	}
>  
> +	switch (domain->revmap_type) {
> +	case IRQ_DOMAIN_MAP_LINEAR:
> +		if (hwirq < domain->revmap_data.linear.size)
> +			domain->revmap_data.linear.revmap[hwirq] = virq;
> +		break;
> +	case IRQ_DOMAIN_MAP_TREE:
> +		irq_radix_revmap_insert(domain, virq, hwirq);
> +		break;
> +	}
> +
>  	irq_clear_status_flags(virq, IRQ_NOREQUEST);
>  
>  	return 0;


