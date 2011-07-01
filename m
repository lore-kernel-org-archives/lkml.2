Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab1GAFh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 01:37:26 -0400
Received: from mobile-166-190-108-096.mycingular.net ([166.190.108.96]:38470
	"EHLO brontomerus.synaptics.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751545Ab1GAFhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 01:37:10 -0400
X-Greylist: delayed 920 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jul 2011 01:37:06 EDT
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Christopher Heiny <cheiny@synaptics.com>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: [PATCH 6/9] input/touchscreen: Synaptics RMI4 Touchscreen Driver
Date: Thu, 30 Jun 2011 22:19:13 -0700
Message-Id: <1309497556-7344-7-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309497556-7344-1-git-send-email-cheiny@synaptics.com>
References: <1309497556-7344-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for Synaptics touchscreens using RMI4 protocol.

Please see the email 0/9 for a description of this patch.

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
Signed-off-by: William Manson <wmanson@synaptics.com>
Signed-off-by: Allie Xiong <axiong@synaptics.com>
Signed-off-by: Peichen Chang <peichen.chang@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

---

diff --git a/drivers/input/touchscreen/rmi_f05.h b/drivers/input/touchscreen/rmi_f05.h
new file mode 100644
index 0000000..10e4df4
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f05.h
@@ -0,0 +1,42 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $11 header.
+ * Copyright (c) 2007 - 2010, Synaptics Incorporated
+ *
+ * For every RMI4 function that has a data source - like 2D sensors,
+ * buttons, LEDs, GPIOs, etc. - the user will create a new rmi_function_xx.c
+ * file and add these functions to perform the config(), init(), report()
+ * and detect() functionality. The function pointers are then srored under
+ * the RMI function info and these functions will automatically be called by
+ * the global config(), init(), report() and detect() functions that will
+ * loop through all data sources and call the data sources functions using
+ * these functions pointed to by the function ptrs.
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#if !defined(_RMI_F05_H)
+#define _RMI_F05_H
+
+void FN_05_inthandler(struct rmi_function_info *rmifninfo,
+		      unsigned int asserted_IRQs);
+int FN_05_config(struct rmi_function_info *rmifninfo);
+int FN_05_init(struct rmi_function_device *function_device);
+int FN_05_detect(struct rmi_function_info *rmifninfo);
+/* No attention function for F05 */
+#endif
diff --git a/drivers/input/touchscreen/rmi_f05.c b/drivers/input/touchscreen/rmi_f05.c
new file mode 100644
index 0000000..2446216
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_f05.c
@@ -0,0 +1,123 @@
+/**
+ *
+ * Synaptics Register Mapped Interface (RMI4) Function $11 support for 2D.
+ * Copyright (c) 2007 - 2011, Synaptics Incorporated
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ *#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ *#############################################################################
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+#include <linux/slab.h>
+
+#include "rmi.h"
+#include "rmi_drvr.h"
+#include "rmi_bus.h"
+#include "rmi_sensor.h"
+#include "rmi_function.h"
+#include "rmi_f05.h"
+#include "rmi_platformdata.h"
+
+struct f05_instance_data {
+	int dummy;		/* TODO: Write this */
+};
+
+/*
+ * There is no attention function for F05 - it is left NULL
+ * in the function table so it is not called.
+ *
+ */
+
+/*
+ * This reads in a sample and reports the F05 source data to the
+ * input subsystem. It is used for both polling and interrupt driven
+ * operation. This is called a lot so don't put in any informational
+ * printks since they will slow things way down!
+ *
+ * This is a stub for now, and will be fleshed out when the implementation
+ * is completed.
+ */
+void FN_05_inthandler(struct rmi_function_info *rmifninfo,
+		      unsigned int asserted_IRQs)
+{
+}
+EXPORT_SYMBOL(FN_05_inthandler);
+
+/* This is a stub for now, and will be fleshed out when the implementation
+ * is completed.
+ */
+int FN_05_config(struct rmi_function_info *rmifninfo)
+{
+	int retval = 0;
+
+	pr_debug("%s: RMI4 F05 config\n", __func__);
+
+	/* TODO: Perform configuration.  In particular, write any cached control
+	 * register values to the device. */
+
+	return retval;
+}
+EXPORT_SYMBOL(FN_05_config);
+
+/* This is a stub for now, and will be fleshed out when the implementation
+ * is completed.
+ */
+int FN_05_init(struct rmi_function_device *function_device)
+{
+	int retval = 0;
+/*
+	struct f05_instance_data *instance_data = function_device->rfi->fndata;
+	struct rmi_f05_functiondata *functiondata =
+	    rmi_sensor_get_functiondata(function_device->sensor, RMI_F05_INDEX);
+*/
+
+	pr_debug("%s: RMI4 F05 init\n", __func__);
+
+	return retval;
+}
+EXPORT_SYMBOL(FN_05_init);
+
+int FN_05_detect(struct rmi_function_info *rmifninfo)
+{
+	int retval = 0;
+	struct f05_instance_data *instance_data;
+
+	pr_debug("%s: RMI4 F05 detect\n", __func__);
+
+	if (rmifninfo->fndata) {
+		/* detect routine should only ever be called once
+		 * per rmifninfo. */
+		pr_err("%s: WTF?!? F05 instance data is already present!",
+		       __func__);
+		return -EINVAL;
+	}
+	instance_data = kzalloc(sizeof(struct f05_instance_data), GFP_KERNEL);
+	if (!instance_data) {
+		pr_err("%s: Error allocating F05 instance data.\n", __func__);
+		return -ENOMEM;
+	}
+	rmifninfo->fndata = instance_data;
+
+	return retval;
+}
+EXPORT_SYMBOL(FN_05_detect);
