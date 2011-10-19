Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1JSWNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:13:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51294 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab1JSWNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:13:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 1/3] PM / Sleep: Mark devices involved in wakeup signaling during suspend
Date: Thu, 20 Oct 2011 00:13:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
References: <201110200012.43840.rjw@sisk.pl>
In-Reply-To: <201110200012.43840.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110200013.56428.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The generic PM domains code in drivers/base/power/domain.c has
to avoid powering off domains that provide power to wakeup devices
during system suspend.  Currently, however, this only works for
wakeup devices directly belonging to the given domain and not for
their children (or the children of their children and so on).
Thus, if there's a wakeup device whose parent belongs to a power
domain handled by the generic PM domains code, the domain will be
powered off during system suspend preventing the device from
signaling wakeup.

To address this problem introduce a device flag, power.wakeup_path,
that will be set during system suspend for all wakeup devices,
their parents, the parents of their parents and so on.  This way,
all wakeup paths in the device hierarchy will be marked and the
generic PM domains code will only need to avoid powering off
domains containing devices whose power.wakeup_path is set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |    4 ++--
 drivers/base/power/main.c   |    8 +++++++-
 include/linux/pm.h          |    1 +
 3 files changed, 10 insertions(+), 3 deletions(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -714,7 +714,7 @@ static int pm_genpd_suspend_noirq(struct
 	if (ret)
 		return ret;
 
-	if (device_may_wakeup(dev)
+	if (dev->power.wakeup_path
 	    && genpd->active_wakeup && genpd->active_wakeup(dev))
 		return 0;
 
@@ -938,7 +938,7 @@ static int pm_genpd_dev_poweroff_noirq(s
 	if (ret)
 		return ret;
 
-	if (device_may_wakeup(dev)
+	if (dev->power.wakeup_path
 	    && genpd->active_wakeup && genpd->active_wakeup(dev))
 		return 0;
 
Index: linux/drivers/base/power/main.c
===================================================================
--- linux.orig/drivers/base/power/main.c
+++ linux/drivers/base/power/main.c
@@ -917,7 +917,11 @@ static int __device_suspend(struct devic
 	}
 
  End:
-	dev->power.is_suspended = !error;
+	if (!error) {
+		dev->power.is_suspended = true;
+		if (dev->power.wakeup_path && dev->parent)
+			dev->parent->power.wakeup_path = true;
+	}
 
 	device_unlock(dev);
 	complete_all(&dev->power.completion);
@@ -1020,6 +1024,8 @@ static int device_prepare(struct device
 
 	device_lock(dev);
 
+	dev->power.wakeup_path = device_may_wakeup(dev);
+
 	if (dev->pm_domain) {
 		pm_dev_dbg(dev, state, "preparing power domain ");
 		if (dev->pm_domain->ops.prepare)
Index: linux/include/linux/pm.h
===================================================================
--- linux.orig/include/linux/pm.h
+++ linux/include/linux/pm.h
@@ -452,6 +452,7 @@ struct dev_pm_info {
 	struct list_head	entry;
 	struct completion	completion;
 	struct wakeup_source	*wakeup;
+	bool			wakeup_path:1;
 #else
 	unsigned int		should_wakeup:1;
 #endif

