Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381Ab1CEBAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:16 -0500
Received: from kroah.org ([198.145.64.141]:50230 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760357Ab1CEBAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:13 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:37 2011
Message-Id: <20110305005637.233257694@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [27/73] PM: Make ACPI wakeup from S5 work again when CONFIG_PM_SLEEP is unset
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 805bdaec1a44155db35f6ee5410d6bbc365324a8 upstream.

Commit 074037e (PM / Wakeup: Introduce wakeup source objects and
event statistics (v3)) caused ACPI wakeup to only work if
CONFIG_PM_SLEEP is set, but it also worked for CONFIG_PM_SLEEP unset
before.  This can be fixed by making device_set_wakeup_enable(),
device_init_wakeup() and device_may_wakeup() work in the same way
as before commit 074037e when CONFIG_PM_SLEEP is unset.

Reported-and-tested-by: Justin Maggard <jmaggard10@gmail.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/pm.h        |    2 ++
 include/linux/pm_wakeup.h |   25 ++++++++++++++-----------
 2 files changed, 16 insertions(+), 11 deletions(-)

--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -470,6 +470,8 @@ struct dev_pm_info {
 	struct list_head	entry;
 	struct completion	completion;
 	struct wakeup_source	*wakeup;
+#else
+	unsigned int		should_wakeup:1;
 #endif
 #ifdef CONFIG_PM_RUNTIME
 	struct timer_list	suspend_timer;
--- a/include/linux/pm_wakeup.h
+++ b/include/linux/pm_wakeup.h
@@ -109,11 +109,6 @@ static inline bool device_can_wakeup(str
 	return dev->power.can_wakeup;
 }
 
-static inline bool device_may_wakeup(struct device *dev)
-{
-	return false;
-}
-
 static inline struct wakeup_source *wakeup_source_create(const char *name)
 {
 	return NULL;
@@ -134,24 +129,32 @@ static inline void wakeup_source_unregis
 
 static inline int device_wakeup_enable(struct device *dev)
 {
-	return -EINVAL;
+	dev->power.should_wakeup = true;
+	return 0;
 }
 
 static inline int device_wakeup_disable(struct device *dev)
 {
+	dev->power.should_wakeup = false;
 	return 0;
 }
 
-static inline int device_init_wakeup(struct device *dev, bool val)
+static inline int device_set_wakeup_enable(struct device *dev, bool enable)
 {
-	dev->power.can_wakeup = val;
-	return val ? -EINVAL : 0;
+	dev->power.should_wakeup = enable;
+	return 0;
 }
 
+static inline int device_init_wakeup(struct device *dev, bool val)
+{
+	device_set_wakeup_capable(dev, val);
+	device_set_wakeup_enable(dev, val);
+	return 0;
+}
 
-static inline int device_set_wakeup_enable(struct device *dev, bool enable)
+static inline bool device_may_wakeup(struct device *dev)
 {
-	return -EINVAL;
+	return dev->power.can_wakeup && dev->power.should_wakeup;
 }
 
 static inline void __pm_stay_awake(struct wakeup_source *ws) {}


