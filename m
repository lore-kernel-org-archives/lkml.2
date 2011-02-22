Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab1BVVJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:09:33 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33032 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab1BVVJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:09:32 -0500
MIME-Version: 1.0
In-Reply-To: <1298405266-1624-5-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-1-git-send-email-bigeasy@linutronix.de> <1298405266-1624-5-git-send-email-bigeasy@linutronix.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 22 Feb 2011 14:06:55 -0700
X-Google-Sender-Auth: hkx6X6kDeu_C1sK_xYKm_IV1HYY
Message-ID: <AANLkTimr7EnfC=qHkLJ30VniMU0X70dLGRP3-_Fo9qaX@mail.gmail.com>
Subject: Re: [PATCH 04/11] x86/dtb: add irq domain abstraction
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 1:07 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> The here introduced irq_domain abstraction represents a generic irq
> controller. It is a subset of powerpc's irq_host which is going to be
> renamed to irq_domain and then become generic. This implementation will
> be removed once it is generic.
>
> The xlate callback is resposible to parse irq informations like irq type
> and number and returns the hardware irq number which is reported by the
> hardware as active.
>
> Cc: devicetree-discuss@lists.ozlabs.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Tested-by: Dirk Brandewie <dirk.brandewie@gmail.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  arch/x86/include/asm/irq_controller.h |   12 ++++++++
>  arch/x86/include/asm/prom.h           |    2 +
>  arch/x86/kernel/devicetree.c          |   47 ++++++++++++++++++++++++++++++++-
>  3 files changed, 60 insertions(+), 1 deletions(-)
>  create mode 100644 arch/x86/include/asm/irq_controller.h
>
> diff --git a/arch/x86/include/asm/irq_controller.h b/arch/x86/include/asm/irq_controller.h
> new file mode 100644
> index 0000000..423bbbd
> --- /dev/null
> +++ b/arch/x86/include/asm/irq_controller.h
> @@ -0,0 +1,12 @@
> +#ifndef __IRQ_CONTROLLER__
> +#define __IRQ_CONTROLLER__
> +
> +struct irq_domain {
> +       int (*xlate)(struct irq_domain *h, const u32 *intspec, u32 intsize,
> +                       u32 *out_hwirq, u32 *out_type);
> +       void *priv;
> +       struct device_node *controller;
> +       struct list_head l;
> +};
> +
> +#endif
> diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
> index 841697d..70467d1 100644
> --- a/arch/x86/include/asm/prom.h
> +++ b/arch/x86/include/asm/prom.h
> @@ -19,9 +19,11 @@
>  #include <asm/irq.h>
>  #include <asm/atomic.h>
>  #include <asm/setup.h>
> +#include <asm/irq_controller.h>
>
>  #ifdef CONFIG_OF
>  extern void add_dtb(u64 data);
> +void add_interrupt_host(struct irq_domain *ih);
>  #else
>  static inline void add_dtb(u64 data) { }
>  #endif
> diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
> index b86c65e..f2f159c 100644
> --- a/arch/x86/kernel/devicetree.c
> +++ b/arch/x86/kernel/devicetree.c
> @@ -3,19 +3,64 @@
>  */
>  #include <linux/bootmem.h>
>  #include <linux/io.h>
> +#include <linux/interrupt.h>
>  #include <linux/list.h>
>  #include <linux/of.h>
>  #include <linux/of_fdt.h>
>  #include <linux/of_platform.h>
>  #include <linux/slab.h>
>
> +#include <asm/irq_controller.h>
> +
>  char __initdata cmd_line[COMMAND_LINE_SIZE];
> +static LIST_HEAD(irq_domains);
> +static DEFINE_RAW_SPINLOCK(big_irq_lock);
> +
> +void add_interrupt_host(struct irq_domain *ih)
> +{
> +       unsigned long flags;
> +
> +       raw_spin_lock_irqsave(&big_irq_lock, flags);
> +       list_add(&ih->l, &irq_domains);
> +       raw_spin_unlock_irqrestore(&big_irq_lock, flags);
> +}
> +
> +static struct irq_domain *get_ih_from_node(struct device_node *controller)
> +{
> +       struct irq_domain *ih, *found = NULL;
> +       unsigned long flags;
> +
> +       raw_spin_lock_irqsave(&big_irq_lock, flags);
> +       list_for_each_entry(ih, &irq_domains, l) {
> +               if (ih->controller ==  controller) {
> +                       found = ih;
> +                       break;
> +               }
> +       }
> +       raw_spin_unlock_irqrestore(&big_irq_lock, flags);
> +       return found;
> +}
>
>  unsigned int irq_create_of_mapping(struct device_node *controller,
>                const u32 *intspec, unsigned int intsize)
>  {
> -       return intspec[0];
> +       struct irq_domain *ih;
> +       u32 virq;
> +       u32 type;
> +       int ret;
>
> +       ih = get_ih_from_node(controller);
> +       if (!ih)
> +               return 0;
> +       ret = ih->xlate(ih, intspec, intsize, &virq, &type);
> +       if (ret)
> +               return ret;
> +       if (type == IRQ_TYPE_NONE)
> +               return virq;
> +       /* set the mask if it is different from current */
> +       if (type == (irq_to_desc(virq)->status & IRQF_TRIGGER_MASK))
> +               set_irq_type(virq, type);
> +       return virq;
>  }
>  EXPORT_SYMBOL_GPL(irq_create_of_mapping);
>
> --
> 1.7.4
>
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
