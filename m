Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab0IKQm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 12:42:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17197 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab0IKQm2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 12:42:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IpBNuuNYpl9dFhRkk2FDiOa3JdertJMIAatj0KdeHOJ9GRuPpU2B1WZCrzqlFK7kJ8
         7rwVGxkbUmuKk350tGyA==
MIME-Version: 1.0
In-Reply-To: <1284196838.2251.12.camel@laptop>
References: <20100909135050.GB2228@osiris.boeblingen.de.ibm.com>
	<1284116817.402.33.camel@laptop>
	<20100910172805.a4fe5c7f.akpm@linux-foundation.org>
	<1284196838.2251.12.camel@laptop>
Date: Sat, 11 Sep 2010 09:42:16 -0700
Message-ID: <AANLkTi=Vrd0g-64oRYLo6fTj1SYYa++VG57vGn608tkA@mail.gmail.com>
Subject: Re: [PATCH] generic-ipi: fix deadlock in __smp_call_function_single
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 11, 2010 at 2:20 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-09-10 at 17:28 -0700, Andrew Morton wrote:
>> Where is this scheduler bug?  Did it occur because someone didn't
>> understand __smp_call_function_single()?  Or did it occur because the
>> scheduler code is doing something which its implementors did not expect
>> or intend?
>
>
> It comes from 83cd4fe2 (sched: Change nohz idle load balancing logic to
> push model), where nohz_balance_kick() simply needs to kick the
> designated driver into action.
>
> I take it Venki assumed __smp_call_function_single() works like
> smp_call_function_single() where you can use it for the local cpu as
> well.

Yes. This was an oversight while moving from using send_remote_softirq
to using __smp_call_function_single.
Also, as we don't have rq lock around this point, it seems possible
that the CPU that was busy and wants to kick idle load balance on
remote CPU, could have become idle and nominated itself as idle load
balancer.

Below patch looks good to me.

Acked-by: Venkatesh Pallipadi <venki@google.com>

I guess, we also need a WARN_ON_ONCE for (cpu == smp_processor_id())
in __smp_call_function_single(), as the eventual result of this bug
that Heiko saw was a deadlock

Thanks,
Venki

>
> I guess we could do something like the below as well, which would be
> slightly faster since we don't actually need to call raise_softirq()
> since we already set it for self a bit earlier in order to have it do
> the regular load-balance actions.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched_fair.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 9b5b4f8..c8ca1cb 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3404,11 +3404,13 @@ static void nohz_balancer_kick(int cpu)
>        }
>
>        if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
> -               struct call_single_data *cp;
> -
>                cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
> -               cp = &per_cpu(remote_sched_softirq_cb, cpu);
> -               __smp_call_function_single(ilb_cpu, cp, 0);
> +
> +               if (ilb_cpu != cpu) {
> +                       struct call_single_data *cp;
> +                       cp = &per_cpu(remote_sched_softirq_cb, cpu);
> +                       __smp_call_function_single(ilb_cpu, cp, 0);
> +               }
>        }
>        return;
>  }
>
>
