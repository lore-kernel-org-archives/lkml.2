Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1AGHrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 02:47:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58563 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab1AGHry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 02:47:54 -0500
Message-ID: <4D26C527.9090403@cn.fujitsu.com>
Date: Fri, 07 Jan 2011 15:47:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 2/3] KVM: send IPI to vcpu only when it's in guest mode
References: <4D26C4D4.30303@cn.fujitsu.com>
In-Reply-To: <4D26C4D4.30303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-07 15:47:30,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-07 15:47:31,
	Serialize complete at 2011-01-07 15:47:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can interrupt the vcpu only when it's running in guest mode
to reduce IPI

It looks like only ia64 and x86 need to send IPI to other vcpus, so
i only add the implementation of 'vcpu->guest_mode' in ia64, but i
don't know ia64 well, please point out the right way for me if the
implementation is incorrect

Also reorganize struct kvm_vcpu to make ->guest_mode and ->requests
in the same cache line explicitly.

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/ia64/kvm/kvm-ia64.c |    2 ++
 arch/x86/kvm/x86.c       |    6 +++++-
 include/linux/kvm_host.h |    9 +++++----
 virt/kvm/kvm_main.c      |    7 ++++++-
 4 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 70d224d..15c11b2 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -662,6 +662,7 @@ again:
 		goto vcpu_run_fail;
 
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	atomic_set(&vcpu->guest_mode, 1);
 	kvm_guest_enter();
 
 	/*
@@ -683,6 +684,7 @@ again:
 	 */
 	barrier();
 	kvm_guest_exit();
+	atomic_set(&vcpu->guest_mode, 0);
 	preempt_enable();
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0b77e9c..f882158 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5214,7 +5214,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	kvm_load_guest_xcr0(vcpu);
 
 	atomic_set(&vcpu->guest_mode, 1);
-	smp_wmb();
+
+	/* We should set ->guest_mode before check ->requests,
+	 * see the comment in make_all_cpus_request.
+	 */
+	smp_mb();
 
 	local_irq_disable();
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b5021db..5f5ef74 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -103,14 +103,15 @@ struct kvm_vcpu {
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	struct preempt_notifier preempt_notifier;
 #endif
+	int cpu;
 	int vcpu_id;
-	struct mutex mutex;
-	int   cpu;
+	int srcu_idx;
 	atomic_t guest_mode;
-	struct kvm_run *run;
 	unsigned long requests;
 	unsigned long guest_debug;
-	int srcu_idx;
+
+	struct mutex mutex;
+	struct kvm_run *run;
 
 	int fpu_active;
 	int guest_fpu_loaded, guest_xcr0_loaded;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b1b6cbb..a475264 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -153,7 +153,12 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
 		if (kvm_make_check_request(req, vcpu))
 			continue;
 		cpu = vcpu->cpu;
-		if (cpus != NULL && cpu != -1 && cpu != me)
+
+		/* Set ->requests bit before we read ->guest_mode */
+		smp_mb();
+
+		if (cpus != NULL && cpu != -1 && cpu != me &&
+		      atomic_read(&vcpu->guest_mode))
 			cpumask_set_cpu(cpu, cpus);
 	}
 	if (unlikely(cpus == NULL))
-- 
1.7.3.4

