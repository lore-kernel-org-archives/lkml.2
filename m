Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2CLOsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:48:43 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:50349 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2CLOsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:48:41 -0400
Message-ID: <4F5E0CC1.6010102@linux.vnet.ibm.com>
Date: Mon, 12 Mar 2012 20:18:33 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix idle ticks in cpu summary line of /proc/stat
References: <20120311182621.41674b39@de.ibm.com> <20120312121726.GA23608@tiehlicka.suse.cz> <20120312101739.26eb373e@de.ibm.com>
In-Reply-To: <20120312101739.26eb373e@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12031204-1618-0000-0000-0000010C8131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 07:47 PM, Martin Schwidefsky wrote:

> On Mon, 12 Mar 2012 13:17:26 +0100
> Michal Hocko <mhocko@suse.cz> wrote:
> 
>> Goot catch. But I think that the following fix should be better because
>> it doesn't change the semantic of the function. What do you think?
> ..
>> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
>> index 7656642..dec767f 100644
>> --- a/kernel/time/tick-sched.c
>> +++ b/kernel/time/tick-sched.c
>> @@ -221,7 +221,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
>>  		update_ts_time_stats(cpu, ts, now, last_update_time);
>>  		idle = ts->idle_sleeptime;
>>  	} else {
>> -		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
>> +		if (cpu_online(cpu) && ts->idle_active && !nr_iowait_cpu(cpu)) {
>>  			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
>>
>>  			idle = ktime_add(ts->idle_sleeptime, delta);
>> @@ -262,7 +262,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
>>  		update_ts_time_stats(cpu, ts, now, last_update_time);
>>  		iowait = ts->iowait_sleeptime;
>>  	} else {
>> -		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
>> +		if (cpu_online(cpu) && ts->idle_active && nr_iowait_cpu(cpu) > 0) {
>>  			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
>>
>>  			iowait = ktime_add(ts->iowait_sleeptime, delta);
> 
> I would prefer an early exit from the functions. The target cpu is offline,
> who guarantees that the "struct tick_sched" for the cpu contains anything
> useful?
> 


Also, what about the case where last_update_time is non-NULL?
With Martin's patch update_ts_time_stats() won't be called for offline cpus,
whereas with Michal's patch it will be called and hence the counters will get
updated.. We don't want to update counters for offline cpus right?

Regards,
Srivatsa S. Bhat

