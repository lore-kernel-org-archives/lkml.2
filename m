Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab2EIVic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:38:32 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34538 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416Ab2EIVi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:38:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 1/2] PM / cpuidle: Add driver reference counter
Date: Wed, 9 May 2012 23:41:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Colin Cross <ccross@android.com>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <201205092340.26561.rjw@sisk.pl>
In-Reply-To: <201205092340.26561.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205092341.56059.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add a reference counter for the cpuidle driver, so that it can't
be unregistered when it is in use.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/cpuidle/driver.c |   29 ++++++++++++++++++++++++++++-
 include/linux/cpuidle.h  |    6 +++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

Index: linux/drivers/cpuidle/driver.c
===================================================================
--- linux.orig/drivers/cpuidle/driver.c
+++ linux/drivers/cpuidle/driver.c
@@ -16,6 +16,7 @@
 
 static struct cpuidle_driver *cpuidle_curr_driver;
 DEFINE_SPINLOCK(cpuidle_driver_lock);
+int cpuidle_driver_refcount;
 
 static void __cpuidle_register_driver(struct cpuidle_driver *drv)
 {
@@ -89,8 +90,34 @@ void cpuidle_unregister_driver(struct cp
 	}
 
 	spin_lock(&cpuidle_driver_lock);
-	cpuidle_curr_driver = NULL;
+
+	if (!WARN_ON(cpuidle_driver_refcount > 0))
+		cpuidle_curr_driver = NULL;
+
 	spin_unlock(&cpuidle_driver_lock);
 }
 
 EXPORT_SYMBOL_GPL(cpuidle_unregister_driver);
+
+struct cpuidle_driver *cpuidle_driver_ref(void)
+{
+	struct cpuidle_driver *drv;
+
+	spin_lock(&cpuidle_driver_lock);
+
+	drv = cpuidle_curr_driver;
+	cpuidle_driver_refcount++;
+
+	spin_unlock(&cpuidle_driver_lock);
+	return drv;
+}
+
+void cpuidle_driver_unref(void)
+{
+	spin_lock(&cpuidle_driver_lock);
+
+	if (!WARN_ON(cpuidle_driver_refcount <= 0))
+		cpuidle_driver_refcount--;
+
+	spin_unlock(&cpuidle_driver_lock);
+}
Index: linux/include/linux/cpuidle.h
===================================================================
--- linux.orig/include/linux/cpuidle.h
+++ linux/include/linux/cpuidle.h
@@ -136,7 +136,9 @@ struct cpuidle_driver {
 extern void disable_cpuidle(void);
 extern int cpuidle_idle_call(void);
 extern int cpuidle_register_driver(struct cpuidle_driver *drv);
-struct cpuidle_driver *cpuidle_get_driver(void);
+extern struct cpuidle_driver *cpuidle_get_driver(void);
+extern struct cpuidle_driver *cpuidle_driver_ref(void);
+extern void cpuidle_driver_unref(void);
 extern void cpuidle_unregister_driver(struct cpuidle_driver *drv);
 extern int cpuidle_register_device(struct cpuidle_device *dev);
 extern void cpuidle_unregister_device(struct cpuidle_device *dev);
@@ -157,6 +159,8 @@ static inline int cpuidle_idle_call(void
 static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
 {return -ENODEV; }
 static inline struct cpuidle_driver *cpuidle_get_driver(void) {return NULL; }
+static inline struct cpuidle_driver *cpuidle_driver_ref(void) {return NULL; }
+static inline void cpuidle_driver_unref(void) {}
 static inline void cpuidle_unregister_driver(struct cpuidle_driver *drv) { }
 static inline int cpuidle_register_device(struct cpuidle_device *dev)
 {return -ENODEV; }

