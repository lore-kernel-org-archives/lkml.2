Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab2BAUZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 15:25:24 -0500
Received: from mga06.intel.com ([134.134.136.21]:50384 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755025Ab2BAUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 15:25:21 -0500
From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
To: linux-security-module@vger.kernel.org
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: [RFC][PATCH v1 1/2] integrity: add ima_module_check hook
Date: Wed,  1 Feb 2012 22:25:03 +0200
Message-Id: <3699a6ea9f31f0d987eae1d1c113cccc84d4a41d.1328122362.git.dmitry.kasatkin@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <cover.1328122362.git.dmitry.kasatkin@intel.com>
References: <cover.1328122362.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1328122362.git.dmitry.kasatkin@intel.com>
References: <cover.1328122362.git.dmitry.kasatkin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMA measures/appraises modules when modprobe or insmod opens and read them.
Unfortunately, there are no guarantees between what is read by userspace and
what is passed to the kernel via load_module system call. This patch adds a
hook called module_check() to verify the integrity of the module being loaded.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 include/linux/integrity.h |   10 ++++++++++
 kernel/module.c           |   20 +++++++++++++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/include/linux/integrity.h b/include/linux/integrity.h
index 66c5fe9..68419d4 100644
--- a/include/linux/integrity.h
+++ b/include/linux/integrity.h
@@ -37,4 +37,14 @@ static inline void integrity_inode_free(struct inode *inode)
 	return;
 }
 #endif /* CONFIG_INTEGRITY_H */
+
+#ifdef CONFIG_INTEGRITY_MODULES
+int module_check(const void *hdr, const unsigned long len, char **args);
+#else
+static inline int module_check(const void *buf, unsigned long len, char **args)
+{
+	return 0;
+}
+#endif
+
 #endif /* _LINUX_INTEGRITY_H */
diff --git a/kernel/module.c b/kernel/module.c
index 2c93276..9d97928 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -58,6 +58,7 @@
 #include <linux/jump_label.h>
 #include <linux/pfn.h>
 #include <linux/bsearch.h>
+#include <linux/integrity.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/module.h>
@@ -2839,6 +2840,7 @@ static struct module *load_module(void __user *umod,
 	struct load_info info = { NULL, };
 	struct module *mod;
 	long err;
+	char *args = NULL;
 
 	pr_debug("load_module: umod=%p, len=%lu, uargs=%p\n",
 	       umod, len, uargs);
@@ -2848,6 +2850,16 @@ static struct module *load_module(void __user *umod,
 	if (err)
 		return ERR_PTR(err);
 
+	args = strndup_user(uargs, ~0UL >> 1);
+	if (IS_ERR(args)) {
+		err = PTR_ERR(args);
+		goto free_copy;
+	}
+
+	err = module_check(info.hdr, info.len, &args);
+	if (err < 0)
+		goto free_copy;
+
 	/* Figure out module layout, and allocate all the memory. */
 	mod = layout_and_allocate(&info);
 	if (IS_ERR(mod)) {
@@ -2887,11 +2899,8 @@ static struct module *load_module(void __user *umod,
 	flush_module_icache(mod);
 
 	/* Now copy in args */
-	mod->args = strndup_user(uargs, ~0UL >> 1);
-	if (IS_ERR(mod->args)) {
-		err = PTR_ERR(mod->args);
-		goto free_arch_cleanup;
-	}
+	mod->args = args;
+	args = NULL;
 
 	/* Mark state as coming so strong_try_module_get() ignores us. */
 	mod->state = MODULE_STATE_COMING;
@@ -2959,6 +2968,7 @@ static struct module *load_module(void __user *umod,
  free_module:
 	module_deallocate(mod, &info);
  free_copy:
+	kfree(args);
 	free_copy(&info);
 	return ERR_PTR(err);
 }
-- 
1.7.5.4

