Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab0EAOgc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:36:32 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:64007 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab0EAOfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:35:46 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Smith <danms@us.ibm.com>
Subject: [PATCH v21 069/100] Expose may_setuid() in user.h and add may_setgid() (v2)
Date: Sat,  1 May 2010 10:15:51 -0400
Message-Id: <1272723382-19470-70-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Smith <danms@us.ibm.com>

Make these helpers available to others.

Changes in v2:
 - Avoid checking the groupinfo in ctx->realcred against the current in
   may_setgid()

Signed-off-by: Dan Smith <danms@us.ibm.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
---
 include/linux/user.h |    9 +++++++++
 kernel/user.c        |   13 ++++++++++++-
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/include/linux/user.h b/include/linux/user.h
index 68daf84..c231e9c 100644
--- a/include/linux/user.h
+++ b/include/linux/user.h
@@ -1 +1,10 @@
+#ifndef _LINUX_USER_H
+#define _LINUX_USER_H
+
 #include <asm/user.h>
+#include <linux/sched.h>
+
+extern int may_setuid(struct user_namespace *ns, uid_t uid);
+extern int may_setgid(gid_t gid);
+
+#endif
diff --git a/kernel/user.c b/kernel/user.c
index 4d1fda6..c546fee 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -279,7 +279,7 @@ static int checkpoint_user(struct ckpt_ctx *ctx, void *ptr)
 	return do_checkpoint_user(ctx, (struct user_struct *) ptr);
 }
 
-static int may_setuid(struct user_namespace *ns, uid_t uid)
+int may_setuid(struct user_namespace *ns, uid_t uid)
 {
 	/*
 	 * this next check will one day become
@@ -306,6 +306,17 @@ static int may_setuid(struct user_namespace *ns, uid_t uid)
 	return 0;
 }
 
+int may_setgid(gid_t gid)
+{
+	if (capable(CAP_SETGID))
+		return 1;
+
+	if (in_egroup_p(gid))
+		return 1;
+
+	return 0;
+}
+
 static struct user_struct *do_restore_user(struct ckpt_ctx *ctx)
 {
 	struct user_struct *u;
-- 
1.6.3.3

