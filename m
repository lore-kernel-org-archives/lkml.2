Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab2ADQre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:47:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab2ADQrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:47:31 -0500
Message-ID: <4F048295.1050907@redhat.com>
Date: Wed, 04 Jan 2012 11:47:17 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <20111230095147.GA10543@elte.hu> <878vlu4bgh.fsf@linux.vnet.ibm.com> <87pqf5mqg4.fsf@abhimanyu.in.ibm.com> <4F017AD2.3090504@redhat.com> <87mxa3zqm1.fsf@abhimanyu.in.ibm.com> <4F046536.5080207@redhat.com>
In-Reply-To: <4F046536.5080207@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2012 09:41 AM, Avi Kivity wrote:
> On 01/04/2012 12:52 PM, Nikunj A Dadhania wrote:
>> On Mon, 02 Jan 2012 11:37:22 +0200, Avi Kivity<avi@redhat.com>  wrote:
>>> On 12/31/2011 04:21 AM, Nikunj A Dadhania wrote:
>>>>
>>>>      GangV2:
>>>>      27.45%       ebizzy  libc-2.12.so            [.] __memcpy_ssse3_back
>>>>      12.12%       ebizzy  [kernel.kallsyms]       [k] clear_page
>>>>       9.22%       ebizzy  [kernel.kallsyms]       [k] __do_page_fault
>>>>       6.91%       ebizzy  [kernel.kallsyms]       [k] flush_tlb_others_ipi
>>>>       4.06%       ebizzy  [kernel.kallsyms]       [k] get_page_from_freelist
>>>>       4.04%       ebizzy  [kernel.kallsyms]       [k] ____pagevec_lru_add
>>>>
>>>>      GangBase:
>>>>      45.08%       ebizzy  [kernel.kallsyms]       [k] flush_tlb_others_ipi
>>>>      15.38%       ebizzy  libc-2.12.so            [.] __memcpy_ssse3_back
>>>>       7.00%       ebizzy  [kernel.kallsyms]       [k] clear_page
>>>>       4.88%       ebizzy  [kernel.kallsyms]       [k] __do_page_fault
>>>
>>> Looping in flush_tlb_others().  Rik, what trace an we run to find out
>>> why PLE directed yield isn't working as expected?
>>>
>> I tried some experiments by adding a pause_loop_exits stat in the
>> kvm_vpu_stat.
>
> (that's deprecated, we use tracepoints these days for stats)
>
>> Here are some observation related to Baseline-only(8vm case)
>>
>>                | ple_gap=128 | ple_gap=64 | ple_gap=256 | ple_window=2048
>> --------------+-------------+------------+-------------+----------------
>> EbzyRecords/s |    2247.50  |    2132.75 |    2086.25  |      1835.62
>> PauseExits    | 7928154.00  | 6696342.00 | 7365999.00  |  50319582.00
>>
>> With ple_window = 2048, PauseExits is more than 6times the default case
>
> So it looks like the default is optimal, at least wrt the cases you
> tested and your test workload.

It depends on the workload.

I believe ebizzy synchronously bounces messages around between
userland threads, and may benefit from lower latency preemption
and re-scheduling.

Workloads like AMQP do asynchronous messaging, and are likely
to benefit from having a lower number of switches.

I do not know which kind of workload is more prevalent.

Another worry with gang scheduling is scalability.  One of
the reasons Linux scales well to larger systems is that a
lot of things are done CPU local, without communicating
things with other CPUs.  Making the scheduling algorithm
system-global has the potential to add in a lot of overhead.

Likewise, removing the ability to migrate workloads to idle
CPUs is likely to hurt a lot of real world workloads.

Benchmarks don't care, because they run full-out. However,
users do not run benchmarks nearly as much as they run
actual workloads...

-- 
All rights reversed
