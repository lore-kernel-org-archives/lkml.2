Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab0EEFRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 01:17:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:49367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab0EEFRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 01:17:36 -0400
Message-ID: <4BE0FF2F.3000908@kernel.org>
Date: Wed, 05 May 2010 07:16:31 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: mingo@elte.hu, peterz@infradead.org, efault@gmx.de, avi@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 03/12] perf: add perf_event_task_migrate()
References: <1272976724-14312-1-git-send-email-tj@kernel.org> <1272976724-14312-4-git-send-email-tj@kernel.org> <20100505050846.GG5427@nowhere>
In-Reply-To: <20100505050846.GG5427@nowhere>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 05 May 2010 05:16:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/05/2010 07:08 AM, Frederic Weisbecker wrote:
>>  /*
>> + * Called from scheduler set_task_cpu() to notify migration events.
>> + * If the task is moving to a different cpu, generate a migration sw
>> + * event.
>> + */
>> +void perf_event_task_migrate(struct task_struct *task, int new_cpu)
>> +{
>> +	if (task_cpu(task) != new_cpu)
>> +		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, 1, NULL, 0);
>> +}
> 
> This needs to be static and inline (I haven't seem external users in this
> patchset).

Hmm... after the last patch, this one becomes a TP probe function
which can't be inlined.

> And we want it to be inlined because we save the caller address and the frame
> pointer from perf_sw_event(), and a new level of call is not wanted here.

Oh I see.  So, to use it with TP, I would need increase the @skip
parameter to perf_fetch_caller_regs() somehow, right?  Also, it
probably would be a good idea to add a comment w/ big fat warning to
perf_sw_event().

>> @@ -2084,11 +2084,10 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
>>  #endif
>>  
>>  	trace_sched_migrate_task(p, new_cpu);
>> +	perf_event_task_migrate(p, new_cpu);
>>  
>> -	if (task_cpu(p) != new_cpu) {
>> +	if (task_cpu(p) != new_cpu)
> 
> In fact why not moving both tracing calls under this check.
> This is going to fix the migrate trace event that gets called
> even on "spurious" migrations, and you avoid the duplicate check
> in the perf callback.

Yeah, that would be my preferred choice too.  I just didn't know that
could be changed.  Cool.  I'll.

Thanks.

-- 
tejun
