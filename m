Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab2JIGIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 02:08:38 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38957 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab2JIGDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 02:03:11 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 16/30] thermal: Fix potential NULL pointer accesses
Date: Tue,  9 Oct 2012 01:54:06 -0400
Message-Id: <204dd1d39c32f39a95bf7a7248f63b372fd137a6.1349761836.git.len.brown@intel.com>
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

The type parameter in thermal_zone_device_register and
thermal_cooling_device_register can be NULL, indicating that no sysfs attribute
for the type should be created. Only call strlen() and strcpy() on type if it is
not NULL.

This patch addresses Coverity #102180 and #102182: Dereference before null check

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/thermal_sys.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 36e6f4d..47498b8 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -901,7 +901,7 @@ thermal_cooling_device_register(char *type, void *devdata,
 	struct thermal_zone_device *pos;
 	int result;
 
-	if (strlen(type) >= THERMAL_NAME_LENGTH)
+	if (type && strlen(type) >= THERMAL_NAME_LENGTH)
 		return ERR_PTR(-EINVAL);
 
 	if (!ops || !ops->get_max_state || !ops->get_cur_state ||
@@ -918,7 +918,7 @@ thermal_cooling_device_register(char *type, void *devdata,
 		return ERR_PTR(result);
 	}
 
-	strcpy(cdev->type, type);
+	strcpy(cdev->type, type ? : "");
 	mutex_init(&cdev->lock);
 	INIT_LIST_HEAD(&cdev->thermal_instances);
 	cdev->ops = ops;
@@ -1344,7 +1344,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 	int count;
 	int passive = 0;
 
-	if (strlen(type) >= THERMAL_NAME_LENGTH)
+	if (type && strlen(type) >= THERMAL_NAME_LENGTH)
 		return ERR_PTR(-EINVAL);
 
 	if (trips > THERMAL_MAX_TRIPS || trips < 0 || mask >> trips)
@@ -1366,7 +1366,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 		return ERR_PTR(result);
 	}
 
-	strcpy(tz->type, type);
+	strcpy(tz->type, type ? : "");
 	tz->ops = ops;
 	tz->device.class = &thermal_class;
 	tz->devdata = devdata;
-- 
1.8.0.rc1

