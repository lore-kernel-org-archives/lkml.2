Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1FRWAg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 18:00:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60459 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1FRWAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 18:00:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=subject:from:to:cc:date:content-type:x-mailer
         :content-transfer-encoding:message-id:mime-version;
        b=icTQWKng5t0wSnflgbXkZyXP2PV0GA36UGk4nNezpaIZ/8okYc4yHp7qH7IlX8EYqs
         xwVLo/0rec3W+nYwDV63az7r8tEFTI8NzlmjM5nGzzqDLPDu0Coyt3qSsTtxQ9GvW3cJ
         nnsAX2huDaP6fwXNKftfR4TWgDECSaciDFCHU=
Subject: module: sysfs - add 'uevent' file to allow coldplug
From: Kay Sievers <kay.sievers@vrfy.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Date: Sun, 19 Jun 2011 00:00:29 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1308434431.1050.5.camel@mop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: module: sysfs - add 'uevent' file to allow built-in coldplug

Userspace wants to manage module parameters with udev rules.
This currently only works for loaded modules, but not for
built-in ones.

To allow access to the built-in modules we need to
re-trigger all module load events that happened before any
userspace was running. We already do the same thing for all
devices, subsystems(buses) and drivers.

This adds the currently missing /sys/module/<name>/uevent files
to all module entries.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

 include/linux/module.h |   24 +++++++++++++-----------
 kernel/module.c        |   31 ++++++++++++++++++++++++-------
 kernel/params.c        |   12 +++++++-----
 3 files changed, 44 insertions(+), 23 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index d9ca2d5..ac6975c 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -48,10 +48,18 @@ struct modversion_info
 
 struct module;
 
+struct module_kobject
+{
+	struct kobject kobj;
+	struct module *mod;
+	struct kobject *drivers_dir;
+	struct module_param_attrs *mp;
+};
+
 struct module_attribute {
-        struct attribute attr;
-        ssize_t (*show)(struct module_attribute *, struct module *, char *);
-        ssize_t (*store)(struct module_attribute *, struct module *,
+	struct attribute attr;
+	ssize_t (*show)(struct module_attribute *, struct module_kobject *, char *);
+	ssize_t (*store)(struct module_attribute *, struct module_kobject *,
 			 const char *, size_t count);
 	void (*setup)(struct module *, const char *);
 	int (*test)(struct module *);
@@ -65,15 +73,9 @@ struct module_version_attribute {
 } __attribute__ ((__aligned__(sizeof(void *))));
 
 extern ssize_t __modver_version_show(struct module_attribute *,
-				     struct module *, char *);
+				     struct module_kobject *, char *);
 
-struct module_kobject
-{
-	struct kobject kobj;
-	struct module *mod;
-	struct kobject *drivers_dir;
-	struct module_param_attrs *mp;
-};
+extern struct module_attribute module_uevent;
 
 /* These are either module local, or the kernel's dummy ones. */
 extern int init_module(void);
diff --git a/kernel/module.c b/kernel/module.c
index 795bdc7..2f0d562 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -545,9 +545,9 @@ static void setup_modinfo_##field(struct module *mod, const char *s)  \
 	mod->field = kstrdup(s, GFP_KERNEL);                          \
 }                                                                     \
 static ssize_t show_modinfo_##field(struct module_attribute *mattr,   \
-	                struct module *mod, char *buffer)             \
+	                struct module_kobject *mk, char *buffer)      \
 {                                                                     \
-	return sprintf(buffer, "%s\n", mod->field);                   \
+	return sprintf(buffer, "%s\n", mk->mod->field);               \
 }                                                                     \
 static int modinfo_##field##_exists(struct module *mod)               \
 {                                                                     \
@@ -902,9 +902,9 @@ void symbol_put_addr(void *addr)
 EXPORT_SYMBOL_GPL(symbol_put_addr);
 
 static ssize_t show_refcnt(struct module_attribute *mattr,
-			   struct module *mod, char *buffer)
+			   struct module_kobject *mk, char *buffer)
 {
-	return sprintf(buffer, "%u\n", module_refcount(mod));
+	return sprintf(buffer, "%u\n", module_refcount(mk->mod));
 }
 
 static struct module_attribute refcnt = {
@@ -952,11 +952,11 @@ static inline int module_unload_init(struct module *mod)
 #endif /* CONFIG_MODULE_UNLOAD */
 
 static ssize_t show_initstate(struct module_attribute *mattr,
-			   struct module *mod, char *buffer)
+			      struct module_kobject *mk, char *buffer)
 {
 	const char *state = "unknown";
 
-	switch (mod->state) {
+	switch (mk->mod->state) {
 	case MODULE_STATE_LIVE:
 		state = "live";
 		break;
@@ -975,10 +975,27 @@ static struct module_attribute initstate = {
 	.show = show_initstate,
 };
 
+static ssize_t store_uevent(struct module_attribute *mattr,
+			    struct module_kobject *mk,
+			    const char *buffer, size_t count)
+{
+	enum kobject_action action;
+
+	if (kobject_action_type(buffer, count, &action) == 0)
+		kobject_uevent(&mk->kobj, action);
+	return count;
+}
+
+struct module_attribute module_uevent = {
+	.attr = { .name = "uevent", .mode = 0200 },
+	.store = store_uevent,
+};
+
 static struct module_attribute *modinfo_attrs[] = {
 	&modinfo_version,
 	&modinfo_srcversion,
 	&initstate,
+	&module_uevent,
 #ifdef CONFIG_MODULE_UNLOAD
 	&refcnt,
 #endif
@@ -1187,7 +1204,7 @@ struct module_sect_attrs
 };
 
 static ssize_t module_sect_show(struct module_attribute *mattr,
-				struct module *mod, char *buf)
+				struct module_kobject *mk, char *buf)
 {
 	struct module_sect_attr *sattr =
 		container_of(mattr, struct module_sect_attr, mattr);
diff --git a/kernel/params.c b/kernel/params.c
index ed72e13..d2f02ca 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -511,7 +511,7 @@ struct module_param_attrs
 #define to_param_attr(n) container_of(n, struct param_attribute, mattr)
 
 static ssize_t param_attr_show(struct module_attribute *mattr,
-			       struct module *mod, char *buf)
+			       struct module_kobject *mk, char *buf)
 {
 	int count;
 	struct param_attribute *attribute = to_param_attr(mattr);
@@ -531,7 +531,7 @@ static ssize_t param_attr_show(struct module_attribute *mattr,
 
 /* sysfs always hands a nul-terminated string in buf.  We rely on that. */
 static ssize_t param_attr_store(struct module_attribute *mattr,
-				struct module *owner,
+				struct module_kobject *km,
 				const char *buf, size_t len)
 {
  	int err;
@@ -730,6 +730,8 @@ static struct module_kobject * __init locate_module_kobject(const char *name)
 		mk->kobj.kset = module_kset;
 		err = kobject_init_and_add(&mk->kobj, &module_ktype, NULL,
 					   "%s", name);
+		if (!err)
+			err = sysfs_create_file(&mk->kobj, &module_uevent.attr);
 		if (err) {
 			kobject_put(&mk->kobj);
 			printk(KERN_ERR
@@ -807,7 +809,7 @@ static void __init param_sysfs_builtin(void)
 }
 
 ssize_t __modver_version_show(struct module_attribute *mattr,
-			      struct module *mod, char *buf)
+			      struct module_kobject *mk, char *buf)
 {
 	struct module_version_attribute *vattr =
 		container_of(mattr, struct module_version_attribute, mattr);
@@ -852,7 +854,7 @@ static ssize_t module_attr_show(struct kobject *kobj,
 	if (!attribute->show)
 		return -EIO;
 
-	ret = attribute->show(attribute, mk->mod, buf);
+	ret = attribute->show(attribute, mk, buf);
 
 	return ret;
 }
@@ -871,7 +873,7 @@ static ssize_t module_attr_store(struct kobject *kobj,
 	if (!attribute->store)
 		return -EIO;
 
-	ret = attribute->store(attribute, mk->mod, buf, len);
+	ret = attribute->store(attribute, mk, buf, len);
 
 	return ret;
 }


