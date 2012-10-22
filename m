Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2JVP6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:58:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56478 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab2JVP6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:58:08 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <alan@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [RESEND PATCH 1/2] of serial port driver - add clk_get_rate() support
Date: Mon, 22 Oct 2012 11:58:01 -0400
Message-ID: <1350921482-22554-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently this driver expects the clock-frequency attribute. This
patch allows getting clock-frequency through clk driver API
clk_get_rate() if clock-frequency attribute is not defined.

So in the device bindings for serial device, one can add clocks
phandle to refer to the clk device to get the rate.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 34e7187..6f64f02 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -21,8 +21,10 @@
 #include <linux/of_serial.h>
 #include <linux/of_platform.h>
 #include <linux/nwpserial.h>
+#include <linux/clk.h>
 
 struct of_serial_info {
+	struct clk *clk;
 	int type;
 	int line;
 };
@@ -51,7 +53,8 @@ EXPORT_SYMBOL_GPL(tegra_serial_handle_break);
  * Fill a struct uart_port for a given device node
  */
 static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
-					int type, struct uart_port *port)
+			int type, struct uart_port *port,
+			struct of_serial_info *info)
 {
 	struct resource resource;
 	struct device_node *np = ofdev->dev.of_node;
@@ -60,8 +63,17 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
 
 	memset(port, 0, sizeof *port);
 	if (of_property_read_u32(np, "clock-frequency", &clk)) {
-		dev_warn(&ofdev->dev, "no clock-frequency property set\n");
-		return -ENODEV;
+
+		/* Get clk rate through clk driver if present */
+		info->clk = clk_get(&ofdev->dev, NULL);
+		if (info->clk == NULL) {
+			dev_warn(&ofdev->dev,
+				"clk or clock-frequency not defined\n");
+			return -ENODEV;
+		}
+
+		clk_prepare_enable(info->clk);
+		clk = clk_get_rate(info->clk);
 	}
 	/* If current-speed was set, then try not to change it. */
 	if (of_property_read_u32(np, "current-speed", &spd) == 0)
@@ -70,7 +82,7 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
 	ret = of_address_to_resource(np, 0, &resource);
 	if (ret) {
 		dev_warn(&ofdev->dev, "invalid address\n");
-		return ret;
+		goto out;
 	}
 
 	spin_lock_init(&port->lock);
@@ -97,7 +109,8 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
 		default:
 			dev_warn(&ofdev->dev, "unsupported reg-io-width (%d)\n",
 				 prop);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 
@@ -111,6 +124,10 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
 		port->handle_break = tegra_serial_handle_break;
 
 	return 0;
+out:
+	if (info->clk)
+		clk_disable_unprepare(info->clk);
+	return ret;
 }
 
 /*
@@ -137,7 +154,7 @@ static int __devinit of_platform_serial_probe(struct platform_device *ofdev)
 		return -ENOMEM;
 
 	port_type = (unsigned long)match->data;
-	ret = of_platform_serial_setup(ofdev, port_type, &port);
+	ret = of_platform_serial_setup(ofdev, port_type, &port, info);
 	if (ret)
 		goto out;
 
@@ -193,6 +210,9 @@ static int of_platform_serial_remove(struct platform_device *ofdev)
 		/* need to add code for these */
 		break;
 	}
+
+	if (info->clk)
+		clk_disable_unprepare(info->clk);
 	kfree(info);
 	return 0;
 }
-- 
1.7.9.5

