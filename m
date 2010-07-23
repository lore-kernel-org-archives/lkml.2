Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111Ab0GWNUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:20:53 -0400
Received: from mail.windriver.com ([147.11.1.11]:60150 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab0GWNUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:20:46 -0400
Message-ID: <4C4996FA.2010301@windriver.com>
Date: Fri, 23 Jul 2010 08:19:54 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "Deng, Dongdong" <dongdong.deng@windriver.com>, will.deacon@arm.com,
        lethal@linux-sh.org, mahesh@linux.vnet.ibm.com,
        prasad@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org,
        mingo@elte.hu, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] hw-breakpoints, kgdb, x86: add a flag to passDIE_DEBUG
 notification
References: <1279851361-32604-1-git-send-email-dongdong.deng@windriver.com> <20100723130430.GA5255@nowhere>
In-Reply-To: <20100723130430.GA5255@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2010 13:19:56.0469 (UTC) FILETIME=[BE693650:01CB2A69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 08:04 AM, Frederic Weisbecker wrote:
> On Fri, Jul 23, 2010 at 10:16:01AM +0800, Dongdong Deng wrote:
>   
>> The hw_breakpoint subsystem consumes all the hardware
>> breakpoint exceptions since it hooks the notify_die
>> handlers first, this means that kgdb doesn't get the
>> opportunity to handle hw breakpoint exceptions generated
>> by kgdb itself.
>>
>> This patch adds an extend flag to perf_event_attr for
>> hw_breakpoint_handler() to decide to pass or stop the
>> DIE_DEBUG notification.
>>
>> As KGDB set that flag, hw_breakpoint_handler() will pass
>> the DIE_DEBUG notification, thus kgdb have the chance
>> to take DIE_DEBUG notification.
>>
>> Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
>> Reviewed-by: Bruce Ashfield <bruce.ashfield@windriver.com>
>> ---
>>  arch/x86/kernel/hw_breakpoint.c |   14 ++++++++++++++
>>  arch/x86/kernel/kgdb.c          |    2 ++
>>  include/linux/perf_event.h      |    9 +++++++++
>>  3 files changed, 25 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
>> index a8f1b80..b38f786 100644
>> --- a/arch/x86/kernel/hw_breakpoint.c
>> +++ b/arch/x86/kernel/hw_breakpoint.c
>> @@ -406,6 +406,8 @@ EXPORT_SYMBOL_GPL(hw_breakpoint_restore);
>>   * ii) When there are more bits than trap<n> set in DR6 register (such
>>   * as BD, BS or BT) indicating that more than one debug condition is
>>   * met and requires some more action in do_debug().
>> + * iii) The source of hw breakpoint event want to handle the event
>> + * by itself, currently just KGDB have this notion.
>>   *
>>   * NOTIFY_STOP returned for all other cases
>>   *
>> @@ -464,6 +466,18 @@ static int __kprobes hw_breakpoint_handler(struct die_args *args)
>>  			break;
>>  		}
>>  
>> +		if (bp->attr.flag == SKIP_HWBP_EVENT_PERF_FLAG) {
>> +			/*
>> +			 * when attr.flag is set to SKIP_HWBP_EVENT_PERF_FLAG
>> +			 * it indicates currently hw breakpoint event
>> +			 * source want to handle this event by itself.
>> +			 * thus return NOTIFY_DONE here.
>> +			 */
>> +			rc = NOTIFY_DONE;
>> +			rcu_read_unlock();
>> +			break;
>> +		}
>> +
>>     
>
>
>
> No. We really shouldn't make a user ABI change (adding attr.flag) just
> to solve an in-kernel-only problem.
>
> And moreover we probably don't need flags at all. Why not just turning kgdb handler
> into a higher priority?
>
> I don't even remember why kgdb has its own handler instead of using the
> struct perf_event:overflow_handler. May be that's because of the early breakpoints.
>
>   


The patch may or may not be the right way to solve the problem.   It is
worth noting that early breakpoints are handled separately with a direct
writes to the debug registers so this API does not apply.

This patch effectively causes the events to get passed to the normal
handlers.

The source of the original problem (which was merged in 2.6.35) is
commit: 018cbffe6819f6f8db20a0a3acd9bab9bfd667e4 -     Merge commit
'v2.6.33' into perf/core

Specifically this line right here:
@@@ -502,6 -486,8 +486,6 @@@ static int __kprobes hw_breakpoint_hand
          rcu_read_lock();
 
          bp = per_cpu(bp_per_reg[i], cpu);
 -        if (bp)
 -            rc = NOTIFY_DONE;

Because the NOTIFY_DONE is never set, a default value of NOTIFY_STOP is
passed at the end and kgdb never gets to see the break point even that
was never intended for the perf handler in the first place.

It is not as easy of course to just revert this patch because it changed
other logic.

Jason.
