Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab1AFAa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:30:29 -0500
Received: from kroah.org ([198.145.64.141]:35856 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab1AFAa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:27 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:05 2011
Message-Id: <20110106002305.025630892@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [087/152] PM / Runtime: Fix pm_runtime_suspended()
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 Documentation/power/runtime_pm.txt |    4 ++--
 include/linux/pm_runtime.h         |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/power/runtime_pm.txt
+++ b/Documentation/power/runtime_pm.txt
@@ -336,8 +336,8 @@ drivers/base/power/runtime.c and include
       zero)
 
   bool pm_runtime_suspended(struct device *dev);
-    - return true if the device's runtime PM status is 'suspended', or false
-      otherwise
+    - return true if the device's runtime PM status is 'suspended' and its
+      'power.disable_depth' field is equal to zero, or false otherwise
 
   void pm_runtime_allow(struct device *dev);
     - set the power.runtime_auto flag for the device and decrease its usage
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -67,7 +67,8 @@ static inline void device_set_run_wake(s
 
 static inline bool pm_runtime_suspended(struct device *dev)
 {
-	return dev->power.runtime_status == RPM_SUSPENDED;
+	return dev->power.runtime_status == RPM_SUSPENDED
+		&& !dev->power.disable_depth;
 }
 
 #else /* !CONFIG_PM_RUNTIME */


