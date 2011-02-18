Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1BRCtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 21:49:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59057 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab1BRCta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 21:49:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=W9xQfg4bm96VBnT+JMjq3qv/ed+E16TZEikFEySlXm9U6pR3Ms+mNgGTxHl0J/xGy7
         4jab43E27Y/9TGZFMKpxBZQAO8M1SgrCzK4csn0BoRBryBvhHSjOwvjmTo74SoLzOFNA
         k9KLlWeUhPKmB14P8UTCougGawNLo3l1Fyvlo=
MIME-Version: 1.0
In-Reply-To: <AANLkTikRUZRh0YnP8nYTKFnFeUiJbK5xKvHHjn_S+gZE@mail.gmail.com>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com>
 <201012170109.43137.rjw@sisk.pl> <AANLkTikRUZRh0YnP8nYTKFnFeUiJbK5xKvHHjn_S+gZE@mail.gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Fri, 18 Feb 2011 08:18:48 +0530
X-Google-Sender-Auth: u-fW_ath8ny33lTIkP4t1euYwYI
Message-ID: <AANLkTinsPqFcodH0w7LQeFEY+amodNH4CneRCRhhbKaz@mail.gmail.com>
Subject: Re: platform/i2c busses: pm runtime and system sleep
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: stern@rowland.harvard.edu, linux-pm@lists.linux-foundation.org,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        khilman@ti.com, magnus.damm@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 20:55, Rabin Vincent <rabin@rab.in> wrote:
> This will solve the platform vs AMBA bus, but shouldn't we really be
> aiming for consistent behaviour between these and the other busses such
> as I2C and SPI, which are also usually commonly used on the same
> platforms and are using GENERIC_PM_OPS?
>
> Should we be auditing all platform drivers and then switch platform to
> the GENERIC_PM_OPS?
>
> Or should the two points (1) and (2) be not handled in the bus at all
> and be left to individual drivers (in which case we should audit i2c and
> spi and change GENERIC_PM_OPS)?

How about something like the below?  If we have something like this, we
can just switch platform to GENERIC_PM_OPS and add the
pm_runtime_want_interaction() (or something better named) call to the
i2c and spi drivers using runtime PM.

diff --git a/drivers/base/power/generic_ops.c b/drivers/base/power/generic_ops.c
index 42f97f9..c2a3b63 100644
--- a/drivers/base/power/generic_ops.c
+++ b/drivers/base/power/generic_ops.c
@@ -87,7 +87,10 @@ static int __pm_generic_call(struct device *dev, int event)
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int (*callback)(struct device *);

-	if (!pm || pm_runtime_suspended(dev))
+	if (!pm)
+		return 0;
+
+	if (device_want_interaction(dev) && pm_runtime_suspended(dev))
 		return 0;

 	switch (event) {
@@ -185,7 +188,7 @@ static int __pm_generic_resume(struct device *dev,
int event)
 		return 0;

 	ret = callback(dev);
-	if (!ret && pm_runtime_enabled(dev)) {
+	if (!ret && device_want_interaction(dev) && pm_runtime_enabled(dev)) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 42615b4..2b8a099 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1069,6 +1069,30 @@ void pm_runtime_allow(struct device *dev)
 EXPORT_SYMBOL_GPL(pm_runtime_allow);

 /**
+ * pm_runtime_want_interaction - Enable interaction between system sleep
+ *				 and runtime PM callbacks at the bus/subsystem
+ *				 level.
+ * @dev: Device to handle
+ *
+ * Set the power.want_interaction flage, which tells the generic PM subsystem
+ * ops that the following actions should be done during system suspend/resume:
+ *
+ * - If the device has been runtime suspended, the driver's
+ *   suspend() handler will not be invoked.
+ *
+ * - If the device has a resume() pm callback, and the resume()
+ *   callback returns success on system resume, the device's
+ *   runtime PM status will be set to active.
+ */
+void pm_runtime_want_interaction(struct device *dev)
+{
+	spin_lock_irq(&dev->power.lock);
+	dev->power.want_interaction = 1;
+	spin_unlock_irq(&dev->power.lock);
+}
+EXPORT_SYMBOL_GPL(pm_runtime_want_interaction);
+
+/**
  * pm_runtime_no_callbacks - Ignore run-time PM callbacks for a device.
  * @dev: Device to handle.
  *
diff --git a/include/linux/pm.h b/include/linux/pm.h
index dd9c7ab..b9bcfb9 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -450,6 +450,7 @@ struct dev_pm_info {
 	unsigned int		irq_safe:1;
 	unsigned int		use_autosuspend:1;
 	unsigned int		timer_autosuspends:1;
+	unsigned int		want_interaction:1;
 	enum rpm_request	request;
 	enum rpm_status		runtime_status;
 	int			runtime_error;
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index d34f067..a0e081b 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -44,6 +44,7 @@ extern void pm_runtime_irq_safe(struct device *dev);
 extern void __pm_runtime_use_autosuspend(struct device *dev, bool use);
 extern void pm_runtime_set_autosuspend_delay(struct device *dev, int delay);
 extern unsigned long pm_runtime_autosuspend_expiration(struct device *dev);
+static void pm_runtime_want_system_sleep_interaction(struct device *dev);

 static inline bool pm_children_suspended(struct device *dev)
 {
@@ -66,6 +67,11 @@ static inline void pm_runtime_put_noidle(struct device *dev)
 	atomic_add_unless(&dev->power.usage_count, -1, 0);
 }

+static inline bool device_want_interaction(struct device *dev)
+{
+	return dev->power.want_interaction;
+}
+
 static inline bool device_run_wake(struct device *dev)
 {
 	return dev->power.run_wake;
@@ -122,6 +128,7 @@ static inline bool pm_children_suspended(struct
device *dev) { return false; }
 static inline void pm_suspend_ignore_children(struct device *dev, bool en) {}
 static inline void pm_runtime_get_noresume(struct device *dev) {}
 static inline void pm_runtime_put_noidle(struct device *dev) {}
+static inline bool device_want_interaction(struct device *dev) {
return false; }
 static inline bool device_run_wake(struct device *dev) { return false; }
 static inline void device_set_run_wake(struct device *dev, bool enable) {}
 static inline bool pm_runtime_suspended(struct device *dev) { return false; }
@@ -132,6 +139,7 @@ static inline int
pm_generic_runtime_suspend(struct device *dev) { return 0; }
 static inline int pm_generic_runtime_resume(struct device *dev) { return 0; }
 static inline void pm_runtime_no_callbacks(struct device *dev) {}
 static inline void pm_runtime_irq_safe(struct device *dev) {}
+static inline void pm_runtime_want_system_sleep_interaction(struct
device *dev) {}

 static inline void pm_runtime_mark_last_busy(struct device *dev) {}
 static inline void __pm_runtime_use_autosuspend(struct device *dev,
