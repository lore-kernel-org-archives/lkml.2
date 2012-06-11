Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab2FKJki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:40:38 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34455 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753249Ab2FKJkg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:40:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAH3Oq6QKkVGtXdLPH6JMZx2H3s9tWG0-sXA9uOVaF3QPiE83Ww@mail.gmail.com>
References: <CAH3Oq6QKkVGtXdLPH6JMZx2H3s9tWG0-sXA9uOVaF3QPiE83Ww@mail.gmail.com>
Date: Mon, 11 Jun 2012 17:40:34 +0800
Message-ID: <CAH3Oq6RP8Md63m_3df9c7J03re+OUJW=K894=O6rHLQT1MjVCw@mail.gmail.com>
Subject: Re: Increment irq count for second edge irq when the first is in progress
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/5 Ning Jiang <ning.n.jiang@gmail.com>:
> I've made a another patch based on your conception of irq accounting.
> It fixes the corner case in which there comes up a second irq when the
> first is still in progress, we'll increment the irq count before we quit.
>
>
> From 93960c69e588989346589fac78b311ac62fb7552 Mon Sep 17 00:00:00 2001
> From: Ning Jiang <ning.n.jiang@gmail.com>
> Date: Mon, 4 Jun 2012 09:54:08 +0800
> Subject: [PATCH] genirq: Increment irq count for second edge irq when
> the first is in progress
>
> kstat_incr_irqs_this_cpu() records the real number of interruptions
> to a certain CPU, regardless of the current irq state. That includes
> interrupts which are delivered in a state where the device handler
> cannot be called.
>
> For level irq, if its disabled or no action available, we'll skip
> irq handling. When it is enabled later, the irq will be retriggered
> and kstat_incr_irqs_this_cpu() will be incremented again. This counts
> the number of interrupts arrived at the CPU and therefor it counts
> TWO in this situation. The CPU is interrupted twice, not once. The
> accounting works correctly as expected.
>
> But for edge irq, we have a subtle problem. Suppose a second irq
> happens when the first is still in progress, it will mark itself
> pending and quit, then it will be handled in the same loop after
> the first one has been handled. Thus kstat_incr_irqs_this_cpu()
> will only be counted once for two irqs.
>
> Add a check in edge handler if there is a irq already in progress,
> we'll first kstat_incr_irqs_this_cpu() before we mask and quit, so
> that we can get correct irq count in this case.
>
> [ Thanks Thomas for his excellent comments ]
>
> Signed-off-by: Ning Jiang <ning.n.jiang@gmail.com>
> ---
>  kernel/irq/chip.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index eebd6d5..254b8aa 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -489,6 +489,8 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
>        if (unlikely(irqd_irq_disabled(&desc->irq_data) ||
>                     irqd_irq_inprogress(&desc->irq_data) || !desc->action)) {
>                if (!irq_check_poll(desc)) {
> +                       if (irqd_irq_inprogress(&desc->irq_data))
> +                               kstat_incr_irqs_this_cpu(irq, desc);
>                        desc->istate |= IRQS_PENDING;
>                        mask_ack_irq(desc);
>                        goto out_unlock;
> @@ -550,6 +552,8 @@ void handle_edge_eoi_irq(unsigned int irq, struct
> irq_desc *desc)
>        if (unlikely(irqd_irq_disabled(&desc->irq_data) ||
>                     irqd_irq_inprogress(&desc->irq_data) || !desc->action)) {
>                if (!irq_check_poll(desc)) {
> +                       if (irqd_irq_inprogress(&desc->irq_data))
> +                               kstat_incr_irqs_this_cpu(irq, desc);
>                        desc->istate |= IRQS_PENDING;
>                        goto out_eoi;
>                }
> --
> 1.7.1

Does anyone have comments on it? Please raise your concerns if any.

Thanks,
Ning
