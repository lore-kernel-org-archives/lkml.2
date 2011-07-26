Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab1GZJk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:40:27 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:47931 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1GZJkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:40:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110726093641.12508.82413.stgit@ponder>
References: <20110726093141.12508.48108.stgit@ponder> <20110726093641.12508.82413.stgit@ponder>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 26 Jul 2011 03:40:01 -0600
X-Google-Sender-Auth: tP47f-Ovm3zVfv4TfRZUmkTuxCo
Message-ID: <CACxGe6vSfhWF_nRU0r=UG52W7UNwgXyWrJtiZ0JRwWy4f7FE0g@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] irq: add irq_domain translation infrastructure
To: devicetree-discuss@lists.ozlabs.org, tglx@linutronix.de,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 3:36 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> This patch adds irq_domain infrastructure for translating from
> hardware irq numbers to linux irqs.  This is particularly important
> for architectures adding device tree support because the current
> implementation (excluding PowerPC and SPARC) cannot handle
> translation for more than a single interrupt controller.  irq_domain
> supports device tree translation for any number of interrupt
> controllers.
>
> This patch converts x86, Microblaze, ARM and MIPS to use irq_domain
> for device tree irq translation.  x86 is untested beyond compiling it,
> irq_domain is enabled for MIPS and Microblaze, but the old behaviour is
> preserved until the core code is modified to actually register an
> irq_domain yet.  On ARM it works and is required for much of the new
> ARM device tree board support.

Oops, I obviously forgot to update the commit text.  This patch only
affects ARM, I've split the MIPS, Microblaze and x86 bits out into a
separate patch.  I'll craft new commit text before reposting.

g.

>
> PowerPC has /not/ been converted to use this new infrastructure.  It
> is still missing some features before it can replace the virq
> infrastructure already in powerpc (see documentation on
> irq_domain_map/unmap for details).  Followup patches will add the
> missing pieces and migrate PowerPC to use irq_domain.
>
> SPARC has its own method of managing interrupts from the device tree
> and is unaffected by this change.
>
> Acked-by: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/arm/Kconfig            |    1
>  arch/arm/include/asm/prom.h |    5 --
>  arch/arm/kernel/devtree.c   |   14 -----
>  include/linux/irq.h         |    6 ++
>  include/linux/irqdomain.h   |   81 ++++++++++++++++++++++++++++
>  include/linux/of_irq.h      |    4 +
>  kernel/irq/Kconfig          |    4 +
>  kernel/irq/Makefile         |    1
>  kernel/irq/irqdomain.c      |  123 +++++++++++++++++++++++++++++++++++++++++++
>  9 files changed, 220 insertions(+), 19 deletions(-)
>  create mode 100644 include/linux/irqdomain.h
>  create mode 100644 kernel/irq/irqdomain.c
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 9cb1f4b..b2695aa 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1680,6 +1680,7 @@ config USE_OF
>        bool "Flattened Device Tree support"
>        select OF
>        select OF_EARLY_FLATTREE
> +       select IRQ_DOMAIN
>        help
>          Include support for flattened device tree machine descriptions.
>
> diff --git a/arch/arm/include/asm/prom.h b/arch/arm/include/asm/prom.h
> index 11b8708..6f65ca8 100644
> --- a/arch/arm/include/asm/prom.h
> +++ b/arch/arm/include/asm/prom.h
> @@ -16,11 +16,6 @@
>  #include <asm/setup.h>
>  #include <asm/irq.h>
>
> -static inline void irq_dispose_mapping(unsigned int virq)
> -{
> -       return;
> -}
> -
>  extern struct machine_desc *setup_machine_fdt(unsigned int dt_phys);
>  extern void arm_dt_memblock_reserve(void);
>
> diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
> index 0cdd7b4..1a33e9d 100644
> --- a/arch/arm/kernel/devtree.c
> +++ b/arch/arm/kernel/devtree.c
> @@ -132,17 +132,3 @@ struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
>
>        return mdesc_best;
>  }
> -
> -/**
> - * irq_create_of_mapping - Hook to resolve OF irq specifier into a Linux irq#
> - *
> - * Currently the mapping mechanism is trivial; simple flat hwirq numbers are
> - * mapped 1:1 onto Linux irq numbers.  Cascaded irq controllers are not
> - * supported.
> - */
> -unsigned int irq_create_of_mapping(struct device_node *controller,
> -                                  const u32 *intspec, unsigned int intsize)
> -{
> -       return intspec[0];
> -}
> -EXPORT_SYMBOL_GPL(irq_create_of_mapping);
> diff --git a/include/linux/irq.h b/include/linux/irq.h
> index 5f69504..87a06f3 100644
> --- a/include/linux/irq.h
> +++ b/include/linux/irq.h
> @@ -108,14 +108,18 @@ enum {
>  };
>
>  struct msi_desc;
> +struct irq_domain;
>
>  /**
>  * struct irq_data - per irq and irq chip data passed down to chip functions
>  * @irq:               interrupt number
> + * @hwirq:             hardware interrupt number, local to the interrupt domain
>  * @node:              node index useful for balancing
>  * @state_use_accessors: status information for irq chip functions.
>  *                     Use accessor functions to deal with it
>  * @chip:              low level interrupt hardware access
> + * @domain:            Interrupt translation domain; responsible for mapping
> + *                     between hwirq number and linux irq number.
>  * @handler_data:      per-IRQ data for the irq_chip methods
>  * @chip_data:         platform-specific per-chip private data for the chip
>  *                     methods, to allow shared chip implementations
> @@ -128,9 +132,11 @@ struct msi_desc;
>  */
>  struct irq_data {
>        unsigned int            irq;
> +       unsigned long           hwirq;
>        unsigned int            node;
>        unsigned int            state_use_accessors;
>        struct irq_chip         *chip;
> +       struct irq_domain       *domain;
>        void                    *handler_data;
>        void                    *chip_data;
>        struct msi_desc         *msi_desc;
> diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
> new file mode 100644
> index 0000000..8f2c10a
> --- /dev/null
> +++ b/include/linux/irqdomain.h
> @@ -0,0 +1,81 @@
> +/*
> + * irq_domain - IRQ translation domains
> + *
> + * Translation infrastructure between hw and linux irq numbers.  This is
> + * helpful for interrupt controllers to implement mapping between hardware
> + * irq numbers and the Linux irq number space.
> + *
> + * irq_domains also have a hook for translating device tree interrupt
> + * representation into a hardware irq number that can be mapped back to a
> + * Linux irq number without any extra platform support code.
> + *
> + * irq_domain is expected to be embedded in an interrupt controller's private
> + * data structure.
> + */
> +#ifndef _LINUX_IRQDOMAIN_H
> +#define _LINUX_IRQDOMAIN_H
> +
> +#include <linux/irq.h>
> +
> +#ifdef CONFIG_IRQ_DOMAIN
> +struct device_node;
> +struct irq_domain;
> +
> +/**
> + * struct irq_domain_ops - Methods for irq_domain objects
> + * @to_irq: (optional) given a local hardware irq number, return the linux
> + *          irq number.  If to_irq is not implemented, then the irq_domain
> + *          will use this translation: irq = (domain->irq_base + hwirq)
> + * @dt_translate: Given a device tree node and interrupt specifier, decode
> + *                the hardware irq number and linux irq type value.
> + */
> +struct irq_domain_ops {
> +       unsigned int (*to_irq)(struct irq_domain *d, unsigned long hwirq);
> +
> +#ifdef CONFIG_OF
> +       int (*dt_translate)(struct irq_domain *d, struct device_node *node,
> +                           const u32 *intspec, unsigned int intsize,
> +                           unsigned long *out_hwirq, unsigned int *out_type);
> +#endif /* CONFIG_OF */
> +};
> +
> +/**
> + * struct irq_domain - Hardware interrupt number translation object
> + * @list: Element in global irq_domain list.
> + * @irq_base: Start of irq_desc range assigned to the irq_domain.  The creator
> + *            of the irq_domain is responsible for allocating the array of
> + *            irq_desc structures.
> + * @nr_irq: Number of irqs managed by the irq domain
> + * @ops: pointer to irq_domain methods
> + * @priv: private data pointer for use by owner.  Not touched by irq_domain
> + *        core code.
> + * @of_node: (optional) Pointer to device tree nodes associated with the
> + *           irq_domain.  Used when decoding device tree interrupt specifiers.
> + */
> +struct irq_domain {
> +       struct list_head list;
> +       unsigned int irq_base;
> +       unsigned int nr_irq;
> +       const struct irq_domain_ops *ops;
> +       void *priv;
> +       struct device_node *of_node;
> +};
> +
> +/**
> + * irq_domain_to_irq() - Translate from a hardware irq to a linux irq number
> + *
> + * Returns the linux irq number associated with a hardware irq.  By default,
> + * the mapping is irq == domain->irq_base + hwirq, but this mapping can
> + * be overridden if the irq_domain implements a .to_irq() hook.
> + */
> +static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
> +                                            unsigned long hwirq)
> +{
> +       return d->ops->to_irq ? d->ops->to_irq(d, hwirq) : d->irq_base + hwirq;
> +}
> +
> +extern void irq_domain_add(struct irq_domain *domain);
> +extern void irq_domain_del(struct irq_domain *domain);
> +#endif /* CONFIG_IRQ_DOMAIN */
> +
> +#endif /* _LINUX_IRQDOMAIN_H */
> diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
> index e6955f5..cd2e61c 100644
> --- a/include/linux/of_irq.h
> +++ b/include/linux/of_irq.h
> @@ -63,6 +63,9 @@ extern int of_irq_map_one(struct device_node *device, int index,
>  extern unsigned int irq_create_of_mapping(struct device_node *controller,
>                                          const u32 *intspec,
>                                          unsigned int intsize);
> +#ifdef CONFIG_IRQ_DOMAIN
> +extern void irq_dispose_mapping(unsigned int irq);
> +#endif
>  extern int of_irq_to_resource(struct device_node *dev, int index,
>                              struct resource *r);
>  extern int of_irq_count(struct device_node *dev);
> @@ -70,6 +73,7 @@ extern int of_irq_to_resource_table(struct device_node *dev,
>                struct resource *res, int nr_irqs);
>  extern struct device_node *of_irq_find_parent(struct device_node *child);
>
> +
>  #endif /* CONFIG_OF_IRQ */
>  #endif /* CONFIG_OF */
>  #endif /* __OF_IRQ_H */
> diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
> index d1d051b3..5a38bf4 100644
> --- a/kernel/irq/Kconfig
> +++ b/kernel/irq/Kconfig
> @@ -52,6 +52,10 @@ config IRQ_EDGE_EOI_HANDLER
>  config GENERIC_IRQ_CHIP
>        bool
>
> +# Generic irq_domain hw <--> linux irq number translation
> +config IRQ_DOMAIN
> +       bool
> +
>  # Support forced irq threading
>  config IRQ_FORCED_THREADING
>        bool
> diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
> index 7329005..fff1738 100644
> --- a/kernel/irq/Makefile
> +++ b/kernel/irq/Makefile
> @@ -2,6 +2,7 @@
>  obj-y := irqdesc.o handle.o manage.o spurious.o resend.o chip.o dummychip.o devres.o
>  obj-$(CONFIG_GENERIC_IRQ_CHIP) += generic-chip.o
>  obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
> +obj-$(CONFIG_IRQ_DOMAIN) += irqdomain.o
>  obj-$(CONFIG_PROC_FS) += proc.o
>  obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
>  obj-$(CONFIG_PM_SLEEP) += pm.o
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> new file mode 100644
> index 0000000..171b754
> --- /dev/null
> +++ b/kernel/irq/irqdomain.c
> @@ -0,0 +1,123 @@
> +
> +#include <linux/irq.h>
> +#include <linux/irqdomain.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/of.h>
> +
> +static LIST_HEAD(irq_domain_list);
> +static DEFINE_MUTEX(irq_domain_mutex);
> +
> +/**
> + * irq_domain_add() - Register an irq_domain
> + * @domain: ptr to initialized irq_domain structure
> + *
> + * Registers an irq_domain structure.  The irq_domain must at a minimum be
> + * initialized with an ops structure pointer, and either a ->to_irq hook or
> + * a valid irq_base value.  Everything else is optional.
> + */
> +void irq_domain_add(struct irq_domain *domain)
> +{
> +       struct irq_data *d;
> +       int hwirq;
> +
> +       /*
> +        * This assumes that the irq_domain owner has already allocated
> +        * the irq_descs.  This block will be removed when support for dynamic
> +        * allocation of irq_descs is added to irq_domain.
> +        */
> +       for (hwirq = 0; hwirq < domain->nr_irq; hwirq++) {
> +               d = irq_get_irq_data(irq_domain_to_irq(domain, hwirq));
> +               if (d || d->domain) {
> +                       /* things are broken; just report, don't clean up */
> +                       WARN(1, "error: irq_desc already assigned to a domain");
> +                       return;
> +               }
> +               d->domain = domain;
> +               d->hwirq = hwirq;
> +       }
> +
> +       mutex_lock(&irq_domain_mutex);
> +       list_add(&domain->list, &irq_domain_list);
> +       mutex_unlock(&irq_domain_mutex);
> +}
> +
> +/**
> + * irq_domain_del() - Unregister an irq_domain
> + * @domain: ptr to registered irq_domain.
> + */
> +void irq_domain_del(struct irq_domain *domain)
> +{
> +       struct irq_data *d;
> +       int hwirq;
> +
> +       mutex_lock(&irq_domain_mutex);
> +       list_del(&domain->list);
> +       mutex_unlock(&irq_domain_mutex);
> +
> +       /* Clear the irq_domain assignments */
> +       for (hwirq = 0; hwirq < domain->nr_irq; hwirq++) {
> +               d = irq_get_irq_data(irq_domain_to_irq(domain, hwirq));
> +               d->domain = NULL;
> +       }
> +}
> +
> +#if defined(CONFIG_OF_IRQ)
> +/**
> + * irq_create_of_mapping() - Map a linux irq number from a DT interrupt spec
> + *
> + * Used by the device tree interrupt mapping code to translate a device tree
> + * interrupt specifier to a valid linux irq number.  Returns either a valid
> + * linux IRQ number or 0.
> + *
> + * When the caller no longer need the irq number returned by this function it
> + * should arrange to call irq_dispose_mapping().
> + */
> +unsigned int irq_create_of_mapping(struct device_node *controller,
> +                                  const u32 *intspec, unsigned int intsize)
> +{
> +       struct irq_domain *domain;
> +       unsigned long hwirq;
> +       unsigned int irq, type;
> +       int rc = -EINVAL;
> +
> +       /* Find a domain which can translate the irq spec */
> +       mutex_lock(&irq_domain_mutex);
> +       list_for_each_entry(domain, &irq_domain_list, list) {
> +               if (!domain->ops->dt_translate)
> +                       continue;
> +               rc = domain->ops->dt_translate(domain, controller,
> +                                       intspec, intsize, &hwirq, &type);
> +               if (rc == 0)
> +                       break;
> +       }
> +       mutex_unlock(&irq_domain_mutex);
> +
> +       if (rc != 0)
> +               return 0;
> +
> +       irq = irq_domain_to_irq(domain, hwirq);
> +       if (type != IRQ_TYPE_NONE)
> +               irq_set_irq_type(irq, type);
> +       pr_debug("%s: mapped hwirq=%i to irq=%i, flags=%x\n",
> +                controller->full_name, (int)hwirq, irq, type);
> +       return irq;
> +}
> +EXPORT_SYMBOL_GPL(irq_create_of_mapping);
> +
> +/**
> + * irq_dispose_mapping() - Discard a mapping created by irq_create_of_mapping()
> + * @irq: linux irq number to be discarded
> + *
> + * Calling this function indicates the caller no longer needs a reference to
> + * the linux irq number returned by a prior call to irq_create_of_mapping().
> + */
> +void irq_dispose_mapping(unsigned int irq)
> +{
> +       /*
> +        * nothing yet; will be filled when support for dynamic allocation of
> +        * irq_descs is added to irq_domain
> +        */
> +}
> +EXPORT_SYMBOL_GPL(irq_dispose_mapping);
> +#endif /* CONFIG_OF_IRQ */
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
