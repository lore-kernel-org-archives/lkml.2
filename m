Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762705Ab2FVVCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:02:43 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:52789 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab2FVVCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:02:41 -0400
Message-ID: <4FE4DCEA.1050701@linux.vnet.ibm.com>
Date: Sat, 23 Jun 2012 02:30:26 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        chegu_vinod@hp.com, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] kvm: handle last_boosted_vcpu = 0 case
References: <20120619202047.26191.40429.sendpatchset@codeblue> <20120619165104.2a4574f8@annuminas.surriel.com> <4FE22E9E.7070206@linux.vnet.ibm.com> <4FE304D0.5000202@linux.vnet.ibm.com> <20120622151149.GA9077@turtle.usersys.redhat.com>
In-Reply-To: <20120622151149.GA9077@turtle.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12062221-5816-0000-0000-00000345491E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2012 08:41 PM, Andrew Jones wrote:
> On Thu, Jun 21, 2012 at 04:56:08PM +0530, Raghavendra K T wrote:
>> Here are the results from kernbench.
>>
>> PS: I think we have to only take that, both the patches perform better,
>> than reading into actual numbers since I am seeing more variance in
>> especially 3x. may be I can test with some more stable benchmark if
>> somebody points
>>
>
> Hi Raghu,
>

First of all Thank you for your test and raising valid points.
It also made the avenue for discussion of all the different experiments
  done over a month (apart from tuning/benchmarking), which may bring
more feedback and precious ideas from community to optimize the 
performance further.

I shall discuss in reply to this mail separately.

> I wonder if we should back up and try to determine the best
> benchmark/test environment first.

I agree, we have to be able to produce similar result independently.
So far sysbench (even pgbench) has been consistent, Currently trying,
if other  benchmarks like hackbench (modified #loops), ebizzy/dbench
have low variance.

[ but they too are dependent on #client/threads etc ]

I think kernbench is good, but

Yes kernbench atleast helped me to tune SPIN_THRESHOLD to good extent.
But Jeremy also had pointed out that kernbench is little inconsistent.

> I wonder about how to simulate the overcommit, and to what degree
> (1x, 3x, ??). What are you currently running to simulate overcommit
> now? Originally we were running kernbench in one VM and cpu hogs
> (bash infinite loops) in other VMs. Then we added vcpus and infinite
> loops to get up to the desired overcommit. I saw later that you've
> experimented with running kernbench in the other VMs as well, rather
> than cpu hogs. Is that still the case?
>

Yes, I am now running same benchmark on all the guest.

on non PLE, while 1 cpuhogs, played good role of simulating LHP, but on
PLE machine It did not seem to be the case.

> I started playing with benchmarking these proposals myself, but so
> far have stuck to the cpu hog, since I wanted to keep variability
> limited.  However, when targeting a reasonable host loadavg with a
> bunch of cpu hog vcpus, it limits the overcommit too much. I certainly
> haven't tried 3x this way. So I'm inclined to throw out the cpu hog
> approach as well. The question is, what to replace it with? It appears
> that the performance of the PLE and pvticketlock proposals are quite
> dependant on the level of overcommit, so we should choose a target
> overcommit level and also a constraint on the host loadavg first,
> then determine how to setup a test environment that fits it and yields
> results with low variance.
>
> Here are results from my 1.125x overcommit test environment using
> cpu hogs.

At first, result seemed backward, but after seeing individual runs and 
variations, it seems, except for rand start I believe all the result 
should converge to zero difference. So if we run the same again we may 
get completely different result.

IMO, on a 64 vcpu guest if we run -j16 it may not represent 1x load, so
what I believe is it has resulted in more of under-commit/nearly 1x
commit result. May be we should try atleast #threads = #vcpu or 2*#vcpu

>
> kcbench (a.k.a kernbench) results; 'mean-time (stddev)'
>    base-noPLE:           235.730 (25.932)
>    base-PLE:             238.820 (11.199)
>    rand_start-PLE:       283.193 (23.262)

Problem currently as we know, in PLE handler  we may end up choosing
same VCPU, which was in spinloop, that would unfortunately result in
more cpu burning.

And with randomizing start_vcpu, we are making that probability more.
we need to have a logic, not choose a vcpu that has recently PL exited 
since it cannot be a lock-holder. and next eligible lock-holder can be
picked up easily with PV patches.

>    pvticketlocks-noPLE:  244.987 (7.562)
>    pvticketlocks-PLE:    247.597 (17.200)
>
> base kernel:          3.5.0-rc3 + Rik's new last_boosted patch
> rand_start kernel:    3.5.0-rc3 + Raghu's proposed random start patch
> pvticketlocks kernel: 3.5.0-rc3 + Rik's new last_boosted patch
>                                  + Raghu's pvticketlock series

Ok, I believe SPIN_THRESHOLD was 2k right? what I had observed is with 
2k THRESHOLD, we see halt exit overheads. currently I am trying with
mostly 4k.

>
> The relative standard deviations are as high as 11%. So I'm not
> real pleased with the results, and they show degradation everywhere.
> Below are the details of the benchmarking. Everything is there except
> the kernel config, but our benchmarking should be reproducible with
> nearly random configs anyway.
>
> Drew
>
> = host =
>    - Intel(R) Xeon(R) CPU X7560 @ 2.27GHz
>    - 64 cpus, 4 nodes, 64G mem
>    - Fedora 17 with test kernels (see tests)
>
> = benchmark =
>    - one cpu hog F17 VM
>      - 64 vcpus, 8G mem
>      - all vcpus run a bash infinite loop
>      - kernel: 3.5.0-rc3
>    - one kcbench (a.k.a kernbench) F17 VM
>      - 8 vcpus, 8G mem
>      - 'kcbench -d /mnt/ram', /mnt/ram is 1G ramfs

may be we have to check whether 1GB RAM is ok when we have 128 threads,
not sure..

>      - kcbench-0.3-8.1.noarch, kcbench-data-2.6.38-0.1-9.fc17.noarch,
>        kcbench-data-0.1-9.fc17.noarch
>      - gcc (GCC) 4.7.0 20120507 (Red Hat 4.7.0-5)
>      - kernel: same test kernel as host
>
> = test 1: base, PLE disabled (ple_gap=0) =
>    - kernel: 3.5.0-rc3 + Rik's last_boosted patch
>
> Run 1 (-j 16):      4211 (e:237.43 P:637% U:697.98 S:815.46 F:0)
> Run 2 (-j 16):      3834 (e:260.77 P:631% U:729.69 S:917.56 F:0)
> Run 3 (-j 16):      4784 (e:208.99 P:644% U:638.17 S:708.63 F:0)
>
> mean: 235.730 stddev: 25.932
>
> = test 2: base, PLE enabled =
>    - kernel: 3.5.0-rc3 + Rik's last_boosted patch
>
> Run 1 (-j 16):      4335 (e:230.67 P:639% U:657.74 S:818.28 F:0)
> Run 2 (-j 16):      4269 (e:234.20 P:647% U:743.43 S:772.52 F:0)
> Run 3 (-j 16):      3974 (e:251.59 P:639% U:724.29 S:884.21 F:0)
>
> mean: 238.820 stddev: 11.199
>
> = test 3: rand_start, PLE enabled =
>    - kernel: 3.5.0-rc3 + Raghu's random start patch
>
> Run 1 (-j 16):      3898 (e:256.52 P:639% U:756.14 S:884.63 F:0)
> Run 2 (-j 16):      3341 (e:299.27 P:633% U:857.49 S:1039.62 F:0)
> Run 3 (-j 16):      3403 (e:293.79 P:635% U:857.21 S:1008.83 F:0)
>
> mean: 283.193 stddev: 23.262
>
> = test 4: pvticketlocks, PLE disabled (ple_gap=0) =
>    - kernel: 3.5.0-rc3 + Rik's last_boosted patch + Raghu's pvticketlock series
>                        + PARAVIRT_SPINLOCKS=y config change
>
> Run 1 (-j 16):      3963 (e:252.29 P:647% U:736.43 S:897.16 F:0)
> Run 2 (-j 16):      4216 (e:237.19 P:650% U:706.68 S:837.42 F:0)
> Run 3 (-j 16):      4073 (e:245.48 P:649% U:709.46 S:884.68 F:0)
>
> mean: 244.987 stddev: 7.562
>
> = test 5: pvticketlocks, PLE enabled =
>    - kernel: 3.5.0-rc3 + Rik's last_boosted patch + Raghu's pvticketlock series
>                        + PARAVIRT_SPINLOCKS=y config change
>
> Run 1 (-j 16):      3978 (e:251.32 P:629% U:758.86 S:824.29 F:0)
> Run 2 (-j 16):      4369 (e:228.84 P:634% U:708.32 S:743.71 F:0)
> Run 3 (-j 16):      3807 (e:262.63 P:626% U:767.03 S:877.96 F:0)
>
> mean: 247.597 stddev: 17.200
>
>

Ok in summary,
can we agree like, for kernbench 1x= -j (2*#vcpu) in 1 vm.
1.5x = -j (2*#vcpu) in 1 vm and -j (#vcpu) in other.. and so on.
also a SPIN_THRESHOLD of 4k?

Any ideas on benchmarks is welcome from all.

- Raghu

