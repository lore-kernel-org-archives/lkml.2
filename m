Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab2JIGJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:09:24 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38957 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2JIGDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:03:03 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "Brown, Len" <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 14/30] thermal: fix potential out-of-bounds memory access
Date: Tue,  9 Oct 2012 01:54:04 -0400
Message-Id: <79a49168b595f5400ed3108cd57e90f5bbe144ca.1349761836.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc1
In-Reply-To: <1349762060-25334-1-git-send-email-lenb@kernel.org>
References: <1349762060-25334-1-git-send-email-lenb@kernel.org>
In-Reply-To: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
References: <e3f25e6e5836c4790fbe395ff42e241f372d859d.1349761836.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

temp_crit.name and temp_input.name have a length of 16 bytes.  Using
THERMAL_NAME_LENGTH (20) as length parameter for snprintf() may result in
out-of-bounds memory accesses.  Replace it with sizeof().

Addresses Coverity #115679

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Len Brown <lenb@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/thermal_sys.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 5be8728..36e6f4d 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -598,7 +598,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 	temp->tz = tz;
 	hwmon->count++;
 
-	snprintf(temp->temp_input.name, THERMAL_NAME_LENGTH,
+	snprintf(temp->temp_input.name, sizeof(temp->temp_input.name),
 		 "temp%d_input", hwmon->count);
 	temp->temp_input.attr.attr.name = temp->temp_input.name;
 	temp->temp_input.attr.attr.mode = 0444;
@@ -611,7 +611,8 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
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
1.8.0.rc1

