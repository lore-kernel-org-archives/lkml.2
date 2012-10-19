Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab2JSGXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 02:23:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:57333 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab2JSGXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 02:23:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,610,1344236400"; 
   d="scan'208";a="229577830"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86/ioapic: Fix that not all allocated irqs are ioapic
 type irqs
Thread-Topic: [PATCH] x86/ioapic: Fix that not all allocated irqs are ioapic
 type irqs
Thread-Index: AQHNrcCWsMKUnJBYZ0mAKuk+gFhM5ZfAJwUQ
Date: Fri, 19 Oct 2012 06:23:47 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1A4EAD@SHSMSX101.ccr.corp.intel.com>
References: <1350643289.15558.45.camel@cliu38-desktop-build>
 <CAE9FiQVY8TqVeNZc_a23WH0fwKeB2XbVQ080z_PQxGQFmqnajw@mail.gmail.com>
In-Reply-To: <CAE9FiQVY8TqVeNZc_a23WH0fwKeB2XbVQ080z_PQxGQFmqnajw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu
> Sent: Friday, October 19, 2012 2:11 PM
> To: Liu, Chuansheng
> Cc: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; Siddha, Suresh B;
> mathias.nyman@linux.intel.com; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] x86/ioapic: Fix that not all allocated irqs are ioapic type
> irqs
> 
> On Fri, Oct 19, 2012 at 3:41 AM, Chuansheng Liu
> <chuansheng.liu@intel.com> wrote:
> >
> > When debugging our system issues related with __setup_vector_irq(),
> > found there is a real wrong code that:
> >         for_each_active_irq(irq) {
> >                 cfg = irq_get_chip_data(irq);
> >                 if (!cfg)
> >                         continue;
> >
> > These codes presume all allocated irqs are ioapic irqs, but it is not
> > like that, in our system there are many GPIO interrupts also.
> >
> > When one irq is not ioapic type irq, the chip_data will not be the
> > type of struct irq_cfg in most cases.
> 
> impossible !
> 
> where is the irq_desc coming from. ?
> 
> after alloc_irq_from, alloc_irq_cfg get called too.
Maybe I do not describe the issue clearly.
When I offlined CPU3 and online it again, __setup_vector_irq will be called.
But  for_each_active_irq(irq) will list all active irqs, many irqs are not IOAPIC type.
And the chip data is not struct irq_cfg at all, it is set by other chips.

For example, in file gpio-omap.c:
irq_set_chip_data(j, bank); the bank is the type of struct gpio_bank.

And in this case, __setup_vector_irq can not go on the below code due to the wrong type variable:
		/*
		 * If it is a legacy IRQ handled by the legacy PIC, this cpu
		 * will be part of the irq_cfg's domain.
		 */
		if (irq < legacy_pic->nr_legacy_irqs && !IO_APIC_IRQ(irq))
			cpumask_set_cpu(cpu, cfg->domain);

		if (!cpumask_test_cpu(cpu, cfg->domain))
			continue;
		vector = cfg->vector;
		per_cpu(vector_irq, cpu)[vector] = irq;

> 
> >
> > So in function __setup_vector_irq(), it will cause some strange issues,
> > moreover, if I added some prints(cfg->...) inside it, it can always
> > cause system panic.
> >
> > Here using the struct irq_chip->flags to help identify if the irq
> > is ioapic type or not.
> >
> > Looked forward all codes with for_each_active_irq(), found there is
> > a commit 6fd36ba02 indicates the similar case in print_IO_APICs().
> 
> that is for not printing wrong for MSI etc.
No, it is for avoidingcrash if it is not IOAPIC chip. I can reproduce it in my system.
> 
> >
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > ---
> >  arch/x86/kernel/apic/io_apic.c |   25 ++++++++++++++++++++++---
> >  1 files changed, 22 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> > index c265593..f0355e6 100644
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -68,6 +68,18 @@
> >  #define for_each_irq_pin(entry, head) \
> >         for (entry = head; entry; entry = entry->next)
> >
> > +/* need more thoughts ... */
> > +#define CHIP_FLAG_IOAPIC       0x1000
> > +static inline bool is_ioapic_irq(int irq)
> > +{
> > +       struct irq_chip *chip;
> > +       chip = irq_get_chip(irq);
> > +       if ((chip) && (chip->flags == CHIP_FLAG_IOAPIC))
> > +               return true;
> > +
> > +       return false;
> > +}
> > +
> >  #ifdef CONFIG_IRQ_REMAP
> >  static void irq_remap_modify_chip_defaults(struct irq_chip *chip);
> >  static inline bool irq_remapped(struct irq_cfg *cfg)
> > @@ -1238,6 +1250,9 @@ void __setup_vector_irq(int cpu)
> >         raw_spin_lock(&vector_lock);
> >         /* Mark the inuse vectors */
> >         for_each_active_irq(irq) {
> > +               if (!is_ioapic_irq(irq))
> > +                       continue;
> > +
> >                 cfg = irq_get_chip_data(irq);
> >                 if (!cfg)
> >                         continue;
> > @@ -1641,7 +1656,6 @@ __apicdebuginit(void) print_IO_APICs(void)
> >         int ioapic_idx;
> >         struct irq_cfg *cfg;
> >         unsigned int irq;
> > -       struct irq_chip *chip;
> >
> >         printk(KERN_DEBUG "number of MP IRQ sources: %d.\n",
> mp_irq_entries);
> >         for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
> > @@ -1662,8 +1676,7 @@ __apicdebuginit(void) print_IO_APICs(void)
> >         for_each_active_irq(irq) {
> >                 struct irq_pin_list *entry;
> >
> > -               chip = irq_get_chip(irq);
> > -               if (chip != &ioapic_chip)
> > +               if (!is_ioapic_irq(irq))
> >                         continue;
> >
> >                 cfg = irq_get_chip_data(irq);
> 
> if the irq is not using ioapic_chip such as msi_chip etc, that irq
> should be skip.
Print MSI chip is not making sense?
