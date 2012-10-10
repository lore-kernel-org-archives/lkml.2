Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab2JJR6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:58:21 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:40998 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab2JJR6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:58:18 -0400
Message-ID: <5075B63C.5030603@linux.vnet.ibm.com>
Date: Wed, 10 Oct 2012 23:24:04 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: habanero@linux.vnet.ibm.com
CC: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
References: <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com> <20121003122209.GA9076@linux.vnet.ibm.com> <506C7057.6000102@redhat.com> <506D69AB.7020400@linux.vnet.ibm.com> <506D83EE.2020303@redhat.com> <1349356038.14388.3.camel@twins> <506DA48C.8050200@redhat.com>  <20121009185108.GA2549@linux.vnet.ibm.com> <1349837987.5551.182.camel@oc6622382223.ibm.com>
In-Reply-To: <1349837987.5551.182.camel@oc6622382223.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12101017-1618-0000-0000-0000029F4FAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 08:29 AM, Andrew Theurer wrote:
> On Wed, 2012-10-10 at 00:21 +0530, Raghavendra K T wrote:
>> * Avi Kivity <avi@redhat.com> [2012-10-04 17:00:28]:
>>
>>> On 10/04/2012 03:07 PM, Peter Zijlstra wrote:
>>>> On Thu, 2012-10-04 at 14:41 +0200, Avi Kivity wrote:
>>>>>
>>>>> Again the numbers are ridiculously high for arch_local_irq_restore.
>>>>> Maybe there's a bad perf/kvm interaction when we're injecting an
>>>>> interrupt, I can't believe we're spending 84% of the time running the
>>>>> popf instruction.
>>>>
>>>> Smells like a software fallback that doesn't do NMI, hrtimer based
>>>> sampling typically hits popf where we re-enable interrupts.
>>>
>>> Good nose, that's probably it.  Raghavendra, can you ensure that the PMU
>>> is properly exposed?  'dmesg' in the guest will tell.  If it isn't, -cpu
>>> host will expose it (and a good idea anyway to get best performance).
>>>
>>
>> Hi Avi, you are right. SandyBridge machine result was not proper.
>> I cleaned up the services, enabled PMU, re-ran all the test again.
>>
>> Here is the summary:
>> We do get good benefit by increasing ple window. Though we don't
>> see good benefit for kernbench and sysbench, for ebizzy, we get huge
>> improvement for 1x scenario. (almost 2/3rd of ple disabled case).
>>
>> Let me know if you think we can increase the default ple_window
>> itself to 16k.
>>
>> I am experimenting with V2 version of undercommit improvement(this) patch
>> series, But I think if you wish  to go for increase of
>> default ple_window, then we would have to measure the benefit of patches
>> when ple_window = 16k.
>>
>> I can respin the whole series including this default ple_window change.
>>
>> I also have the perf kvm top result for both ebizzy and kernbench.
>> I think they are in expected lines now.
>>
>> Improvements
>> ================
>>
>> 16 core PLE machine with 16 vcpu guest
>>
>> base = 3.6.0-rc5 + ple handler optimization patches
>> base_pleopt_16k = base + ple_window = 16k
>> base_pleopt_32k = base + ple_window = 32k
>> base_pleopt_nople = base + ple_gap = 0
>> kernbench, hackbench, sysbench (time in sec lower is better)
>> ebizzy (rec/sec higher is better)
>>
>> % improvements w.r.t base (ple_window = 4k)
>> ---------------+---------------+-----------------+-------------------+
>>                 |base_pleopt_16k| base_pleopt_32k | base_pleopt_nople |
>> ---------------+---------------+-----------------+-------------------+
>> kernbench_1x   |  0.42371      |  1.15164        |   0.09320         |
>> kernbench_2x   | -1.40981      | -17.48282       |  -570.77053       |
>> ---------------+---------------+-----------------+-------------------+
>> sysbench_1x    | -0.92367      | 0.24241         | -0.27027          |
>> sysbench_2x    | -2.22706      |-0.30896         | -1.27573          |
>> sysbench_3x    | -0.75509      | 0.09444         | -2.97756          |
>> ---------------+---------------+-----------------+-------------------+
>> ebizzy_1x      | 54.99976      | 67.29460        |  74.14076         |
>> ebizzy_2x      | -8.83386      |-27.38403        | -96.22066         |
>> ---------------+---------------+-----------------+-------------------+
>>
>> perf kvm top observation for kernbench and ebizzy (nople, 4k, 32k window)
>> ========================================================================
>
> Is the perf data for 1x overcommit?

Yes, 16vcpu guest on 16 core

>
>> pleopt   ple_gap=0
>> --------------------
>> ebizzy : 18131 records/s
>> 63.78%  [guest.kernel]  [g] _raw_spin_lock_irqsave
>>      5.65%  [guest.kernel]  [g] smp_call_function_many
>>      3.12%  [guest.kernel]  [g] clear_page
>>      3.02%  [guest.kernel]  [g] down_read_trylock
>>      1.85%  [guest.kernel]  [g] async_page_fault
>>      1.81%  [guest.kernel]  [g] up_read
>>      1.76%  [guest.kernel]  [g] native_apic_mem_write
>>      1.70%  [guest.kernel]  [g] find_vma
>
> Does 'perf kvm top' not give host samples at the same time?  Would be
> nice to see the host overhead as a function of varying ple window.  I
> would expect that to be the major difference between 4/16/32k window
> sizes.

No, I did something like this
perf kvm  --guestvmlinux ./vmlinux.guest top -g  -U -d 3. Yes that is a
good idea.

(I am getting some segfaults with perf top, I think it is already fixed
but yet to see the patch that fixes)



>
> A big concern I have (if this is 1x overcommit) for ebizzy is that it
> has just terrible scalability to begin with.  I do not think we should
> try to optimize such a bad workload.
>

I think my way of running dbench has some flaw, so I went to ebizzy.
Could you let me know how you generally run dbench?

