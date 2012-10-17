Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2JQCYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:24:31 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37890 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab2JQCY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:24:28 -0400
Subject: [PATCH RFC V2 2/5] Expand the steal time msr to also contain the
 consigned time.
To: linux-kernel@vger.kernel.org
From: Michael Wolf <mjw@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, peterz@infradead.org, mtosatti@redhat.com,
        glommer@parallels.com, mingo@redhat.com, avi@redhat.com,
        anthony@codemonkey.ws
Date: Tue, 16 Oct 2012 21:24:13 -0500
Message-ID: <20121017022412.16949.41306.stgit@lambeau>
In-Reply-To: <20121017022249.16949.2775.stgit@lambeau>
References: <20121017022249.16949.2775.stgit@lambeau>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12101702-7014-0000-0000-00000209C4FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a consigned field.  This field will hold the time lost due to capping or overcommit.
The rest of the time will still show up in the steal-time field.

Signed-off-by: Michael Wolf <mjw@linux.vnet.ibm.com>
---
 arch/x86/include/asm/paravirt.h |    4 ++--
 arch/x86/kernel/kvm.c           |    7 ++-----
 kernel/sched/cputime.c          |    2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index a0facf3..a5f9f30 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -196,9 +196,9 @@ struct static_key;
 extern struct static_key paravirt_steal_enabled;
 extern struct static_key paravirt_steal_rq_enabled;
 
-static inline u64 paravirt_steal_clock(int cpu)
+static inline u64 paravirt_steal_clock(int cpu, u64 *steal)
 {
-	return PVOP_CALL1(u64, pv_time_ops.steal_clock, cpu);
+	PVOP_VCALL2(pv_time_ops.steal_clock, cpu, steal);
 }
 
 static inline unsigned long long paravirt_read_pmc(int counter)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index c1d61ee..91b3b2a 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -368,9 +368,8 @@ static struct notifier_block kvm_pv_reboot_nb = {
 	.notifier_call = kvm_pv_reboot_notify,
 };
 
-static u64 kvm_steal_clock(int cpu)
+static u64 kvm_steal_clock(int cpu, u64 *steal)
 {
-	u64 steal;
 	struct kvm_steal_time *src;
 	int version;
 
@@ -378,11 +377,9 @@ static u64 kvm_steal_clock(int cpu)
 	do {
 		version = src->version;
 		rmb();
-		steal = src->steal;
+		*steal = src->steal;
 		rmb();
 	} while ((version & 1) || (version != src->version));
-
-	return steal;
 }
 
 void kvm_disable_steal_time(void)
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 81b763b..dd3fd46 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -275,7 +275,7 @@ static __always_inline bool steal_account_process_tick(void)
 	if (static_key_false(&paravirt_steal_enabled)) {
 		u64 steal, st = 0;
 
-		steal = paravirt_steal_clock(smp_processor_id());
+		paravirt_steal_clock(smp_processor_id(), &steal);
 		steal -= this_rq()->prev_steal_time;
 
 		st = steal_ticks(steal);

