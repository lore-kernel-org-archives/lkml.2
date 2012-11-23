Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab2KWU3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 15:29:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221Ab2KWU2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 15:28:14 -0500
Date: Fri, 23 Nov 2012 21:28:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] uprobes: Kill uprobe_consumer->filter()
Message-ID: <20121123202810.GA18894@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121123202741.GA18858@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_consumer->filter() is pointless in its current form, kill it.

We will add it back, but with the different signature/semantics. Perhaps
we will even re-introduce the callsite in handler_chain(), but not to
just skip uc->handler().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/uprobes.h     |    5 -----
 kernel/events/uprobes.c     |    6 ++----
 kernel/trace/trace_uprobe.c |    1 -
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 4f628a6..83742b9 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -37,11 +37,6 @@ struct inode;
 
 struct uprobe_consumer {
 	int (*handler)(struct uprobe_consumer *self, struct pt_regs *regs);
-	/*
-	 * filter is optional; If a filter exists, handler is run
-	 * if and only if filter returns true.
-	 */
-	bool (*filter)(struct uprobe_consumer *self, struct task_struct *task);
 
 	struct uprobe_consumer *next;
 };
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index d8e930a..e761974 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -477,10 +477,8 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
 		return;
 
 	down_read(&uprobe->consumer_rwsem);
-	for (uc = uprobe->consumers; uc; uc = uc->next) {
-		if (!uc->filter || uc->filter(uc, current))
-			uc->handler(uc, regs);
-	}
+	for (uc = uprobe->consumers; uc; uc = uc->next)
+		uc->handler(uc, regs);
 	up_read(&uprobe->consumer_rwsem);
 }
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 03003cd..38eee92 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -546,7 +546,6 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
 		return -EINTR;
 
 	utc->cons.handler = uprobe_dispatcher;
-	utc->cons.filter = NULL;
 	ret = uprobe_register(tu->inode, tu->offset, &utc->cons);
 	if (ret) {
 		kfree(utc);
-- 
1.5.5.1

