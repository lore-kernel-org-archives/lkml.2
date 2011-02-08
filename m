Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab1BHACh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 19:02:37 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:56909 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755178Ab1BHACf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 19:02:35 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Miller <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: [PATCH 1/3] module: deal with alignment issues in built-in module versions
Date: Mon,  7 Feb 2011 16:02:25 -0800
Message-Id: <1297123347-2170-1-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On m68k natural alignment is 2-byte boundary but we are trying to
align structures in __modver section on sizeof(void *) boundary.
This causes trouble when we try to access elements in this section
in array-like fashion when create "version" attributes for built-in
modules.

Moreover, as DaveM said, we can't reliably put structures into
independent objects, put them into a special section, and then expect
array access over them (via the section boundaries) after linking the
objects together to just "work" due to variable alignment choices in
different situations. The only solution that seems to work reliably
is to make an array of plain pointers to the objects in question and
put those pointers in the special section.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 include/linux/module.h |   10 +++++-----
 kernel/params.c        |    9 ++++++---
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 9bdf27c..9b7081a 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -174,10 +174,7 @@ extern struct module __this_module;
 #define MODULE_VERSION(_version)					\
 	extern ssize_t __modver_version_show(struct module_attribute *,	\
 					     struct module *, char *);	\
-	static struct module_version_attribute __modver_version_attr	\
-	__used								\
-    __attribute__ ((__section__ ("__modver"),aligned(sizeof(void *)))) \
-	= {								\
+	static struct module_version_attribute ___modver_attr = {	\
 		.mattr	= {						\
 			.attr	= {					\
 				.name	= "version",			\
@@ -187,7 +184,10 @@ extern struct module __this_module;
 		},							\
 		.module_name	= KBUILD_MODNAME,			\
 		.version	= _version,				\
-	}
+	};								\
+	static const struct module_version_attribute			\
+	__used __attribute__ ((__section__ ("__modver")))		\
+	* __moduleparam_const __modver_attr = &___modver_attr
 #endif
 
 /* Optional firmware file (or files) needed by the module
diff --git a/kernel/params.c b/kernel/params.c
index 0da1411..09a08cb 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -821,15 +821,18 @@ ssize_t __modver_version_show(struct module_attribute *mattr,
 	return sprintf(buf, "%s\n", vattr->version);
 }
 
-extern struct module_version_attribute __start___modver[], __stop___modver[];
+extern const struct module_version_attribute *__start___modver[];
+extern const struct module_version_attribute *__stop___modver[];
 
 static void __init version_sysfs_builtin(void)
 {
-	const struct module_version_attribute *vattr;
+	const struct module_version_attribute **p;
 	struct module_kobject *mk;
 	int err;
 
-	for (vattr = __start___modver; vattr < __stop___modver; vattr++) {
+	for (p = __start___modver; p < __stop___modver; p++) {
+		const struct module_version_attribute *vattr = *p;
+
 		mk = locate_module_kobject(vattr->module_name);
 		if (mk) {
 			err = sysfs_create_file(&mk->kobj, &vattr->mattr.attr);
-- 
1.7.3.2

