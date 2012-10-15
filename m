Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2JOMOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:14:40 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:57243 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2JOMOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:14:36 -0400
Message-ID: <507BFD2C.3010808@linux.vnet.ibm.com>
Date: Mon, 15 Oct 2012 17:40:20 +0530
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
References: <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com> <20121003122209.GA9076@linux.vnet.ibm.com> <506C7057.6000102@redhat.com> <506D69AB.7020400@linux.vnet.ibm.com> <506D83EE.2020303@redhat.com> <1349356038.14388.3.camel@twins> <506DA48C.8050200@redhat.com>  <20121009185108.GA2549@linux.vnet.ibm.com> <1349837987.5551.182.camel@oc6622382223.ibm.com> <5075B63C.5030603@linux.vnet.ibm.com> <1349897783.22418.15.camel@oc2024037011.ibm.com>
In-Reply-To: <1349897783.22418.15.camel@oc2024037011.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12101512-0260-0000-0000-000001FC4AC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 01:06 AM, Andrew Theurer wrote:
> On Wed, 2012-10-10 at 23:24 +0530, Raghavendra K T wrote:
>> On 10/10/2012 08:29 AM, Andrew Theurer wrote:
>>> On Wed, 2012-10-10 at 00:21 +0530, Raghavendra K T wrote:
>>>> * Avi Kivity <avi@redhat.com> [2012-10-04 17:00:28]:
>>>>
>>>>> On 10/04/2012 03:07 PM, Peter Zijlstra wrote:
>>>>>> On Thu, 2012-10-04 at 14:41 +0200, Avi Kivity wrote:
>>>>>>>
[...]
>>> A big concern I have (if this is 1x overcommit) for ebizzy is that it
>>> has just terrible scalability to begin with.  I do not think we should
>>> try to optimize such a bad workload.
>>>
>>
>> I think my way of running dbench has some flaw, so I went to ebizzy.
>> Could you let me know how you generally run dbench?
>
> I mount a tmpfs and then specify that mount for dbench to run on.  This
> eliminates all IO.  I use a 300 second run time and number of threads is
> equal to number of vcpus.  All of the VMs of course need to have a
> synchronized start.
>
> I would also make sure you are using a recent kernel for dbench, where
> the dcache scalability is much improved.  Without any lock-holder
> preemption, the time in spin_lock should be very low:
>
>
>>      21.54%      78016         dbench  [kernel.kallsyms]   [k] copy_user_generic_unrolled
>>       3.51%      12723         dbench  libc-2.12.so        [.] __strchr_sse42
>>       2.81%      10176         dbench  dbench              [.] child_run
>>       2.54%       9203         dbench  [kernel.kallsyms]   [k] _raw_spin_lock
>>       2.33%       8423         dbench  dbench              [.] next_token
>>       2.02%       7335         dbench  [kernel.kallsyms]   [k] __d_lookup_rcu
>>       1.89%       6850         dbench  libc-2.12.so        [.] __strstr_sse42
>>       1.53%       5537         dbench  libc-2.12.so        [.] __memset_sse2
>>       1.47%       5337         dbench  [kernel.kallsyms]   [k] link_path_walk
>>       1.40%       5084         dbench  [kernel.kallsyms]   [k] kmem_cache_alloc
>>       1.38%       5009         dbench  libc-2.12.so        [.] memmove
>>       1.24%       4496         dbench  libc-2.12.so        [.] vfprintf
>>       1.15%       4169         dbench  [kernel.kallsyms]   [k] __audit_syscall_exit
>

Hi Andrew,
I ran the test with dbench with tmpfs. I do not see any improvements in
dbench for 16k ple window.

So it seems apart from ebizzy no workload benefited by that. and I
agree that, it may not be good to optimize for ebizzy.
I shall drop changing to 16k default window and continue with other
original patch series. Need to experiment with latest kernel.

(PS: Thanks for pointing towards, perf in latest kernel. It works fine.)

Results:
dbench run for 120 sec 30 sec warmup 8 iterations using tmpfs
base = 3.6.0-rc5 with ple handler optimization patch.

x => base + ple_window = 4k
+ => base + ple_window = 16k
* => base + ple_gap = 0

dbench 1x overcommit case
=========================
     N           Min           Max        Median           Avg        Stddev
x   8        5322.5       5519.05       5482.71     5461.0962     63.522276
+   8       5255.45       5530.55       5496.94     5455.2137     93.070363
*   8       5350.85       5477.81      5408.065     5418.4338     44.762697


dbench 2x overcommit case
==========================

     N           Min           Max        Median           Avg        Stddev
x   8       3054.32       3194.47       3137.33      3132.625     54.491615
+   8        3040.8       3148.87      3088.615     3088.1887     32.862336
*   8       3031.51       3171.99        3083.6     3097.4612     50.526977

