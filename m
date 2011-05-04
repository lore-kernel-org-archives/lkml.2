Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1EDNbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:31:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab1EDNbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:31:07 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH 1/2] rcu: provide rcu_virt_note_context_switch() function.
Date: Wed,  4 May 2011 16:31:03 +0300
Message-Id: <1304515864-17105-2-git-send-email-gleb@redhat.com>
In-Reply-To: <1304515864-17105-1-git-send-email-gleb@redhat.com>
References: <1304515864-17105-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide rcu_virt_note_context_switch() for vitalization use to note
quiescent state during guest entry.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 include/linux/rcutiny.h |    8 ++++++++
 include/linux/rcutree.h |   10 ++++++++++
 kernel/rcutree.c        |    1 +
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 30ebd7c..52b3e02 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -100,6 +100,14 @@ static inline void rcu_note_context_switch(int cpu)
 }
 
 /*
+ * Take advantage of the fact that there is only one CPU, which
+ * allows us to ignore virtualization-based context switches.
+ */
+static inline void rcu_virt_note_context_switch(int cpu)
+{
+}
+
+/*
  * Return the number of grace periods.
  */
 static inline long rcu_batches_completed(void)
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 3a93348..b2a906e 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -35,6 +35,16 @@ extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu);
 extern void rcu_cpu_stall_reset(void);
 
+/*
+ * Note a virtualization-based context switch.  This is simply a
+ * wrapper around rcu_note_context_switch(), which allows TINY_RCU
+ * to save a few bytes.
+ */
+static inline void rcu_virt_note_context_switch(int cpu)
+{
+	rcu_note_context_switch(cpu);
+}
+
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 extern void exit_rcu(void);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index dd4aea8..0837d63 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -124,6 +124,7 @@ void rcu_note_context_switch(int cpu)
 	rcu_sched_qs(cpu);
 	rcu_preempt_note_context_switch(cpu);
 }
+EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
 #ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
-- 
1.7.4.4

