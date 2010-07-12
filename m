Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0GLRMD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:12:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:44831 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab0GLRL7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:11:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Z2AxPHb7OqzM0QHMLXyPJiER8ImqInElwRJ2k8iMZQ6PA8yrsj/e5jhlz3hQXZklr
	hSfC6Cr5FsgORejNo6EZw==
MIME-Version: 1.0
In-Reply-To: <1278612989.1900.176.camel@laptop>
References: <1278088816.1917.279.camel@laptop>
	<1278089799-11949-1-git-send-email-venki@google.com>
	<1278598336.1900.150.camel@laptop>
	<1278611133.2834.10.camel@sbs-t61.sc.intel.com>
	<1278612989.1900.176.camel@laptop>
Date: Mon, 12 Jul 2010 10:11:56 -0700
Message-ID: <AANLkTinCWjyfsMeMTMZeYTcLgYD3LMKviOi_PNXWHUou@mail.gmail.com>
Subject: Re: [PATCH] sched: Call update_group_power only for local_group
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
        Joel Schopp <jschopp@austin.ibm.com>,
        Michael Neuling <mikey@neuling.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 8, 2010 at 11:16 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-07-08 at 10:45 -0700, Suresh Siddha wrote:
>> > @@ -2433,7 +2433,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
>> >               return;
>> >       }
>> >
>> > -     update_group_power(sd, this_cpu);
>> > +     if (local_group)
>> > +             update_group_power(sd, this_cpu);
>>
>> if IDLE == CPU_NEWLY_IDLE, then all the cpu's in the local group will do
>> this. Also update_group_power() can be done on only on the local cpu,
>> i.e., when this_cpu == smp_processor_id() right?
>
> It might make sense to only update_group_power on !CPU_NEWLY_IDLE and
> rely on the tick driven cpu_power updates.
>
> No sense in updating them in finer slices I guess.
>
> So how about something like:

Yes. This looks good.

Acked-by: Venkatesh Pallipadi <venki@google.com>

>
> ---
>  kernel/sched_fair.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 9910e1b..2f05679 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -2427,14 +2427,14 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
>         * domains. In the newly idle case, we will allow all the cpu's
>         * to do the newly idle load balance.
>         */
> -       if (idle != CPU_NEWLY_IDLE && local_group &&
> -           balance_cpu != this_cpu) {
> -               *balance = 0;
> -               return;
> +       if (idle != CPU_NEWLY_IDLE && local_group) {
> +               if (balance_cpu != this_cpu) {
> +                       *balance = 0;
> +                       return;
> +               }
> +               update_group_power(sd, this_cpu);
>        }
>
> -       update_group_power(sd, this_cpu);
> -
>        /* Adjust by relative CPU power of the group */
>        sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
>
>
>
