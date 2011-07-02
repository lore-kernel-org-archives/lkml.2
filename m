Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab1GBKb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 06:31:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:37291 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab1GBKb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 06:31:58 -0400
Subject: Re: [PATCH v4 7/9] KVM-GST: KVM Steal time accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
        Eric B Munson <emunson@mgebm.net>
In-Reply-To: <1309555369-16867-8-git-send-email-glommer@redhat.com>
References: <1309555369-16867-1-git-send-email-glommer@redhat.com>
	 <1309555369-16867-8-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 02 Jul 2011 12:30:28 +0200
Message-ID: <1309602628.10073.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 17:22 -0400, Glauber Costa wrote:
> @@ -3929,6 +3945,23 @@ void account_process_tick(struct task_struct *p, int user_tick)
>                 return;
>         }
>  
> +#ifdef CONFIG_PARAVIRT
> +       if (static_branch(&paravirt_steal_enabled)) {
> +               u64 steal, st = 0;
> +
> +               steal = paravirt_steal_clock(smp_processor_id());
> +               steal -= this_rq()->prev_steal_time;
> +
> +               st = steal_ticks(steal);
> +               this_rq()->prev_steal_time += st * TICK_NSEC;
> +
> +               if (st) {
> +                       account_steal_time(st);
> +                       return;
> +               }
> +       }
> +#endif
> +
>         if (user_tick)
>                 account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
>         else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET)) 

So I was about to send an Ack for this patch, when I noticed that this
will all be dead code when CONFIG_IRQ_TIME_ACCOUNTING &&
sched_clock_irqtime.

I think irqtime_account_process_tick() wants a similar hunk (which
suggests splitting it out into an inline function).
