Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab1GDFeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 01:34:18 -0400
Received: from ozlabs.org ([203.10.76.45]:44085 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab1GDFeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 01:34:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: module: sysfs - add 'uevent' file to allow coldplug
In-Reply-To: <BANLkTimmTpcPefmWz=H7+4R6-7o4dZ+hnQ@mail.gmail.com>
References: <1308434431.1050.5.camel@mop> <8739j59zib.fsf@rustcorp.com.au> <BANLkTink8YTe=-Tr5Ax3epiFoFCfzcex7w@mail.gmail.com> <87boxshrwe.fsf@rustcorp.com.au> <BANLkTinL4r3RfNuA5x6=UK4DCSSJNeZw7w@mail.gmail.com> <87r56m8w2b.fsf@rustcorp.com.au> <BANLkTimNpDdp+JBXt0wUjuc0awypJSvXRg@mail.gmail.com> <87fwn18k9h.fsf@rustcorp.com.au> <BANLkTi=v-axftYKJCJ33+9UnfF9NJDAykQ@mail.gmail.com> <BANLkTimmTpcPefmWz=H7+4R6-7o4dZ+hnQ@mail.gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 04 Jul 2011 14:35:39 +0930
Message-ID: <87hb72skik.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011 05:07:41 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Thu, Jun 23, 2011 at 13:24, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > On Thu, Jun 23, 2011 at 02:27, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >> On Wed, 22 Jun 2011 12:17:49 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
> >>> On Wed, Jun 22, 2011 at 04:00, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >> I'd prefer that patch first, I think: it's a sensible cleanup.
> >
> > You want the patch split up in two? You want to remove the mod
> > parameter somehow?
> 
> Can we get these 20 lines of code sorted out please? :)

An odd question, since I was waiting for you to do exactly that!

Rather than go around again, I have:
1) Split the patch into one which changes the attr functions, and one
   which adds the uevent file.
2) Fixed the title of the (second) patch to "module: add
   /sys/module/<name>/uevent files"
3) Fixed up the three checkpatch.pl errors (sure, 2 were just code
   moves, but we're slowly neatening things).

Here they are below, back-to-back.

Thanks,
Rusty.

Subject: module: change attr callbacks to take struct module_kobject

This simplifies the next patch, where we have an attribute on a
builtin module (ie. module == NULL).

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (split into 2)
---
 include/linux/module.h |   23 ++++++++++++-----------
 kernel/module.c        |   14 +++++++-------
 kernel/params.c        |   10 +++++-----
 3 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -48,10 +48,18 @@ struct modversion_info
 
 struct module;
 
+struct module_kobject {
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
+	ssize_t (*show)(struct module_attribute *, struct module_kobject *,
+			char *);
+	ssize_t (*store)(struct module_attribute *, struct module_kobject *,
 			 const char *, size_t count);
 	void (*setup)(struct module *, const char *);
 	int (*test)(struct module *);
@@ -65,15 +72,8 @@ struct module_version_attribute {
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
 
 /* These are either module local, or the kernel's dummy ones. */
 extern int init_module(void);
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -545,9 +545,9 @@ static void setup_modinfo_##field(struct
 	mod->field = kstrdup(s, GFP_KERNEL);                          \
 }                                                                     \
 static ssize_t show_modinfo_##field(struct module_attribute *mattr,   \
-	                struct module *mod, char *buffer)             \
+			struct module_kobject *mk, char *buffer)      \
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
@@ -952,11 +952,11 @@ static inline int module_unload_init(str
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
@@ -1187,7 +1187,7 @@ struct module_sect_attrs
 };
 
 static ssize_t module_sect_show(struct module_attribute *mattr,
-				struct module *mod, char *buf)
+				struct module_kobject *mk, char *buf)
 {
 	struct module_sect_attr *sattr =
 		container_of(mattr, struct module_sect_attr, mattr);
diff --git a/kernel/params.c b/kernel/params.c
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
@@ -531,7 +531,7 @@ static ssize_t param_attr_show(struct mo
 
 /* sysfs always hands a nul-terminated string in buf.  We rely on that. */
 static ssize_t param_attr_store(struct module_attribute *mattr,
-				struct module *owner,
+				struct module_kobject *km,
 				const char *buf, size_t len)
 {
  	int err;
@@ -807,7 +807,7 @@ static void __init param_sysfs_builtin(v
 }
 
 ssize_t __modver_version_show(struct module_attribute *mattr,
-			      struct module *mod, char *buf)
+			      struct module_kobject *mk, char *buf)
 {
 	struct module_version_attribute *vattr =
 		container_of(mattr, struct module_version_attribute, mattr);
@@ -852,7 +852,7 @@ static ssize_t module_attr_show(struct k
 	if (!attribute->show)
 		return -EIO;
 
-	ret = attribute->show(attribute, mk->mod, buf);
+	ret = attribute->show(attribute, mk, buf);
 
 	return ret;
 }
@@ -871,7 +871,7 @@ static ssize_t module_attr_store(struct 
 	if (!attribute->store)
 		return -EIO;
 
-	ret = attribute->store(attribute, mk->mod, buf, len);
+	ret = attribute->store(attribute, mk, buf, len);
 
 	return ret;
 }


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: module: add /sys/module/<name>/uevent files

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
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (split)
---
 include/linux/module.h |    1 +
 kernel/module.c        |   17 +++++++++++++++++
 kernel/params.c        |    2 ++
 3 files changed, 20 insertions(+)

diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -74,6 +74,7 @@ struct module_version_attribute {
 extern ssize_t __modver_version_show(struct module_attribute *,
 				     struct module_kobject *, char *);
 
+extern struct module_attribute module_uevent;
 
 /* These are either module local, or the kernel's dummy ones. */
 extern int init_module(void);
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -975,10 +975,27 @@ static struct module_attribute initstate
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
diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -730,6 +730,8 @@ static struct module_kobject * __init lo
 		mk->kobj.kset = module_kset;
 		err = kobject_init_and_add(&mk->kobj, &module_ktype, NULL,
 					   "%s", name);
+		if (!err)
+			err = sysfs_create_file(&mk->kobj, &module_uevent.attr);
 		if (err) {
 			kobject_put(&mk->kobj);
 			printk(KERN_ERR
