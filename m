Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab2BIWvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 17:51:33 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58655 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab2BIWvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 17:51:32 -0500
Date: Thu, 9 Feb 2012 14:51:30 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Use NUMA node cpu mask in irq affinity [v2]
In-Reply-To: <1328805897-16359-1-git-send-email-prarit@redhat.com>
Message-ID: <alpine.DEB.2.00.1202091449570.7219@chino.kir.corp.google.com>
References: <1328805897-16359-1-git-send-email-prarit@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Feb 2012, Prarit Bhargava wrote:

> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index a9a9dbe..3064f2f 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -301,6 +301,13 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
>  	}
>  
>  	cpumask_and(mask, cpu_online_mask, set);
> +	if (desc->irq_data.node != -1) {

Should probably be using NUMA_NO_NODE.

> +		const struct cpumask *nodemask =
> +					   cpumask_of_node(desc->irq_data.node);
> +		/* make sure at least one of the cpus in nodemask is online */
> +		if (cpumask_intersects(mask, nodemask))
> +			cpumask_and(mask, mask, nodemask);
> +	}
>  	ret = chip->irq_set_affinity(&desc->irq_data, mask, false);
>  	switch (ret) {
>  	case IRQ_SET_MASK_OK:
