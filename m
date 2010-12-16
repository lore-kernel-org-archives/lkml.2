Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0LPKAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 05:00:49 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48432 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0LPKAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 05:00:42 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Linux-mm <linux-mm@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 16 Dec 2010 15:28:03 +0530
Message-Id: <20101216095803.23751.41491.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
Subject: [RFC] [PATCH 2.6.37-rc5-tip 4/20]  4: uprobes: Adding and remove a uprobe in a rb tree.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Provides interfaces to add and remove uprobes from the global rb tree.
Also provides definitions for uprobe_consumer, interfaces to add and
remove a consumer to a uprobe.  There is a unique uprobe element in the
rbtree for each unique inode:offset pair.

Uprobe gets added to the global rb tree when the first consumer for that
uprobe gets registered. It gets removed from the tree only when all
registered consumers are unregistered.

Multiple consumers can share the same probe. Each consumer provides a
filter to limit the tasks on which the handler should run, a handler
that runs on probe hit and a value which helps filter callback to limit
the tasks on which the handler should run.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 include/linux/uprobes.h |   14 +++
 kernel/uprobes.c        |  209 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 223 insertions(+), 0 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 952e9d7..94557ff 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -23,6 +23,7 @@
  *	Jim Keniston
  */
 
+#include <linux/rbtree.h>
 #ifdef CONFIG_ARCH_SUPPORTS_UPROBES
 #include <asm/uprobes.h>
 #else
@@ -56,6 +57,19 @@ extern unsigned long uprobes_write_vm(struct task_struct *tsk,
 			void __user *vaddr, const void *kbuf,
 			unsigned long nbytes);
 
+struct uprobe_consumer {
+	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
+	/*
+	 * filter is optional; If a filter exists, handler is run
+	 * if and only if filter returns true.
+	 */
+	bool (*filter)(struct uprobe_consumer *self, struct task_struct *task);
+
+	struct uprobe_consumer *next;
+	void *fvalue;	/* filter value */
+};
+
+
 /*
  * Most architectures can use the default versions of @read_opcode(),
  * @set_bkpt(), @set_orig_insn(), and @is_bkpt_insn();
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index cb5884b..ba8ff99 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -34,6 +34,12 @@
 #include <linux/rmap.h> /* needed for anon_vma_prepare */
 
 struct uprobe {
+	struct rb_node		rb_node;	/* node in the rb tree */
+	atomic_t		ref;		/* lifetime muck */
+	struct rw_semaphore	consumer_rwsem;
+	struct uprobe_consumer	*consumers;
+	struct inode		*inode;		/* we hold a ref */
+	unsigned long		offset;
 	uprobe_opcode_t		opcode;
 	u16			fixups;
 };
@@ -250,3 +256,206 @@ bool __weak is_bkpt_insn(struct uprobe *uprobe)
 	return (uprobe->opcode == UPROBES_BKPT_INSN);
 }
 
+static struct rb_root uprobes_tree = RB_ROOT;
+static DEFINE_MUTEX(uprobes_mutex);
+static DEFINE_SPINLOCK(treelock);
+
+static int match_inode(struct uprobe *uprobe, struct inode *inode,
+						struct rb_node **p)
+{
+	struct rb_node *n = *p;
+
+	if (inode < uprobe->inode)
+		*p = n->rb_left;
+	else if (inode > uprobe->inode)
+		*p = n->rb_right;
+	else
+		return 1;
+	return 0;
+}
+
+static int match_offset(struct uprobe *uprobe, unsigned long offset,
+						struct rb_node **p)
+{
+	struct rb_node *n = *p;
+
+	if (offset < uprobe->offset)
+		*p = n->rb_left;
+	else if (offset > uprobe->offset)
+		*p = n->rb_right;
+	else
+		return 1;
+	return 0;
+}
+
+/*
+ * Find a uprobe corresponding to a given inode:offset
+ * Acquires treelock
+ */
+static struct uprobe *find_uprobe(struct inode * inode,
+					 unsigned long offset)
+{
+	struct rb_node *n = uprobes_tree.rb_node;
+	struct uprobe *uprobe, *u = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&treelock, flags);
+	while (n) {
+		uprobe = rb_entry(n, struct uprobe, rb_node);
+
+		if (match_inode(uprobe, inode, &n)) {
+			if (match_offset(uprobe, offset, &n)) {
+				if (atomic_inc_not_zero(&uprobe->ref))
+					u = uprobe;
+				break;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&treelock, flags);
+	return u;
+}
+
+/*
+ * Check if a uprobe is already inserted;
+ *	If it does; return refcount incremented uprobe
+ *	else add the current uprobe and return NULL
+ * Acquires treelock.
+ */
+static struct uprobe *insert_uprobe_rb_node(struct uprobe *uprobe)
+{
+	struct rb_node **p = &uprobes_tree.rb_node;
+	struct rb_node *parent = NULL;
+	struct uprobe *u;
+	unsigned long flags;
+
+	spin_lock_irqsave(&treelock, flags);
+	while (*p) {
+		parent = *p;
+		u = rb_entry(parent, struct uprobe, rb_node);
+		if (u->inode > uprobe->inode)
+			p = &(*p)->rb_left;
+		else if (u->inode < uprobe->inode)
+			p = &(*p)->rb_right;
+		else {
+			if (u->offset > uprobe->offset)
+				p = &(*p)->rb_left;
+			else if (u->offset < uprobe->offset)
+				p = &(*p)->rb_right;
+			else {
+				atomic_inc(&u->ref);
+				goto unlock_return;
+			}
+		}
+	}
+	u = NULL;
+	rb_link_node(&uprobe->rb_node, parent, p);
+	rb_insert_color(&uprobe->rb_node, &uprobes_tree);
+	atomic_set(&uprobe->ref, 2);
+
+unlock_return:
+	spin_unlock_irqrestore(&treelock, flags);
+	return u;
+}
+
+/* Should be called lock-less */
+static void put_uprobe(struct uprobe *uprobe)
+{
+	if (atomic_dec_and_test(&uprobe->ref))
+		kfree(uprobe);
+}
+
+static int valid_vma(struct vm_area_struct *vma)
+{
+	if (!vma->vm_file)
+		return 0;
+
+	if ((vma->vm_flags & (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)) ==
+						(VM_READ|VM_EXEC))
+		return 1;
+
+	return 0;
+}
+
+/* Acquires uprobes_mutex */
+static struct uprobe *uprobes_add(struct inode *inode,
+					unsigned long offset)
+{
+	struct uprobe *uprobe, *cur_uprobe;
+
+	__iget(inode);
+	uprobe = kzalloc(sizeof(struct uprobe), GFP_KERNEL);
+
+	if (!uprobe) {
+		iput(inode);
+		return NULL;
+	}
+	uprobe->inode = inode;
+	uprobe->offset = offset;
+
+	/* add to uprobes_tree, sorted on inode:offset */
+	cur_uprobe = insert_uprobe_rb_node(uprobe);
+
+	/* a uprobe exists for this inode:offset combination*/
+	if (cur_uprobe) {
+		kfree(uprobe);
+		uprobe = cur_uprobe;
+		iput(inode);
+	} else
+		init_rwsem(&uprobe->consumer_rwsem);
+
+	return uprobe;
+}
+
+/* Acquires uprobe->consumer_rwsem */
+static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
+{
+	struct uprobe_consumer *consumer = uprobe->consumers;
+
+	down_read(&uprobe->consumer_rwsem);
+	while (consumer) {
+		if (!consumer->filter || consumer->filter(consumer, current))
+			consumer->handler(consumer, regs);
+
+		consumer = consumer->next;
+	}
+	up_read(&uprobe->consumer_rwsem);
+}
+
+/* Acquires uprobe->consumer_rwsem */
+static void add_consumer(struct uprobe *uprobe,
+				struct uprobe_consumer *consumer)
+{
+	down_write(&uprobe->consumer_rwsem);
+	consumer->next = uprobe->consumers;
+	uprobe->consumers = consumer;
+	up_write(&uprobe->consumer_rwsem);
+	return;
+}
+
+/* Acquires uprobe->consumer_rwsem */
+static int del_consumer(struct uprobe *uprobe,
+				struct uprobe_consumer *consumer)
+{
+	struct uprobe_consumer *con;
+	int ret = 0;
+
+	down_write(&uprobe->consumer_rwsem);
+	con = uprobe->consumers;
+	if (consumer == con) {
+		uprobe->consumers = con->next;
+		if (!con->next)
+			put_uprobe(uprobe);
+		ret = 1;
+	} else {
+		for (; con; con = con->next) {
+			if (con->next == consumer) {
+				con->next = consumer->next;
+				ret = 1;
+				break;
+			}
+		}
+	}
+	up_write(&uprobe->consumer_rwsem);
+	return ret;
+}
+
