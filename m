Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1BMQoo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 11:44:44 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44319 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab1BMQoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 11:44:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mRu/10I0Am1zZIosbmIqfvq32N9AP3V0NAWl2eOd2+mnfi6o/YrstHhEMHBrvJ0mmO
         Up4mJAlSEk7DdgiN5bni2INTwEqTI3PjoCFsiDMm2tw6FwrV3UD19uAllHnCWDjTC3U+
         zaQWK52RAuBs10oKfA0J/QhUgTIpr07vJryhc=
From: Imran Haider <imran1008@gmail.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, Imran Haider <imran1008@gmail.com>
Subject: [PATCH] module: Fix bug: read __param section as pointers to object
Date: Sun, 13 Feb 2011 11:29:14 -0500
Message-Id: <1297614554-24373-1-git-send-email-imran1008@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent changes in commit 3834583b causes module parameters to be stored
in the __param section as pointer to struct instead of the struct itself.
module.c was still reading the section as an array of struct which caused
modules to not load when any module parameter is specified.
---
 include/linux/module.h |    2 +-
 kernel/module.c        |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index cb41837..5f843dc 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -292,7 +292,7 @@ struct module
 	unsigned int num_syms;
 
 	/* Kernel parameters. */
-	struct kernel_param *kp;
+	struct kernel_param **kpp;
 	unsigned int num_kp;
 
 	/* GPL-only exported symbols. */
diff --git a/kernel/module.c b/kernel/module.c
index efa290e..314b39d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1693,7 +1693,7 @@ static void free_module(struct module *mod)
 	module_unload_free(mod);
 
 	/* Free any allocated parameters. */
-	destroy_params(mod->kp, mod->num_kp);
+	destroy_params(*mod->kpp, mod->num_kp);
 
 	/* This may be NULL, but that's OK */
 	unset_section_ro_nx(mod, mod->module_init);
@@ -2429,8 +2429,8 @@ static int check_modinfo(struct module *mod, struct load_info *info)
 
 static void find_module_sections(struct module *mod, struct load_info *info)
 {
-	mod->kp = section_objs(info, "__param",
-			       sizeof(*mod->kp), &mod->num_kp);
+	mod->kpp = section_objs(info, "__param",
+			       sizeof(void *), &mod->num_kp);
 	mod->syms = section_objs(info, "__ksymtab",
 				 sizeof(*mod->syms), &mod->num_syms);
 	mod->crcs = section_addr(info, "__kcrctab");
@@ -2803,12 +2803,12 @@ static struct module *load_module(void __user *umod,
 	mutex_unlock(&module_mutex);
 
 	/* Module is ready to execute: parsing args may do that. */
-	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
+	err = parse_args(mod->name, mod->args, *(mod->kpp), mod->num_kp, NULL);
 	if (err < 0)
 		goto unlink;
 
 	/* Link in to syfs. */
-	err = mod_sysfs_setup(mod, &info, mod->kp, mod->num_kp);
+	err = mod_sysfs_setup(mod, &info, *(mod->kpp), mod->num_kp);
 	if (err < 0)
 		goto unlink;
 
-- 
1.7.3.4

