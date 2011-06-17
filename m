Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1FQOvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:51:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47581 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759301Ab1FQOut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:50:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=vJNHBGfYO2cMT6I5wycU/WE2voYqelCj1Pg3m8n6mm4XWQyS+If/qBWD9/Ptc22L5G
         aRF5ixg7lBDnjssjk5kjkQXvqP+M/FSxmPUy0yE4ssVRi+XbKXpcxuESRIa8zF5Lqsmg
         oCQ2bTQwYnRy4FhnhZNaiTTSQhRxtzGuRDNek=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, oleg@redhat.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        hch@infradead.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] ptrace: move SIGTRAP on exec(2) logic to ptrace_event()
Date: Fri, 17 Jun 2011 16:50:36 +0200
Message-Id: <1308322240-8247-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308322240-8247-1-git-send-email-tj@kernel.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move SIGTRAP on exec(2) logic from tracehook_report_exec() to
ptrace_event().  This is part of changes to make ptrace_event()
smarter and handle ptrace event related details in one place.

This doesn't introduce any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/ptrace.h    |   16 ++++++++--------
 include/linux/tracehook.h |    4 +---
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 18feac6..b546fd6 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -172,17 +172,17 @@ static inline bool ptrace_event_enabled(struct task_struct *task, int event)
  * Check whether @event is enabled and, if so, report @event and @message
  * to the ptrace parent.
  *
- * Returns nonzero if we did a ptrace notification, zero if not.
- *
  * Called without locks.
  */
-static inline int ptrace_event(int event, unsigned long message)
+static inline void ptrace_event(int event, unsigned long message)
 {
-	if (likely(!ptrace_event_enabled(current, event)))
-		return false;
-	current->ptrace_message = message;
-	ptrace_notify((event << 8) | SIGTRAP);
-	return true;
+	if (unlikely(ptrace_event_enabled(current, event))) {
+		current->ptrace_message = message;
+		ptrace_notify((event << 8) | SIGTRAP);
+	} else if (event == PTRACE_EVENT_EXEC && unlikely(current->ptrace)) {
+		/* legacy EXEC report via SIGTRAP */
+		send_sig(SIGTRAP, current, 0);
+	}
 }
 
 /**
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 7d38571..3b68aa8 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -201,9 +201,7 @@ static inline void tracehook_report_exec(struct linux_binfmt *fmt,
 					 struct linux_binprm *bprm,
 					 struct pt_regs *regs)
 {
-	if (!ptrace_event(PTRACE_EVENT_EXEC, 0) &&
-	    unlikely(current->ptrace & PT_PTRACED))
-		send_sig(SIGTRAP, current, 0);
+	ptrace_event(PTRACE_EVENT_EXEC, 0);
 }
 
 /**
-- 
1.7.5.4

