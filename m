Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab2ICSxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 14:53:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54256 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab2ICSxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 14:53:40 -0400
MIME-Version: 1.0
In-Reply-To: <034a9cbb168501954408f1004a28c827f3a4158b.1346653435.git.agordeev@redhat.com>
References: <cover.1346653435.git.agordeev@redhat.com>
	<034a9cbb168501954408f1004a28c827f3a4158b.1346653435.git.agordeev@redhat.com>
Date: Mon, 3 Sep 2012 11:53:39 -0700
X-Google-Sender-Auth: YOf7LUIWdwclkj6euPyi6nWy6WY
Message-ID: <CAE9FiQUuAPy884Ytu5PrFkcoQ5tT_DPxyYDk1D1jKbo+G577Mw@mail.gmail.com>
Subject: Re: [PATCH v2 -tip 1/5] x86, MSI: Support multiple MSIs in presense
 of IRQ remapping
From: Yinghai Lu <yinghai@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 2:17 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> The MSI specification has several constraints in comparison with MSI-X,
> most notable of them is the inability to configure MSIs independently.
> As a result, it is impossible to dispatch interrupts from different
> queues to different CPUs. This is largely devalues the support of
> multiple MSIs in SMP systems.
>
> Also, a necessity to allocate a contiguous block of vector numbers for
> devices capable of multiple MSIs might cause a considerable pressure on
> x86 interrupt vector allocator and could lead to fragmentation of the
> interrupt vectors space.
>
> This patch overcomes both drawbacks in presense of IRQ remapping and
> lets devices take advantage of multiple queues and per-IRQ affinity
> assignments.
>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |  166 +++++++++++++++++++++++++++++++++++++--
>  include/linux/irq.h            |    6 ++
>  kernel/irq/chip.c              |   30 +++++--
>  kernel/irq/irqdesc.c           |   31 ++++++++
>  4 files changed, 216 insertions(+), 17 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index c265593..5fd2577 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -305,6 +305,11 @@ static int alloc_irq_from(unsigned int from, int node)
>         return irq_alloc_desc_from(from, node);
>  }
>
> +static int alloc_irqs_from(unsigned int from, unsigned int count, int node)
> +{
> +       return irq_alloc_descs_from(from, count, node);
> +}
> +
>  static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
>  {
>         free_irq_cfg(at, cfg);
> @@ -3039,6 +3044,55 @@ int create_irq(void)
>         return irq;
>  }
>
> +unsigned int create_irqs(unsigned int from, unsigned int count, int node)
> +{
> +       struct irq_cfg **cfg;
> +       unsigned long flags;
> +       int irq, i;
> +
> +       if (from < nr_irqs_gsi)
> +               from = nr_irqs_gsi;
> +
> +       cfg = kzalloc_node(count * sizeof(cfg[0]), GFP_KERNEL, node);
> +       if (!cfg)
> +               return 0;
> +
> +       irq = alloc_irqs_from(from, count, node);
> +       if (irq < 0)
> +               goto out_cfgs;
> +
> +       for (i = 0; i < count; i++) {
> +               cfg[i] = alloc_irq_cfg(irq + i, node);
> +               if (!cfg[i])
> +                       goto out_irqs;
> +       }
> +
> +       raw_spin_lock_irqsave(&vector_lock, flags);
> +       for (i = 0; i < count; i++)
> +               if (__assign_irq_vector(irq + i, cfg[i], apic->target_cpus()))
> +                       goto out_vecs;
> +       raw_spin_unlock_irqrestore(&vector_lock, flags);
> +
> +       for (i = 0; i < count; i++) {
> +               irq_set_chip_data(irq + i, cfg[i]);
> +               irq_clear_status_flags(irq + i, IRQ_NOREQUEST);
> +       }
> +
> +       kfree(cfg);
> +       return irq;
> +
> +out_vecs:
> +       for (; i; i--)
> +               __clear_irq_vector(irq + i - 1, cfg[i - 1]);
> +       raw_spin_unlock_irqrestore(&vector_lock, flags);
> +out_irqs:
> +       for (i = 0; i < count; i++)
> +               free_irq_at(irq + i, cfg[i]);
> +out_cfgs:
> +       kfree(cfg);
> +       return 0;
> +}
> +

You may update create_irq_nr to be __create_irq_nr, and it could take
extra count.

and later have create_irq_nr to be __create_irq_nr(,1,)
and create_irqs to be __create_irq_nr(,count,)
....

BTW, in short, how much performance benefits for adding 500 lines code?

Thanks

Yinghai
