Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab1J0CXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 22:23:25 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15220 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab1J0CXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 22:23:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization;
	b=bLREIOxdvATdApAylI5p+xkONn6QpDD/MD0QWqSkTcbVMCurlJI2uPAlyuBs4nsgt
	zNJ4l9/OlXmrKdg6LLbBw==
From: David Decotigny <david.decotigny@google.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Randy Dunlap <rdunlap@xenotime.net>,
        Michal Schmidt <mschmidt@redhat.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH v1 2/3] param: simple refactoring
Date: Wed, 26 Oct 2011 19:22:26 -0700
Message-Id: <d5ff2295aaa3b37523df0092b0e45d2631bf4d80.1319679966.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1319679966.git.david.decotigny@google.com>
References: <cover.1319679966.git.david.decotigny@google.com>
In-Reply-To: <cover.1319679966.git.david.decotigny@google.com>
References: <cover.1319679966.git.david.decotigny@google.com>
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moved locate_module_kobject() to limit the number of #ifdef/#endif
blocks. Also moved __modinit macro definition at the top.

Tested:
  make defconfig all
  + make all with # CONFIG_SYSFS is not set

Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 kernel/params.c |   93 ++++++++++++++++++++++++++----------------------------
 1 files changed, 45 insertions(+), 48 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 75fd7bf..b0e1668 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -31,6 +31,12 @@
 #define DEBUGP(fmt, a...)
 #endif
 
+#ifdef CONFIG_MODULES
+#define __modinit
+#else
+#define __modinit __init
+#endif
+
 /* Protects all parameters, and incidentally kmalloced_param list. */
 static DEFINE_MUTEX(param_lock);
 
@@ -515,6 +521,44 @@ struct module_param_attrs
 };
 
 #ifdef CONFIG_SYSFS
+static struct module_kobject * __init locate_module_kobject(const char *name)
+{
+	struct module_kobject *mk;
+	struct kobject *kobj;
+	int err;
+
+	kobj = kset_find_obj(module_kset, name);
+	if (kobj) {
+		mk = to_module_kobject(kobj);
+	} else {
+		mk = kzalloc(sizeof(struct module_kobject), GFP_KERNEL);
+		BUG_ON(!mk);
+
+		mk->mod = THIS_MODULE;
+		mk->kobj.kset = module_kset;
+		err = kobject_init_and_add(&mk->kobj, &module_ktype, NULL,
+					   "%s", name);
+#ifdef CONFIG_MODULES
+		if (!err)
+			err = sysfs_create_file(&mk->kobj, &module_uevent.attr);
+#endif
+		if (err) {
+			kobject_put(&mk->kobj);
+			printk(KERN_ERR
+				"Module '%s' failed add to sysfs, error number %d\n",
+				name, err);
+			printk(KERN_ERR
+				"The system will be unstable now.\n");
+			return NULL;
+		}
+
+		/* So that we hold reference in both cases. */
+		kobject_get(&mk->kobj);
+	}
+
+	return mk;
+}
+
 #define to_param_attr(n) container_of(n, struct param_attribute, mattr)
 
 static ssize_t param_attr_show(struct module_attribute *mattr,
@@ -554,15 +598,7 @@ static ssize_t param_attr_store(struct module_attribute *mattr,
 		return len;
 	return err;
 }
-#endif
-
-#ifdef CONFIG_MODULES
-#define __modinit
-#else
-#define __modinit __init
-#endif
 
-#ifdef CONFIG_SYSFS
 void __kernel_param_lock(void)
 {
 	mutex_lock(&param_lock);
@@ -709,46 +745,7 @@ void module_param_sysfs_remove(struct module *mod)
 		free_module_param_attrs(&mod->mkobj);
 	}
 }
-#endif
-
-
-static struct module_kobject * __init locate_module_kobject(const char *name)
-{
-	struct module_kobject *mk;
-	struct kobject *kobj;
-	int err;
-
-	kobj = kset_find_obj(module_kset, name);
-	if (kobj) {
-		mk = to_module_kobject(kobj);
-	} else {
-		mk = kzalloc(sizeof(struct module_kobject), GFP_KERNEL);
-		BUG_ON(!mk);
-
-		mk->mod = THIS_MODULE;
-		mk->kobj.kset = module_kset;
-		err = kobject_init_and_add(&mk->kobj, &module_ktype, NULL,
-					   "%s", name);
-#ifdef CONFIG_MODULES
-		if (!err)
-			err = sysfs_create_file(&mk->kobj, &module_uevent.attr);
-#endif
-		if (err) {
-			kobject_put(&mk->kobj);
-			printk(KERN_ERR
-				"Module '%s' failed add to sysfs, error number %d\n",
-				name, err);
-			printk(KERN_ERR
-				"The system will be unstable now.\n");
-			return NULL;
-		}
-
-		/* So that we hold reference in both cases. */
-		kobject_get(&mk->kobj);
-	}
-
-	return mk;
-}
+#endif /* CONFIG_MODULES */
 
 static void __init kernel_add_sysfs_param(const char *name,
 					  struct kernel_param *kparam,
-- 
1.7.3.1

