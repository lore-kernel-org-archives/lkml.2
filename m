Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab2GLTTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 15:19:47 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:51837 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843Ab2GLTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 15:19:44 -0400
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
Date: Fri, 13 Jul 2012 00:47:12 +0530
Message-Id: <20120712191712.30440.68944.sendpatchset@codeblue>
Subject: [PATCH RFC V3 0/3] kvm: Improving directed yield in PLE handler
x-cbid: 12071209-1396-0000-0000-0000018D0AF1
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

Summary: There is a very good improvement for moderate / no over-commit scenario
 for kvm based guest on PLE machine.

 Results: kernbench improves by around 30%, 6% for 1x,2x
          ebizzy improves by around 87%, 23% for 1x,2x

 Links 
  V1: https://lkml.org/lkml/2012/7/9/32

  V2: https://lkml.org/lkml/2012/7/10/392

 Raghavendra K T (3):
   config: Add config to support ple or cpu relax optimzation 
   kvm : Note down when cpu relax intercepted or pause loop exited 
   kvm : Choose a better candidate for directed yield 
---
 arch/s390/kvm/Kconfig    |    1 +
 arch/x86/kvm/Kconfig     |    1 +
 include/linux/kvm_host.h |   12 ++++++++++++
 virt/kvm/Kconfig         |    3 +++
 virt/kvm/kvm_main.c      |   38 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 55 insertions(+), 0 deletions(-)

