Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab1CWKJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:09:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65002 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab1CWKGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:06:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=HzsL5bOg7XajfvP9YH+zCiaB0vEkyk/+fIWkiU0JKU8o/14aw5XbrZi8077OG/jciU
         mG1Y3BG2Dl8GzKLoRqTt9+vUXcTMzJ8RL5xTeNGKhOjjvk/f+fe78pOOzS8t7DZe8DX7
         LeX63qIphTTgVAcos29skFtvooFym2tCLZtWY=
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, roland@hack.frob.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/20] ptrace: Collapse ptrace_untrace() into __ptrace_unlink()
Date: Wed, 23 Mar 2011 11:05:57 +0100
Message-Id: <1300874766-12941-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300874766-12941-1-git-send-email-tj@kernel.org>
References: <1300874766-12941-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the extra task_is_traced() check in __ptrace_unlink() and
collapse ptrace_untrace() into __ptrace_unlink().  This is to prepare
for further changes.

While at it, drop the comment on top of ptrace_untrace() and convert
__ptrace_unlink() comment to docbook format.  Detailed comment will be
added by the next patch.

This patch doesn't cause any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/ptrace.c |   40 +++++++++++++++-------------------------
 1 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 745fc2d..e609843 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -37,15 +37,23 @@ void __ptrace_link(struct task_struct *child, struct task_struct *new_parent)
 	child->parent = new_parent;
 }
 
-/*
- * Turn a tracing stop into a normal stop now, since with no tracer there
- * would be no way to wake it up with SIGCONT or SIGKILL.  If there was a
- * signal sent that would resume the child, but didn't because it was in
- * TASK_TRACED, resume it now.
- * Requires that irqs be disabled.
+/**
+ * __ptrace_unlink - unlink ptracee and restore its execution state
+ * @child: ptracee to be unlinked
+ *
+ * Remove @child from the ptrace list, move it back to the original parent.
+ *
+ * CONTEXT:
+ * write_lock_irq(tasklist_lock)
  */
-static void ptrace_untrace(struct task_struct *child)
+void __ptrace_unlink(struct task_struct *child)
 {
+	BUG_ON(!child->ptrace);
+
+	child->ptrace = 0;
+	child->parent = child->real_parent;
+	list_del_init(&child->ptrace_entry);
+
 	spin_lock(&child->sighand->siglock);
 	if (task_is_traced(child)) {
 		/*
@@ -70,24 +78,6 @@ static void ptrace_untrace(struct task_struct *child)
 }
 
 /*
- * unptrace a task: move it back to its original parent and
- * remove it from the ptrace list.
- *
- * Must be called with the tasklist lock write-held.
- */
-void __ptrace_unlink(struct task_struct *child)
-{
-	BUG_ON(!child->ptrace);
-
-	child->ptrace = 0;
-	child->parent = child->real_parent;
-	list_del_init(&child->ptrace_entry);
-
-	if (task_is_traced(child))
-		ptrace_untrace(child);
-}
-
-/*
  * Check that we have indeed attached to the thing..
  */
 int ptrace_check_attach(struct task_struct *child, int kill)
-- 
1.7.1

