Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab2AJQrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:47:51 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37878 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab2AJQrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:47:49 -0500
Message-ID: <1326214063.1038.1.camel@mop>
Subject: Re: [PATCH] modules: sysfs - export: taint, address, size
From: Kay Sievers <kay.sievers@vrfy.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jon Masters <jcm@redhat.com>, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Tue, 10 Jan 2012 17:47:43 +0100
In-Reply-To: <87zkdw7ayp.fsf@rustcorp.com.au>
References: <1325951076.860.2.camel@mop> <871ur99vzf.fsf@rustcorp.com.au>
	 <CAPXgP12rUUYfRy6QB5Z4Rwdday3hNHubCsSRY4gMDYuQGs3oJg@mail.gmail.com>
	 <87zkdw7ayp.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-10 at 09:14 +1030, Rusty Russell wrote:
> On Mon, 9 Jan 2012 13:44:52 +0100, Kay Sievers <kay.sievers@vrfy.org> wrote:
> > On Mon, Jan 9, 2012 at 08:27, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > The else here is weird.  Shouldn't we leave the exclusion elsewhere?
> > 
> > You mean the 'else if ... TAINT_OOT_MODULE'?  It's a one-to-one copy
> > of the current code, which just moved up a bit.
> > 
> > Disconnect the two flags form each other?
> 
> Yes, I think so.
> 
> > > This copies a past mistake, and is definitely wrong.  Either expose both
> > > pointers and sizes, or don't include init_size here.  Sure, it'll
> > > normally be 0, but if not it's confusing...
> > 
> > Ah, good to know, mod->init_size is 0 for all modules here, so we
> > should just drop mod->init_size and maybe name the 'size' attribute to
> > 'coresize'?
> 
> If a module is still initializing, mod->init_size may well be non-zero.
> Let's rename it to coresize, and add initsize.
> 
> > > But the bigger question is: Why are we exposing these sizes?
> > > /proc/modules did since 2.2, or before, but that doesn't make it the
> > > best option...
> > 
> > Good question, I doubt it is too useful, it's just that 'lsmod' shows
> > it, so we wanted to show too.
> 
> And breaking lsmod output might kill some scripts.  So it stays.
> 
> Let's drop the address stuff though.

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: modules: sysfs - export: taint, coresize, initsize

Recent tools do not want to use /proc to retrieve module information. A few
values are currently missing from sysfs to replace the information available
in /proc/modules.

This adds /sys/module/*/{coresize,initsize,taint} attributes.

TAINT_PROPRIETARY_MODULE (P) and TAINT_OOT_MODULE (O) flags are both always
shown now, and do no longer exclude each other, also in /proc/modules.

Replace the open-coded sysfs attribute initializers with the __ATTR() macro.

Add the new attributes to Documentation/ABI.

Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 Documentation/ABI/testing/sysfs-module |   16 +++++
 kernel/module.c                        |   93 ++++++++++++++++++++++-----------
 2 files changed, 80 insertions(+), 29 deletions(-)

--- a/Documentation/ABI/testing/sysfs-module
+++ b/Documentation/ABI/testing/sysfs-module
@@ -33,3 +33,19 @@ Description:	Maximum time allowed for pe
 		Beware, non-standard modes are usually not thoroughly tested by
 		hardware designers, and the hardware can malfunction when this
 		setting differ from default 100.
+
+What:		/sys/module/*/{coresize,initsize}
+Date:		Jan 2012
+KernelVersion:»·3.3
+Contact:	Kay Sievers <kay.sievers@vrfy.org>
+Description:	Module size in bytes.
+
+What:		/sys/module/*/taint
+Date:		Jan 2012
+KernelVersion:»·3.3
+Contact:	Kay Sievers <kay.sievers@vrfy.org>
+Description:	Module taint flags:
+			P - proprietary module
+			O - out-of-tree module
+			F - force-loaded module
+			C - staging driver module
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
+	if (mod->taints & (1 << TAINT_OOT_MODULE))
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
+static struct module_attribute modinfo_refcnt =
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
+static struct module_attribute modinfo_initstate =
+	__ATTR(initstate, 0444, show_initstate, NULL);
 
 static ssize_t store_uevent(struct module_attribute *mattr,
 			    struct module_kobject *mk,
@@ -986,18 +1002,50 @@ static ssize_t store_uevent(struct modul
 	return count;
 }
 
-struct module_attribute module_uevent = {
-	.attr = { .name = "uevent", .mode = 0200 },
-	.store = store_uevent,
-};
+struct module_attribute module_uevent =
+	__ATTR(uevent, 0200, NULL, store_uevent);
+
+static ssize_t show_coresize(struct module_attribute *mattr,
+			     struct module_kobject *mk, char *buffer)
+{
+	return sprintf(buffer, "%u\n", mk->mod->core_size);
+}
+
+static struct module_attribute modinfo_coresize =
+	__ATTR(coresize, 0444, show_coresize, NULL);
+
+static ssize_t show_initsize(struct module_attribute *mattr,
+			     struct module_kobject *mk, char *buffer)
+{
+	return sprintf(buffer, "%u\n", mk->mod->init_size);
+}
+
+static struct module_attribute modinfo_initsize =
+	__ATTR(initsize, 0444, show_initsize, NULL);
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
+static struct module_attribute modinfo_taint =
+	__ATTR(taint, 0444, show_taint, NULL);
 
 static struct module_attribute *modinfo_attrs[] = {
+	&module_uevent,
 	&modinfo_version,
 	&modinfo_srcversion,
-	&initstate,
-	&module_uevent,
+	&modinfo_initstate,
+	&modinfo_coresize,
+	&modinfo_initsize,
+	&modinfo_taint,
 #ifdef CONFIG_MODULE_UNLOAD
-	&refcnt,
+	&modinfo_refcnt,
 #endif
 	NULL,
 };
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


