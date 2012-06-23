Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab2FWSgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 14:36:19 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:51365 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab2FWSgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 14:36:18 -0400
Message-ID: <4FE60C41.5020907@linux.vnet.ibm.com>
Date: Sun, 24 Jun 2012 00:04:41 +0530
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
References: <20120619202047.26191.40429.sendpatchset@codeblue> <20120619165104.2a4574f8@annuminas.surriel.com> <4FE22E9E.7070206@linux.vnet.ibm.com> <4FE304D0.5000202@linux.vnet.ibm.com> <20120622151149.GA9077@turtle.usersys.redhat.com> <4FE4DCEA.1050701@linux.vnet.ibm.com>
In-Reply-To: <4FE4DCEA.1050701@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12062318-3864-0000-0000-0000037694AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2012 02:30 AM, Raghavendra K T wrote:
> On 06/22/2012 08:41 PM, Andrew Jones wrote:
>> On Thu, Jun 21, 2012 at 04:56:08PM +0530, Raghavendra K T wrote:
>>> Here are the results from kernbench.
>>>
>>> PS: I think we have to only take that, both the patches perform better,
>>> than reading into actual numbers since I am seeing more variance in
>>> especially 3x. may be I can test with some more stable benchmark if
>>> somebody points
>>>
[...]
> can we agree like, for kernbench 1x= -j (2*#vcpu) in 1 vm.
> 1.5x = -j (2*#vcpu) in 1 vm and -j (#vcpu) in other.. and so on.
> also a SPIN_THRESHOLD of 4k?

Please forget about 1.5x above. I am not too sure on that.

>
> Any ideas on benchmarks is welcome from all.
>

My run for other benchmarks did not have Rik's patches, so re-spinning
everything with that now.

Here is the detailed info on env and benchmark I am currently trying. 
Let me know if you have any comments

=======
kernel 3.5.0-rc1 with Rik's Ple handler fix  as base

Machine : Intel(R) Xeon(R) CPU X7560  @ 2.27GHz, 4 numa node, 256GB RAM, 
32 core machine

Host: enterprise linux  gcc version 4.4.6 20120305 (Red Hat 4.4.6-4) 
(GCC) with test kernels
Guest: fedora 16 with different built-in kernel from same source tree.
32 vcpus 8GB memory. (configs not changed with patches except for
CONFIG_PARAVIRT_SPINLOCK)

Note: for Pv patches, SPIN_THRESHOLD is set to 4k

Benchmarks:
1) kernbench: kernbench-0.50

cmd:
echo "3" > /proc/sys/vm/drop_caches
ccache -C
kernbench -f -H -M -o 2*vcpu

Very first run in kernbench is omitted.

2) dbench: dbench version 4.00
cmd: dbench --warmup=30 -t 120 2*vcpu

3) hackbench:
https://build.opensuse.org/package/files?package=hackbench&project=benchmark
hackbench.c modified with loops=10000
used hackbench with num-threads = 2* vcpu

4) Specjbb: specjbb2000-1.02
Input Properties:
   ramp_up_seconds = 30
   measurement_seconds = 120
   forcegc = true
   starting_number_warehouses = 1
   increment_number_warehouses = 1
   ending_number_warehouses = 8


5) sysbench: 0.4.12
sysbench --test=oltp --db-driver=pgsql prepare
sysbench --num-threads=2*vcpu --max-requests=100000 --test=oltp 
--oltp-table-size=500000 --db-driver=pgsql --oltp-read-only run
Note that driver for this pgsql.


6) ebizzy: release 0.3
cmd: ebizzy -S 120

- specjbb ran for 1x and 2x others mostly for 1x, 2x, 3x overcommit.
- overcommit of 2x means same benchmark running on 2 guests.
- sample for each overcommit is mostly 8

Note: I ran kernbench with old kernbench0.50, may be I can try kcbench
with ramfs if necessary

will soon come with detailed results
> - Raghu

