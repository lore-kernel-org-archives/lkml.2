Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab2GIGXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:23:00 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55071 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2GIGWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:22:47 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Date: Mon, 09 Jul 2012 11:50:13 +0530
Message-Id: <20120709062012.24030.37154.sendpatchset@codeblue>
Subject: [PATCH RFC 0/2] kvm: Improving directed yield in PLE handler
x-cbid: 12070820-5140-0000-0000-000001B77A6B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently Pause Looop Exit (PLE) handler is doing directed yield to a
random VCPU on PL exit. Though we already have filtering while choosing
the candidate to yield_to, we can do better.

Problem is, for large vcpu guests, we have more probability of yielding
to a bad vcpu. We are not able to prevent directed yield to same guy who
has done PL exit recently, who perhaps spins again and wastes CPU.

Fix that by keeping track of who has done PL exit. So The Algorithm in series
give chance to a VCPU which has:

 (a) Not done PLE exit at all (probably he is preempted lock-holder)

 (b) VCPU skipped in last iteration because it did PL exit, and probably
 has become eligible now (next eligible lock holder)

Future enhancemnets:
  (1) Currently we have a boolean to decide on eligibility of vcpu. It
    would be nice if I get feedback on guest (>32 vcpu) whether we can
    improve better with integer counter. (with counter = say f(log n )).
  
  (2) We have not considered system load during iteration of vcpu. With
   that information we can limit the scan and also decide whether schedule()
   is better. [ I am able to use #kicked vcpus to decide on this But may
   be there are better ideas like information from global loadavg.]

  (3) We can exploit this further with PV patches since it also knows about
   next eligible lock-holder.

Summary: There is a huge improvement for moderate / no overcommit scenario
 for kvm based guest on PLE machine (which is difficult ;) ).

Result:
Base : kernel 3.5.0-rc5 with Rik's Ple handler fix

Machine : Intel(R) Xeon(R) CPU X7560  @ 2.27GHz, 4 numa node, 256GB RAM,
          32 core machine

Host: enterprise linux  gcc version 4.4.6 20120305 (Red Hat 4.4.6-4) (GCC)
  with test kernels 

Guest: fedora 16 with 32 vcpus 8GB memory. 

Benchmarks:
1) kernbench: kernbench-0.5 (kernbench -f -H -M -o 2*vcpu)
Very first run in kernbench is omitted.

2) sysbench: 0.4.12
sysbench --test=oltp --db-driver=pgsql prepare
sysbench --num-threads=2*vcpu --max-requests=100000 --test=oltp --oltp-table-size=500000 --db-driver=pgsql --oltp-read-only run
Note that driver for this pgsql.

3) ebizzy: release 0.3
cmd: ebizzy -S 120 

              1) kernbench (time in sec lesser is better)
+-----------+-----------+-----------+------------+-----------+
   base_rik    stdev       patched      stdev       %improve
+-----------+-----------+-----------+------------+-----------+
1x  49.2300     1.0171	    38.3792     1.3659	   28.27261%
2x  91.9358     1.7768	    85.8842     1.6654      7.04623%
+-----------+-----------+-----------+------------+-----------+

              2) sysbench (time in sec lesser is better)
+-----------+-----------+-----------+------------+-----------+
   base_rik    stdev       patched      stdev       %improve
+-----------+-----------+-----------+------------+-----------+
1x  12.1623     0.0942	    12.1674     0.3126	  -0.04192%
2x  14.3069     0.8520	    14.1879     0.6811	   0.83874%
+-----------+-----------+-----------+------------+-----------+

Note that 1x scenario differs in only third decimal place and
degradation/improvemnet for sysbench will not be seen even with
higher confidence interval.


              3) ebizzy (records/sec more is better)
+-----------+-----------+-----------+------------+-----------+
   base_rik    stdev       patched      stdev       %improve
+-----------+-----------+-----------+------------+-----------+
1x  1129.2500  28.6793    2316.6250    53.0066     105.14722%
2x  1892.3750  75.1112    2386.5000   168.8033      26.11137%
+-----------+-----------+-----------+------------+-----------+

kernbench 1x: 4 fast runs = 12 runs avg
kernbench 2x: 4 fast runs = 12 runs avg

sysbench 1x: 8runs avg
sysbench 2x: 8runs avg

ebizzy 1x: 8runs avg
ebizzy 2x: 8runs avg

Thanks Vatsa and Srikar for brainstorming discussions regarding
optimizations.

 Raghavendra K T (2):
   kvm vcpu: Note down pause loop exit
   kvm PLE handler: Choose better candidate for directed yield

 arch/s390/include/asm/kvm_host.h |    5 +++++
 arch/x86/include/asm/kvm_host.h  |    9 ++++++++-
 arch/x86/kvm/svm.c               |    1 +
 arch/x86/kvm/vmx.c               |    1 +
 arch/x86/kvm/x86.c               |   18 +++++++++++++++++-
 virt/kvm/kvm_main.c              |    3 +++
 6 files changed, 35 insertions(+), 2 deletions(-)

