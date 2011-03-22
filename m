Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1CVKUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:20:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34129 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab1CVKUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:20:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pC4vuDFYdAGoClMeOeC30n/HLDrvCP8DZhqsod7TsjJakJYjP3cSxrwOcgnpylNS13
         1fewsuiGx0cuAIpcbgjvxirBMup4Nc5RHxpqx7wrRrQRveEKqQmdDjualXp9qYMa1T5t
         DzEshDbGd8NscwHJ3fzrdf2KTqs3hOleHIO3M=
Date: Tue, 22 Mar 2011 11:20:10 +0100
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        vda.linux@googlemail.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: [PATCH 0.1/8] ptrace: Collapse ptrace_untrace() into
 __ptrace_unlink()
Message-ID: <20110322102010.GN12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299614199-25142-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
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
---
 kernel/ptrace.c |   40 +++++++++++++++-------------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

Index: work/kernel/ptrace.c
===================================================================
--- work.orig/kernel/ptrace.c
+++ work/kernel/ptrace.c
@@ -37,15 +37,23 @@ void __ptrace_link(struct task_struct *c
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
@@ -70,24 +78,6 @@ static void ptrace_untrace(struct task_s
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
