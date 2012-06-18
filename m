Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab2FREwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 00:52:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38513 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2FREwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 00:52:39 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <len.brown@intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] thermal: Constify 'type' argument for the registration routine
Date: Sun, 17 Jun 2012 21:50:37 -0700
Message-Id: <1339995037-19561-1-git-send-email-cbouatmailru@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thermal_zone_device_register() does not modify 'type' argument, so
it is safe to declare it as const. Otherwise, if we pass a const
string, we are getting the ugly warning:

  CC      drivers/power/power_supply_core.o
drivers/power/power_supply_core.c: In function 'psy_register_thermal':
drivers/power/power_supply_core.c:204:6: warning: passing argument 1 of ‘thermal_zone_device_register’ discards 'const' qualifier from pointer target type [enabled by default]
include/linux/thermal.h:140:29: note: expected 'char *' but argument is of type 'const char *'

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/thermal/thermal_sys.c |    2 +-
 include/linux/thermal.h       |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 022bacb..3bf68c9 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -1106,7 +1106,7 @@ EXPORT_SYMBOL(thermal_zone_device_update);
  * longer needed. The passive cooling formula uses tc1 and tc2 as described in
  * section 11.1.5.1 of the ACPI specification 3.0.
  */
-struct thermal_zone_device *thermal_zone_device_register(char *type,
+struct thermal_zone_device *thermal_zone_device_register(const char *type,
 	int trips, void *devdata,
 	const struct thermal_zone_device_ops *ops,
 	int tc1, int tc2, int passive_delay, int polling_delay)
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index 796f1ff..ef75757 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -137,7 +137,8 @@ enum {
 };
 #define THERMAL_GENL_CMD_MAX (__THERMAL_GENL_CMD_MAX - 1)
 
-struct thermal_zone_device *thermal_zone_device_register(char *, int, void *,
+struct thermal_zone_device *
+thermal_zone_device_register(const char *, int, void *,
 		const struct thermal_zone_device_ops *, int tc1, int tc2,
 		int passive_freq, int polling_freq);
 void thermal_zone_device_unregister(struct thermal_zone_device *);
-- 
1.7.10.4

