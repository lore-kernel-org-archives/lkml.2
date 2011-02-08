Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab1BHACk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 19:02:40 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:56915 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755410Ab1BHACh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 19:02:37 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Miller <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: [PATCH 2/3] module: deal with alignment issues in built-in module parameters
Date: Mon,  7 Feb 2011 16:02:26 -0800
Message-Id: <1297123347-2170-2-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1297123347-2170-1-git-send-email-dtor@vmware.com>
References: <1297123347-2170-1-git-send-email-dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As DaveM said, we can't reliably put structures into independent
objects, put them into a special section, and then expect array
access over them (via the section boundaries) after linking the
objects together to just "work" due to variable alignment choices
in different situations. The only solution that seems to work
reliably is to make an array of plain pointers to the objects in
question and put those pointers in the special section.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 include/linux/moduleparam.h |   14 ++++++++------
 kernel/params.c             |   10 ++++++----
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 07b4195..05b92c0 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -147,15 +147,17 @@ struct kparam_array
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
 	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
 	static const char __param_str_##name[] = prefix #name;		\
-	static struct kernel_param __moduleparam_const __param_##name	\
-	__used								\
-    __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
-	= { __param_str_##name, ops, perm, isbool ? KPARAM_ISBOOL : 0,	\
-	    { arg } }
+	static const struct kernel_param ___param_##name = {		\
+	    __param_str_##name, ops, perm, isbool ? KPARAM_ISBOOL : 0,	\
+	    { arg }							\
+	};								\
+	static const struct kernel_param				\
+	__used __attribute__ ((__section__ ("__param")))		\
+	* __moduleparam_const __param_##name = &___param_##name
 
 /* Obsolete - use module_param_cb() */
 #define module_param_call(name, set, get, arg, perm)			\
-	static struct kernel_param_ops __param_ops_##name =		\
+	static const struct kernel_param_ops __param_ops_##name =	\
 		 { (void *)set, (void *)get };				\
 	__module_param_call(MODULE_PARAM_PREFIX,			\
 			    name, &__param_ops_##name, arg,		\
diff --git a/kernel/params.c b/kernel/params.c
index 09a08cb..66f7e66 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -498,7 +498,8 @@ EXPORT_SYMBOL(param_ops_string);
 #define to_module_attr(n) container_of(n, struct module_attribute, attr)
 #define to_module_kobject(n) container_of(n, struct module_kobject, kobj)
 
-extern struct kernel_param __start___param[], __stop___param[];
+extern const struct kernel_param *__start___param[];
+extern const struct kernel_param *__stop___param[];
 
 struct param_attribute
 {
@@ -754,7 +755,7 @@ static struct module_kobject * __init locate_module_kobject(const char *name)
 }
 
 static void __init kernel_add_sysfs_param(const char *name,
-					  struct kernel_param *kparam,
+					  const struct kernel_param *kparam,
 					  unsigned int name_skip)
 {
 	struct module_kobject *mk;
@@ -789,11 +790,12 @@ static void __init kernel_add_sysfs_param(const char *name,
  */
 static void __init param_sysfs_builtin(void)
 {
-	struct kernel_param *kp;
+	const struct kernel_param **p;
 	unsigned int name_len;
 	char modname[MODULE_NAME_LEN];
 
-	for (kp = __start___param; kp < __stop___param; kp++) {
+	for (p = __start___param; p < __stop___param; p++) {
+		const struct kernel_param *kp = *p;
 		char *dot;
 
 		if (kp->perm == 0)
-- 
1.7.3.2

