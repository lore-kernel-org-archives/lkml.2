Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab0DSUQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 16:16:45 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46048 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab0DSUQn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 16:16:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mfSx4F4h7vBPqtYBGy6WgrMcgLv+68yEY9pmYxLhX8/acalvBmoN9WRqN2vQS2Ib7x
         y0ALiG8PSvf+9bPLR404Mda99tO34Yu+3YusH8sDWQ4sa7cwoKlTPSmMTLFus1jyETUW
         60u8IHIOau05aJ+48TTxMaXS+peaXDR2YBIAg=
MIME-Version: 1.0
In-Reply-To: <1271703130.1676.214.camel@laptop>
References: <1271200751-18697-1-git-send-email-chase.douglas@canonical.com>
	 <1271703130.1676.214.camel@laptop>
Date: Mon, 19 Apr 2010 13:16:42 -0700
X-Google-Sender-Auth: 2ddcb64957628f4c
Message-ID: <n2y40ec3ea41004191316sc65cefeq478c74f302406be3@mail.gmail.com>
Subject: Re: [REGRESSION 2.6.30][PATCH v3] sched: update load count only once 
	per cpu in 10 tick update window
From: Chase Douglas <chase.douglas@canonical.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 11:52 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-04-13 at 16:19 -0700, Chase Douglas wrote:
>> There's a period of 10 ticks where calc_load_tasks is updated by all the
>> cpus for the load avg. Usually all the cpus do this during the first
>> tick. If any cpus go idle, calc_load_tasks is decremented accordingly.
>> However, if they wake up calc_load_tasks is not incremented. Thus, if
>> cpus go idle during the 10 tick period, calc_load_tasks may be
>> decremented to a non-representative value. This issue can lead to
>> systems having a load avg of exactly 0, even though the real load avg
>> could theoretically be up to NR_CPUS.
>>
>> This change defers calc_load_tasks accounting after each cpu updates the
>> count until after the 10 tick update window.
>>
>> A few points:
>>
>> * A global atomic deferral counter, and not per-cpu vars, is needed
>>   because a cpu may go NOHZ idle and not be able to update the global
>>   calc_load_tasks variable for subsequent load calculations.
>> * It is not enough to add calls to account for the load when a cpu is
>>   awakened:
>>   - Load avg calculation must be independent of cpu load.
>>   - If a cpu is awakend by one tasks, but then has more scheduled before
>>     the end of the update window, only the first task will be accounted.
>
> OK, so what you're saying is that because we update calc_load_tasks from
> entering idle, we decrease earlier than a regular 10 tick sample
> interval would?
>
> Hence you batch these early updates into _deferred and let the next 10
> tick sample roll them over?

Correct

> So the only early updates can come from
> pick_next_task_idle()->calc_load_account_active(), so why not specialize
> that callchain instead of the below?
>
> Also, since its all NO_HZ, why not stick this in with the ILB? Once
> people get around to making that scale better, this can hitch a ride.
>
> Something like the below perhaps? It does run partially from softirq
> context, but since there's a distinct lack of synchronization here that
> didn't seem like an immediate problem.

I understand everything until you move the calc_load_account_active
call to run_rebalance_domains. I take it that when CPUs go NO_HZ idle,
at least one cpu is left to monitor and perform updates as necessary.
Conceptually, it makes sense that this cpu should be handling the load
accounting updates. However, I'm new to this code, so I'm having a
hard time understanding all the cases and timings for when the
scheduler softirq is called. Is it guaranteed to be called during
every 10 tick load update window? If not, then we'll have the issue
where a NO_HZ idle cpu won't be updated to 0 running tasks in time for
the load avg calculation.

Would someone be able to explain how we are guaranteed of the correct
timing for this path?

I also have a concern with run_rebalance_domains: If the designated
no_hz.load_balancer cpu wasn't idle at the last tick or needs
rescheduling, load accounting won't occur for idle cpus. Is it
possible for this to occur every time when called in the 10 tick
update window?

-- Chase
