Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2AMAgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 19:36:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:53986 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab2AMAgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 19:36:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="55987999"
From: Huang Ying <ying.huang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, ying.huang@intel.com,
        Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC 1/2] urn, make user return notifier lockless
Date: Fri, 13 Jan 2012 08:36:40 +0800
Message-Id: <1326415001-2145-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1326415001-2145-1-git-send-email-ying.huang@intel.com>
References: <1326415001-2145-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible to use user return notifier in hardware error
handler, which usually has NMI like semantics such as machine check
exception handler.

The implementation is based on that of irq_work.

Because one mandatory initializer interface is added, to make patchset
bisectable, the changes to the only current user: kvm, is included in
this patch too.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kvm/x86.c                   |    7 ++--
 include/linux/user-return-notifier.h |   15 +++++++--
 kernel/user-return-notifier.c        |   53 ++++++++++++++++++++++++++++-------
 3 files changed, 59 insertions(+), 16 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -178,7 +178,6 @@ static void kvm_on_user_return(struct us
 		}
 	}
 	locals->registered = false;
-	user_return_notifier_unregister(urn);
 }
 
 static void shared_msr_update(unsigned slot, u32 msr)
@@ -225,7 +224,7 @@ void kvm_set_shared_msr(unsigned slot, u
 	smsr->values[slot].curr = value;
 	wrmsrl(shared_msrs_global.msrs[slot], value);
 	if (!smsr->registered) {
-		smsr->urn.on_user_return = kvm_on_user_return;
+		init_user_return_notifier(&smsr->urn, kvm_on_user_return);
 		user_return_notifier_register(&smsr->urn);
 		smsr->registered = true;
 	}
@@ -236,8 +235,10 @@ static void drop_user_return_notifiers(v
 {
 	struct kvm_shared_msrs *smsr = &__get_cpu_var(shared_msrs);
 
-	if (smsr->registered)
+	if (smsr->registered) {
 		kvm_on_user_return(&smsr->urn);
+		user_return_notifier_unregister(&smsr->urn);
+	}
 }
 
 u64 kvm_get_apic_base(struct kvm_vcpu *vcpu)
--- a/include/linux/user-return-notifier.h
+++ b/include/linux/user-return-notifier.h
@@ -3,16 +3,25 @@
 
 #ifdef CONFIG_USER_RETURN_NOTIFIER
 
-#include <linux/list.h>
+#include <linux/llist.h>
 #include <linux/sched.h>
 
 struct user_return_notifier {
+	unsigned long flags;
 	void (*on_user_return)(struct user_return_notifier *urn);
-	struct hlist_node link;
+	struct llist_node link;
 };
 
 
-void user_return_notifier_register(struct user_return_notifier *urn);
+static inline
+void init_user_return_notifier(struct user_return_notifier *urn,
+			       void (*func)(struct user_return_notifier *))
+{
+	urn->flags = 0;
+	urn->on_user_return = func;
+}
+
+bool user_return_notifier_register(struct user_return_notifier *urn);
 void user_return_notifier_unregister(struct user_return_notifier *urn);
 
 static inline void propagate_user_return_notify(struct task_struct *prev,
--- a/kernel/user-return-notifier.c
+++ b/kernel/user-return-notifier.c
@@ -3,18 +3,26 @@
 #include <linux/percpu.h>
 #include <linux/sched.h>
 #include <linux/export.h>
+#include <linux/llist.h>
 
-static DEFINE_PER_CPU(struct hlist_head, return_notifier_list);
+/* The urn entry is claimed to be enqueued */
+#define URN_CLAIMED_BIT		0
+
+static DEFINE_PER_CPU(struct llist_head, return_notifier_list);
 
 /*
  * Request a notification when the current cpu returns to userspace.  Must be
  * called in atomic context.  The notifier will also be called in atomic
- * context.
+ * context.  Return true on success, failure when the urn entry was already
+ * enqueued by someone else.
  */
-void user_return_notifier_register(struct user_return_notifier *urn)
+bool user_return_notifier_register(struct user_return_notifier *urn)
 {
+	if (test_and_set_bit(URN_CLAIMED_BIT, &urn->flags))
+		return false;
+	llist_add(&urn->link, &__get_cpu_var(return_notifier_list));
 	set_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
-	hlist_add_head(&urn->link, &__get_cpu_var(return_notifier_list));
+	return true;
 }
 EXPORT_SYMBOL_GPL(user_return_notifier_register);
 
@@ -24,9 +32,27 @@ EXPORT_SYMBOL_GPL(user_return_notifier_r
  */
 void user_return_notifier_unregister(struct user_return_notifier *urn)
 {
-	hlist_del(&urn->link);
-	if (hlist_empty(&__get_cpu_var(return_notifier_list)))
-		clear_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
+	struct llist_head *head;
+	struct llist_node *node;
+	bool found;
+
+	head = &__get_cpu_var(return_notifier_list);
+	clear_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
+	node = llist_del_all(head);
+	while (node) {
+		if (&urn->link == node) {
+			found = true;
+			continue;
+		}
+		llist_add(node, head);
+		node = node->next;
+	}
+	/* The urn entry may be fired already */
+	if (!found)
+		return;
+	if (!llist_empty(head))
+		set_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
+	clear_bit(URN_CLAIMED_BIT, &urn->flags);
 }
 EXPORT_SYMBOL_GPL(user_return_notifier_unregister);
 
@@ -34,11 +60,18 @@ EXPORT_SYMBOL_GPL(user_return_notifier_u
 void fire_user_return_notifiers(void)
 {
 	struct user_return_notifier *urn;
-	struct hlist_node *tmp1, *tmp2;
-	struct hlist_head *head;
+	struct llist_node *node, *next;
+	struct llist_head *head;
 
 	head = &get_cpu_var(return_notifier_list);
-	hlist_for_each_entry_safe(urn, tmp1, tmp2, head, link)
+	clear_tsk_thread_flag(current, TIF_USER_RETURN_NOTIFY);
+	node = llist_del_all(head);
+	while (node) {
+		next = node->next;
+		urn = llist_entry(node, struct user_return_notifier, link);
+		clear_bit(URN_CLAIMED_BIT, &urn->flags);
 		urn->on_user_return(urn);
+		node = next;
+	}
 	put_cpu_var(return_notifier_list);
 }
