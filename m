Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab0LERup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:50:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64682 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab0LERum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:50:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K4haiKn4iOuTpVZWgR0rZz1XHrmBZJm51hsWDBGljfQnnD4RjXs+eoCqLC1MzQIHS1
         o7vCmWK/yuHUUlzlpy005FrxzKBOWdN7u67rBnvdSBlHa8+IY4d95Vr6DZGBxhV/p+KV
         M5gMd1p+6S1/C8oW8VFLqB4UYtU1JdMbd8B58=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 14/45] kstrtox: convert drivers/base/
Date: Sun,  5 Dec 2010 19:49:11 +0200
Message-Id: <1291571382-2719-14-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/base/core.c        |    6 +++---
 drivers/base/memory.c      |   10 ++++++----
 drivers/base/power/sysfs.c |    9 +++++----
 include/linux/device.h     |    2 +-
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6ed6454..f4862a4 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -28,13 +28,13 @@
 
 #ifdef CONFIG_SYSFS_DEPRECATED
 #ifdef CONFIG_SYSFS_DEPRECATED_V2
-long sysfs_deprecated = 1;
+int sysfs_deprecated = 1;
 #else
-long sysfs_deprecated = 0;
+int sysfs_deprecated = 0;
 #endif
 static __init int sysfs_deprecated_setup(char *arg)
 {
-	return strict_strtol(arg, 10, &sysfs_deprecated);
+	return kstrtoint(arg, 10, &sysfs_deprecated);
 }
 early_param("sysfs.deprecated", sysfs_deprecated_setup);
 #endif
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index cafeaaf..2dc57aa 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -380,8 +380,9 @@ store_soft_offline_page(struct class *class,
 	u64 pfn;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (strict_strtoull(buf, 0, &pfn) < 0)
-		return -EINVAL;
+	ret = kstrtou64(buf, 0, &pfn);
+	if (ret < 0)
+		return ret;
 	pfn >>= PAGE_SHIFT;
 	if (!pfn_valid(pfn))
 		return -ENXIO;
@@ -399,8 +400,9 @@ store_hard_offline_page(struct class *class,
 	u64 pfn;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (strict_strtoull(buf, 0, &pfn) < 0)
-		return -EINVAL;
+	ret = kstrtou64(buf, 0, &pfn);
+	if (ret < 0)
+		return ret;
 	pfn >>= PAGE_SHIFT;
 	ret = __memory_failure(pfn, 0, 0);
 	return ret ? ret : count;
diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
index 0b1e46b..1397768 100644
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -197,14 +197,15 @@ static ssize_t autosuspend_delay_ms_show(struct device *dev,
 static ssize_t autosuspend_delay_ms_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t n)
 {
-	long delay;
+	int delay;
+	int rv;
 
 	if (!dev->power.use_autosuspend)
 		return -EIO;
 
-	if (strict_strtol(buf, 10, &delay) != 0 || delay != (int) delay)
-		return -EINVAL;
-
+	rv = kstrtoint(buf, 10, &delay);
+	if (rv < 0)
+		return rv;
 	pm_runtime_set_autosuspend_delay(dev, delay);
 	return n;
 }
diff --git a/include/linux/device.h b/include/linux/device.h
index dd48953..f3474dc 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -753,7 +753,7 @@ do {						     \
 	MODULE_ALIAS("char-major-" __stringify(major) "-*")
 
 #ifdef CONFIG_SYSFS_DEPRECATED
-extern long sysfs_deprecated;
+extern int sysfs_deprecated;
 #else
 #define sysfs_deprecated 0
 #endif
-- 
1.7.2.2

