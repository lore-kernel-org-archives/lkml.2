Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944Ab2HQXVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 19:21:43 -0400
Received: from [12.239.217.82] ([12.239.217.82]:28612 "EHLO
	venom.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756906Ab2HQXUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 19:20:47 -0400
X-Greylist: delayed 3724 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2012 19:20:45 EDT
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
Subject: [RFC PATCH 4/17] input: RMI4 configs and makefiles
Date: Fri, 17 Aug 2012 15:17:44 -0700
Message-Id: <1345241877-16200-5-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Cc: Joeri de Gram <j.de.gram@gmail.com>

Acked-by: Jean Delvare <khali@linux-fr.org>

---

 drivers/input/Kconfig       |    2 +
 drivers/input/Makefile      |    4 +-
 drivers/input/rmi4/Kconfig  |  262 +++++++++++++++++++++++++++++++++++++++++++
 drivers/input/rmi4/Makefile |   18 +++
 4 files changed, 284 insertions(+), 2 deletions(-)

diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 1903c0f..0cdd8a5 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -185,6 +185,8 @@ source "drivers/input/touchscreen/Kconfig"
 
 source "drivers/input/misc/Kconfig"
 
+source "drivers/input/rmi4/Kconfig"
+
 endif
 
 menu "Hardware I/O ports"
diff --git a/drivers/input/Makefile b/drivers/input/Makefile
index 09614ce..cfb383e 100644
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -23,6 +23,6 @@ obj-$(CONFIG_INPUT_TABLET)	+= tablet/
 obj-$(CONFIG_INPUT_TOUCHSCREEN)	+= touchscreen/
 obj-$(CONFIG_INPUT_MISC)	+= misc/
 
-obj-$(CONFIG_INPUT_APMPOWER)	+= apm-power.o
+obj-$(CONFIG_INPUT_RMI4) += rmi4/
 
-obj-$(CONFIG_XEN_KBDDEV_FRONTEND)	+= xen-kbdfront.o
+obj-$(CONFIG_INPUT_APMPOWER)	+= apm-power.o
diff --git a/drivers/input/rmi4/Kconfig b/drivers/input/rmi4/Kconfig
new file mode 100644
index 0000000..3cedf8b
--- /dev/null
+++ b/drivers/input/rmi4/Kconfig
@@ -0,0 +1,262 @@
+#
+# RMI4 configuration
+#
+config RMI4_BUS
+	bool "Synaptics RMI4 bus support"
+	help
+	  Say Y here if you want to support the Synaptics RMI4 bus.  This is
+	  required for all RMI4 device support.
+
+	  If unsure, say Y.
+
+	  This feature is not currently available as a loadable module.
+
+config RMI4_DEBUG
+	bool "RMI4 Debugging"
+	depends on RMI4_BUS
+	help
+	  Say Y here to enable debug feature in the RMI4 driver.
+
+	  Note that the RMI4 driver debug features can generate a lot of
+	  output (potentially clogging up your dmesg output) and generally
+	  slow down driver operation.  It's recommended to enable them only
+	  if you are actively developing/debugging RMI4 features.
+
+	  If unsure, say N.
+
+config RMI4_SPECIAL_EARLYSUSPEND
+	bool "Synaptics RMI4 special early suspend"
+	depends on RMI4_BUS && HAS_EARLYSUSPEND
+	help
+	  Say Y here to enable special suspend handling in the RMI4 driver.
+
+	  This feature causes the RMI4 sensors to be placed in full suspend
+	  state during the early suspend process.  The standard early suspend
+	  and late resume handlers will be replaced by the suspend and resume
+	  handling routines.  The result will be a small savings in power
+	  consumption, at the expense of decreased UI responsiveness at late
+	  resume.  Enable this feature only if you have extremely limited
+	  power resources in your system.
+
+	  If unsure, say N.
+
+config RMI4_FWLIB
+	bool "RMI4 Firmware Update"
+	depends on RMI4_BUS
+	help
+	  Say Y here to enable in-kernel firmware update capability.
+
+	  The RMI4 driver will check for firmware updates during the device
+	  initialization process, and apply the updates if appropriate.
+
+	  This feature is not available as a loadable module.
+
+
+config RMI4_I2C
+	bool "RMI4 I2C Support"
+	depends on RMI4_BUS && I2C
+	help
+	  Say Y here if you want to support RMI4 devices connected to an I2C
+	  bus.
+
+	  If unsure, say Y.
+
+	  This feature is not currently available as a loadable module.
+
+config RMI4_SPI
+	bool "RMI4 SPI Support"
+	depends on RMI4_BUS && SPI
+	help
+	  Say Y here if you want to support RMI4 devices connected to an SPI
+	  bus.
+
+	  If unsure, say Y.
+
+	  This feature is not currently available as a loadable module.
+
+config RMI4_SMB
+	bool "RMI4 SMB Support"
+	depends on RMI4_BUS
+	help
+	  Say Y here if you want to support RMI4 devices connected to an SMB
+	  bus.
+
+	  If unsure, say Y.
+
+	  This feature is not currently available as a loadable module.
+
+config RMI4_GENERIC
+	bool "RMI4 Generic driver"
+	depends on RMI4_BUS
+	help
+	  Say Y here if you want to support generic RMI4 devices.
+
+	  This is pretty much required if you want to do anything useful with
+	  your RMI device.
+
+	  This feature is not currently available as a loadable module.
+
+
+config RMI4_F1A
+	tristate "RMI4 Function 1A (capacitive button sensor)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 1A.
+
+	  Function 1A provides self testing for touchscreens and touchpads.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f1a.
+
+config RMI4_F09
+	tristate "RMI4 Function 09 (self testing)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 09.
+
+	  Function 09 provides self testing for touchscreens and touchpads.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f09.
+
+config RMI4_F11
+	tristate "RMI4 Function 11 (2D pointing)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 11.
+
+	  Function 11 provides 2D multifinger pointing for touchscreens and
+	  touchpads.  For sensors that support relative pointing, F11 also
+	  provides mouse input.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f11.
+
+config RMI4_F11_PEN
+	bool "RMI4 F11 Pen Support"
+	depends on RMI4_F11
+	help
+	  Say Y here to add support for pen input to RMI4 function 11.
+
+	  If this feature is enabled, when pen inputs are detected they
+	  will be reported to the input stream as MT_TOOL_PEN.  Otherwise,
+	  pens will be treated the same as fingers.
+
+	  Not all UI implementations deal gracefully with pen discrimination.
+	  If your system is not recognizing pen touches and you know your
+	  sensor supports pen input, you probably want to turn this feature
+	  off.
+
+config RMI4_F11_TYPEB
+	bool "RMI4 F11 Type B Support"
+	depends on RMI4_F11
+	help
+	  Say Y here to add support for Type B multi-touch.
+
+	  If this feature is enabled, the driver will support type B multi-
+	  touch input.
+
+	  See Documentation/input/multi-touch-protocol for details.
+
+config RMI4_VIRTUAL_BUTTON
+	tristate "RMI4 Vitual Button"
+	depends on RMI4_F11
+	help
+	  Say Y here if you want to add support for RMI4 virtual button to F11.
+
+	  The virtual button feature implement the virtual button device in
+	  certain RMI4 touch sensors.
+
+	  This works only if your sensor supports F11 gestures.
+
+config RMI4_F17
+	tristate "RMI4 Function 17 (pointing sticks)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 17.
+
+	  Function 19 provides support for capacitive and resistive
+	  pointing sticks.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f17.
+
+config RMI4_F19
+	tristate "RMI4 Function 19 (0D pointing)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 19.
+
+	  Function 19 provides support for capacitive buttons for sensors
+	  that implement capacitive buttons.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f19.
+
+config RMI4_F21
+	tristate "RMI4 Function 21 (2D Force)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 21.
+
+	  Function 21 provides 2D Force Sensing for ForcePad products.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f21.
+
+config RMI4_F30
+	tristate "RMI4 Function 30 (GPIO LED)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 30.
+
+	  Function 30 provides GPIO LED support for sensors.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f30.
+
+config RMI4_F34
+	tristate "RMI4 Function 34 (device reflash)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 34.
+
+	  Function 34 provides firmware upgrade capability for your sensor.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f34.
+
+config RMI4_F41
+	tristate "RMI4 Function 41 (active pen)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 41.
+
+	  Function 41 provides active pen support for active pen enabled sensors.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f41.
+
+config RMI4_F54
+	tristate "RMI4 Function 54 (analog diagnostics)"
+	depends on RMI4_BUS && RMI4_GENERIC
+	help
+	  Say Y here if you want to add support for RMI4 function 54.
+
+	  Function 54 provides access to various diagnostic features in
+	  certain RMI4 touch sensors.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-f54.
+
+config RMI4_DEV
+	tristate "Synaptics direct RMI device support (rmidev)"
+	depends on GPIO_SYSFS && (RMI4_I2C || RMI4_SPI)
+	help
+	  Say Y here to add support for rmidev.
+
+	  The rmidev feature implements a character device providing access
+	  to RMI4 sensor register maps.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rmi-dev.
diff --git a/drivers/input/rmi4/Makefile b/drivers/input/rmi4/Makefile
new file mode 100644
index 0000000..4a14a21
--- /dev/null
+++ b/drivers/input/rmi4/Makefile
@@ -0,0 +1,18 @@
+obj-$(CONFIG_RMI4_BUS) += rmi_bus.o
+obj-$(CONFIG_RMI4_I2C) += rmi_i2c.o
+obj-$(CONFIG_RMI4_SPI) += rmi_spi.o
+obj-$(CONFIG_RMI4_SMB) += rmi_smbus.o
+obj-$(CONFIG_RMI4_GENERIC) += rmi_driver.o rmi_f01.o
+obj-$(CONFIG_RMI4_FWLIB) += rmi_fw_update.o
+obj-$(CONFIG_RMI4_F09) += rmi_f09.o
+obj-$(CONFIG_RMI4_F1A) += rmi_f1a.o
+obj-$(CONFIG_RMI4_F11) += rmi_f11.o
+obj-$(CONFIG_RMI4_F17) += rmi_f17.o
+obj-$(CONFIG_RMI4_F19) += rmi_f19.o
+obj-$(CONFIG_RMI4_F21) += rmi_f21.o
+obj-$(CONFIG_RMI4_F30) += rmi_f30.o
+obj-$(CONFIG_RMI4_F34) += rmi_f34.o
+obj-$(CONFIG_RMI4_F41) += rmi_f41.o
+obj-$(CONFIG_RMI4_F54) += rmi_f54.o
+obj-$(CONFIG_RMI4_DEV) += rmi_dev.o
+
