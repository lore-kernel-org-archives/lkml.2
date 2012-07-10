Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab2GJJ2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:28:15 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:52129 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab2GJJ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:28:12 -0400
Message-ID: <4FFBF534.5040107@linux.vnet.ibm.com>
Date: Tue, 10 Jul 2012 14:56:12 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving directed yield in PLE handler
References: <20120709062012.24030.37154.sendpatchset@codeblue> <1341870457.2909.27.camel@oc2024037011.ibm.com>
In-Reply-To: <1341870457.2909.27.camel@oc2024037011.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071000-3568-0000-0000-0000021CA783
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 03:17 AM, Andrew Theurer wrote:
 > On Mon, 2012-07-09 at 11:50 +0530, Raghavendra K T wrote:
 >> Currently Pause Looop Exit (PLE) handler is doing directed yield to a
 >> random VCPU on PL exit. Though we already have filtering while choosing
 >> the candidate to yield_to, we can do better.
 >
 > Hi, Raghu.
Hi Andrew,
Thank you for your analysis and inputs

 >
 >> Problem is, for large vcpu guests, we have more probability of yielding
 >> to a bad vcpu. We are not able to prevent directed yield to same guy who
 >> has done PL exit recently, who perhaps spins again and wastes CPU.
 >>
 >> Fix that by keeping track of who has done PL exit. So The Algorithm 
in series
 >> give chance to a VCPU which has:
 >>
 >>   (a) Not done PLE exit at all (probably he is preempted lock-holder)
 >>
 >>   (b) VCPU skipped in last iteration because it did PL exit, and 
probably
 >>   has become eligible now (next eligible lock holder)
 >>
 >> Future enhancemnets:
 >>    (1) Currently we have a boolean to decide on eligibility of vcpu. It
 >>      would be nice if I get feedback on guest (>32 vcpu) whether we can
 >>      improve better with integer counter. (with counter = say f(log 
n )).
 >>
 >>    (2) We have not considered system load during iteration of vcpu. With
 >>     that information we can limit the scan and also decide whether 
schedule()
 >>     is better. [ I am able to use #kicked vcpus to decide on this 
But may
 >>     be there are better ideas like information from global loadavg.]
 >>
 >>    (3) We can exploit this further with PV patches since it also 
knows about
 >>     next eligible lock-holder.
 >>
 >> Summary: There is a huge improvement for moderate / no overcommit 
scenario
 >>   for kvm based guest on PLE machine (which is difficult ;) ).
 >>
 >> Result:
 >> Base : kernel 3.5.0-rc5 with Rik's Ple handler fix
 >>
 >> Machine : Intel(R) Xeon(R) CPU X7560  @ 2.27GHz, 4 numa node, 256GB RAM,
 >>            32 core machine
 >
 > Is this with HT enabled, therefore 64 CPU threads?

No. HT disabled with 32 online CPUs

 >
 >> Host: enterprise linux  gcc version 4.4.6 20120305 (Red Hat 4.4.6-4) 
(GCC)
 >>    with test kernels
 >>
 >> Guest: fedora 16 with 32 vcpus 8GB memory.
 >
 > Can you briefly explain the 1x and 2x configs?  This of course is highly
 > dependent whether or not HT is enabled...

1x config:  kernbench/ebizzy/sysbench running on 1 guest (32 vcpu)
  all the benchmarks have 2*#vcpu = 64 threads

2x config:  kernbench/ebizzy/sysbench running on 2 guests each with  32
vcpu)
  all the benchmarks have 2*#vcpu = 64 threads

 >
 > FWIW, I started testing what I would call "0.5x", where I have one 40
 > vcpu guest running on a host with 40 cores and 80 CPU threads total (HT
 > enabled, no extra load on the system).  For ebizzy, the results are
 > quite erratic from run to run, so I am inclined to discard it as a

I will be posting full run detail (individual run) in reply to this
mail since it is big. I have posted stdev also with the result.. it has
not shown too much deviation.

 > workload, but maybe I should try "1x" and "2x" cpu over-commit as well.
 >
 >> From initial observations, at least for the ebizzy workload, the
 > percentage of exits that result in a yield_to() are very low, around 1%,
 > before these patches.

Hmm Ok..
IMO for a under-committed workload, probably low percentage of yield_to
was expected, but not sure whether 1% is too less though.
But importantly,  number of successful yield_to can never measure
benefit.

With this patch what I am trying to address is to ensure successful
yield_to result in benefit.

So, I am concerned that at least for this test,
 > reducing that number even more has diminishing returns.  I am however
 > still concerned about the scalability problem with yield_to(),

So did you mean you are expected to see more yield_to overheads with 
large guests?
As already mentioned in future enhancements, one thing I will be trying 
in future would be,

a. have counter instead of boolean for skipping yield_to
b. just scan probably f(log(n)) vcpu to yield and then schedule()/ 
return depending on system load.

so we will be reducing overall vcpu iteration in PLE handler from
O(n * n) to O(n log n)

which
 > shows like this for me (perf):
 >
 >> 63.56%     282095         qemu-kvm  [kernel.kallsyms]        [k] 
_raw_spin_lock
 >> 5.42%      24420         qemu-kvm  [kvm]                    [k] 
kvm_vcpu_yield_to
 >> 5.33%      26481         qemu-kvm  [kernel.kallsyms]        [k] 
get_pid_task
 >> 4.35%      20049         qemu-kvm  [kernel.kallsyms]        [k] yield_to
 >> 2.74%      15652         qemu-kvm  [kvm]                    [k] 
kvm_apic_present
 >> 1.70%       8657         qemu-kvm  [kvm]                    [k] 
kvm_vcpu_on_spin
 >> 1.45%       7889         qemu-kvm  [kvm]                    [k] 
vcpu_enter_guest
 >
 > For the cpu threads in the host that are actually active (in this case
 > 1/2 of them), ~50% of their time is in kernel and ~43% in guest.This
 > is for a no-IO workload, so that's just incredible to see so much cpu
 > wasted.  I feel that 2 important areas to tackle are a more scalable
 > yield_to() and reducing the number of pause exits itself (hopefully by
 > just tuning ple_window for the latter).

I think this is a concern and as you stated I agree that tuning
ple_window helps here.

 >
 > Honestly, I not confident addressing this problem will improve the
 > ebizzy score. That workload is so erratic for me, that I do not trust
 > the results at all.  I have however seen consistent improvements in
 > disabling PLE for a http guest workload and a very high IOPS guest
 > workload, both with much time spent in host in the double runqueue lock
 > for yield_to(), so that's why I still gravitate toward that issue.

The problem starts (in PLE disabled) when we have workload just > 1x.We 
start burning so much of cpu.

IIRC, in 2x overcommit, kernel compilation that takes 10hr on non-PLE,
used to take just 1hr after pv patches (and should be same with PLE enabled)

If we leave PLE disabled case, I do not expect any degradation even in 
0.5 x scenario, though you say results are erratic.

Could you please let me know, When PLE was enabled,
before and after the patch did you see any degradation for 0.5x?

 > -Andrew Theurer
 >
 >

