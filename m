Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1ISJ2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:28:12 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56285 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753907Ab1ISJ2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:28:11 -0400
Message-ID: <4E770B3E.9040401@arm.com>
Date: Mon, 19 Sep 2011 10:28:30 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 1/3] genirq: add support for per-cpu dev_id interrupts
References: <1316105551-17505-1-git-send-email-marc.zyngier@arm.com> <1316105551-17505-2-git-send-email-marc.zyngier@arm.com> <4E767CD6.6090208@codeaurora.org>
In-Reply-To: <4E767CD6.6090208@codeaurora.org>
X-Enigmail-Version: 1.2.1
X-OriginalArrivalTime: 19 Sep 2011 09:28:05.0604 (UTC) FILETIME=[6F9FEA40:01CC76AE]
X-MC-Unique: 111091910280801801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/11 00:20, Abhijeet Dharmapurikar wrote:
> On 09/15/2011 09:52 AM, Marc Zyngier wrote:
>  > The ARM GIC interrupt controller offers per CPU interrupts (PPIs),
>  > which are usually used to connect local timers to each core.
>  > Each CPU has its own private interface to the GIC,
>  > and only sees the PPIs that are directly connect to it.
>  >
>  > While these timers are separate devices and have a separate
>  > interrupt line to a core, they all use the same IRQ number.
>  >
>  > For these devices, request_irq() is not the right API as it
>  > assumes that an IRQ number is visible by a number of CPUs
>  > (through the affinity setting), but makes it very awkward to
>  > express that an IRQ number can be handled by all CPUs, and
>  > yet be a different interrupt line on each CPU, requiring a
>  > different dev_id cookie to be passed back to the handler.
>  >
>  > The *_percpu_irq() functions is designed to overcome these
>  > limitations, by providing a per-cpu dev_id vector:
>  >
>  > int request_percpu_irq(unsigned int irq, irq_handler_t handler,
>  >                 const char *devname, void __percpu *percpu_dev_id);
>  > void free_percpu_irq(unsigned int, void __percpu *);
>  > int setup_percpu_irq(unsigned int irq, struct irqaction *new);
>  > void remove_percpu_irq(unsigned int irq, struct irqaction *act);
>  > void enable_percpu_irq(unsigned int irq);
>  > void disable_percpu_irq(unsigned int irq);
>  >
>  > The API has a number of limitations:
>  > - no interrupt sharing
>  > - no threading
>  > - common handler across all the CPUs
>  >
>  > Once the interrupt is requested using setup_percpu_irq() or
>  > request_percpu_irq(), it must be enabled by each core that wishes
>  > its local interrupt to be delivered.
>  >
>  > Based on an initial patch by Thomas Gleixner.
>  >
>  > Cc: Thomas Gleixner<tglx@linutronix.de>
>  > Signed-off-by: Marc Zyngier<marc.zyngier@arm.com>
>  > ---
>  >   include/linux/interrupt.h |   40 ++++++---
>  >   include/linux/irq.h       |   25 +++++-
>  >   include/linux/irqdesc.h   |    3 +
>  >   kernel/irq/Kconfig        |    4 +
>  >   kernel/irq/chip.c         |   58 +++++++++++++
>  >   kernel/irq/internals.h    |    2 +
>  >   kernel/irq/manage.c       |  209
> ++++++++++++++++++++++++++++++++++++++++++++-
>  >   kernel/irq/settings.h     |    7 ++
>  >   8 files changed, 332 insertions(+), 16 deletions(-)
>  >
>  > diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
>  > index a103732..f9b7fa3 100644
>  > --- a/include/linux/interrupt.h
>  > +++ b/include/linux/interrupt.h
>  > @@ -95,6 +95,7 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
>  >    * @flags: flags (see IRQF_* above)
>  >    * @name:  name of the device
>  >    * @dev_id:        cookie to identify the device
>  > + * @percpu_dev_id:  cookie to identify the device
>  >    * @next:  pointer to the next irqaction for shared interrupts
>  >    * @irq:   interrupt number
>  >    * @dir:   pointer to the proc/irq/NN/name entry
>  > @@ -104,17 +105,20 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
>  >    * @thread_mask:   bitmask for keeping track of @thread activity
>  >    */
>  >   struct irqaction {
>  > -    irq_handler_t handler;
>  > -    unsigned long flags;
>  > -    void *dev_id;
>  > -    struct irqaction *next;
>  > -    int irq;
>  > -    irq_handler_t thread_fn;
>  > -    struct task_struct *thread;
>  > -    unsigned long thread_flags;
>  > -    unsigned long thread_mask;
>  > -    const char *name;
>  > -    struct proc_dir_entry *dir;
>  > +    irq_handler_t           handler;
>  > +    unsigned long           flags;
>  > +    void                    *dev_id;
>  > +#ifdef CONFIG_IRQ_PERCPU_DEVID
>  > +    void __percpu           *percpu_dev_id;
>  > +#endif
>  > +    struct irqaction        *next;
>  > +    int                     irq;
>  > +    irq_handler_t           thread_fn;
>  > +    struct task_struct      *thread;
>  > +    unsigned long           thread_flags;
>  > +    unsigned long           thread_mask;
>  > +    const char              *name;
>  > +    struct proc_dir_entry   *dir;
>  >   } ____cacheline_internodealigned_in_smp;
>  >
>  >   extern irqreturn_t no_action(int cpl, void *dev_id);
>  > @@ -136,6 +140,10 @@ extern int __must_check
>  >   request_any_context_irq(unsigned int irq, irq_handler_t handler,
>  >                      unsigned long flags, const char *name, void *dev_id);
>  >
>  > +extern int __must_check
>  > +request_percpu_irq(unsigned int irq, irq_handler_t handler,
>  > +               const char *devname, void __percpu *percpu_dev_id);
>  > +
>  >   extern void exit_irq_thread(void);
>  >   #else
>  >
>  > @@ -164,10 +172,18 @@ request_any_context_irq(unsigned int irq,
> irq_handler_t handler,
>  >      return request_irq(irq, handler, flags, name, dev_id);
>  >   }
>  >
>  > +static inline int __must_check
>  > +request_percpu_irq(unsigned int irq, irq_handler_t handler,
>  > +               const char *devname, void __percpu *percpu_dev_id)
>  > +{
>  > +    return request_irq(irq, handler, 0, name, dev_id);
> 
> you probably meant devname here instead of name and also percpu_dev_id
> instead of dev_id.

Doh. Indeed, thanks for noticing this.

>  > +/*
>  > + * Internal function to unregister a percpu irqaction.
>  > + */
>  > +static struct irqaction *__free_percpu_irq(unsigned int irq, void
> __percpu *dev_id)
>  > +{
>  > +    struct irq_desc *desc = irq_to_desc(irq);
>  > +    struct irqaction *action;
>  > +    unsigned long flags;
>  > +
>  > +    WARN(in_interrupt(), "Trying to free IRQ %d from IRQ context!\n", irq);
>  > +
>  > +    if (!desc)
>  > +            return NULL;
>  > +
>  > +    raw_spin_lock_irqsave(&desc->lock, flags);
>  > +
>  > +    action = desc->action;
>  > +    if (!action || action->percpu_dev_id != dev_id) {
>  > +            WARN(1, "Trying to free already-free IRQ %d\n", irq);
>  > +            raw_spin_unlock_irqrestore(&desc->lock, flags);
>  > +            return NULL;
>  > +    }
>  > +
>  > +    /* Found it - now remove it from the list of entries: */
>  > +    WARN(!cpumask_empty(desc->percpu_enabled),
>  > +         "percpu IRQ %d still enabled on CPU%d!\n",
>  > +         irq, cpumask_first(desc->percpu_enabled));
>  > +    desc->action = NULL;
>  > +
>  > +#ifdef CONFIG_SMP
>  > +    /* make sure affinity_hint is cleaned up */
>  > +    if (WARN_ON_ONCE(desc->affinity_hint))
>  > +            desc->affinity_hint = NULL;
>  > +#endif
>  > +
>  > +    raw_spin_unlock_irqrestore(&desc->lock, flags);
>  > +
>  > +    unregister_handler_proc(irq, action);
>  > +
>  > +    /* Make sure it's not being used on another CPU: */
>  > +    synchronize_irq(irq);
>  > +
>  > +    module_put(desc->owner);
> 
> Not sure why is this required. Where is the corresponding try_module_get()?

A few lines into __setup_irq().

>  > +/**
>  > + *  request_percpu_irq - allocate a percpu interrupt line
>  > + *  @irq: Interrupt line to allocate
>  > + *  @handler: Function to be called when the IRQ occurs.
>  > + *            Primary handler for threaded interrupts
>  > + *            If NULL and thread_fn != NULL the default
>  > + *            primary handler is installed
> 
> The patch doesnt support threaded percpu interrupts - please set the
> comment accordingly?

Yup, will fix.

>  > + *  @devname: An ascii name for the claiming device
>  > + *  @dev_id: A percpu cookie passed back to the handler function
>  > + *
>  > + *  This call allocates interrupt resources, but doesn't
>  > + *  automatically enable the interrupt. It has to be done on each
>  > + *  CPU using enable_percpu_irq().
>  > + *
>  > + *  Dev_id must be globally unique. It is a per-cpu variable, and
>  > + *  the handler gets called with the interrupted CPU's instance of
>  > + *  that variable.
>  > + */
>  > +int request_percpu_irq(unsigned int irq, irq_handler_t handler,
>  > +                   const char *devname, void __percpu *dev_id)
> 
> Can we add irqflags argument. I think it will be useful to pass flags,
> at least the IRQF_TRIGGER_MASK since it ends up calling __setup_irq().
> The chip could use a set_type callback for ppi's too.

We're entering dangerous territory here. While this would work with the
GIC (the interrupt type is at the distributor level), you could easily
imagine an interrupt controller with the PPI configuration at the CPU
interface level... In that case, calling set_type from __setup_irq()
would end up doing the wrong thing, and I'd hate the API to give the
idea it can do things it may not do in the end...

Furthermore, do we actually have a GIC implementation where PPI
configuration isn't read-only? I only know about the ARM implementation,
and the Qualcomm may well be different (the spec says it's
implementation defined).

Cheers,

	M.
-- 
Jazz is not dead. It just smells funny...

