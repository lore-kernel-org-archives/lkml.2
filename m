Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab2CYX1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 19:27:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61995 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab2CYX01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 19:26:27 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 11/16] dynamic_debug: print ram usage by ddebug tables if verbose
Date: Sun, 25 Mar 2012 17:25:49 -0600
Message-Id: <1332717954-5775-12-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
References: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Print ram usage of dynamic-debug so user knows cost of enabling
CONFIG_DYNAMIC_DEBUG.  Only counts cost of pr_debug in builtins, not
those in loadable modules.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 5f0d31f..38bd4d66 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -970,7 +970,7 @@ static int __init dynamic_debug_init(void)
 	const char *modname = NULL;
 	char *cmdline;
 	int ret = 0;
-	int n = 0;
+	int n = 0, entries = 0, modct = 0;
 
 	if (__start___verbose == __stop___verbose) {
 		pr_warn("_ddebug table is empty in a "
@@ -981,7 +981,9 @@ static int __init dynamic_debug_init(void)
 	modname = iter->modname;
 	iter_start = iter;
 	for (; iter < __stop___verbose; iter++) {
+		entries++;
 		if (strcmp(modname, iter->modname)) {
+			modct++;
 			ret = ddebug_add_module(iter_start, n, modname);
 			if (ret)
 				goto out_err;
@@ -996,6 +998,9 @@ static int __init dynamic_debug_init(void)
 		goto out_err;
 
 	ddebug_init_success = 1;
+	vpr_info("%d modules, %d entries in ddebug tables, %d bytes used\n",
+		modct, entries, modct * sizeof(struct ddebug_table)
+		+ __stop___verbose - __start___verbose);
 
 	/* apply ddebug_query boot param, dont unload tables on err */
 	if (ddebug_setup_string[0] != '\0') {
-- 
1.7.7.6

