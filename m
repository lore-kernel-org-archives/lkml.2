Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab2APAcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 19:32:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50676 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2APAca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 19:32:30 -0500
From: Olof Johansson <olof@lixom.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] modules: fix build error with !CONFIG_MODULE_UNLOAD
Date: Sun, 15 Jan 2012 16:32:23 -0800
Message-Id: <1326673943-26105-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.8.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the "module_flags_taint" helper was added under an #ifdef
CONFIG_MODULE_UNLOAD block, move it out of it.

Fixes:

kernel/module.c: In function 'show_taint':
kernel/module.c:1024:2: error: implicit declaration of function 'module_flags_taint'

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 kernel/module.c |   40 ++++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index acf6ed3..2c93276 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -842,26 +842,6 @@ out:
 	return ret;
 }
 
-static size_t module_flags_taint(struct module *mod, char *buf)
-{
-	size_t l = 0;
-
-	if (mod->taints & (1 << TAINT_PROPRIETARY_MODULE))
-		buf[l++] = 'P';
-	if (mod->taints & (1 << TAINT_OOT_MODULE))
-		buf[l++] = 'O';
-	if (mod->taints & (1 << TAINT_FORCED_MODULE))
-		buf[l++] = 'F';
-	if (mod->taints & (1 << TAINT_CRAP))
-		buf[l++] = 'C';
-	/*
-	 * TAINT_FORCED_RMMOD: could be added.
-	 * TAINT_UNSAFE_SMP, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
-	 * apply to modules.
-	 */
-	return l;
-}
-
 static inline void print_unload_info(struct seq_file *m, struct module *mod)
 {
 	struct module_use *use;
@@ -962,6 +942,26 @@ static inline int module_unload_init(struct module *mod)
 }
 #endif /* CONFIG_MODULE_UNLOAD */
 
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
 static ssize_t show_initstate(struct module_attribute *mattr,
 			      struct module_kobject *mk, char *buffer)
 {
-- 
1.7.8.GIT

