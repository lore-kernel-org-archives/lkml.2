Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2HHFgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 01:36:43 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54130 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab2HHFgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 01:36:42 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Wed, 08 Aug 2012 00:36:41 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] thermal: Fix potential NULL pointer accesses
Date: Tue,  7 Aug 2012 22:36:45 -0700
Message-Id: <1344404205-22861-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The type parameter in thermal_zone_device_register and
thermal_cooling_device_register can be NULL, indicating that no sysfs attribute
for the type should be created. Only call strlen() and strcpy() on type if it is
not NULL.

This patch addresses Coverity #102180 and #102182: Dereference before null check

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Applies on top of git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git (thermal).

 drivers/thermal/thermal_sys.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 5be8728..e69f76d 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -900,7 +900,7 @@ thermal_cooling_device_register(char *type, void *devdata,
 	struct thermal_zone_device *pos;
 	int result;
 
-	if (strlen(type) >= THERMAL_NAME_LENGTH)
+	if (type && strlen(type) >= THERMAL_NAME_LENGTH)
 		return ERR_PTR(-EINVAL);
 
 	if (!ops || !ops->get_max_state || !ops->get_cur_state ||
@@ -917,7 +917,7 @@ thermal_cooling_device_register(char *type, void *devdata,
 		return ERR_PTR(result);
 	}
 
-	strcpy(cdev->type, type);
+	strcpy(cdev->type, type ? : "");
 	mutex_init(&cdev->lock);
 	INIT_LIST_HEAD(&cdev->thermal_instances);
 	cdev->ops = ops;
@@ -1343,7 +1343,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 	int count;
 	int passive = 0;
 
-	if (strlen(type) >= THERMAL_NAME_LENGTH)
+	if (type && strlen(type) >= THERMAL_NAME_LENGTH)
 		return ERR_PTR(-EINVAL);
 
 	if (trips > THERMAL_MAX_TRIPS || trips < 0 || mask >> trips)
@@ -1365,7 +1365,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 		return ERR_PTR(result);
 	}
 
-	strcpy(tz->type, type);
+	strcpy(tz->type, type ? : "");
 	tz->ops = ops;
 	tz->device.class = &thermal_class;
 	tz->devdata = devdata;
-- 
1.7.9.7

