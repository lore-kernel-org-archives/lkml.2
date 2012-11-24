Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab2KXSCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 13:02:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab2KXSCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 13:02:34 -0500
Date: Sat, 24 Nov 2012 19:02:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] uprobes: Introduce uprobe->register_rwsem
Message-ID: <20121124180228.GA30980@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121124180213.GA30963@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce uprobe->register_rwsem. It is taken for writing around
__uprobe_register/unregister.

Change handler_chain() to use this sem rather than consumer_rwsem.

The main reason for this change is that we have the nasty problem
with mmap_sem/consumer_rwsem dependency. filter_chain() needs to
protect uprobe->consumers like handler_chain(), but they can not
use the same lock. filter_chain() can be called under ->mmap_sem
(currently this is always true), but we want to allow ->handler()
to play with the probed task's memory, and this needs ->mmap_sem.

Alternatively we could use srcu, but synchronize_srcu() is very
slow and ->register_rwsem allows us to do more. In particular, we
can teach handler_chain() to do remove_breakpoint() if this bp is
"nacked" by all consumers, we know that we can't race with the
new consumer which does uprobe_register().

See also the next patches. uprobes_mutex[] is almost ready to die.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index c80507d..03ffbb5 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -91,6 +91,7 @@ static atomic_t uprobe_events = ATOMIC_INIT(0);
 struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
 	atomic_t		ref;
+	struct rw_semaphore	register_rwsem;
 	struct rw_semaphore	consumer_rwsem;
 	struct mutex		copy_mutex;	/* TODO: kill me and UPROBE_COPY_INSN */
 	struct list_head	pending_list;
@@ -449,6 +450,7 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
 
 	uprobe->inode = igrab(inode);
 	uprobe->offset = offset;
+	init_rwsem(&uprobe->register_rwsem);
 	init_rwsem(&uprobe->consumer_rwsem);
 	mutex_init(&uprobe->copy_mutex);
 	/* For now assume that the instruction need not be single-stepped */
@@ -476,10 +478,10 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 	if (!test_bit(UPROBE_RUN_HANDLER, &uprobe->flags))
 		return;
 
-	down_read(&uprobe->consumer_rwsem);
+	down_read(&uprobe->register_rwsem);
 	for (uc = uprobe->consumers; uc; uc = uc->next)
 		uc->handler(uc, regs);
-	up_read(&uprobe->consumer_rwsem);
+	up_read(&uprobe->register_rwsem);
 }
 
 static void consumer_add(struct uprobe *uprobe, struct uprobe_consumer *uc)
@@ -873,9 +875,11 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	mutex_lock(uprobes_hash(inode));
 	uprobe = alloc_uprobe(inode, offset);
 	if (uprobe) {
+		down_write(&uprobe->register_rwsem);
 		ret = __uprobe_register(uprobe, uc);
 		if (ret)
 			__uprobe_unregister(uprobe, uc);
+		up_write(&uprobe->register_rwsem);
 	}
 	mutex_unlock(uprobes_hash(inode));
 	if (uprobe)
@@ -899,7 +903,9 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
 		return;
 
 	mutex_lock(uprobes_hash(inode));
+	down_write(&uprobe->register_rwsem);
 	__uprobe_unregister(uprobe, uc);
+	up_write(&uprobe->register_rwsem);
 	mutex_unlock(uprobes_hash(inode));
 	put_uprobe(uprobe);
 }
-- 
1.5.5.1

