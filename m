Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1BEOVj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:21:39 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1BEOVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FDc0C1fj+ji5wGl9RrGxlhovogO9ndDPUcv2zATCZI65VOqqs6MKxUjj3lj98RFUWy
         n2uhIWWJZvgOKcT47qZZ+D584/V5EYtgej9ScfdHXfK1hPLNOm9wv21lG5Kw0wpY7wtA
         hFFLwQ4b38bzuKEeKbWn5DLkD1XkizuEIKHxg=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 12/52] kstrtox: convert drivers/base/
Date: Sat,  5 Feb 2011 16:20:15 +0200
Message-Id: <1296915654-7458-12-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
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
index 080e9ca..0fccdc4 100644
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
index 1bf5cf0..bf838b5 100644
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
1.7.3.4

