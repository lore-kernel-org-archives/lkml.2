Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab2FDFIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:08:30 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:49240 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab2FDFI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:08:27 -0400
Subject: [PATCH v2 4/7] KVM: export kvm_kick_vcpu for pv_flush
To: peterz@infradead.org, mingo@elte.hu, mtosatti@redhat.com, avi@redhat.com
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Date: Mon, 04 Jun 2012 10:37:50 +0530
Message-ID: <20120604050730.4560.98650.stgit@abhimanyu.in.ibm.com>
In-Reply-To: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060405-3864-0000-0000-0000032C20FB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_para.h |    4 ++++
 arch/x86/kernel/kvm.c           |   18 +++++++++---------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 684a285..651a305 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -206,6 +206,7 @@ void kvm_async_pf_task_wait(u32 token);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
 extern void kvm_disable_steal_time(void);
+void kvm_kick_cpu(int cpu);
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 void __init kvm_spinlock_init(void);
@@ -229,6 +230,9 @@ static inline void kvm_disable_steal_time(void)
 {
 	return;
 }
+
+#define kvm_kick_cpu(T) do {} while (0)
+
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 66db54e..5943285 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -487,6 +487,15 @@ static __init int activate_jump_labels(void)
 }
 arch_initcall(activate_jump_labels);
 
+/* Kick a cpu */
+void kvm_kick_cpu(int cpu)
+{
+	int apicid;
+
+	apicid = per_cpu(x86_cpu_to_apicid, cpu);
+	kvm_hypercall1(KVM_HC_KICK_CPU, apicid);
+}
+
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 
 enum kvm_contention_stat {
@@ -695,15 +704,6 @@ out:
 }
 PV_CALLEE_SAVE_REGS_THUNK(kvm_lock_spinning);
 
-/* Kick a cpu by its apicid*/
-static inline void kvm_kick_cpu(int cpu)
-{
-	int apicid;
-
-	apicid = per_cpu(x86_cpu_to_apicid, cpu);
-	kvm_hypercall1(KVM_HC_KICK_CPU, apicid);
-}
-
 /* Kick vcpu waiting on @lock->head to reach value @ticket */
 static void kvm_unlock_kick(struct arch_spinlock *lock, __ticket_t ticket)
 {

