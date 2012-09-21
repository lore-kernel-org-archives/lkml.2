Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab2IUMEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:04:11 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:58333 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab2IUMDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:03:47 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Date: Fri, 21 Sep 2012 17:30:01 +0530
Message-Id: <20120921120000.27611.71321.sendpatchset@codeblue>
In-Reply-To: <20120921115942.27611.67488.sendpatchset@codeblue>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
Subject: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE handler
x-cbid: 12092112-0260-0000-0000-000001E160FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

When total number of VCPUs of system is less than or equal to physical CPUs,
PLE exits become costly since each VCPU can have dedicated PCPU, and
trying to find a target VCPU to yield_to just burns time in PLE handler.

This patch reduces overhead, by simply doing a return in such scenarios by
checking the length of current cpu runqueue.

Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 include/linux/sched.h |    1 +
 kernel/sched/core.c   |    6 ++++++
 virt/kvm/kvm_main.c   |    3 +++
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b8c8664..3645458 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -138,6 +138,7 @@ extern int nr_threads;
 DECLARE_PER_CPU(unsigned long, process_counts);
 extern int nr_processes(void);
 extern unsigned long nr_running(void);
+extern unsigned long rq_nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(int cpu);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fbf1fd0..2170b81 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4820,6 +4820,12 @@ void __sched yield(void)
 }
 EXPORT_SYMBOL(yield);
 
+unsigned long rq_nr_running(void)
+{
+	return this_rq()->nr_running;
+}
+EXPORT_SYMBOL(rq_nr_running);
+
 /**
  * yield_to - yield the current processor to another thread in
  * your thread group, or accelerate that thread toward the
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 28f00bc..8323685 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1629,6 +1629,9 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
 	int pass;
 	int i;
 
+	if (unlikely(rq_nr_running() == 1))
+		return;
+
 	kvm_vcpu_set_in_spin_loop(me, true);
 	/*
 	 * We boost the priority of a VCPU that is runnable but not

