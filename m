Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998Ab0LNUy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:54:26 -0500
Received: from www.tglx.de ([62.245.132.106]:47936 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759883Ab0LNUyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:54:25 -0500
Date: Tue, 14 Dec 2010 21:54:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
In-Reply-To: <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de>
Message-ID: <alpine.LFD.2.00.1012142147420.12146@localhost6.localdomain6>
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Dec 2010, Jan Kiszka wrote:
> @@ -943,6 +950,9 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
>  	/* Make sure it's not being used on another CPU: */
>  	synchronize_irq(irq);
>  
> +	if (single_handler)
> +		desc->irq_data.drv_status &= ~IRQS_SHARED;
> +

What's the reason to clear this flag outside of the desc->lock held
region. I need this status for other purposes as well, where I
definitely need serialization.

> +	mutex_lock(&register_lock);
> +
> +	old_action = desc->action;
> +	if (old_action && (old_action->flags & IRQF_ADAPTIVE) &&
> +	    !(desc->irq_data.drv_status & IRQS_SHARED)) {
> +		/*
> +		 * Signal the old handler that is has to switch to shareable
> +		 * handling mode. Disable the line to avoid any conflict with
> +		 * a real IRQ.
> +		 */
> +		disable_irq(irq);
> +		local_irq_disable();
> +
> +		desc->irq_data.drv_status |= IRQS_SHARED | IRQS_MAKE_SHAREABLE;

Unserialized access as well. Will think about it.

> +		old_action->handler(irq, old_action->dev_id);
> +		desc->irq_data.drv_status &= ~IRQS_MAKE_SHAREABLE;

Thanks,

	tglx
