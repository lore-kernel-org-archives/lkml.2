Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab1HGRzS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 13:55:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39160 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab1HGRzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 13:55:14 -0400
Date: Sun, 7 Aug 2011 18:55:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: fix rcu annotations noise in cred.h
Message-ID: <20110807175511.GZ2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task->cred is declared as __rcu, and access to other tasks' ->cred is,
indeed, protected.  Access to current->cred does not need rcu_dereference()
at all, since only the task itself can change its ->cred.  sparse, of
course, has no way of knowing that...

Add force-cast in current_cred(), make current_fsuid() et.al. use it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 48e82af..98f46ef 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -265,10 +265,11 @@ static inline void put_cred(const struct cred *_cred)
 /**
  * current_cred - Access the current task's subjective credentials
  *
- * Access the subjective credentials of the current task.
+ * Access the subjective credentials of the current task.  RCU-safe,
+ * since nobody else can modify it.
  */
 #define current_cred() \
-	(current->cred)
+	(*(__force struct cred **)&current->cred)
 
 /**
  * __task_cred - Access a task's objective credentials
@@ -307,7 +308,7 @@ static inline void put_cred(const struct cred *_cred)
 ({							\
 	struct user_struct *__u;			\
 	struct cred *__cred;				\
-	__cred = (struct cred *) current_cred();	\
+	__cred = current_cred();			\
 	__u = get_uid(__cred->user);			\
 	__u;						\
 })
@@ -322,7 +323,7 @@ static inline void put_cred(const struct cred *_cred)
 ({							\
 	struct group_info *__groups;			\
 	struct cred *__cred;				\
-	__cred = (struct cred *) current_cred();	\
+	__cred = current_cred();			\
 	__groups = get_group_info(__cred->group_info);	\
 	__groups;					\
 })
@@ -341,7 +342,7 @@ static inline void put_cred(const struct cred *_cred)
 
 #define current_cred_xxx(xxx)			\
 ({						\
-	current->cred->xxx;			\
+	current_cred()->xxx;			\
 })
 
 #define current_uid()		(current_cred_xxx(uid))
