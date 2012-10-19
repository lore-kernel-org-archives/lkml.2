Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab2JSGLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 02:11:05 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36563 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2JSGLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 02:11:04 -0400
MIME-Version: 1.0
In-Reply-To: <1350643289.15558.45.camel@cliu38-desktop-build>
References: <1350643289.15558.45.camel@cliu38-desktop-build>
Date: Thu, 18 Oct 2012 23:11:02 -0700
X-Google-Sender-Auth: o6M5phLb5tRSF2QcTBe3DfGsdJ8
Message-ID: <CAE9FiQVY8TqVeNZc_a23WH0fwKeB2XbVQ080z_PQxGQFmqnajw@mail.gmail.com>
Subject: Re: [PATCH] x86/ioapic: Fix that not all allocated irqs are ioapic
 type irqs
From: Yinghai Lu <yinghai@kernel.org>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        suresh.b.siddha@intel.com, mathias.nyman@linux.intel.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 3:41 AM, Chuansheng Liu
<chuansheng.liu@intel.com> wrote:
>
> When debugging our system issues related with __setup_vector_irq(),
> found there is a real wrong code that:
>         for_each_active_irq(irq) {
>                 cfg = irq_get_chip_data(irq);
>                 if (!cfg)
>                         continue;
>
> These codes presume all allocated irqs are ioapic irqs, but it is not
> like that, in our system there are many GPIO interrupts also.
>
> When one irq is not ioapic type irq, the chip_data will not be the
> type of struct irq_cfg in most cases.

impossible !

where is the irq_desc coming from. ?

after alloc_irq_from, alloc_irq_cfg get called too.

>
> So in function __setup_vector_irq(), it will cause some strange issues,
> moreover, if I added some prints(cfg->...) inside it, it can always
> cause system panic.
>
> Here using the struct irq_chip->flags to help identify if the irq
> is ioapic type or not.
>
> Looked forward all codes with for_each_active_irq(), found there is
> a commit 6fd36ba02 indicates the similar case in print_IO_APICs().

that is for not printing wrong for MSI etc.

>
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |   25 ++++++++++++++++++++++---
>  1 files changed, 22 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index c265593..f0355e6 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -68,6 +68,18 @@
>  #define for_each_irq_pin(entry, head) \
>         for (entry = head; entry; entry = entry->next)
>
> +/* need more thoughts ... */
> +#define CHIP_FLAG_IOAPIC       0x1000
> +static inline bool is_ioapic_irq(int irq)
> +{
> +       struct irq_chip *chip;
> +       chip = irq_get_chip(irq);
> +       if ((chip) && (chip->flags == CHIP_FLAG_IOAPIC))
> +               return true;
> +
> +       return false;
> +}
> +
>  #ifdef CONFIG_IRQ_REMAP
>  static void irq_remap_modify_chip_defaults(struct irq_chip *chip);
>  static inline bool irq_remapped(struct irq_cfg *cfg)
> @@ -1238,6 +1250,9 @@ void __setup_vector_irq(int cpu)
>         raw_spin_lock(&vector_lock);
>         /* Mark the inuse vectors */
>         for_each_active_irq(irq) {
> +               if (!is_ioapic_irq(irq))
> +                       continue;
> +
>                 cfg = irq_get_chip_data(irq);
>                 if (!cfg)
>                         continue;
> @@ -1641,7 +1656,6 @@ __apicdebuginit(void) print_IO_APICs(void)
>         int ioapic_idx;
>         struct irq_cfg *cfg;
>         unsigned int irq;
> -       struct irq_chip *chip;
>
>         printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
>         for (ioapic_idx = 0; ioapic_idx < nr_ioapics; ioapic_idx++)
> @@ -1662,8 +1676,7 @@ __apicdebuginit(void) print_IO_APICs(void)
>         for_each_active_irq(irq) {
>                 struct irq_pin_list *entry;
>
> -               chip = irq_get_chip(irq);
> -               if (chip != &ioapic_chip)
> +               if (!is_ioapic_irq(irq))
>                         continue;
>
>                 cfg = irq_get_chip_data(irq);

if the irq is not using ioapic_chip such as msi_chip etc, that irq
should be skip.
