Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab2CIQja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 11:39:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758058Ab2CIQj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 11:39:29 -0500
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/2] x86,nmi: Fix page faults by nmiaction if kmemcheck is enabled
Date: Fri,  9 Mar 2012 11:37:24 -0500
Message-Id: <1331311044-1120-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1331311044-1120-1-git-send-email-dzickus@redhat.com>
References: <1331311044-1120-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zhong <zhong@linux.vnet.ibm.com>

This patch tries to fix the problem of page fault exception caused by
accessing nmiaction structure in nmi if kmemcheck is enabled.

If kmemcheck is enabled, the memory allocated through slab are in pages
that are marked non-present, so that some checks could be done in the
page fault handling code ( e.g. whether the memory is read before
written to ).
As nmiaction is allocated in this way, so it resides in a non-present
page. Then there is a page fault while the nmi code accessing the
nmiaction structure, which would then cause a warning by
WARN_ON_ONCE(in_nmi()) in kmemcheck_fault(), called by do_page_fault().

v2: as Peter suggested, changed the nmiaction to use static storage.

v3: as Peter suggested, use macro to shorten the codes. Also keep the
original usage of register_nmi_handler, so users of this call doesn't
need change.

[simplified wrappers -dcz]

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h |   20 ++++++++++++-
 arch/x86/kernel/nmi.c      |   65 ++++---------------------------------------
 2 files changed, 24 insertions(+), 61 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index fd3f9f1..2a17e57 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -35,8 +35,24 @@ enum {
 
 typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
 
-int register_nmi_handler(unsigned int, nmi_handler_t, unsigned long,
-			 const char *);
+struct nmiaction {
+	struct list_head list;
+	nmi_handler_t handler;
+	unsigned int flags;
+	const char *name;
+};
+
+#define register_nmi_handler(t, fn, fg, n)		\
+({							\
+	static struct nmiaction fn##_na = {		\
+		.handler = (fn),			\
+		.name = (n),				\
+		.flags = (fg),				\
+	};						\
+	__register_nmi_handler((t), &fn##_na);	\
+})
+
+int __register_nmi_handler(unsigned int, struct nmiaction *);
 
 void unregister_nmi_handler(unsigned int, const char *);
 
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 47acaf3..f13302d 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -31,14 +31,6 @@
 #include <asm/nmi.h>
 #include <asm/x86_init.h>
 
-#define NMI_MAX_NAMELEN	16
-struct nmiaction {
-	struct list_head list;
-	nmi_handler_t handler;
-	unsigned int flags;
-	char *name;
-};
-
 struct nmi_desc {
 	spinlock_t lock;
 	struct list_head head;
@@ -107,11 +99,14 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs,
 	return handled;
 }
 
-static int __setup_nmi(unsigned int type, struct nmiaction *action)
+int __register_nmi_handler(unsigned int type, struct nmiaction *action)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
 	unsigned long flags;
 
+	if (!action->handler)
+		return -EINVAL;
+
 	spin_lock_irqsave(&desc->lock, flags);
 
 	/*
@@ -133,8 +128,9 @@ static int __setup_nmi(unsigned int type, struct nmiaction *action)
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
 }
+EXPORT_SYMBOL(__register_nmi_handler);
 
-static struct nmiaction *__free_nmi(unsigned int type, const char *name)
+void unregister_nmi_handler(unsigned int type, const char *name)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
 	struct nmiaction *n;
@@ -157,56 +153,7 @@ static struct nmiaction *__free_nmi(unsigned int type, const char *name)
 
 	spin_unlock_irqrestore(&desc->lock, flags);
 	synchronize_rcu();
-	return (n);
 }
-
-int register_nmi_handler(unsigned int type, nmi_handler_t handler,
-			unsigned long nmiflags, const char *devname)
-{
-	struct nmiaction *action;
-	int retval = -ENOMEM;
-
-	if (!handler)
-		return -EINVAL;
-
-	action = kzalloc(sizeof(struct nmiaction), GFP_KERNEL);
-	if (!action)
-		goto fail_action;
-
-	action->handler = handler;
-	action->flags = nmiflags;
-	action->name = kstrndup(devname, NMI_MAX_NAMELEN, GFP_KERNEL);
-	if (!action->name)
-		goto fail_action_name;
-
-	retval = __setup_nmi(type, action);
-
-	if (retval)
-		goto fail_setup_nmi;
-
-	return retval;
-
-fail_setup_nmi:
-	kfree(action->name);
-fail_action_name:
-	kfree(action);
-fail_action:	
-
-	return retval;
-}
-EXPORT_SYMBOL_GPL(register_nmi_handler);
-
-void unregister_nmi_handler(unsigned int type, const char *name)
-{
-	struct nmiaction *a;
-
-	a = __free_nmi(type, name);
-	if (a) {
-		kfree(a->name);
-		kfree(a);
-	}
-}
-
 EXPORT_SYMBOL_GPL(unregister_nmi_handler);
 
 static notrace __kprobes void
-- 
1.7.7.6

