Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab1EMEQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 00:16:09 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43518 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab1EMEQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 00:16:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LHCrlrNn9FYgDgVZYsy7ofd4px7VRGMuz2unDGouw4cg0hXuqfzrPRieCu7lx1FpH7
         v0GH+XDMRm0YgJu+mti3XWDY2MdYjm0x4bLFH4KufhJ8dbK8IaZ1ots7L97GLREzHNGz
         Om1XzA+4dspSWDHvfSRHXuGeft1IJiLd5Tcj8=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1105121229150.2407@chino.kir.corp.google.com>
References: <1889981320.330808.1305081044822.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
	<alpine.DEB.2.00.1105111331480.9346@chino.kir.corp.google.com>
	<BANLkTi=fNtPZQk5Mp7rbZJFpA1tzBh+VcA@mail.gmail.com>
	<alpine.DEB.2.00.1105121229150.2407@chino.kir.corp.google.com>
Date: Fri, 13 May 2011 13:16:02 +0900
Message-ID: <BANLkTikJvT8BmfvMeyL8MAyww3Gdgm3kPA@mail.gmail.com>
Subject: Re: OOM Killer don't works at all if the system have >gigabytes
 memory (was Re: [PATCH] mm: check zone->all_unreclaimable in all_unreclaimable())
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: CAI Qian <caiqian@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 4:38 AM, David Rientjes <rientjes@google.com> wrote:
> On Thu, 12 May 2011, Minchan Kim wrote:
>
>> > processes a 1% bonus for every 30% of memory they use as proposed
>> > earlier.)
>>
>> I didn't follow earlier your suggestion.
>> But it's not formal patch so I expect if you send formal patch to
>> merge, you would write down the rationale.
>>
>
> Yes, I'm sure we'll still have additional discussion when KOSAKI-san
> replies to my review of his patchset, so this quick patch was written only
> for CAI's testing at this point.
>
> In reference to the above, I think that giving root processes a 3% bonus
> at all times may be a bit aggressive.  As mentioned before, I don't think
> that all root processes using 4% of memory and the remainder of system
> threads are using 1% should all be considered equal.  At the same time, I
> do not believe that two threads using 50% of memory should be considered
> equal if one is root and one is not.  So my idea was to discount 1% for
> every 30% of memory that a root process uses rather than a strict 3%.
>
> That change can be debated and I think we'll probably settle on something
> more aggressive like 1% for every 10% of memory used since oom scores are
> only useful in comparison to other oom scores: in the above scenario where
> there are two threads, one by root and one not by root, using 50% of
> memory each, I think it would be legitimate to give the root task a 5%
> bonus so that it would only be selected if no other threads used more than
> 44% of memory (even though the root thread is truly using 50%).
>
> This is a heuristic within the oom killer badness scoring that can always
> be debated back and forth, but I think a 1% bonus for root processes for
> every 10% of memory used is plausible.
>
> Comments?

Yes. Tend to agree.
Apparently, absolute 3% bonus is a problem in CAI's case.

Your approach which makes bonus with function of rss is consistent
with current OOM heuristic.
So In consistency POV, I like it as it could help deterministic OOM policy.

About 30% or 10% things, I think it's hard to define a ideal magic
value for handling for whole workloads.
It would be very arguable. So we might need some standard method to
measure it/or redhat/suse peoples. Anyway, I don't want to argue it
until we get a number.

>
>> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> > --- a/mm/oom_kill.c
>> > +++ b/mm/oom_kill.c
>> > @@ -160,7 +160,7 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>> >         */
>> >        if (p->flags & PF_OOM_ORIGIN) {
>> >                task_unlock(p);
>> > -               return 1000;
>> > +               return 10000;
>> >        }
>> >
>> >        /*
>> > @@ -177,32 +177,32 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>> >        points = get_mm_rss(p->mm) + p->mm->nr_ptes;
>> >        points += get_mm_counter(p->mm, MM_SWAPENTS);
>> >
>> > -       points *= 1000;
>> > +       points *= 10000;
>> >        points /= totalpages;
>> >        task_unlock(p);
>> >
>> >        /*
>> > -        * Root processes get 3% bonus, just like the __vm_enough_memory()
>> > -        * implementation used by LSMs.
>> > +        * Root processes get 1% bonus per 30% memory used for a total of 3%
>> > +        * possible just like LSMs.
>> >         */
>> >        if (has_capability_noaudit(p, CAP_SYS_ADMIN))
>> > -               points -= 30;
>> > +               points -= 100 * (points / 3000);
>> >
>> >        /*
>> >         * /proc/pid/oom_score_adj ranges from -1000 to +1000 such that it may
>> >         * either completely disable oom killing or always prefer a certain
>> >         * task.
>> >         */
>> > -       points += p->signal->oom_score_adj;
>> > +       points += p->signal->oom_score_adj * 10;
>> >
>> >        /*
>> >         * Never return 0 for an eligible task that may be killed since it's
>> > -        * possible that no single user task uses more than 0.1% of memory and
>> > +        * possible that no single user task uses more than 0.01% of memory and
>> >         * no single admin tasks uses more than 3.0%.
>> >         */
>> >        if (points <= 0)
>> >                return 1;
>> > -       return (points < 1000) ? points : 1000;
>> > +       return (points < 10000) ? points : 10000;
>> >  }
>> >
>> >  /*
>> > @@ -314,7 +314,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>> >                         */
>> >                        if (p == current) {
>> >                                chosen = p;
>> > -                               *ppoints = 1000;
>> > +                               *ppoints = 10000;
>>
>> Scattering constant value isn't good.
>> You are proving it now.
>> I think you did it since this is not a formal patch.
>> I expect you will define new value (ex, OOM_INTERNAL_MAX_SCORE or whatever)
>>
>
> Right, we could probably do something like
>
>        #define OOM_SCORE_MAX_FACTOR    10
>        #define OOM_SCORE_MAX           (OOM_SCORE_ADJ_MAX * OOM_SCORE_MAX_FACTOR)
>
> in mm/oom_kill.c, which would then be used to replace all of the constants
> above since OOM_SCORE_ADJ_MAX is already defined to be 1000 in
> include/linux/oom.h.

Looks good to me.
Let's wait KOSAKI's opinion and CAI's test result.

-- 
Kind regards,
Minchan Kim
