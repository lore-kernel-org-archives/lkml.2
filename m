Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab2BGIef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 03:34:35 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51941 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab2BGIe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 03:34:26 -0500
MIME-Version: 1.0
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Gross <markgross@thegnar.org>,
        Venkatesh Pallipadi <venki@google.com>
Cc: Jean Pihet <j-pihet@ti.com>
Subject: [PATCH 2/2] PM / QoS: unconditionally build the per-device constraints feature
Date: Tue,  7 Feb 2012 09:34:06 +0100
Message-Id: <1328603646-2714-3-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1328603646-2714-1-git-send-email-j-pihet@ti.com>
References: <1328603646-2714-1-git-send-email-j-pihet@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The per-device PM QoS feature depends on CONFIG_PM which depends
on PM_SLEEP || PM_RUNTIME. This breaks CPU C-states with kernels
not having these CONFIGs.

This patch allows the feature in all cases.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Mark Gross <markgross@thegnar.org>
---
 drivers/base/power/Makefile |    3 ++-
 include/linux/pm_qos.h      |   39 ---------------------------------------
 2 files changed, 2 insertions(+), 40 deletions(-)

diff --git a/drivers/base/power/Makefile b/drivers/base/power/Makefile
index 2e58ebb..312eb65 100644
--- a/drivers/base/power/Makefile
+++ b/drivers/base/power/Makefile
@@ -1,4 +1,5 @@
-obj-$(CONFIG_PM)	+= sysfs.o generic_ops.o common.o qos.o
+obj-y			+= qos.o
+obj-$(CONFIG_PM)	+= sysfs.o generic_ops.o common.o
 obj-$(CONFIG_PM_SLEEP)	+= main.o wakeup.o
 obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
 obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
index 105be69..37b017a 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -77,7 +77,6 @@ int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier);
 int pm_qos_request_active(struct pm_qos_request *req);
 s32 pm_qos_read_value(struct pm_qos_constraints *c);
 
-#ifdef CONFIG_PM
 s32 __dev_pm_qos_read_value(struct device *dev);
 s32 dev_pm_qos_read_value(struct device *dev);
 int dev_pm_qos_add_request(struct device *dev, struct dev_pm_qos_request *req,
@@ -94,43 +93,5 @@ void dev_pm_qos_constraints_init(struct device *dev);
 void dev_pm_qos_constraints_destroy(struct device *dev);
 int dev_pm_qos_add_ancestor_request(struct device *dev,
 				    struct dev_pm_qos_request *req, s32 value);
-#else
-static inline s32 __dev_pm_qos_read_value(struct device *dev)
-			{ return 0; }
-static inline s32 dev_pm_qos_read_value(struct device *dev)
-			{ return 0; }
-static inline int dev_pm_qos_add_request(struct device *dev,
-					 struct dev_pm_qos_request *req,
-					 s32 value)
-			{ return 0; }
-static inline int dev_pm_qos_update_request(struct dev_pm_qos_request *req,
-					    s32 new_value)
-			{ return 0; }
-static inline int dev_pm_qos_remove_request(struct dev_pm_qos_request *req)
-			{ return 0; }
-static inline int dev_pm_qos_add_notifier(struct device *dev,
-					  struct notifier_block *notifier)
-			{ return 0; }
-static inline int dev_pm_qos_remove_notifier(struct device *dev,
-					     struct notifier_block *notifier)
-			{ return 0; }
-static inline int dev_pm_qos_add_global_notifier(
-					struct notifier_block *notifier)
-			{ return 0; }
-static inline int dev_pm_qos_remove_global_notifier(
-					struct notifier_block *notifier)
-			{ return 0; }
-static inline void dev_pm_qos_constraints_init(struct device *dev)
-{
-	dev->power.power_state = PMSG_ON;
-}
-static inline void dev_pm_qos_constraints_destroy(struct device *dev)
-{
-	dev->power.power_state = PMSG_INVALID;
-}
-static inline int dev_pm_qos_add_ancestor_request(struct device *dev,
-				    struct dev_pm_qos_request *req, s32 value)
-			{ return 0; }
-#endif
 
 #endif
-- 
1.7.5.4

