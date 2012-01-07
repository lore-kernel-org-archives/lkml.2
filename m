Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab2AGPol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 10:44:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42017 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab2AGPok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 10:44:40 -0500
Message-ID: <1325951076.860.2.camel@mop>
Subject: [PATCH] modules: sysfs - export: taint, address, size
From: Kay Sievers <kay.sievers@vrfy.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Sat, 07 Jan 2012 16:44:36 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: modules: sysfs - export taint, address, size

Recent tools do not use /proc to retrieve module information. A few values
are currently missing from sysfs.

Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 kernel/module.c |   89 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 62 insertions(+), 27 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -849,6 +849,26 @@ out:
 	return ret;
 }
 
+static size_t module_flags_taint(struct module *mod, char *buf)
+{
+	size_t l = 0;
+
+	if (mod->taints & (1 << TAINT_PROPRIETARY_MODULE))
+		buf[l++] = 'P';
+	else if (mod->taints & (1 << TAINT_OOT_MODULE))
+		buf[l++] = 'O';
+	if (mod->taints & (1 << TAINT_FORCED_MODULE))
+		buf[l++] = 'F';
+	if (mod->taints & (1 << TAINT_CRAP))
+		buf[l++] = 'C';
+	/*
+	 * TAINT_FORCED_RMMOD: could be added.
+	 * TAINT_UNSAFE_SMP, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
+	 * apply to modules.
+	 */
+	return l;
+}
+
 static inline void print_unload_info(struct seq_file *m, struct module *mod)
 {
 	struct module_use *use;
@@ -907,10 +927,8 @@ static ssize_t show_refcnt(struct module
 	return sprintf(buffer, "%u\n", module_refcount(mk->mod));
 }
 
-static struct module_attribute refcnt = {
-	.attr = { .name = "refcnt", .mode = 0444 },
-	.show = show_refcnt,
-};
+static struct module_attribute refcnt =
+	__ATTR(refcnt, 0444, show_refcnt, NULL);
 
 void module_put(struct module *module)
 {
@@ -970,10 +988,8 @@ static ssize_t show_initstate(struct mod
 	return sprintf(buffer, "%s\n", state);
 }
 
-static struct module_attribute initstate = {
-	.attr = { .name = "initstate", .mode = 0444 },
-	.show = show_initstate,
-};
+static struct module_attribute module_initstate =
+	__ATTR(initstate, 0444, show_initstate, NULL);
 
 static ssize_t store_uevent(struct module_attribute *mattr,
 			    struct module_kobject *mk,
@@ -986,16 +1002,48 @@ static ssize_t store_uevent(struct modul
 	return count;
 }
 
-struct module_attribute module_uevent = {
-	.attr = { .name = "uevent", .mode = 0200 },
-	.store = store_uevent,
-};
+struct module_attribute module_uevent =
+	__ATTR(uevent, 0200, NULL, store_uevent);
+
+static ssize_t show_address(struct module_attribute *mattr,
+			    struct module_kobject *mk, char *buffer)
+{
+	return sprintf(buffer, "0x%pK\n", mk->mod->module_core);
+}
+
+struct module_attribute module_address =
+	__ATTR(address, 0444, show_address, NULL);
+
+static ssize_t show_size(struct module_attribute *mattr,
+			struct module_kobject *mk, char *buffer)
+{
+	return sprintf(buffer, "%u\n", mk->mod->init_size + mk->mod->core_size);
+}
+
+struct module_attribute module_size =
+	__ATTR(size, 0444, show_size, NULL);
+
+static ssize_t show_taint(struct module_attribute *mattr,
+			  struct module_kobject *mk, char *buffer)
+{
+	size_t l;
+
+	l = module_flags_taint(mk->mod, buffer);
+	buffer[l++] = '\n';
+	return l;
+}
+
+struct module_attribute module_taint =
+	__ATTR(taint, 0444, show_taint, NULL);
 
 static struct module_attribute *modinfo_attrs[] = {
 	&modinfo_version,
 	&modinfo_srcversion,
-	&initstate,
+	&module_initstate,
 	&module_uevent,
+	&module_address,
+	&module_size,
+	&module_taint,
 #ifdef CONFIG_MODULE_UNLOAD
 	&refcnt,
 #endif
@@ -3256,20 +3304,7 @@ static char *module_flags(struct module
 	    mod->state == MODULE_STATE_GOING ||
 	    mod->state == MODULE_STATE_COMING) {
 		buf[bx++] = '(';
-		if (mod->taints & (1 << TAINT_PROPRIETARY_MODULE))
-			buf[bx++] = 'P';
-		else if (mod->taints & (1 << TAINT_OOT_MODULE))
-			buf[bx++] = 'O';
-		if (mod->taints & (1 << TAINT_FORCED_MODULE))
-			buf[bx++] = 'F';
-		if (mod->taints & (1 << TAINT_CRAP))
-			buf[bx++] = 'C';
-		/*
-		 * TAINT_FORCED_RMMOD: could be added.
-		 * TAINT_UNSAFE_SMP, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
-		 * apply to modules.
-		 */
-
+		bx += module_flags_taint(mod, buf + bx);
 		/* Show a - for module-is-being-unloaded */
 		if (mod->state == MODULE_STATE_GOING)
 			buf[bx++] = '-';


