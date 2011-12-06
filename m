Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1LFTNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:13:48 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48902 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab1LFTNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:13:08 -0500
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 22/25] dynamic_debug: protect "dyndbg" fake module param name at compile-time
Date: Tue,  6 Dec 2011 12:11:32 -0700
Message-Id: <1323198694-7186-23-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com>
 <1323198694-7186-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Add BUILD_BUG_DECL(name, cond) to cause compile error if condition is
true.  Unlike other flavors of BUILD_BUG_*, this works at file scope;
it declares an unused 0-sized var: __BUILD_BUG_DECL_##name, whose
declaration is readily found if compile errors happen.

Use this macro in module_param_named() to insure that "dyndbg" is
reserved and not used by modules as a param name, and drop the
run-time check for same.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/kernel.h      |   10 ++++++++++
 include/linux/moduleparam.h |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e8b1597..62f210b 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -665,6 +665,7 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 #define BUILD_BUG_ON_ZERO(e) (0)
 #define BUILD_BUG_ON_NULL(e) ((void*)0)
 #define BUILD_BUG_ON(condition)
+#define BUILD_BUG_DECL(name, condition)
 #else /* __CHECKER__ */
 
 /* Force a compilation error if a constant expression is not a power of 2 */
@@ -703,6 +704,15 @@ extern int __build_bug_on_failed;
 		if (condition) __build_bug_on_failed = 1;	\
 	} while(0)
 #endif
+/* 
+ * BUILD_BUG_DECL is usable at file scope (by avoiding do {} loop).
+ * If condition is true, causes a compile error, otherwize it declares
+ * a 0-sized array (so it doesn't waste space)
+ */
+#define BUILD_BUG_DECL(name, condition)					\
+	static struct __BUILD_BUG_DECL_ ##name {			\
+		int __BUILD_BUG_DECL_ ##name[1 - 2*!!(condition)];	\
+  } __BUILD_BUG_DECL_ ##name[0] __attribute__((unused))
 #endif	/* __CHECKER__ */
 
 /* Trap pasters of __FUNCTION__ at compile-time */
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 91bd56a..da24b78 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -118,6 +118,7 @@ struct kparam_array
  * structure.  This allows exposure under a different name.
  */
 #define module_param_named(name, value, type, perm)			   \
+	BUILD_BUG_DECL(name, !__builtin_strcmp(#name, "dyndbg"));	   \
 	param_check_##type(name, &(value));				   \
 	module_param_cb(name, &param_ops_##type, &value, perm);		   \
 	__MODULE_PARM_TYPE(name, #type)
-- 
1.7.7.3

