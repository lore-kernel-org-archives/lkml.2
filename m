Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760427Ab2D0Q1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:27:10 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:54751 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757446Ab2D0Q1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:27:08 -0400
Subject: [RFC PATCH v1 4/5] KVM: get kvm_kick_vcpu out for pv_flush
To: peterz@infradead.org, mingo@elte.hu
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: jeremy@goop.org, mtosatti@redhat.com, kvm@vger.kernel.org, x86@kernel.org,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, avi@redhat.com,
        hpa@zytor.com
Date: Fri, 27 Apr 2012 21:56:36 +0530
Message-ID: <20120427162446.27082.8215.stgit@abhimanyu>
In-Reply-To: <20120427161727.27082.43096.stgit@abhimanyu>
References: <20120427161727.27082.43096.stgit@abhimanyu>
User-Agent: StGit/0.16-2-g0d85
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12042716-9574-0000-0000-000002643ECF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get kvm_kick_cpu out of CONFIG_PARAVIRT_SPINLOCK define

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
---
 arch/x86/kernel/kvm.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

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

