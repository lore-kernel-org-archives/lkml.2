Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab2KYWd5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 17:33:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab2KYWdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 17:33:55 -0500
Date: Sun, 25 Nov 2012 23:33:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] uprobes: Introduce uprobe_is_active()
Message-ID: <20121125223347.GA24808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121125223331.GA24788@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lifetime of uprobe->rb_node and uprobe->inode is not refcounted,
delete_uprobe() is called when we detect that uprobe has no consumers,
and it would be deadly wrong to do this twice.

Change delete_uprobe() to WARN() if it was already called. We use
RB_CLEAR_NODE() to mark uprobe "inactive", then RB_EMPTY_NODE() can
be used to detect this case.

RB_EMPTY_NODE() is not used directly, we add the trivial helper for
the next change.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 53dc2eb..2886c82 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -669,6 +669,10 @@ remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vad
 	return set_orig_insn(&uprobe->arch, mm, vaddr);
 }
 
+static inline bool uprobe_is_active(struct uprobe *uprobe)
+{
+	return !RB_EMPTY_NODE(&uprobe->rb_node);
+}
 /*
  * There could be threads that have already hit the breakpoint. They
  * will recheck the current insn and restart if find_uprobe() fails.
@@ -676,9 +680,13 @@ remove_breakpoint(struct uprobe *uprobe, struct mm_struct *mm, unsigned long vad
  */
 static void delete_uprobe(struct uprobe *uprobe)
 {
+	if (WARN_ON(!uprobe_is_active(uprobe)))
+		return;
+
 	spin_lock(&uprobes_treelock);
 	rb_erase(&uprobe->rb_node, &uprobes_tree);
 	spin_unlock(&uprobes_treelock);
+	RB_CLEAR_NODE(&uprobe->rb_node); /* for uprobe_is_active() */
 	iput(uprobe->inode);
 	put_uprobe(uprobe);
 }
-- 
1.5.5.1

