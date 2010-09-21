Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab0IUUlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 16:41:07 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43833 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab0IUUlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 16:41:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=j+LkWArKS46aZ738X8tt8GSmRgQ//PTryYqx/zkHqDj2CzIsb6ji25NcdEgDDLYwD9
         uK8mMmUtQ9gmlGXdfgngML7fVgH8FvbVK2bBYeUiXbJx9NPV9hqJE2mAyuP3TAC9L31J
         eF6xGBlJA9Ys+IiTio2lobZ/A+u4xSQaI6EQs=
MIME-Version: 1.0
In-Reply-To: <20100921200502.GA26587@sgi.com>
References: <20100921200502.GA26587@sgi.com>
Date: Tue, 21 Sep 2010 13:41:04 -0700
X-Google-Sender-Auth: gu3A5R7flp63T4ZhYNAlXLOZa_o
Message-ID: <AANLkTinkiZC6bvRJ10EsG-CZSjdJtqW4N7pfq7vnvz3i@mail.gmail.com>
Subject: Re: [PATCH] x86 - irq vector assignment
From: Yinghai Lu <yinghai@kernel.org>
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 1:05 PM, Jack Steiner <steiner@sgi.com> wrote:
> Try to assign irq vectors to cpus on the correct node & fall back to global
> assignment only if node-local fails. This reduces the chances of
> using all of the interrupt vectors of a single cpu.
>
> Signed-off-by: Jack Steiner <steiner@sgi.com>
>
>
> ---
> Note: this is a fix for a problem we saw on systems with a large number of IOHs.
> The IOHs are distributed across 10's of nodes.
>
> Early in boot, the IO infrastructure assigns interrupts for the DMA engines.
> Currently, all interrupts are targeted to cpu 0. This uses all interrupt
> vectors on cpu 0. Later, some drivers try to create irqs targeted to
> cpu 0. The assignment fails because all vectors are assigned.
>
> This is a repost of a patch sent earlier. See
>        http://marc.info/?l=linux-kernel&m=127740806705617&w=2
>        http://marc.info/?l=linux-kernel&m=127791052828867&w=2
>
>
>
>  arch/x86/kernel/apic/io_apic.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> Index: linux/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/apic/io_apic.c   2010-09-17 13:00:19.164638447 -0500
> +++ linux/arch/x86/kernel/apic/io_apic.c        2010-09-17 13:00:23.448595373 -0500
> @@ -3253,6 +3253,11 @@ unsigned int create_irq_nr(unsigned int
>                desc_new = move_irq_desc(desc_new, node);
>                cfg_new = desc_new->chip_data;
>
> +#ifdef CONFIG_NUMA
> +               if (node >= 0 && __assign_irq_vector(new, cfg_new, node_to_cpumask_map[node]) == 0)
> +                       irq = new;
> +               else
> +#endif
>                if (__assign_irq_vector(new, cfg_new, apic->target_cpus()) == 0)
>                        irq = new;
>                break;

target_cpus() for uv_x and x2apic phys mode all have cpu_online_mask()

so we should get the vector for other cpus. aka __assign_irq_vector()
should not fail. unless you have so many irq > nr_irqs.

current code we only make sure irq_desc on device local node.

for the vectors, user can set irq smp_affinity move the device local
cpus if needed.

Thanks

Yinghai
