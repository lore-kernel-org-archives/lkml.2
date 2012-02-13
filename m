Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab2BMNvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 08:51:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46255 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2BMNvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 08:51:19 -0500
MIME-Version: 1.0
From: Jean Pihet <jean.pihet@newoldbits.com>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Gross <markgross@thegnar.org>,
        Venkatesh Pallipadi <venki@google.com>
Cc: Jean Pihet <j-pihet@ti.com>
Subject: [PATCH] PM / QoS: unconditionally build the feature
Date: Mon, 13 Feb 2012 14:50:59 +0100
Message-Id: <1329141059-16554-1-git-send-email-j-pihet@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1328603646-2714-2-git-send-email-j-pihet@ti.com>
References: <1328603646-2714-2-git-send-email-j-pihet@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PM QoS feature depends on CONFIG_PM which depends on
PM_SLEEP || PM_RUNTIME. This breaks CPU C-states with kernels
not having these CONFIGs.

This patch allows the feature in all cases.

Signed-off-by: Jean Pihet <j-pihet@ti.com>
Reported-by: Venkatesh Pallipadi <venki@google.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Mark Gross <markgross@thegnar.org>
---
 include/linux/pm_qos.h |   41 +----------------------------------------
 kernel/power/Makefile  |    3 ++-
 2 files changed, 3 insertions(+), 41 deletions(-)

diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
index 4d99e4e..105be69 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -63,7 +63,6 @@ static inline int dev_pm_qos_request_active(struct dev_pm_qos_request *req)
 	return req->dev != 0;
 }
 
-#ifdef CONFIG_PM
 int pm_qos_update_target(struct pm_qos_constraints *c, struct plist_node *node,
 			 enum pm_qos_req_action action, int value);
 void pm_qos_add_request(struct pm_qos_request *req, int pm_qos_class,
@@ -78,6 +77,7 @@ int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier);
 int pm_qos_request_active(struct pm_qos_request *req);
 s32 pm_qos_read_value(struct pm_qos_constraints *c);
 
+#ifdef CONFIG_PM
 s32 __dev_pm_qos_read_value(struct device *dev);
 s32 dev_pm_qos_read_value(struct device *dev);
 int dev_pm_qos_add_request(struct device *dev, struct dev_pm_qos_request *req,
@@ -95,45 +95,6 @@ void dev_pm_qos_constraints_destroy(struct device *dev);
 int dev_pm_qos_add_ancestor_request(struct device *dev,
 				    struct dev_pm_qos_request *req, s32 value);
 #else
-static inline int pm_qos_update_target(struct pm_qos_constraints *c,
-				       struct plist_node *node,
-				       enum pm_qos_req_action action,
-				       int value)
-			{ return 0; }
-static inline void pm_qos_add_request(struct pm_qos_request *req,
-				      int pm_qos_class, s32 value)
-			{ return; }
-static inline void pm_qos_update_request(struct pm_qos_request *req,
-					 s32 new_value)
-			{ return; }
-static inline void pm_qos_remove_request(struct pm_qos_request *req)
-			{ return; }
-
-static inline int pm_qos_request(int pm_qos_class)
-{
-	switch (pm_qos_class) {
-	case PM_QOS_CPU_DMA_LATENCY:
-		return PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE;
-	case PM_QOS_NETWORK_LATENCY:
-		return PM_QOS_NETWORK_LAT_DEFAULT_VALUE;
-	case PM_QOS_NETWORK_THROUGHPUT:
-		return PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE;
-	default:
-		return PM_QOS_DEFAULT_VALUE;
-	}
-}
-
-static inline int pm_qos_add_notifier(int pm_qos_class,
-				      struct notifier_block *notifier)
-			{ return 0; }
-static inline int pm_qos_remove_notifier(int pm_qos_class,
-					 struct notifier_block *notifier)
-			{ return 0; }
-static inline int pm_qos_request_active(struct pm_qos_request *req)
-			{ return 0; }
-static inline s32 pm_qos_read_value(struct pm_qos_constraints *c)
-			{ return 0; }
-
 static inline s32 __dev_pm_qos_read_value(struct device *dev)
 			{ return 0; }
 static inline s32 dev_pm_qos_read_value(struct device *dev)
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 07e0e28..66d808e 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -1,7 +1,8 @@
 
 ccflags-$(CONFIG_PM_DEBUG)	:= -DDEBUG
 
-obj-$(CONFIG_PM)		+= main.o qos.o
+obj-y				+= qos.o
+obj-$(CONFIG_PM)		+= main.o
 obj-$(CONFIG_VT_CONSOLE_SLEEP)	+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_SUSPEND)		+= suspend.o
-- 
1.7.5.4

