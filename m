Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab0HEOke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:40:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:41635 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933394Ab0HEOk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:40:28 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 3/9] kgdboc: Add call backs to allow kernel mode switching
Date: Thu,  5 Aug 2010 09:39:52 -0500
Message-Id: <1281019198-6777-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019198-6777-3-git-send-email-jason.wessel@windriver.com>
References: <1281019198-6777-1-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-2-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:40:06.0123 (UTC) FILETIME=[188EEBB0:01CB34AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the kms keyword processing to kgdboc and the callbacks to invoke
console switching when ever kgdboc is started with "kgdboc=kms,kbd".

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/serial/kgdboc.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index a9a94ae..39f9a1a 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -17,6 +17,7 @@
 #include <linux/kdb.h>
 #include <linux/tty.h>
 #include <linux/console.h>
+#include <linux/vt_kern.h>
 
 #define MAX_CONFIG_LEN		40
 
@@ -31,6 +32,7 @@ static struct kparam_string kps = {
 	.maxlen			= MAX_CONFIG_LEN,
 };
 
+static int kgdboc_use_kms;  /* 1 if we use kernel mode switching */
 static struct tty_driver	*kgdb_tty_driver;
 static int			kgdb_tty_line;
 
@@ -104,6 +106,12 @@ static int configure_kgdboc(void)
 	kgdboc_io_ops.is_console = 0;
 	kgdb_tty_driver = NULL;
 
+	kgdboc_use_kms = 0;
+	if (strncmp(cptr, "kms,", 4) == 0) {
+		cptr += 4;
+		kgdboc_use_kms = 1;
+	}
+
 	if (kgdboc_register_kbd(&cptr))
 		goto do_register;
 
@@ -201,8 +209,14 @@ static int param_set_kgdboc_var(const char *kmessage, struct kernel_param *kp)
 	return configure_kgdboc();
 }
 
+static int dbg_restore_graphics;
+
 static void kgdboc_pre_exp_handler(void)
 {
+	if (!dbg_restore_graphics && kgdboc_use_kms) {
+		dbg_restore_graphics = 1;
+		con_debug_enter(vc_cons[fg_console].d);
+	}
 	/* Increment the module count when the debugger is active */
 	if (!kgdb_connected)
 		try_module_get(THIS_MODULE);
@@ -213,6 +227,10 @@ static void kgdboc_post_exp_handler(void)
 	/* decrement the module count when the debugger detaches */
 	if (!kgdb_connected)
 		module_put(THIS_MODULE);
+	if (kgdboc_use_kms && dbg_restore_graphics) {
+		dbg_restore_graphics = 0;
+		con_debug_leave();
+	}
 }
 
 static struct kgdb_io kgdboc_io_ops = {
-- 
1.6.4.rc1

