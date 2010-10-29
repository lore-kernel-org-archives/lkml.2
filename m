Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139Ab0J2SoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:44:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:58507 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759106Ab0J2SoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:44:16 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Dongdong Deng <dongdong.deng@windriver.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 6/7] kgdbts: prevent re-entry to kgdbts before it unregisters
Date: Fri, 29 Oct 2010 13:43:40 -0500
Message-Id: <1288377821-24520-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
References: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 29 Oct 2010 18:43:52.0675 (UTC) FILETIME=[3BC66330:01CB7799]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongdong Deng <dongdong.deng@windriver.com>

The "kgdb_connected" variable of debug_core just indicates whether or
not kgdbts is connected to the debug_core.  It does not completely
prevent a script from trying invoke kgdbts again and possibly crashing
the system (see Call Trace below).

The configured variable in kgtbts can be used instead of
kgdb_connected instead of kgdb_connected. The cleanup_kgdbts() can
also be removed because there is no possible way to build kgdbts as a
kernel module that you could unload with rmmod.

Call Trace:
-----------------------------------------------------------------
root:/$ echo kgdbts=V1S1000 > /sys/module/kgdbts/parameters/kgdbts
kgdb: Unregistered I/O driver kgdbts, debugger disabled.
------------[ cut here ]------------
WARNING: at kernel/debug/debug_core.c:1002
kgdb_unregister_io_module+0xec/0x100()
Hardware name: Moon Creek platform
Modules linked in:
Pid: 664, comm: sh Not tainted 2.6.34.1-WR4.0.0.0_standard #58
Call Trace:
 [<c103b1ed>] warn_slowpath_common+0x6d/0xa0
 [<c1079fdc>] ? kgdb_unregister_io_module+0xec/0x100
 [<c1079fdc>] ? kgdb_unregister_io_module+0xec/0x100
 [<c10544e0>] ? param_attr_store+0x0/0x20
 [<c103b235>] warn_slowpath_null+0x15/0x20
 [<c1079fdc>] kgdb_unregister_io_module+0xec/0x100
 [<c124e4ea>] cleanup_kgdbts+0x1a/0x20
 [<c124eced>] param_set_kgdbts_var+0x6d/0xb0
 [<c124ec80>] ? param_set_kgdbts_var+0x0/0xb0
 [<c10544f7>] param_attr_store+0x17/0x20
 [<c105457c>] module_attr_store+0x2c/0x40
 [<c111fe84>] sysfs_write_file+0x94/0xf0
 [<c10d42f6>] vfs_write+0x96/0x130
 [<c111fdf0>] ? sysfs_write_file+0x0/0xf0
 [<c10d44d6>] sys_write+0x46/0xd0
 [<c13bf329>] system_call_done+0x0/0x4
---[ end trace 4eb028c6ee43154c ]---
kgdb: Unregistered I/O driver kgdbts, debugger disabled.
-----------------------------------------------------------------

[jason.wessel@windriver.com: remove cleanup_kgdbts() ]
Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/misc/kgdbts.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 7245023..59c118c 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -1044,12 +1044,6 @@ static int __init init_kgdbts(void)
 	return configure_kgdbts();
 }
 
-static void cleanup_kgdbts(void)
-{
-	if (configured == 1)
-		kgdb_unregister_io_module(&kgdbts_io_ops);
-}
-
 static int kgdbts_get_char(void)
 {
 	int val = 0;
@@ -1081,10 +1075,8 @@ static int param_set_kgdbts_var(const char *kmessage, struct kernel_param *kp)
 		return 0;
 	}
 
-	if (kgdb_connected) {
-		printk(KERN_ERR
-	       "kgdbts: Cannot reconfigure while KGDB is connected.\n");
-
+	if (configured == 1) {
+		printk(KERN_ERR "kgdbts: ERROR: Already configured and running.\n");
 		return -EBUSY;
 	}
 
@@ -1093,9 +1085,6 @@ static int param_set_kgdbts_var(const char *kmessage, struct kernel_param *kp)
 	if (config[len - 1] == '\n')
 		config[len - 1] = '\0';
 
-	if (configured == 1)
-		cleanup_kgdbts();
-
 	/* Go and configure with the new params. */
 	return configure_kgdbts();
 }
@@ -1123,7 +1112,6 @@ static struct kgdb_io kgdbts_io_ops = {
 };
 
 module_init(init_kgdbts);
-module_exit(cleanup_kgdbts);
 module_param_call(kgdbts, param_set_kgdbts_var, param_get_string, &kps, 0644);
 MODULE_PARM_DESC(kgdbts, "<A|V1|V2>[F#|S#][N#]");
 MODULE_DESCRIPTION("KGDB Test Suite");
-- 
1.6.3.3

