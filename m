Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1ARH0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 02:26:12 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34056 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1ARH0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 02:26:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NbaUKSWUQsIbQtZCLmauYP5xDaZS2UF4CVF6yI5Ufkcao2EgpS43vffjYl33hpTHRP
         p1BIPq++vrtYKE9BQPA66T77ZL+b4q4oih1BQaNztAS+wGGu+nhEf5X5LvQFIgcs62VU
         A2fsck+6OWH6EOdOmfKwqz2xOTIuQxG5M5HTA=
MIME-Version: 1.0
In-Reply-To: <1295274811-3504-1-git-send-email-yong.zhang0@gmail.com>
References: <1295274811-3504-1-git-send-email-yong.zhang0@gmail.com>
Date: Tue, 18 Jan 2011 15:26:10 +0800
Message-ID: <AANLkTi=TjjfLVsV0xV0crZ9Jj=8TmoSJ7U4gxi6KktH9@mail.gmail.com>
Subject: Re: [PATCH -rt] genirq: IRQF_NODELAY must be consistent between
 shared irqs
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 10:33 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> IRQF_NODELAY can not be messed up for shared irqs, because if
> one of the regestered irq can be threaded, irq_desc->status will
> set with IRQ_ONESHOT. Thus when irq is triggered, the
> none-threaded one will warn with warn_no_thread().

Precisely, this occurs when we first register a threaded action,
then register another one with IRQF_NODELAY. When irq
for the second one is coming, warn_no_thread() will yell on
it.

Thanks,
Yong

>
> So let __setup_irq fail if IRQF_NODELAY is not consistent between
> them.
>
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/irq/manage.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index cda70cb..7ce9050 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -797,10 +797,11 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
>                 * Can't share interrupts unless both agree to and are
>                 * the same type (level, edge, polarity). So both flag
>                 * fields must have IRQF_SHARED set and the bits which
> -                * set the trigger type must match.
> +                * set the trigger type and IRQF_NODELAY must match.
>                 */
>                if (!((old->flags & new->flags) & IRQF_SHARED) ||
> -                   ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK)) {
> +                   ((old->flags ^ new->flags) & (IRQF_TRIGGER_MASK |
> +                                                 IRQF_NODELAY))) {
>                        old_name = old->name;
>                        goto mismatch;
>                }
> --
> 1.7.1
