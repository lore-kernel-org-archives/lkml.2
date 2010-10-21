Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab0JUTWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:22:46 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:54790 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757926Ab0JUTWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:22:44 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: User Mode Linux broken
Date: Thu, 21 Oct 2010 21:22:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: peterz@infradead.org, hpa@zytor.com, mingo@elte.hu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
References: <201010211315.26679.richard@nod.at> <alpine.LFD.2.00.1010211805040.2418@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010211805040.2418@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010212122.38437.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 21 Oktober 2010, 18:09:22 schrieb Thomas Gleixner:
> On Thu, 21 Oct 2010, Richard Weinberger wrote:
> > Thomas,
> > 
> > Your commit c5f7563 ("genirq: Provide compat handling for
> > chip->enable()") breaks UML.
> > It does not start anymore.
> > 
> > When I apply this patch it works fine again.
> > http://userweb.kernel.org/~akpm/mmotm/broken-out/um-migrate-from-__do_irq
> > -to- generic_handle_irq.patch
> > 
> > Maybe your patch breaks all users of __do_IRQ()?
> 
> Not intentionally :)
> 
> The irq_chip of um has it's own dummy enable function, so the compat
> code uses it.
> 
> +static void compat_irq_enable(struct irq_data *data)
> +{
> +	data->chip->enable(data->irq);
> +}
> +
> 
> ...
> 
> +	if (chip->enable)
> +		chip->irq_enable = compat_irq_enable;
> +
> +	/*
> +	 * The real defaults
> +	 */
> +	if (!chip->irq_enable)
> +		chip->irq_enable = default_enable;
> 
> So I really can't see how's that supposed to break UM
> 

This patch solves the issue for me.
What do you think?

Thanks,
//richard

diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 891115a..1fb4012 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -60,8 +60,11 @@ void check_irq_resend(struct irq_desc *desc, unsigned int 
irq)
        /*
         * Make sure the interrupt is enabled, before resending it:
         */
+#ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
+       desc->irq_data.chip->enable(irq);
+#elif
        desc->irq_data.chip->irq_enable(&desc->irq_data);
-
+#endif
        /*
         * We do not resend level type interrupts. Level type
         * interrupts are resent by hardware when they are still
