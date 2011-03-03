Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab1CCBob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:44:31 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:21947 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756711Ab1CCBoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:44:30 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+lbuyHFHy1SfCxk1UfZQe9
Date: Wed, 2 Mar 2011 17:44:16 -0800
From: Tony Lindgren <tony@atomide.com>
To: Armando Uribe <x0095078@ti.com>
Cc: hiroshi.doyu@nokia.com, ohad@wizery.com,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Hari Kanigeri <h-kanigeri2@ti.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: Re: [PATCHv2] omap:mailbox: resolve hang issue
Message-ID: <20110303014416.GL20560@atomide.com>
References: <1299104058-28565-1-git-send-email-x0095078@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299104058-28565-1-git-send-email-x0095078@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Armando Uribe <x0095078@ti.com> [110302 13:54]:
> From: Hari Kanigeri <h-kanigeri2@ti.com>
> 
> omap4 interrupt disable bits is different. On rx kfifo full, the mbox rx
> interrupts wasn't getting disabled, and this is causing the rcm stress tests
> to hang.
> 
> Signed-off-by: Hari Kanigeri <h-kanigeri2@ti.com>
> Signed-off-by: Armando Uribe <x0095078@ti.com>
> Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>

Should we merge this as a fix for the 2.6.38 still?

Tony

> ---
>  arch/arm/mach-omap2/mailbox.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
> index 394413d..011ca50 100644
> --- a/arch/arm/mach-omap2/mailbox.c
> +++ b/arch/arm/mach-omap2/mailbox.c
> @@ -193,10 +193,12 @@ static void omap2_mbox_disable_irq(struct omap_mbox *mbox,
>  		omap_mbox_type_t irq)
>  {
>  	struct omap_mbox2_priv *p = mbox->priv;
> -	u32 l, bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
> -	l = mbox_read_reg(p->irqdisable);
> -	l &= ~bit;
> -	mbox_write_reg(l, p->irqdisable);
> +	u32 bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
> +
> +	if (!cpu_is_omap44xx())
> +		bit = mbox_read_reg(p->irqdisable) & ~bit;
> +
> +	mbox_write_reg(bit, p->irqdisable);
>  }
>  
>  static void omap2_mbox_ack_irq(struct omap_mbox *mbox,
> -- 
> 1.7.0.4
> 
