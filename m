Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab2KXSCi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 13:02:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab2KXSCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 13:02:36 -0500
Date: Sat, 24 Nov 2012 19:02:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] uprobes: Kill UPROBE_RUN_HANDLER flag
Message-ID: <20121124180233.GA30990@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121124180213.GA30963@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply remove UPROBE_RUN_HANDLER and the corresponding code.

It can only help if uprobe has a single consumer, and in fact
it is no longer needed after handler_chain() was changed to use
->register_rwsem, we simply can not race with uprobe_register().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   23 +++++------------------
 1 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 873c993..97c3874 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -83,10 +83,8 @@ static atomic_t uprobe_events = ATOMIC_INIT(0);
 
 /* Have a copy of original instruction */
 #define UPROBE_COPY_INSN	0
-/* Dont run handlers when first register/ last unregister in progress*/
-#define UPROBE_RUN_HANDLER	1
 /* Can skip singlestep */
-#define UPROBE_SKIP_SSTEP	2
+#define UPROBE_SKIP_SSTEP	1
 
 struct uprobe {
 	struct rb_node		rb_node;	/* node in the rb tree */
@@ -475,9 +473,6 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 {
 	struct uprobe_consumer *uc;
 
-	if (!test_bit(UPROBE_RUN_HANDLER, &uprobe->flags))
-		return;
-
 	down_read(&uprobe->register_rwsem);
 	for (uc = uprobe->consumers; uc; uc = uc->next)
 		uc->handler(uc, regs);
@@ -825,13 +820,8 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 
 static int __uprobe_register(struct uprobe *uprobe, struct uprobe_consumer *uc)
 {
-	int err;
-
 	consumer_add(uprobe, uc);
-	err = register_for_each_vma(uprobe, true);
-	if (!err) /* TODO: pointless unless the first consumer */
-		set_bit(UPROBE_RUN_HANDLER, &uprobe->flags);
-	return err;
+	return register_for_each_vma(uprobe, true);
 }
 
 static void __uprobe_unregister(struct uprobe *uprobe, struct uprobe_consumer *uc)
@@ -842,12 +832,9 @@ static void __uprobe_unregister(struct uprobe *uprobe, struct uprobe_consumer *u
 		return;
 
 	err = register_for_each_vma(uprobe, false);
-	if (!uprobe->consumers) {
-		clear_bit(UPROBE_RUN_HANDLER, &uprobe->flags);
-		/* TODO : cant unregister? schedule a worker thread */
-		if (!err)
-			delete_uprobe(uprobe);
-	}
+	/* TODO : cant unregister? schedule a worker thread */
+	if (!uprobe->consumers && !err)
+		delete_uprobe(uprobe);
 }
 
 /*
-- 
1.5.5.1

