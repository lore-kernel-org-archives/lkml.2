Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab1KJTCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 14:02:53 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:37744 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082Ab1KJTCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 14:02:51 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Date: Fri, 11 Nov 2011 00:07:45 +0530
Message-Id: <20111110183745.11361.97661.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20111110183725.11361.57827.sendpatchset@srdronam.in.ibm.com>
References: <20111110183725.11361.57827.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v6 3.2-rc1 2/28]   Uprobes: Allow multiple consumers for an uprobe.
x-cbid: 11111019-8256-0000-0000-0000001A6EC9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since there is a unique uprobe for a inode, offset combination, provide
an ability for users to have more than one consumer for a uprobe.

Each consumer will define a handler and an optional filter.  Handler
specifies the routine to run on hitting a probepoint.  Filter allows to
selectively run the handler on hitting the probepoint.  Handler/Filter
will be relevant on probehit.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

Changelog:(Since v5)
modified del_consumer as per comments from Peter.

 include/linux/uprobes.h |   13 +++++++++++++
 kernel/uprobes.c        |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index bfb85c4..bf31f7c 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -25,9 +25,22 @@
 
 #include <linux/rbtree.h>
 
+struct uprobe_consumer {
+	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
+	/*
+	 * filter is optional; If a filter exists, handler is run
+	 * if and only if filter returns true.
+	 */
+	bool (*filter)(struct uprobe_consumer *self, struct task_struct *task);
+
+	struct uprobe_consumer *next;
+};
+
 struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
 	atomic_t		ref;
+	struct rw_semaphore	consumer_rwsem;
+	struct uprobe_consumer	*consumers;
 	struct inode		*inode;		/* Also hold a ref to inode */
 	loff_t			offset;
 };
diff --git a/kernel/uprobes.c b/kernel/uprobes.c
index cacf333..2c92b9a 100644
--- a/kernel/uprobes.c
+++ b/kernel/uprobes.c
@@ -149,6 +149,7 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
 
 	uprobe->inode = igrab(inode);
 	uprobe->offset = offset;
+	init_rwsem(&uprobe->consumer_rwsem);
 
 	/* add to uprobes_tree, sorted on inode:offset */
 	cur_uprobe = insert_uprobe(uprobe);
@@ -162,6 +163,40 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
 	return uprobe;
 }
 
+/* Returns the previous consumer */
+static struct uprobe_consumer *add_consumer(struct uprobe *uprobe,
+				struct uprobe_consumer *consumer)
+{
+	down_write(&uprobe->consumer_rwsem);
+	consumer->next = uprobe->consumers;
+	uprobe->consumers = consumer;
+	up_write(&uprobe->consumer_rwsem);
+	return consumer->next;
+}
+
+/*
+ * For uprobe @uprobe, delete the consumer @consumer.
+ * Return true if the @consumer is deleted successfully
+ * or return false.
+ */
+static bool del_consumer(struct uprobe *uprobe,
+				struct uprobe_consumer *consumer)
+{
+	struct uprobe_consumer **con;
+	bool ret = false;
+
+	down_write(&uprobe->consumer_rwsem);
+	for (con = &uprobe->consumers; *con; con = &(*con)->next) {
+		if (*con == consumer) {
+			*con = consumer->next;
+			ret = true;
+			break;
+		}
+	}
+	up_write(&uprobe->consumer_rwsem);
+	return ret;
+}
+
 static void delete_uprobe(struct uprobe *uprobe)
 {
 	unsigned long flags;

