Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab0EFGcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 02:32:42 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:35533 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752584Ab0EFGck convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 02:32:40 -0400
Message-ID: <4BE2627C.4060003@tu-dresden.de>
Date: Thu, 06 May 2010 08:32:28 +0200
From: =?ISO-8859-1?Q?Ronny_Tsch=FCter?= <Ronny.Tschueter@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: rostedt@goodmis.org, Arjan van de Ven <arjan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Tracing of power:power_start events doesn't work
References: <4BDECD66.2010906@tu-dresden.de> <1273019517.22438.10.camel@gandalf.stny.rr.com> <4BE11169.3010602@tu-dresden.de> <20100505172339.GC6320@nowhere>
In-Reply-To: <20100505172339.GC6320@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2010-05-05 19:23, Frederic Weisbecker wrote:
> On Wed, May 05, 2010 at 08:34:17AM +0200, Ronny Tschüter wrote:
>    
>> On Wed 2010-05-05 02:31, Steven Rostedt wrote:
>>      
>>> On Mon, 2010-05-03 at 15:19 +0200, Ronny Tschüter wrote:
>>>
>>>        
>>>> Hello,
>>>>
>>>> i use kernel version 2.6.33.2 (x86-64, Core 2 Duo) and the perf events
>>>> to track frequency and c states of my cpu. But if i want to trace
>>>> power:power_start events, it does not work. After typing
>>>>
>>>> echo "power:power_start" | sudo tee set_event
>>>>
>>>> on the console, the trace doesn't contain such events.
>>>> power:power_frequency and power:power_end events are reported correctly
>>>> by the system. I read in the mailing list that Robert Schoene had a
>>>> similiar problem, but with power:power_end events. Is there a known bug
>>>> regarding to trace_power_start methods in process.c?
>>>>
>>>>          
>>> Is this for perf or ftrace? I'm assuming you did this from the debugfs
>>> tracing directory. The set_event file is for ftrace not perf.
>>>
>>>        
>> It is for perf - i'm interested in event tracing. I used the event
>> tracing system like it is described in Documentation/trace/events.txt.
>> In addition i wrote a program which uses syscall(__NR_perf_counter_open,
>> ... ) to trace power events. But the result is the same -
>> power:power_end events are reported, power:power_start events not.
>>
>> Bye Ronny
>>      
>
> Hi, can you please compare the perf and ftrace output to
> see if ftrace works while perf doesn't for example?
>
> In perf:
> 	perf record -f -c 1 -a -e power:power_start
> 	^C
> 	perf report
>
> In ftrace:
> 	echo 1>  $DEBUGFS/tracing/events/power/power_start/enable
> 	cat $DEBUGFS/trace_pipe
>
> Thanks
Hi

IN PERF:

-> patched kernel (see my mail from yesterday)
perf record -f -c 1 -a -e power:power_start
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.500 MB perf.data (~21826 samples) ]
perf report
# Samples: 7880
#
# Overhead          Command      Shared Object  Symbol
# ........  ...............  .................  ......
#
     57.13%          swapper                  0  [k] 0000000000000000
     42.86%             init                  0  [k] 0000000000000000
      0.01%          swapper  [kernel]           [k] 0000000000000000
#
# (For a higher level overview, try: perf report --sort comm,dso)
#

-> unpatched kernel
perf record -f -c 1 -a -e power:power_start
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.263 MB perf.data (~11484 samples) ]
perf report
# Samples: 0
#
# Overhead          Command  Shared Object  Symbol
# ........  ...............  .............  ......
#
#
# (For a higher level overview, try: perf report --sort comm,dso)
#


IN FTRACE:
-> patched kernel
cat trace_pipe shows events like
<idle>-0     [001] 59067.030622: power_start: type=1 state=2
<idle>-0     [001] 59067.032514: power_start: type=1 state=2
<idle>-0     [000] 59067.032522: power_start: type=1 state=2
<idle>-0     [001] 59067.032561: power_start: type=1 state=2
<idle>-0     [000] 59067.037527: power_start: type=1 state=2
<idle>-0     [001] 59067.037528: power_start: type=1 state=2

-> unpatched kernel
cat trace returns no output

Bye
