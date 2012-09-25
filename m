Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2IYMKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:10:37 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37528 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab2IYMKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:10:36 -0400
MIME-Version: 1.0
In-Reply-To: <1348505678.11847.110.camel@twins>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	<20120914212717.GA29307@liondog.tnic>
	<CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	<20120924150048.GB11266@suse.de>
	<1348500647.11847.69.camel@twins>
	<CA+55aFxtQXmqeo5uNNgy+GLDWbQ5e+cqqc5-qnjds=P-VSCOsQ@mail.gmail.com>
	<1348505678.11847.110.camel@twins>
Date: Tue, 25 Sep 2012 20:10:35 +0800
Message-ID: <CAJd=RBBV+hsygaceBmpCxBN+Ek_oUOXQFDN1ThwNaxAD1Kox-A@mail.gmail.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Borislav Petkov <bp@alien8.de>,
        Nikolay Ulyanitsky <lystor@gmail.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>, Th@jasper.es
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 12:54 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2012-09-24 at 09:33 -0700, Linus Torvalds wrote:
>> Sure, the "scan bits" bitops will return ">= nr_cpu_ids" for the "I
>> couldn't find a bit" thing, but that doesn't mean that everything else
>> should.
>
> Fair enough..
>
> ---
>  kernel/sched/fair.c | 42 +++++++++++++++++++++---------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 6b800a1..329f78d 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2634,25 +2634,12 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>   */
>  static int select_idle_sibling(struct task_struct *p, int target)
>  {
> -       int cpu = smp_processor_id();
> -       int prev_cpu = task_cpu(p);
>         struct sched_domain *sd;
>         struct sched_group *sg;
>         int i;
>
> -       /*
> -        * If the task is going to be woken-up on this cpu and if it is
> -        * already idle, then it is the right target.
> -        */
> -       if (target == cpu && idle_cpu(cpu))
> -               return cpu;
> -
> -       /*
> -        * If the task is going to be woken-up on the cpu where it previously
> -        * ran and if it is currently idle, then it the right target.
> -        */
> -       if (target == prev_cpu && idle_cpu(prev_cpu))
> -               return prev_cpu;
> +       if (idle_cpu(target))
> +               return target;
>
>         /*
>          * Otherwise, iterate the domains and find an elegible idle cpu.
> @@ -2661,18 +2648,31 @@ static int select_idle_sibling(struct task_struct *p, int target)
>         for_each_lower_domain(sd) {
>                 sg = sd->groups;
>                 do {
> -                       if (!cpumask_intersects(sched_group_cpus(sg),
> -                                               tsk_cpus_allowed(p)))
> -                               goto next;
> +                       int candidate = -1;
>
> +                       /*
> +                        * In the SMT case the groups are the SMT-siblings,
> +                        * otherwise they're singleton groups.
> +                        */
>                         for_each_cpu(i, sched_group_cpus(sg)) {
> +                               if (!cpumask_test_cpu(i, tsk_cpus_allowed(p)))
> +                                       continue;
> +
> +                               /*
> +                                * If any of the SMT-siblings are !idle, the
> +                                * core isn't idle.
> +                                */
>                                 if (!idle_cpu(i))
>                                         goto next;
> +
> +                               if (candidate < 0)
> +                                       candidate = i;


Any reason to determine candidate by scanning a non-idle core?
>                         }
>
> -                       target = cpumask_first_and(sched_group_cpus(sg),
> -                                       tsk_cpus_allowed(p));
> -                       goto done;
> +                       if (candidate >= 0) {
> +                               target = candidate;
> +                               goto done;
> +                       }
>  next:
>                         sg = sg->next;
>                 } while (sg != sd->groups);
>
> --
