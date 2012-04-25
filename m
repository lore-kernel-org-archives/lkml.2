Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab2DYN4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:56:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44580 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758173Ab2DYN4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:56:19 -0400
Date: Wed, 25 Apr 2012 06:55:50 -0700
From: tip-bot for Li Zhong <zhong@linux.vnet.ibm.com>
Message-ID: <tip-72b3fb24713755cf9740b403e95aa67ceedf3509@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        seiji.aguchi@hds.com, zhong@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        seiji.aguchi@hds.com, zhong@linux.vnet.ibm.com,
        akpm@linux-foundation.org, tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1333051877-15755-4-git-send-email-dzickus@redhat.com>
References: <1333051877-15755-4-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] x86/nmi:
  Fix page faults by nmiaction if kmemcheck is enabled
Git-Commit-ID: 72b3fb24713755cf9740b403e95aa67ceedf3509
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Apr 2012 06:55:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72b3fb24713755cf9740b403e95aa67ceedf3509
Gitweb:     http://git.kernel.org/tip/72b3fb24713755cf9740b403e95aa67ceedf3509
Author:     Li Zhong <zhong@linux.vnet.ibm.com>
AuthorDate: Thu, 29 Mar 2012 16:11:17 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Apr 2012 12:44:06 +0200

x86/nmi: Fix page faults by nmiaction if kmemcheck is enabled

This patch tries to fix the problem of page fault exception
caused by accessing nmiaction structure in nmi if kmemcheck
is enabled.

If kmemcheck is enabled, the memory allocated through slab are
in pages that are marked non-present, so that some checks could
be done in the page fault handling code ( e.g. whether the
memory is read before written to ).

As nmiaction is allocated in this way, so it resides in a
non-present page. Then there is a page fault while the nmi code
accessing the nmiaction structure, which would then cause a
warning by WARN_ON_ONCE(in_nmi()) in kmemcheck_fault(), called
by do_page_fault().

This significantly simplifies the code as well, as the whole
dynamic allocation dance goes away.

v2: as Peter suggested, changed the nmiaction to use static
    storage.

v3: as Peter suggested, use macro to shorten the codes. Also
    keep the original usage of register_nmi_handler, so users of
    this call doesn't need change.

Tested-by: Seiji Aguchi <seiji.aguchi@hds.com>
Fixes: https://lkml.org/lkml/2012/3/2/356
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
[ simplified the wrappers ]
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: thomas.mingarelli@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1333051877-15755-4-git-send-email-dzickus@redhat.com
[ tidied the patch a bit ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/nmi.h |   20 ++++++++++++-
 arch/x86/kernel/nmi.c      |   65 ++++---------------------------------------
 2 files changed, 24 insertions(+), 61 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 07162df..a1a836c 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -37,8 +37,24 @@ enum {
 
 typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
 
-int register_nmi_handler(unsigned int, nmi_handler_t, unsigned long,
-			 const char *);
+struct nmiaction {
+	struct list_head	list;
+	nmi_handler_t		handler;
+	unsigned int		flags;
+	const char		*name;
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
index ac9c1b7..585be4b 100644
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
@@ -115,11 +107,14 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs,
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
@@ -143,8 +138,9 @@ static int __setup_nmi(unsigned int type, struct nmiaction *action)
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return 0;
 }
+EXPORT_SYMBOL(__register_nmi_handler);
 
-static struct nmiaction *__free_nmi(unsigned int type, const char *name)
+void unregister_nmi_handler(unsigned int type, const char *name)
 {
 	struct nmi_desc *desc = nmi_to_desc(type);
 	struct nmiaction *n;
@@ -167,56 +163,7 @@ static struct nmiaction *__free_nmi(unsigned int type, const char *name)
 
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
