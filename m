Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717Ab2GXSIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:08:47 -0400
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:42357 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab2GXSIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:08:43 -0400
Message-ID: <500EE486.6070905@genband.com>
Date: Tue, 24 Jul 2012 12:08:06 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Rik van Riel <riel@redhat.com>,
        Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: CFS vs. cpufreq/cstates vs. latency
References: <50057565.7030405@redhat.com> <500BD0DD.3000309@redhat.com>
In-Reply-To: <500BD0DD.3000309@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2012 18:08:08.0231 (UTC) FILETIME=[477BB370:01CD69C7]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19062.001
X-TM-AS-Result: No--9.152100-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 07/17/2012 05:23 PM, Rik van Riel wrote:
>> While tracking down a latency issue with communication between
>> KVM guests, we ran into a very interesting issue, an interplay
>> of CFS and power saving code.
>>
>> About 3/4 of the 230us latency came from CPUs waking up out of
>> C-states. Disabling C states reduced the latency to 60us...
>>
>> The issue? The communication is between various threads and
>> processes, each of which last ran on a CPU that is now in a
>> deeper C state. The total latency from that is "CPU wakeup
>> latency * NR CPUs woken".
>>
>> This problem could be common to many different multi-threaded
>> or multi-process applications. It looks like something that
>> would be fixable at the scheduler + cpufreq level.
>>
>> Specifically, waking up some process requires that the CPU
>> which is running the wakeup is already in C0 state. If the
>> CPU on which the to-be-woken task ran last is in a deep C
>> state, it may make sense to simply run the woken up task
>> on the local CPU, not the CPU where it was originally.
>>
>> I seem to remember some scheduling code that (for power
>> saving reasons) tried running all the tasks on one CPU,
>> until that CPU got busy, and then spilled over onto other
>> CPUs.
>>
>> I do not seem to be able to find that code in recent kernels,
>> but I have the feeling that a policy like that (related to
>> WAKE_AFFINE scheduling?) could improve this issue.
>>
>> As an additional benefit, it has the possibility of further
>> improving power saving.
>>
>> What do the scheduler and cpufreq people think about this
>> problem?
>>
>> Any preferred ways to solve the "N * cpu wakeup latency"
>> problem that is plaguing multi-process and multi-threaded
>> workloads?
> A few notes:
>
> - if you go into deep C-state, it may be worthwhile to migrate all the
> interrupts away from that cpu.  sysfs says C3 latency is 200 us on one
> of my machines, if we go there we should migrate anything important away.
>
> - I believe some of those C-states flush the cache, so executing on a
> cpu that is has awoken from one of these states will be slow for a
> while; needs to be taken into account.

On current Intel I think C3 flushes L1/L2 and when all cores on a socket 
are in C7 the last-level-cache is flushed.

Chris

