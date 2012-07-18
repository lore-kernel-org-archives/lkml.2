Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab2GRNjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:39:35 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:53823 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2GRNjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:39:32 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Srikar <srikar@linux.vnet.ibm.com>, S390 <linux-s390@vger.kernel.org>,
        Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Date: Wed, 18 Jul 2012 19:07:17 +0530
Message-Id: <20120718133717.5321.71347.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH RFC V5 0/3] kvm: Improving directed yield in PLE handler
x-cbid: 12071803-5140-0000-0000-000001C3FD60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently Pause Loop Exit (PLE) handler is doing directed yield to a
random vcpu on pl-exit. We already have filtering while choosing
the candidate to yield_to. This change adds more checks while choosing
a candidate to yield_to.

On a large vcpu guests, there is a high probability of
yielding to the same vcpu who had recently done a pause-loop exit. 
Such a yield can lead to the vcpu spinning again.

The patchset keeps track of the pause loop exit and gives chance to a
vcpu which has:

 (a) Not done pause loop exit at all (probably he is preempted lock-holder)

 (b) vcpu skipped in last iteration because it did pause loop exit, and
 probably has become eligible now (next eligible lock holder)

This concept also helps in cpu relax interception cases which use same handler.

Changes since V4:
 - Naming Change (Avi):
  struct ple ==> struct spin_loop
  cpu_relax_intercepted ==> in_spin_loop
  vcpu_check_and_update_eligible ==> vcpu_eligible_for_directed_yield
 - mark vcpu in spinloop as not eligible to avoid influence of previous exit

Changes since V3:
 - arch specific fix/changes (Christian)

Changes since v2:
 - Move ple structure to common code (Avi)
 - rename pause_loop_exited to cpu_relax_intercepted (Avi)
 - add config HAVE_KVM_CPU_RELAX_INTERCEPT (Avi)
 - Drop superfluous curly braces (Ingo)

Changes since v1:
 - Add more documentation for structure and algorithm and Rename
   plo ==> ple (Rik).
 - change dy_eligible initial value to false. (otherwise very first directed
    yield will not be skipped. (Nikunj)
 - fixup signoff/from issue

Future enhancements:
  (1) Currently we have a boolean to decide on eligibility of vcpu. It
    would be nice if I get feedback on guest (>32 vcpu) whether we can
    improve better with integer counter. (with counter = say f(log n )).
  
  (2) We have not considered system load during iteration of vcpu. With
   that information we can limit the scan and also decide whether schedule()
   is better. [ I am able to use #kicked vcpus to decide on this But may
   be there are better ideas like information from global loadavg.]

  (3) We can exploit this further with PV patches since it also knows about
   next eligible lock-holder.

Summary: There is a very good improvement for kvm based guest on PLE machine.
The V5 has huge improvement for kbench.

+-----------+-----------+-----------+------------+-----------+
   base_rik    stdev       patched      stdev       %improve
+-----------+-----------+-----------+------------+-----------+
              kernbench (time in sec lesser is better)
+-----------+-----------+-----------+------------+-----------+
 1x    49.2300     1.0171    22.6842     0.3073    117.0233 %
 2x    91.9358     1.7768    53.9608     1.0154    70.37516 %
+-----------+-----------+-----------+------------+-----------+

+-----------+-----------+-----------+------------+-----------+
              ebizzy (records/sec more is better)
+-----------+-----------+-----------+------------+-----------+
 1x  1129.2500    28.6793    2125.6250    32.8239    88.23334 %
 2x  1892.3750    75.1112    2377.1250   181.6822    25.61596 %
+-----------+-----------+-----------+------------+-----------+

Note: The patches are tested on x86.

 Links
  V4: https://lkml.org/lkml/2012/7/16/80
  V3: https://lkml.org/lkml/2012/7/12/437
  V2: https://lkml.org/lkml/2012/7/10/392
  V1: https://lkml.org/lkml/2012/7/9/32

 Raghavendra K T (3):
   config: Add config to support ple or cpu relax optimzation 
   kvm : Note down when cpu relax intercepted or pause loop exited 
   kvm : Choose a better candidate for directed yield 
---
 arch/s390/kvm/Kconfig    |    1 +
 arch/x86/kvm/Kconfig     |    1 +
 include/linux/kvm_host.h |   39 +++++++++++++++++++++++++++++++++++++++
 virt/kvm/Kconfig         |    3 +++
 virt/kvm/kvm_main.c      |   41 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 85 insertions(+), 0 deletions(-)

