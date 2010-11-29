Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab0K2Tne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:43:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59001 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0K2Tnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:43:33 -0500
Date: Mon, 29 Nov 2010 20:43:28 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Greg KH <greg@kroah.com>
Subject: [PATCH/RFC] core: add a function to safely try to get device driver
 owner
Message-ID: <Pine.LNX.4.64.1011292043000.27962@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:3/ddqxrsGJ+YzIWl8M4smJd8Xt8cQ3oLPEVy6cs4uea
 q5npWwcNPW1jMmYoQuYEjrhZAeGpvOKVBnXweu8cVQxYmbcNIt
 tPESc75OMQLlc06vU4S9lUPNi31kUFPWwl48PBiX3SXJEHsvAi
 LUpG1XosK6WnvyDW8iubzemQo3p2M4oE7eoP3tToWD9txZdeyM
 R8Cq9jrP9mYjOteP1+tQ6TjytSPl0f57giTQZMVP3g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When two drivers interoperate without an explicit dependency, it is often
required to prevent one of them from being unloaded safely by dereferencing
dev->driver->owner. This patch provides a generic function to do this in a
race-free way.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Not run-time tested in this form, but this is just a generalisation of the 
code in drivers/media/video/sh_mobile_ceu_camera.c::sh_mobile_ceu_probe(). 
If the idea is accepted in principle, I will replace that specific 
implementation with a call to this function, test... But I am not sure, if 
I'd be able to test it for races. If such testing is required on SMP, I'd 
have to write some test-case for it. Thoughts?

 drivers/base/dd.c      |   63 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |    1 +
 2 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index da57ee9..44c6672 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -17,10 +17,12 @@
  * This file is released under the GPLv2
  */
 
+#include <linux/completion.h>
 #include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/kthread.h>
+#include <linux/notifier.h>
 #include <linux/wait.h>
 #include <linux/async.h>
 #include <linux/pm_runtime.h>
@@ -422,3 +424,64 @@ void dev_set_drvdata(struct device *dev, void *data)
 	dev->p->driver_data = data;
 }
 EXPORT_SYMBOL(dev_set_drvdata);
+
+struct bus_wait {
+	struct notifier_block	notifier;
+	struct completion	completion;
+	struct device		*dev;
+};
+
+static int bus_notify(struct notifier_block *nb,
+		      unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct bus_wait *wait = container_of(nb, struct bus_wait, notifier);
+
+	if (wait->dev != dev)
+		return NOTIFY_DONE;
+
+	switch (action) {
+	case BUS_NOTIFY_UNBOUND_DRIVER:
+		/* Protect from module unloading */
+		wait_for_completion(&wait->completion);
+		return NOTIFY_OK;
+	}
+	return NOTIFY_DONE;
+}
+
+int device_try_get_driver(struct device *dev)
+{
+	struct bus_wait wait = {
+		.completion = COMPLETION_INITIALIZER_ONSTACK(wait.completion),
+		.dev = dev,
+		.notifier.notifier_call = bus_notify,
+	};
+	struct bus_type	*bus;
+	int ret;
+
+	if (!dev || !dev->bus)
+		return 0;
+
+	bus = dev->bus;
+
+	if (bus_register_notifier(bus, &wait.notifier) < 0)
+		return 0;
+
+	/*
+	 * From this point the driver module will not unload, until we complete
+	 * the completion. In the worst case it is hanging in device release on
+	 * our completion. So, _now_ dereferencing the "owner" is safe.
+	 */
+	if (dev->driver && dev->driver->owner)
+		ret = try_module_get(dev->driver->owner);
+	else
+		/* Either no driver, or too late, or probing failed */
+		ret = 0;
+
+	/* Let notifier complete, if it has been blocked */
+	complete(&wait.completion);
+	bus_unregister_notifier(bus, &wait.notifier);
+
+	return ret;
+}
+EXPORT_SYMBOL(device_try_get_driver);
diff --git a/include/linux/device.h b/include/linux/device.h
index dd48953..5932169 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -559,6 +559,7 @@ extern const char *device_get_devnode(struct device *dev,
 				      mode_t *mode, const char **tmp);
 extern void *dev_get_drvdata(const struct device *dev);
 extern void dev_set_drvdata(struct device *dev, void *data);
+int device_try_get_driver(struct device *dev);
 
 /*
  * Root device objects for grouping under /sys/devices
-- 
1.7.2.3

