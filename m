Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1JABye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 21:54:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:63355 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1JABy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 21:54:28 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: sebastian@breakpoint.cc
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] irq: don't put module.h into irq.h for tracking irqgen modules.
Date: Fri, 30 Sep 2011 21:53:57 -0400
Message-Id: <1317434037-15343-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent commit "irq: Track the owner of irq descriptor" in
commit ID b6873807a7143b7 placed module.h into linux/irq.h
but we are trying to limit module.h inclusion to just C files
that really need it, due to its size and number of children
includes.  This targets just reversing that include.

Add in the basic "struct module" since that is all we really need
to ensure things compile.  In theory, b687380 should have added the
module.h include to the irqdesc.h header as well, but the implicit
module.h everywhere presence masked this from showing up.  So give
it the "struct module" as well.

As for the C files, irqdesc.c is only using THIS_MODULE, so it
does not need module.h - give it export.h instead.  The C file
irq/manage.c is now (as of b687380) using try_module_get and
module_put and so it needs module.h (which it already has).

Also convert the irq_alloc_descs variants to macros, since all
they really do is is call the __irq_alloc_descs primitive.
This avoids including export.h and no debug info is lost.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

---

[This is a commit I've recently added to the module.h tree,
 since b687380 didn't exist when I'd sent the module.h RFC
 commits a while back.  Sending just for review comments.]

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 5951730..adde1d3 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -23,13 +23,13 @@
 #include <linux/errno.h>
 #include <linux/topology.h>
 #include <linux/wait.h>
-#include <linux/module.h>
 
 #include <asm/irq.h>
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
 
 struct seq_file;
+struct module;
 struct irq_desc;
 struct irq_data;
 typedef	void (*irq_flow_handler_t)(unsigned int irq,
@@ -551,29 +551,21 @@ static inline struct msi_desc *irq_data_get_msi(struct irq_data *d)
 int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 		struct module *owner);
 
-static inline int irq_alloc_descs(int irq, unsigned int from, unsigned int cnt,
-		int node)
-{
-	return __irq_alloc_descs(irq, from, cnt, node, THIS_MODULE);
-}
+/* use macros to avoid needing export.h for THIS_MODULE */
+#define irq_alloc_descs(irq, from, cnt, node)	\
+	__irq_alloc_descs(irq, from, cnt, node, THIS_MODULE)
 
-void irq_free_descs(unsigned int irq, unsigned int cnt);
-int irq_reserve_irqs(unsigned int from, unsigned int cnt);
+#define irq_alloc_desc(node)			\
+	irq_alloc_descs(-1, 0, 1, node)
 
-static inline int irq_alloc_desc(int node)
-{
-	return irq_alloc_descs(-1, 0, 1, node);
-}
+#define irq_alloc_desc_at(at, node)		\
+	irq_alloc_descs(at, at, 1, node)
 
-static inline int irq_alloc_desc_at(unsigned int at, int node)
-{
-	return irq_alloc_descs(at, at, 1, node);
-}
+#define irq_alloc_desc_from(from, node)		\
+	irq_alloc_descs(-1, from, 1, node)
 
-static inline int irq_alloc_desc_from(unsigned int from, int node)
-{
-	return irq_alloc_descs(-1, from, 1, node);
-}
+void irq_free_descs(unsigned int irq, unsigned int cnt);
+int irq_reserve_irqs(unsigned int from, unsigned int cnt);
 
 static inline void irq_free_desc(unsigned int irq)
 {
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 150134a..d9a9f61 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -11,6 +11,7 @@
 struct irq_affinity_notify;
 struct proc_dir_entry;
 struct timer_rand_state;
+struct module;
 /**
  * struct irq_desc - interrupt descriptor
  * @irq_data:		per irq and chip data passed down to chip functions
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 039b889..9888f7e 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -9,7 +9,7 @@
  */
 #include <linux/irq.h>
 #include <linux/slab.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/interrupt.h>
 #include <linux/kernel_stat.h>
 #include <linux/radix-tree.h>
-- 
1.7.6

