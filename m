Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab3AGSH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:07:26 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45119 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab3AGSHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:07:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130107150422.GB3926@htj.dyndns.org>
References: <cover.1352196505.git.viresh.kumar@linaro.org>
	<ad25c731a6ca1bd1269555245952f05c856a9759.1352196505.git.viresh.kumar@linaro.org>
	<20121126171539.GZ15971@htj.dyndns.org>
	<CAKohpom9=K976NmyFWtXx2UQyRcLAqsoGw-5AaqXRpSL6uxP_g@mail.gmail.com>
	<CAKohpokBMhto6xzp3MPGRJqstEkkC=kzgrKNhVXzi1Y8GejkXg@mail.gmail.com>
	<20130104150928.GC15633@mtj.dyndns.org>
	<CAKohpo=hhScCDUnDcqnZx4YzU_8nF1658jmSM_wzsOpSCxXwqA@mail.gmail.com>
	<20130107150422.GB3926@htj.dyndns.org>
Date: Mon, 7 Jan 2013 23:37:22 +0530
Message-ID: <CAKohponQP7+fUJtTysDiaDNQA0fTCcErb97gpKCxXpshSOuYfg@mail.gmail.com>
Subject: Re: [PATCH V2 Resend 3/4] workqueue: Schedule work on non-idle cpu
 instead of current one
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: rostedt@goodmis.org, Vincent Guittot <vincent.guittot@linaro.org>,
        pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        mingo@redhat.com, peterz@infradead.org, Arvind.Chauhan@arm.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        pdsw-power-team@arm.com, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Removed Suresh and Venki from discussion, they switched their companies
probably]

On 7 January 2013 20:34, Tejun Heo <tj@kernel.org> wrote:
> The latter part "not using idle cpu just for processing work" does
> apply to homogeneous systems too but as I wrote earlier work items
> don't spontaneously happen on an idle core.  Something, including
> timer, needs to kick it.  So, by definition, a CPU already isn't idle
> when a work item starts execution on it.  What am I missing here?

We are talking about a core being idle from schedulers perspective :)

>> I have another idea that we can try:
>>
>> queue_work_on_any_cpu().
>>
>> With this we would not break any existing code and can try to migrate
>> old users to
>> this new infrastructure (atleast the ones which are rearming works from their
>> work_handlers). What do you say?
>
> Yeah, this could be a better solution, I think.  Plus, it's not like
> finding the optimal cpu is free.

Thanks for the first part (When i shared this idea with Vincent and Amit, i
wasn't sure at all about the feedback i will get from you and others, but i
am very happy now :) ).

I couldn't understand the second part. We still need to search for a free cpu
for this new routine. And the implementation would almost be same as the
implementation of queue_work() in my initial patch

>> To take care of the cache locality issue, we can pass an argument to
>> this routine,
>> that can provide
>> - the mask of cpus to schedule this work on
>>   OR
>> - Sched Level (SD_LEVEL) of cpus to run it.
>
> Let's start simple for now.  If we really need it, we can always add
> more later.

:)
Agreed. But i liked the idea from steven, we can have two routines:
queue_work_on_any_cpu() and queue_work_on_cpus()
