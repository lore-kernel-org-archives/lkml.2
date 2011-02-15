Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab1BOS0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:26:06 -0500
Received: from smtp-out.google.com ([216.239.44.51]:34415 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab1BOS0F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:26:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iCVu7qgHdHhA+G7fcDChuMuA//wNVoJUWG/15jHNV7SFICG7DPoTvqmqmNPJTnmYcT
         AETcfO58PfsAS4r0IPwQ==
MIME-Version: 1.0
In-Reply-To: <20110215170127.GA28865@dirshya.in.ibm.com>
References: <1297473616.2806.16.camel@sbsiddha-MOBL3.sc.intel.com>
	<1297723130-693-1-git-send-email-venki@google.com>
	<20110215170127.GA28865@dirshya.in.ibm.com>
Date: Tue, 15 Feb 2011 10:26:01 -0800
Message-ID: <AANLkTi=ENtUtgHYaCJqvDGYVFKyXYFcVVOOFf8-dfW=+@mail.gmail.com>
Subject: Re: [PATCH] sched: Wholesale removal of sd_idle logic
From: Venkatesh Pallipadi <venki@google.com>
To: svaidy@linux.vnet.ibm.com
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@gmail.com>,
        Tim Chen <tim.c.chen@intel.com>, Alex Shi <alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 9:01 AM, Vaidyanathan Srinivasan
<svaidy@linux.vnet.ibm.com> wrote:
> * Venkatesh Pallipadi <venki@google.com> [2011-02-14 14:38:50]:
>
>> sd_idle logic was introduced way back in 2005 (commit 5969fe06),
>> as an HT optimization.
>>
>> As per the discussion in the thread here
>> lkml subject - sched: Resolve sd_idle and first_idle_cpu Catch-22 - v1
>> https://patchwork.kernel.org/patch/532501/
>>
>> the capacity based logic in the load balancer right now handles this
>> in a much cleaner way, handling more than 2 SMT siblings etc, and sd_idle
>> does not seem to bring any adiitional benefits. sd_idle logic also has
>> some bugs that has performance impact. Here is the patch that removes
>> the sd_idle logic altogether.
>>
>> The initial patch here - https://patchwork.kernel.org/patch/532501/
>> applies cleanly over the below change and provides a micro-optimization
>> for a specific case, where an idle core can pull tasks instead of a
>> core with one thread being idle and other thread being busy.
>> It will be good to get some data on whether this micro-optimization
>> matters or not.
>>
>> Also, there was a dependency of sched_mc_power_savings == 2, with sd_idle
>> logic. Copying Vaidy to know the impact of this change there.
>
> Hi Venki,
>
> The dependency is to avoid active balancing when there is a busy
> sibling and power save balance is not set.
>
> Another logic would propagate/force sd_idle=1 to induce more frequent
> balancing for idle sibling in case of power save balance.  Removing
> sd_idle will make this default.
>
> Your changes look good.  I will test and report.
>
>> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
>
> Acked-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
>
>> ---
>>  kernel/sched_fair.c |   53 ++++++++++----------------------------------------
>>  1 files changed, 11 insertions(+), 42 deletions(-)
>>

<snip>

>> @@ -3386,10 +3363,6 @@ redo:
>>                       sd->balance_interval *= 2;
>>       }
>>
>> -     if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
>> -         !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
>> -             ld_moved = -1;
>
> I have not figured out where ld_moved is checked for -1 and why we
> need to treat this as a special case.
>

Return value of -1 was being consumed in rebalance domains() call
to load_balance(). Returning -1 (instead of 0 in this case) makes
rebalance_domains() to call higher domain load balancing
with CPU_NOT_IDLE, when sibling is busy and even when there
was no load pulled in.

Thanks,
Venki

> Your bug fix in idle_balance() for if (pulled_task) {...} is a good
> catch.
>
>> -
>>       goto out;
>>
>>  out_balanced:
>> @@ -3403,11 +3376,7 @@ out_one_pinned:
>>                       (sd->balance_interval < sd->max_interval))
>>               sd->balance_interval *= 2;
>>
>> -     if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
>> -         !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
>> -             ld_moved = -1;
>> -     else
>> -             ld_moved = 0;
>
> Ack.  But why did we have to flag this case earlier?
>
>> +     ld_moved = 0;
>>  out:
>>       return ld_moved;
>>  }
>
> --Vaidy
>
>
