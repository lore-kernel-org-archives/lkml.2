Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab0GVAiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 20:38:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:59981 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab0GVAhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 20:37:14 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 5/5] sysrq,kdb: Use __handle_sysrq() for kdb's sysrq function
Date: Wed, 21 Jul 2010 19:36:15 -0500
Message-Id: <1279758975-16658-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1279758975-16658-5-git-send-email-jason.wessel@windriver.com>
References: <1279758975-16658-1-git-send-email-jason.wessel@windriver.com>
 <1279758975-16658-2-git-send-email-jason.wessel@windriver.com>
 <1279758975-16658-3-git-send-email-jason.wessel@windriver.com>
 <1279758975-16658-4-git-send-email-jason.wessel@windriver.com>
 <1279758975-16658-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Jul 2010 00:36:35.0830 (UTC) FILETIME=[F0B09160:01CB2935]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kdb code should not toggle the sysrq state in case an end user
wants to try and resume the normal kernel execution.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/char/sysrq.c        |    2 +-
 include/linux/sysrq.h       |    1 +
 kernel/debug/kdb/kdb_main.c |    3 +--
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
index 5d64e3a..878ac0c 100644
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -493,7 +493,7 @@ static void __sysrq_put_key_op(int key, struct sysrq_key_op *op_p)
                 sysrq_key_table[i] = op_p;
 }
 
-static void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
+void __handle_sysrq(int key, struct tty_struct *tty, int check_mask)
 {
 	struct sysrq_key_op *op_p;
 	int orig_log_level;
diff --git a/include/linux/sysrq.h b/include/linux/sysrq.h
index 4496322..609e8ca 100644
--- a/include/linux/sysrq.h
+++ b/include/linux/sysrq.h
@@ -45,6 +45,7 @@ struct sysrq_key_op {
  */
 
 void handle_sysrq(int key, struct tty_struct *tty);
+void __handle_sysrq(int key, struct tty_struct *tty, int check_mask);
 int register_sysrq_key(int key, struct sysrq_key_op *op);
 int unregister_sysrq_key(int key, struct sysrq_key_op *op);
 struct sysrq_key_op *__sysrq_get_key_op(int key);
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 7e9bfd5..ebe4a28 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1820,9 +1820,8 @@ static int kdb_sr(int argc, const char **argv)
 {
 	if (argc != 1)
 		return KDB_ARGCOUNT;
-	sysrq_toggle_support(1);
 	kdb_trap_printk++;
-	handle_sysrq(*argv[1], NULL);
+	__handle_sysrq(*argv[1], NULL, 0);
 	kdb_trap_printk--;
 
 	return 0;
-- 
1.6.3.3

