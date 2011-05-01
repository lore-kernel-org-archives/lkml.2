Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240Ab1EABjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 21:39:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65417 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab1EABh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 21:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UHiJL+VZhhBtWX5ckqTWPBVWt77PKPoYavJqiVV0zDc5nkbKPov1l/loWwifDwlDr8
         b5LW6HcDP/lKD7YdUi8RSlk6IOoaOdkWnJkbvp5aM/kbie/3BOUuVJXNaQKfJKdhvNu7
         yxV6gn4l+qe46D4OWmQmXJydsSX46lZ1tGpOY=
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: [PATCH 56/69] sysctl: no-child: manually register kernel/keys
Date: Sun,  1 May 2011 03:36:26 +0200
Message-Id: <1304213799-10257-57-git-send-email-lucian.grijincu@gmail.com>
X-Mailer: git-send-email 1.7.5.134.g1c08b
In-Reply-To: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
References: <1304213799-10257-1-git-send-email-lucian.grijincu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
---
 include/linux/key.h    |    4 +++-
 kernel/sysctl.c        |    7 -------
 security/keys/key.c    |    1 +
 security/keys/sysctl.c |   18 +++++++++++++++++-
 4 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index b2bb017..9b3df18 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -281,7 +281,9 @@ static inline key_serial_t key_serial(struct key *key)
 				   rwsem_is_locked(&((struct key *)(KEY))->sem)))
 
 #ifdef CONFIG_SYSCTL
-extern ctl_table key_sysctls[];
+extern int __init key_register_sysctls(void);
+#else
+static int __init key_register_sysctls(void) { return 0; }
 #endif
 
 extern void key_replace_session_keyring(void);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index a3f060c..4e63701 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -905,13 +905,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dostring,
 	},
-#ifdef CONFIG_KEYS
-	{
-		.procname	= "keys",
-		.mode		= 0555,
-		.child		= key_sysctls,
-	},
-#endif
 #ifdef CONFIG_RCU_TORTURE_TEST
 	{
 		.procname       = "rcutorture_runnable",
diff --git a/security/keys/key.c b/security/keys/key.c
index f7f9d93..33903c2 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -1099,6 +1099,7 @@ EXPORT_SYMBOL(unregister_key_type);
  */
 void __init key_init(void)
 {
+	key_register_sysctls();
 	/* allocate a slab in which we can store keys */
 	key_jar = kmem_cache_create("key_jar", sizeof(struct key),
 			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
diff --git a/security/keys/sysctl.c b/security/keys/sysctl.c
index ee32d18..e079223 100644
--- a/security/keys/sysctl.c
+++ b/security/keys/sysctl.c
@@ -15,7 +15,7 @@
 
 static const int zero, one = 1, max = INT_MAX;
 
-ctl_table key_sysctls[] = {
+static struct ctl_table key_table[] = {
 	{
 		.procname = "maxkeys",
 		.data = &key_quota_maxkeys,
@@ -63,3 +63,19 @@ ctl_table key_sysctls[] = {
 	},
 	{ }
 };
+
+static const __initdata struct ctl_path key_path[] = {
+	{ .procname = "kernel" },
+	{ .procname = "keys" },
+	{ }
+};
+
+static struct ctl_table_header *key_header;
+
+int __init key_register_sysctls(void)
+{
+	key_header = register_sysctl_paths(key_path, key_table);
+	if (key_header == NULL)
+		return -ENOMEM;
+	return 0;
+}
-- 
1.7.5.134.g1c08b

