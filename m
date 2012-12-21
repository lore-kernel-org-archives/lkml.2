Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab2LULRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 06:17:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab2LULQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 06:16:56 -0500
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Anton Arapov <anton@redhat.com>
Subject: [RFC PATCH 6/6] uretprobes: register() and unregister() implementation
Date: Fri, 21 Dec 2012 12:16:36 +0100
Message-Id: <1356088596-17858-7-git-send-email-anton@redhat.com>
In-Reply-To: <1356088596-17858-1-git-send-email-anton@redhat.com>
References: <1356088596-17858-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A uretprobe is specified by a file:offset:handler. A uprobe is created
at the offset specified. When this uprobe is hit a uretprobe instance
created and a probe placed instead of the return address of the current
function. The handler specified is invoked before replacing the return
address. A uretprobe therefore places two probes, firstly a uprobe at
offset, whose handler in turn places the second probe at the return
address at task runtime.

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 include/linux/uprobes.h | 10 +++++
 kernel/events/uprobes.c | 97 +++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 91 insertions(+), 16 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 741cc77..ebf957f 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -104,6 +104,8 @@ extern int __weak set_orig_insn(struct arch_uprobe *aup, struct mm_struct *mm, u
 extern bool __weak is_swbp_insn(uprobe_opcode_t *insn);
 extern int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
 extern void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
+extern int uretprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
+extern void uretprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consumer *uc);
 extern int uprobe_mmap(struct vm_area_struct *vma);
 extern void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end);
 extern void uprobe_start_dup_mmap(void);
@@ -130,6 +132,14 @@ static inline void
 uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consumer *uc)
 {
 }
+uretprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc)
+{
+	return -ENOSYS;
+}
+static inline void
+uretprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consumer *uc)
+{
+}
 static inline int uprobe_mmap(struct vm_area_struct *vma)
 {
 	return 0;
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index d4016282..d360077 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -486,6 +486,14 @@ static void consumer_add(struct uprobe *uprobe, struct uprobe_consumer *uc)
 	up_write(&uprobe->consumer_rwsem);
 }
 
+static void return_consumer_add(struct uprobe *uprobe, struct uprobe_consumer *uc)
+{
+	down_write(&uprobe->consumer_rwsem);
+	uc->next = uprobe->return_consumers;
+	uprobe->return_consumers = uc;
+	up_write(&uprobe->consumer_rwsem);
+}
+
 /*
  * For uprobe @uprobe, delete the consumer @uc.
  * Return true if the @uc is deleted successfully
@@ -509,6 +517,24 @@ static bool consumer_del(struct uprobe *uprobe, struct uprobe_consumer *uc)
 	return ret;
 }
 
+static bool return_consumer_del(struct uprobe *uprobe, struct uprobe_consumer *uc)
+{
+	struct uprobe_consumer **con;
+	bool ret = false;
+
+	down_write(&uprobe->consumer_rwsem);
+	for (con = &uprobe->return_consumers; *con; con = &(*con)->next) {
+		if (*con == uc) {
+			*con = uc->next;
+			ret = true;
+			break;
+		}
+	}
+	up_write(&uprobe->consumer_rwsem);
+
+	return ret;
+}
+
 static int
 __copy_insn(struct address_space *mapping, struct file *filp, char *insn,
 			unsigned long nbytes, loff_t offset)
@@ -831,30 +857,29 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 	return err;
 }
 
-static int __uprobe_register(struct uprobe *uprobe, struct uprobe_consumer *uc)
-{
-	consumer_add(uprobe, uc);
-	return register_for_each_vma(uprobe, true);
-}
-
-static void __uprobe_unregister(struct uprobe *uprobe, struct uprobe_consumer *uc)
+static void __uprobe_unregister(struct uprobe *uprobe, struct uprobe_consumer *uc, bool is_rp)
 {
 	int err;
 
-	if (!consumer_del(uprobe, uc))	/* WARN? */
+	if (is_rp)
+		err = return_consumer_del(uprobe, uc);
+	else
+		err = consumer_del(uprobe, uc);
+	if (!err) /* WARN? */
 		return;
 
 	err = register_for_each_vma(uprobe, false);
 	/* TODO : cant unregister? schedule a worker thread */
-	if (!uprobe->consumers && !err)
+	if (!uprobe->consumers && !uprobe->return_consumers && !err)
 		delete_uprobe(uprobe);
 }
 
 /*
- * uprobe_register - register a probe
+ * __uprobe_register - register a probe
  * @inode: the file in which the probe has to be placed.
  * @offset: offset from the start of the file.
- * @uc: information on howto handle the probe..
+ * @uc: information on howto handle the probe.
+ * @is_rp: if true - return probe.
  *
  * Apart from the access refcount, uprobe_register() takes a creation
  * refcount (thro alloc_uprobe) if and only if this @uprobe is getting
@@ -867,7 +892,7 @@ static void __uprobe_unregister(struct uprobe *uprobe, struct uprobe_consumer *u
  * Return errno if it cannot successully install probes
  * else return 0 (success)
  */
-int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc)
+int __uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc, bool is_rp)
 {
 	struct uprobe *uprobe;
 	int ret;
@@ -887,9 +912,14 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	down_write(&uprobe->register_rwsem);
 	ret = -EAGAIN;
 	if (likely(uprobe_is_active(uprobe))) {
-		ret = __uprobe_register(uprobe, uc);
+		if (is_rp)
+			return_consumer_add(uprobe, uc);
+		else
+			consumer_add(uprobe, uc);
+
+		ret = register_for_each_vma(uprobe, true);
 		if (ret)
-			__uprobe_unregister(uprobe, uc);
+			__uprobe_unregister(uprobe, uc, is_rp);
 	}
 	up_write(&uprobe->register_rwsem);
 	put_uprobe(uprobe);
@@ -900,7 +930,26 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 }
 
 /*
- * uprobe_unregister - unregister a already registered probe.
+ * u[ret]probe_register - register a probe
+ * @inode: the file in which the probe has to be placed.
+ * @offset: offset from the start of the file.
+ * @uc: information on howto handle the probe.
+ *
+ * Return errno if it cannot successully install probes
+ * else return 0 (success)
+ */
+int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc)
+{
+	return __uprobe_register(inode, offset, uc, false);
+}
+
+int uretprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *uc)
+{
+	return __uprobe_register(inode, offset, uc, true);
+}
+
+/*
+ * u[ret]probe_unregister - unregister a already registered probe.
  * @inode: the file in which the probe has to be removed.
  * @offset: offset from the start of the file.
  * @uc: identify which probe if multiple probes are colocated.
@@ -914,8 +963,24 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
 		return;
 
 	down_write(&uprobe->register_rwsem);
-	__uprobe_unregister(uprobe, uc);
+	__uprobe_unregister(uprobe, uc, false);
 	up_write(&uprobe->register_rwsem);
+
+	put_uprobe(uprobe);
+}
+
+void uretprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consumer *uc)
+{
+	struct uprobe *uprobe;
+
+	uprobe = find_uprobe(inode, offset);
+	if (!uprobe)
+		return;
+
+	down_write(&uprobe->register_rwsem);
+	__uprobe_unregister(uprobe, uc, true);
+	up_write(&uprobe->register_rwsem);
+
 	put_uprobe(uprobe);
 }
 
-- 
1.8.0.2

