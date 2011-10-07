Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138Ab1JGQaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:30:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:43068 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab1JGQaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:30:04 -0400
Date: Fri, 7 Oct 2011 18:29:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: xen: IPI interrupts not resumed early enough on suspend/resume
In-Reply-To: <1318001583.21903.355.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.LFD.2.02.1110071822160.3240@ionos>
References: <1317654626.21903.72.camel@zakaz.uk.xensource.com>   <alpine.LFD.2.02.1110032033530.1489@ionos>  <1317668908.11991.20.camel@dagon.hellion.org.uk>  <alpine.LFD.2.02.1110032229250.1489@ionos> <1318001583.21903.355.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Oct 2011, Ian Campbell wrote:
> On Mon, 2011-10-03 at 22:35 +0200, Thomas Gleixner wrote:
>  /**
> + * irq_pm_syscore_ops - enable interrupt lines early
> + *
> + * Enable all interrupt lines with %IRQF_EARLY_RESUME set
> + */
> +static void irq_pm_syscore_resume(void)
> +{
> +	struct irq_desc *desc;
> +	int irq;
> +
> +	for_each_irq_desc(irq, desc) {
> +		unsigned long flags;
> +
> +		if (!desc->action || !(desc->action->flags & IRQF_EARLY_RESUME))
> +			continue;
> +
> +		raw_spin_lock_irqsave(&desc->lock, flags);
> +		__enable_irq(desc, irq, true);
> +		raw_spin_unlock_irqrestore(&desc->lock, flags);
> +	}
> +}

Come on, this is a full copy of resume_device_irqs(). What about
having a common function with an (bool early) argument and call it
from both syscore and resume_device?

Thanks,

	tglx
