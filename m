Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab1DVM7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 08:59:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19932 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1DVM7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 08:59:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=mdp9Nbz77E9MLPRPVYd9XmT6GJcV57ujcEETWq9Pv9GPquF2pU4HdlHllwnAHwfGwk
         2po0aMS+1NKlwXYsoPcQ==
MIME-Version: 1.0
Date: Fri, 22 Apr 2011 14:59:10 +0200
Message-ID: <BANLkTinNJERr_=ELO61UbrwCJjW1KAdK2A@mail.gmail.com>
Subject: perf_events: questions about cpu_has_ht_siblings() and offcore support
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: mingo@elte.hu, Peter Zijlstra <peterz@infradead.org>,
        Lin Ming <ming.m.lin@intel.com>, andi.kleen@intel.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lin,

In arch/x86/include/asm/smp.h, you added:

static inline bool cpu_has_ht_siblings(void)
{
       bool has_siblings = false;
#ifdef CONFIG_SMP
       has_siblings = cpu_has_ht && smp_num_siblings > 1;
#endif
       return has_siblings;
}

I am wondering about the goal of this function.

Is it supposed to return whether or not HT is enabled?

Ht enabled != HT supported

On my systems (NHM or SNB), its value does not change
when I enable/disable HT.

Looking at Intel's AP-485 (CPUID documentation), they
clearly say that none of the Leaf functions which report
about HT or the number of logical cores, can be used to
detect HT enabled or disabled. Seems those leaf functions
are the basis for smp_num_siblings. The trick in Table-5.5
for bit 28 with CPUID(1).EBX[23:16] used in detect_ht()
is about HT supported and not HT enabled.

HT supported means multi-core or multi-thread supported.

Going back to the perf_event code, I wonder what is the
point of using this function in intel_pmu_cpu_prepare(), then.

I suspect you wanted to know whether or not HT was enabled.
But that's not going to work. If you want that functionality, then
I tried:

+static inline int is_ht_enabled(void)
+{
+       bool has_ht = false;
+#ifdef CONFIG_SMP
+       int w;
+       w = cpumask_weight(cpu_sibling_mask(smp_processor_id()));
+       has_ht = cpu_has_ht && w > 1;
+#endif
+       return has_ht;
+}

But that cannot be used in the CPU hotplug callback for prepare(),
it is too early.

OTOH, you need some validation even in the case HT is off. No two events
scheduled together on the same PMU can have different values for the extra
reg. Thus, the fact that cpu_has_ht_siblings() is imune to HT state helps here,
but then what's the point of it?

I am preparing a patch that builds on your patch and improves
support for those events or features which require an extra
(shared) register. They are differences between NHM/WSM
and SNB.
