Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1BEOa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:30:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583Ab1BEOVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DVCzrsEq7xEY9DllhFQ+c0N7caNX7iU1H4PQDsZjWiIVqsMaFgWKoAt35S5riPu34j
         lZ60SSL5YUeATTtPvtMVBZAP/1UaQ38bRZecePW0nQoBQ+dMvSnET7WPaVp2E3TEMCzg
         zAC1L7eYOq2BrwKpahj+ihwvIMl1nv4K3u7eA=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 10/52] kstrtox: convert drivers/acpi/
Date: Sat,  5 Feb 2011 16:20:13 +0200
Message-Id: <1296915654-7458-10-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/acpi/acpi_pad.c    |   27 ++++++++++++++++++---------
 drivers/acpi/power_meter.c |   16 +++++++---------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index 6afceb3..20d1c2d 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -284,9 +284,12 @@ static uint32_t acpi_pad_idle_cpus_num(void)
 static ssize_t acpi_pad_rrtime_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long num;
-	if (strict_strtoul(buf, 0, &num))
-		return -EINVAL;
+	unsigned int num;
+	int rv;
+
+	rv = kstrtouint(buf, 0, &num);
+	if (rv < 0)
+		return rv;
 	if (num < 1 || num >= 100)
 		return -EINVAL;
 	mutex_lock(&isolated_cpus_lock);
@@ -307,9 +310,12 @@ static DEVICE_ATTR(rrtime, S_IRUGO|S_IWUSR,
 static ssize_t acpi_pad_idlepct_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long num;
-	if (strict_strtoul(buf, 0, &num))
-		return -EINVAL;
+	unsigned int num;
+	int rv;
+
+	rv = kstrtouint(buf, 0, &num);
+	if (rv < 0)
+		return rv;
 	if (num < 1 || num >= 100)
 		return -EINVAL;
 	mutex_lock(&isolated_cpus_lock);
@@ -330,9 +336,12 @@ static DEVICE_ATTR(idlepct, S_IRUGO|S_IWUSR,
 static ssize_t acpi_pad_idlecpus_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	unsigned long num;
-	if (strict_strtoul(buf, 0, &num))
-		return -EINVAL;
+	unsigned int num;
+	int rv;
+
+	rv = kstrtouint(buf, 0, &num);
+	if (rv < 0)
+		return rv;
 	mutex_lock(&isolated_cpus_lock);
 	acpi_pad_idle_cpus(num);
 	mutex_unlock(&isolated_cpus_lock);
diff --git a/drivers/acpi/power_meter.c b/drivers/acpi/power_meter.c
index 66f6729..a468c33 100644
--- a/drivers/acpi/power_meter.c
+++ b/drivers/acpi/power_meter.c
@@ -166,12 +166,12 @@ static ssize_t set_avg_interval(struct device *dev,
 	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
 	struct acpi_object_list args = { 1, &arg0 };
 	int res;
-	unsigned long temp;
+	u64 temp;
 	unsigned long long data;
 	acpi_status status;
 
-	res = strict_strtoul(buf, 10, &temp);
-	if (res)
+	res = kstrtou64(buf, 10, &temp);
+	if (res < 0)
 		return res;
 
 	if (temp > resource->caps.max_avg_interval ||
@@ -241,8 +241,8 @@ static ssize_t set_cap(struct device *dev, struct device_attribute *devattr,
 	unsigned long long data;
 	acpi_status status;
 
-	res = strict_strtoul(buf, 10, &temp);
-	if (res)
+	res = kstrtoul(buf, 10, &temp);
+	if (res < 0)
 		return res;
 
 	temp /= 1000;
@@ -311,13 +311,11 @@ static ssize_t set_trip(struct device *dev, struct device_attribute *devattr,
 	int res;
 	unsigned long temp;
 
-	res = strict_strtoul(buf, 10, &temp);
-	if (res)
+	res = kstrtoul(buf, 10, &temp);
+	if (res < 0)
 		return res;
 
 	temp /= 1000;
-	if (temp < 0)
-		return -EINVAL;
 
 	mutex_lock(&resource->lock);
 	resource->trip[attr->index - 7] = temp;
-- 
1.7.3.4

