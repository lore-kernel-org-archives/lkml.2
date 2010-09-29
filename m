Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab0I2Tcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:32:31 -0400
Received: from smtp-out.google.com ([74.125.121.35]:34479 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab0I2Tca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ds5KyAEgIo1W7jPqBKqUhbeM851j06tz43RsX+N4x/8h5pSQHjAfaBhubd5RqXzoyU
         39KOJCBwbqqI669qVeUQ==
MIME-Version: 1.0
In-Reply-To: <1285724758.7440.11.camel@marge.simson.net>
References: <1285633798-26886-1-git-send-email-ncrao@google.com>
 <1285682273.7469.3.camel@marge.simson.net> <AANLkTin=Dic2UE55yUaam8NzGHTib=9s=x-wyzk03BU0@mail.gmail.com>
 <1285724758.7440.11.camel@marge.simson.net>
From: Nikhil Rao <ncrao@google.com>
Date: Wed, 29 Sep 2010 12:32:02 -0700
Message-ID: <AANLkTi=TQnYGLPC=Pi0o1As83W6VdWdjvimZNSrGT4qW@mail.gmail.com>
Subject: Re: [PATCH 0/3][RFC] Improve load balancing when tasks have large
 weight differential
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 6:45 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Tue, 2010-09-28 at 14:15 -0700, Nikhil Rao wrote:
>
>> Thanks for running this. I've not been able to reproduce what you are
>> seeing on the few test machines that I have (different combinations of
>> MC, CPU and NODE domains). Can you please give me more info about
>> your setup?
>
> It's a plain-jane Q6600 box, so has only MC and CPU domains.
>
> It doesn't necessarily _instantly_ "stick", can take a couple tries, or
> a little time.

The closest I have is a quad-core dual-socket machine (MC, CPU
domains). And I'm having trouble reproducing it on that machine as
well :-( I ran 5 soaker threads (one of them niced to -15) for a few
hours and didn't see the problem. Can you please give me some trace
data & schedstats to work with?

Looking at the patch/code, I suspect active migration on the CPU
scheduling domain pushes the nice 0 task (running on the same socket
as the nice -15 task) to the other socket. This leaves you with an
idle core on the nice -15 socket, and with soaker threads there is no
way to come back to a 100% utilized state. One possible explanation is
the group capacity for a sched group in the CPU sched domain is
rounded to 1 (instead of 2). I have a patch below that throws a hammer
at the problem and uses group weight instead of group capacity (this
is experimental, will refine it if it works). Can you please see if
that solves the problem?

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 6d934e8..3fdd669 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2057,6 +2057,7 @@ struct sg_lb_stats {
        unsigned long sum_nr_running; /* Nr tasks running in the group */
        unsigned long sum_weighted_load; /* Weighted load of group's tasks */
        unsigned long group_capacity;
+       unsigned long group_weight;
        int group_imb; /* Is there an imbalance in the group ? */
 };

@@ -2458,6 +2459,8 @@ static inline void update_sg_lb_stats(struct
sched_domain *sd,
                DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
        if (!sgs->group_capacity)
                sgs->group_capacity = fix_small_capacity(sd, group);
+
+       sgs->group_weight = cpumask_weight(sched_group_cpus(group));
 }

 /**
@@ -2480,6 +2483,9 @@ static bool update_sd_pick_busiest(struct
sched_domain *sd,
        if (sgs->avg_load <= sds->max_load)
                return false;

+       if (sgs->sum_nr_running <= sgs->group_weight)
+               return false;
+
        if (sgs->sum_nr_running > sgs->group_capacity)
                return true;
