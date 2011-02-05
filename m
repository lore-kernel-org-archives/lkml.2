Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1BEOVR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:21:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab1BEOVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s62uLPZnec6A4BcFEBdYiszdqFcgQqb6G7y1570f8LssqM4aETdNjqTUNL1nNVY/YF
         szTDz/BEnOShz+hnmCXHc/k/WBZdk0ZOm48S9ZVKWv8q6wusp87pfdLjzVXumdMfoHeu
         6S/1ogYjz78V6CABi2YXNsLt8ibMAB9OpT7zo=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 02/52] kstrtox: convert kernel/
Date: Sat,  5 Feb 2011 16:20:05 +0200
Message-Id: <1296915654-7458-2-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 kernel/gcov/fs.c    |    5 +----
 kernel/ksysfs.c     |    5 +++--
 kernel/params.c     |   24 +++++++++++-------------
 kernel/power/main.c |    8 +++++---
 4 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/kernel/gcov/fs.c b/kernel/gcov/fs.c
index 9bd0934..347c2b3 100644
--- a/kernel/gcov/fs.c
+++ b/kernel/gcov/fs.c
@@ -72,13 +72,10 @@ static int gcov_persist = 1;
 
 static int __init gcov_persist_setup(char *str)
 {
-	unsigned long val;
-
-	if (strict_strtoul(str, 0, &val)) {
+	if (kstrtoint(str, 0, &gcov_persist) < 0) {
 		pr_warning("invalid gcov_persist parameter '%s'\n", str);
 		return 0;
 	}
-	gcov_persist = val;
 	pr_info("setting gcov_persist to %d\n", gcov_persist);
 
 	return 1;
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 0b624e7..b0b4681 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -112,8 +112,9 @@ static ssize_t kexec_crash_size_store(struct kobject *kobj,
 	unsigned long cnt;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &cnt))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &cnt);
+	if (ret < 0)
+		return ret;
 
 	ret = crash_shrink_memory(cnt);
 	return ret < 0 ? ret : count;
diff --git a/kernel/params.c b/kernel/params.c
index 0da1411..0c36a99 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -218,16 +218,14 @@ int parse_args(const char *name,
 }
 
 /* Lazy bastard, eh? */
-#define STANDARD_PARAM_DEF(name, type, format, tmptype, strtolfn)      	\
+#define STANDARD_PARAM_DEF(name, type, format, strtolfn)		\
 	int param_set_##name(const char *val, const struct kernel_param *kp) \
 	{								\
-		tmptype l;						\
 		int ret;						\
 									\
-		ret = strtolfn(val, 0, &l);				\
-		if (ret == -EINVAL || ((type)l != l))			\
-			return -EINVAL;					\
-		*((type *)kp->arg) = l;					\
+		ret = strtolfn(val, 0, (type *)kp->arg);		\
+		if (ret < 0)						\
+			return ret;					\
 		return 0;						\
 	}								\
 	int param_get_##name(char *buffer, const struct kernel_param *kp) \
@@ -243,13 +241,13 @@ int parse_args(const char *name,
 	EXPORT_SYMBOL(param_ops_##name)
 
 
-STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(short, short, "%hi", long, strict_strtol);
-STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(int, int, "%i", long, strict_strtol);
-STANDARD_PARAM_DEF(uint, unsigned int, "%u", unsigned long, strict_strtoul);
-STANDARD_PARAM_DEF(long, long, "%li", long, strict_strtol);
-STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", unsigned long, strict_strtoul);
+STANDARD_PARAM_DEF(byte, u8, "%c", kstrtou8);
+STANDARD_PARAM_DEF(short, s16, "%hi", kstrtos16);
+STANDARD_PARAM_DEF(ushort, u16, "%hu", kstrtou16);
+STANDARD_PARAM_DEF(int, int, "%i", kstrtoint);
+STANDARD_PARAM_DEF(uint, unsigned int, "%u", kstrtouint);
+STANDARD_PARAM_DEF(long, long, "%li", kstrtol);
+STANDARD_PARAM_DEF(ulong, unsigned long, "%lu", kstrtoul);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 7b5db6a..c53c77e 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -56,10 +56,12 @@ static ssize_t pm_async_show(struct kobject *kobj, struct kobj_attribute *attr,
 static ssize_t pm_async_store(struct kobject *kobj, struct kobj_attribute *attr,
 			      const char *buf, size_t n)
 {
-	unsigned long val;
+	unsigned int val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	rv = kstrtouint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	if (val > 1)
 		return -EINVAL;
-- 
1.7.3.4

