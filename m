Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0FZB0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 21:26:09 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53531 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab0FZB0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 21:26:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FpU36mzDMuM4YiZbQ1NkHftnny/FALFasYQdmXy9h0OCkVnegHxbCKEGRWGiWR3+qv
         kOZH6m8cGologQPs0YZK0OEBkEQ/Kp+gn+DsmagFNmLohVlVkVwKdym8Vyd2E6Yxag5u
         fHg3sK9HQ4oGtJa6C5qrG/8t6+xwaZmajuVxs=
MIME-Version: 1.0
In-Reply-To: <1277490625.1875.986.camel@laptop>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
	<1277361352.1875.838.camel@laptop>
	<1277490625.1875.986.camel@laptop>
Date: Sat, 26 Jun 2010 09:26:05 +0800
Message-ID: <AANLkTiltWgLtf2_pIu57-7V_Ya_PvOa5y75t_BwCvAtg@mail.gmail.com>
Subject: Re: [RFC][PATCH] irq_work -v2
From: huang ying <huang.ying.caritas@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H.Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, tglx <tglx@linutronix.de>,
       davem <davem@davemloft.net>, paulus <paulus@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 26, 2010 at 2:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> +
> +static DEFINE_PER_CPU(struct irq_work *, irq_work_list);
> +
> +/*
> + * Claim the entry so that no one else will poke at it.
> + */
> +static bool irq_work_claim(struct irq_work *entry)
> +{
> +       unsigned long flags;
> +
> +       do {
> +               flags = (unsigned long)entry->next;
> +               if (flags & IRQ_WORK_PENDING)
> +                       return false;
> +       } while (cmpxchg(&entry->next, flags, flags | IRQ_WORK_FLAGS) != flags);
> +
> +       return true;
> +}
> +
> +
> +void __weak arch_irq_work_raise(void)
> +{
> +       /*
> +        * Lame architectures will get the timer tick callback
> +        */
> +}
> +
> +/*
> + * Queue the entry and raise the IPI if needed.
> + */
> +static void __irq_work_queue(struct irq_work *entry)
> +{
> +       struct irq_work **head;
> +
> +       head = &get_cpu_var(irq_work_list);
> +
> +       do {
> +               /*
> +                * Can assign non-atomic because we keep the flags set.
> +                */
> +               entry->next = next_flags(*head, IRQ_WORK_FLAGS);
> +       } while (cmpxchg(head, entry->next, entry) != entry->next);

*head & IRQ_WORK_FLAGS == 0, but entry->next & IRQ_WORK_FLAGS ==
IRQ_WORK_FLAGS. So the cmpxchg will never succeed.

> +
> +       /*
> +        * The list was empty, raise self-interrupt to start processing.
> +        */
> +       if (!irq_work_next(entry))
> +               arch_irq_work_raise();
> +
> +       put_cpu_var(irq_work_list);
> +}

Best Regards,
Huang Ying
