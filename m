Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab2EDQvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:51:52 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:37249 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2EDQvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:51:50 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/07+ZKuZhksKylUDV1rsEx
Date: Fri, 4 May 2012 09:51:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Oleg Matcovschi <oleg.matcovschi@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH] omap: dma: Clear status registers on enable/disable
 irq.
Message-ID: <20120504165146.GB5613@atomide.com>
References: <1334954578-10478-1-git-send-email-oleg.matcovschi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334954578-10478-1-git-send-email-oleg.matcovschi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Oleg Matcovschi <oleg.matcovschi@ti.com> [120420 13:49]:
> Use omap_disable_channel_irq() function instead of directly accessing CICR.
> The omap_disable_chanel_irq() function clears pending interrupts
> and disables interrupt on channel.
> Functions omap2_enable_irq_lch()/omap2_disable_irq_lch() clear interrupt
> status register.

This seems like a nice fix to me. As it affects all omaps, I'd like to
see some tested-by from Janusz/Jarkko/Peter. Can you guys give it a try
with some audio tests?

Also one comment below.
 
> @@ -575,10 +573,15 @@ static inline void omap_enable_channel_irq(int lch)
>  	p->dma_write(dma_chan[lch].enabled_irqs, CICR, lch);
>  }
>  
> -static void omap_disable_channel_irq(int lch)
> +static inline void omap_disable_channel_irq(int lch)
>  {
> -	if (cpu_class_is_omap2())
> -		p->dma_write(0, CICR, lch);
> +	/* disable channel interrupts */
> +	p->dma_write(0, CICR, lch);
> +	/* Clear CSR */
> +	if (cpu_class_is_omap1())
> +		p->dma_read(CSR, lch);
> +	else if (cpu_class_is_omap2())
> +		p->dma_write(OMAP2_DMA_CSR_CLEAR_MASK, CSR, lch);
>  }

You can leave out the else if cpu_class_is_omap2 and replace it
with just else above.

Regards,

Tony 
