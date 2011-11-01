Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab1KAXwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:52:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52315 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab1KAXv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:51:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization;
	b=X3eXgfq9juHNW6CU41FwLs43Z2KUO+ryt24fqYaHTos0jShl5g2VDR92qFmcKxRfc
	nHJmtGpdvph2DDz6Q7rXg==
From: David Decotigny <david.decotigny@google.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Michal Schmidt <mschmidt@redhat.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Dmitry Torokhov <dtor@vmware.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Satoru Moriya <satoru.moriya@hds.com>,
        David Decotigny <decot@google.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH v2 2/3] param: simple refactoring
Date: Tue,  1 Nov 2011 16:50:34 -0700
Message-Id: <6e4eb7cacd383e2d2a030e7bd323edcc0dec8fef.1320191327.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320191327.git.david.decotigny@google.com>
References: <cover.1320191327.git.david.decotigny@google.com>
In-Reply-To: <cover.1320191327.git.david.decotigny@google.com>
References: <cover.1320191327.git.david.decotigny@google.com>
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@google.com>

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

