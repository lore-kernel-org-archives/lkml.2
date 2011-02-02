Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab1BBAoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:59105 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab1BBAos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028514"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: rjw@sisk.pl, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [81/139] PM / Runtime: Fix pm_runtime_suspended()
Message-Id: <20110202004438.8EC983E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

commit f08f5a0add20834d3f3d876dfe08005a5df656db upstream.

There are some situations (e.g. in __pm_generic_call()), where
pm_runtime_suspended() is used to decide whether or not to execute
a device's (system) ->suspend() callback.  The callback is not
executed if pm_runtime_suspended() returns true, but it does so
for devices that don't even support runtime PM, because the
power.disable_depth device field is ignored by it.  This leads to
problems (i.e. devices are not suspened when they should), so rework
pm_runtime_suspended() so that it returns false if the device's
power.disable_depth field is different from zero.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Documentation/power/runtime_pm.txt |    4 ++--
 include/linux/pm_runtime.h         |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/Documentation/power/runtime_pm.txt
===================================================================
--- linux-2.6.35.y.orig/Documentation/power/runtime_pm.txt
+++ linux-2.6.35.y/Documentation/power/runtime_pm.txt
@@ -336,8 +336,8 @@ drivers/base/power/runtime.c and include
       zero)
 
   bool pm_runtime_suspended(struct device *dev);
-    - return true if the device's runtime PM status is 'suspended', or false
-      otherwise
+    - return true if the device's runtime PM status is 'suspended' and its
+      'power.disable_depth' field is equal to zero, or false otherwise
 
   void pm_runtime_allow(struct device *dev);
     - set the power.runtime_auto flag for the device and decrease its usage
Index: linux-2.6.35.y/include/linux/pm_runtime.h
===================================================================
--- linux-2.6.35.y.orig/include/linux/pm_runtime.h
+++ linux-2.6.35.y/include/linux/pm_runtime.h
@@ -67,7 +67,8 @@ static inline void device_set_run_wake(s
 
 static inline bool pm_runtime_suspended(struct device *dev)
 {
-	return dev->power.runtime_status == RPM_SUSPENDED;
+	return dev->power.runtime_status == RPM_SUSPENDED
+		&& !dev->power.disable_depth;
 }
 
 #else /* !CONFIG_PM_RUNTIME */
