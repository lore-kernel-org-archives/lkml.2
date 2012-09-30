Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab2I3TlZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 15:41:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab2I3Tkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 15:40:53 -0400
Date: Sun, 30 Sep 2012 21:42:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] uprobes: Fix uprobe_copy_insn() race with itself
Message-ID: <20120930194224.GA11347@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120930194119.GA11278@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

install_breakpoint() is called under mm->mmap_sem, this protects
set_swbp() but not uprobe_copy_insn(). Two or more different tasks
can call install_breakpoint()->uprobe_copy_insn() at the same time,
this leads to numerous problems if UPROBE_COPY_INSN is not set.

Just for example, the second copy_insn() can corrupt the already
analyzed/fixuped uprobe->arch.insn and race with handle_swbp().

This patch simply adds uprobe->copy_mutex to serialize this code.
We could probably reuse ->consumer_rwsem, but this would mean that
consumer->handler() can not use mm->mmap_sem, not good.

Note: this is another temporary ugly hack until we move this logic
into uprobe_register().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 5c0c1b0..8410388 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -89,6 +89,7 @@ struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
 	atomic_t		ref;
 	struct rw_semaphore	consumer_rwsem;
+	struct mutex		copy_mutex;	/* TODO: kill me and UPROBE_COPY_INSN */
 	struct list_head	pending_list;
 	struct uprobe_consumer	*consumers;
 	struct inode		*inode;		/* Also hold a ref to inode */
@@ -444,6 +445,7 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
 	uprobe->inode = igrab(inode);
 	uprobe->offset = offset;
 	init_rwsem(&uprobe->consumer_rwsem);
+	mutex_init(&uprobe->copy_mutex);
 
 	/* add to uprobes_tree, sorted on inode:offset */
 	cur_uprobe = insert_uprobe(uprobe);
@@ -578,6 +580,10 @@ static int uprobe_copy_insn(struct uprobe *uprobe, struct file *file,
 	if (uprobe->flags & UPROBE_COPY_INSN)
 		return ret;
 
+	mutex_lock(&uprobe->copy_mutex);
+	if (uprobe->flags & UPROBE_COPY_INSN)
+		goto out;
+
 	ret = copy_insn(uprobe, file);
 	if (ret)
 		goto out;
@@ -598,6 +604,8 @@ static int uprobe_copy_insn(struct uprobe *uprobe, struct file *file,
 	uprobe->flags |= UPROBE_COPY_INSN;
 	ret = 0;
  out:
+	mutex_unlock(&uprobe->copy_mutex);
+
 	return ret;
 }
 
-- 
1.5.5.1

