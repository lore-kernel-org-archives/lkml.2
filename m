Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab2KWU3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 15:29:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110Ab2KWU3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 15:29:49 -0500
Date: Fri, 23 Nov 2012 21:28:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] uprobes: _unregister() should always do
	register_for_each_vma(false)
Message-ID: <20121123202815.GA18904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121123202741.GA18858@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe_unregister() removes the breakpoints only if the last consumer
goes away. To support the filtering it should do this every time, we
want to remove the breakpoints which nobody else want to keep.

Note: given that filter_chain() is not actually implemented, this patch
itself doesn't change the behaviour yet, register_for_each_vma(false)
is a heavy "nop" unless there are no more consumers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index edc47ae..7c98671 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -825,12 +825,20 @@ static int __uprobe_register(struct uprobe *uprobe)
 	return register_for_each_vma(uprobe, true);
 }
 
-static void __uprobe_unregister(struct uprobe *uprobe)
+static void __uprobe_unregister(struct uprobe *uprobe, struct uprobe_consumer *uc)
 {
-	if (!register_for_each_vma(uprobe, false))
-		delete_uprobe(uprobe);
+	int err;
+
+	if (!consumer_del(uprobe, uc))	/* WARN? */
+		return;
 
-	/* TODO : cant unregister? schedule a worker thread */
+	err = register_for_each_vma(uprobe, false);
+	if (!uprobe->consumers) {
+		clear_bit(UPROBE_RUN_HANDLER, &uprobe->flags);
+		/* TODO : cant unregister? schedule a worker thread */
+		if (!err)
+			delete_uprobe(uprobe);
+	}
 }
 
 /*
@@ -868,8 +876,7 @@ int uprobe_register(struct inode *inode, loff_t offset, struct uprobe_consumer *
 	} else if (!consumer_add(uprobe, uc)) {
 		ret = __uprobe_register(uprobe);
 		if (ret) {
-			uprobe->consumers = NULL;
-			__uprobe_unregister(uprobe);
+			__uprobe_unregister(uprobe, uc);
 		} else {
 			set_bit(UPROBE_RUN_HANDLER, &uprobe->flags);
 		}
@@ -897,14 +904,7 @@ void uprobe_unregister(struct inode *inode, loff_t offset, struct uprobe_consume
 		return;
 
 	mutex_lock(uprobes_hash(inode));
-
-	if (consumer_del(uprobe, uc)) {
-		if (!uprobe->consumers) {
-			__uprobe_unregister(uprobe);
-			clear_bit(UPROBE_RUN_HANDLER, &uprobe->flags);
-		}
-	}
-
+	__uprobe_unregister(uprobe, uc);
 	mutex_unlock(uprobes_hash(inode));
 	put_uprobe(uprobe);
 }
-- 
1.5.5.1

