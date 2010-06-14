Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab0FNHpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 03:45:09 -0400
Received: from mailout2.zih.tu-dresden.de ([141.30.67.73]:38643 "EHLO
	mailout2.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851Ab0FNHpH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 03:45:07 -0400
Message-ID: <4C15DDF5.5040202@tu-dresden.de>
Date: Mon, 14 Jun 2010 09:44:53 +0200
From: =?UTF-8?B?Um9ubnkgVHNjaMO8dGVy?= <Ronny.Tschueter@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sched:sched_migrate_task event tracing returns incorrect
 events
References: <4C10FD1C.7080200@tu-dresden.de> <1276182701.2077.462.camel@twins>
In-Reply-To: <1276182701.2077.462.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-TUD-Virus-Scanned: mailout2.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 10.06.2010 17:11, schrieb Peter Zijlstra:
> On Thu, 2010-06-10 at 16:56 +0200, Ronny Tschüter wrote:
>    
>> Hi,
>>
>> I want to know a little bit more about the execution of my program.
>> Especially I'm interested in cpu migrations of my process. Therefore I
>> use the Linux performance counter infrastructure, set appropriate
>> perf_event attributes and setup the sched:sched_migrate_task event with
>> a system call:
>> ...
>> attr.type = PERF_TYPE_TRACEPOINT;
>> attr.size = sizeof( struct perf_event_attr );
>> attr.config = event_id; // id of sched:sched_migrate_task event
>> attr.sample_type = PERF_SAMPLE_TIME|PERF_SAMPLE_CPU|PERF_SAMPLE_RAW;
>> attr.freq = 0;
>> attr.sample_freq = 1;
>> fd = syscall( __NR_perf_counter_open,&attr, getpid(), -1, -1, 0 );
>> ...
>> Finally to read the events I map the kernel event buffer via mmap and
>> process every event in this buffer. However I run into two problems:
>>
>> (1) I need root privileges to open the counter successfully. Without
>> root privileges syscall returns -1. I think that is not OK because users
>> should be allowed to create per task counters.
>>      
> It is, because you specify PERF_SAMPLE_RAW, which is considered a data
> leak for unpriv users.
>
>    
>> (2) The buffer contains events that aren't caused by my process (i.e.
>> the COMM field does not contain the name of my process and the PID field
>> is not equal to the pid of my process).
>>      
> I think that could happen if the migration happens from interrupt
> context while your task is running. Also wakeups your process does can
> result in migrations of the woken task from the context of your task.
>    
What I need is a counter that trace every scheduling event (at least 
every cpu migration event) of a given process. Is there such a counter 
in the perf_events or does all counters come with this weakness? At the 
moment I open one counter per cpu, trace all scheduling events on this 
cpu and filter the events manually. But this approach is not feasible 
for MPI programs, because the number of required counters will increase 
enormously ( #processes * #cpus counters are needed ).


