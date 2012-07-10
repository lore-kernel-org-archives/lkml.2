Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab2GJTdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 15:33:06 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:48681 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab2GJTdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 15:33:04 -0400
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
Date: Wed, 11 Jul 2012 01:00:57 +0530
Message-Id: <20120710193056.16440.40112.sendpatchset@codeblue>
Subject: [PATCH RFC V2 0/2] kvm: Improving directed yield in PLE handler
x-cbid: 12071009-5140-0000-0000-000001BA09B3
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

Changes since V1:
 - Add more documentation for structure and algorithm and Rename
   plo ==> ple (Rik).
 - change dy_eligible initial value to false. (otherwise very first directed
    yield will not be skipped. (Nikunj)
 - fixup signoff/from issue

Summary: There is a very good improvement for moderate / no overcommit scenario
 for kvm based guest on PLE machine (which is difficult ;) ).
 
       kernbench    sysbench    ebizzy
 1x    28 %          -0.04 %     105 %    
 2x    7 %            0.83 %      26 %

---
 Link for V1: (It also has result)
  https://lkml.org/lkml/2012/7/9/32

 Raghavendra K T (2):
   kvm vcpu: Note down pause loop exit
   kvm PLE handler: Choose better candidate for directed yield

 arch/s390/include/asm/kvm_host.h |    5 +++++
 arch/x86/include/asm/kvm_host.h  |   13 ++++++++++++-
 arch/x86/kvm/svm.c               |    1 +
 arch/x86/kvm/vmx.c               |    1 +
 arch/x86/kvm/x86.c               |   34 +++++++++++++++++++++++++++++++++-
 virt/kvm/kvm_main.c              |    3 +++
 6 files changed, 55 insertions(+), 2 deletions(-)

