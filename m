Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab0GVFex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:34:53 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36251 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab0GVFev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:34:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F9YZzaOitdV9ihMsYdDaczuPw2rANGltg9UtUAWbsGqfhDuG4Ga8z/Eg+n+VaeMiZM
         MFMIHVh3tI86SIL66RcJgFpqtPFF0auvYA4Su6FeME4JKBCWDc9sqdoD1Knh5IYpkIrh
         X5bU6JUA6KcOnBMVj5GhAWwyA4BqLpq2CuQ2g=
MIME-Version: 1.0
In-Reply-To: <AANLkTinNr28LM6NfsmbbmmV28mCzUugTTSI_Bq6N9-8C@mail.gmail.com>
References: <AANLkTinNr28LM6NfsmbbmmV28mCzUugTTSI_Bq6N9-8C@mail.gmail.com>
Date: Thu, 22 Jul 2010 11:04:50 +0530
Message-ID: <AANLkTikIt_DEDKdYB7BuikGlCBEN92YsASCrQ0U-hT1H@mail.gmail.com>
Subject: Re: clock drift in set_task_cpu()
From: Jack Daniel <wanders.thirst@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I would be much obliged if anyone can answer my below query. Any
guidance or advice is much appreciated. I believe the problem still
exists in the new kernel versions.

Thanks and regards,
Jack

On Wed, Jul 21, 2010 at 5:10 PM, Jack Daniel <wanders.thirst@gmail.com> wrote:
> Hi Peter/Ingo,
>
> I have a query with the kernel code that was changed not too long time
> back in v2.6.33-rc1 commit id 5afcdab706d6002cb02b567ba46e650215e694e8
> [tip:sched/urgent] sched: Remove rq->clock coupling from
> set_task_cpu()
>
> void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
> {
> int old_cpu = task_cpu(p);
> struct rq *old_rq = cpu_rq(old_cpu), *new_rq = cpu_rq(new_cpu);
> struct cfs_rq *old_cfsrq = task_cfs_rq(p),
>      *new_cfsrq = cpu_cfs_rq(old_cfsrq, new_cpu);
> u64 clock_offset;
>
> clock_offset = old_rq->clock - new_rq->clock;
> ---
>
> On a Xeon 55xx with 8 CPU's, I found out the new_rq->clock value is
> sometimes larger than old_rq->clock and so clock_offset tends to warp
> around leading to incorrect values. You have very correctly noted in
> the commit header that all functions that access set_task_cpu() must
> do so after a call to sched_clock_remote(), in this case the function
> is sched_fork(). I validated by adding update_rq_clock(old_rq); into
> set_task_cpu() and that seems to fix the issue. But I noticed that
> since CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is already set, if
> (sched_clock_stable)  in sched_clock_cpu() will yield to true and the
> flow never gets to sched_clock_remote() or sched_clock_local().
>
> What do you think is the best way to approach the problem *assuming
> the older kernel*, since I believe the problem still exists? That is
> to reinstate your axiom ".... which should ensure the observed time
> between these two cpus is monotonic"
>
> 1) CONFIG_HAVE_UNSTABLE_SCHED_CLOCK cannot be disabled since it is set
> by default for x86
> 2) Does one create a new function with just this line of pseudo code?
> fix_clock_drift()
> {
> if (cpu != smp_processor_id())
>                clock = sched_clock_remote(scd);
>        else
>                clock = sched_clock_local(scd);
>
>        return clock;
> }
>
> Thanks and regards,
> Jack
>
