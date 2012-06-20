Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab2FTPEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 11:04:16 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61404 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2FTPEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 11:04:15 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Wed, 20 Jun 2012 09:36:29 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] thermal: Fix potential out-of-bounds memory access
Date: Wed, 20 Jun 2012 07:36:34 -0700
Message-Id: <1340202994-12744-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

temp_crit.name and temp_input.name have a length of 16 bytes. Using
THERMAL_NAME_LENGTH (20) as length parameter for snprintf() may result
in out-of-bounds memory accesses. Replace it with sizeof().

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Coverity #115679

 drivers/thermal/thermal_sys.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 9f2a35c..d9a682e 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -549,7 +549,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 	temp->tz = tz;
 	hwmon->count++;
 
-	snprintf(temp->temp_input.name, THERMAL_NAME_LENGTH,
+	snprintf(temp->temp_input.name, sizeof(temp->temp_input.name),
 		 "temp%d_input", hwmon->count);
 	temp->temp_input.attr.attr.name = temp->temp_input.name;
 	temp->temp_input.attr.attr.mode = 0444;
@@ -562,7 +562,8 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 	if (tz->ops->get_crit_temp) {
 		unsigned long temperature;
 		if (!tz->ops->get_crit_temp(tz, &temperature)) {
-			snprintf(temp->temp_crit.name, THERMAL_NAME_LENGTH,
+			snprintf(temp->temp_crit.name,
+				 sizeof(temp->temp_crit.name),
 				"temp%d_crit", hwmon->count);
 			temp->temp_crit.attr.attr.name = temp->temp_crit.name;
 			temp->temp_crit.attr.attr.mode = 0444;
-- 
1.7.9.7

