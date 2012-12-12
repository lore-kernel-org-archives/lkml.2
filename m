Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab2LLVfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:35:17 -0500
Received: from mail-yh0-f74.google.com ([209.85.213.74]:58484 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2LLVfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:35:12 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Simon Glass <sjg@chromium.org>,
        Che-Liang Chiou <clchiou@chromium.org>,
        Jonathan Kliegman <kliegs@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: [PATCH 2/5] mfd: Add ChromeOS EC implementation
Date: Wed, 12 Dec 2012 13:33:45 -0800
Message-Id: <1355348028-19017-3-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1355348028-19017-1-git-send-email-sjg@chromium.org>
References: <1355348028-19017-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the base EC implementation, which provides a high level
interface to the EC for use by the rest of the kernel. The actual
communcations is dealt with by a separate protocol driver which
registers itself with this interface.

Interrupts are passed on through a notifier. The driver supports
resume notification also, in case drivers wish to perform some
action there.

A simple message structure is used to pass messages to the
protocol driver.
Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>
Signed-off-by: Jonathan Kliegman <kliegs@chromium.org>
Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
Signed-off-by: Olof Johansson <olofj@chromium.org>
Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 Documentation/devicetree/bindings/mfd/cros-ec.txt |   56 ++++++
 drivers/mfd/Kconfig                               |    8 +
 drivers/mfd/Makefile                              |    1 +
 drivers/mfd/cros_ec.c                             |  219 +++++++++++++++++++++
 include/linux/mfd/cros_ec.h                       |  190 ++++++++++++++++++
 5 files changed, 474 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/cros-ec.txt
 create mode 100644 drivers/mfd/cros_ec.c
 create mode 100644 include/linux/mfd/cros_ec.h

diff --git a/Documentation/devicetree/bindings/mfd/cros-ec.txt b/Documentation/devicetree/bindings/mfd/cros-ec.txt
new file mode 100644
index 0000000..e0e59c5
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/cros-ec.txt
@@ -0,0 +1,56 @@
+ChromeOS Embedded Controller
+
+Google's ChromeOS EC is a Cortex-M device which talks to the AP and
+implements various function such as keyboard and battery charging.
+
+The EC can be connect through various means (I2C, SPI, LPC) and the
+compatible string used depends on the inteface. Each connection method has
+its own driver which connects to the top level interface-agnostic EC driver.
+Other Linux driver (such as cros-ec-keyb for the matrix keyboard) connect to
+the top-level driver.
+
+Required properties (I2C):
+- compatible: "google,cros-ec-i2c"
+- reg: I2C slave address
+
+Required properties (SPI):
+- compatible: "google,cros-ec-spi"
+- reg: SPI chip select
+
+Required properties (LPC):
+- compatible: "google,cros-ec-lpc"
+- reg: List of (IO address, size) pairs defining the interface uses
+
+
+Example for I2C:
+
+i2c@12CA0000 {
+	cros-ec@1e {
+		reg = <0x1e>;
+		compatible = "google,cros-ec-i2c";
+		interrupts = <14 0>;
+		interrupt-parent = <&wakeup_eint>;
+		wakeup-source;
+	};
+
+
+Example for SPI:
+
+spi@131b0000 {
+	ec@0 {
+		compatible = "google,cros-ec-spi";
+		reg = <0x0>;
+		interrupts = <14 0>;
+		interrupt-parent = <&wakeup_eint>;
+		wakeup-source;
+		spi-max-frequency = <5000000>;
+		controller-data {
+		cs-gpio = <&gpf0 3 4 3 0>;
+		samsung,spi-cs;
+		samsung,spi-feedback-delay = <2>;
+		};
+	};
+};
+
+
+Example for LPC is not supplied as it is not yet implemented.
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 09d43a9..6983eb4 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -21,6 +21,14 @@ config MFD_88PM860X
 	  select individual components like voltage regulators, RTC and
 	  battery-charger under the corresponding menus.
 
+config MFD_CROS_EC
+	bool "Support ChromeOS Embedded Controller"
+	help
+	  If you say yes here you get support for the ChromeOS Embedded
+	  Controller (EC) providing keyboard, battery and power services.
+	  You also ned to enable the driver for the bus you are using. The
+	  protocol for talking to the EC is defined by the bus driver.
+
 config MFD_88PM800
 	tristate "Support Marvell 88PM800"
 	depends on I2C=y && GENERIC_HARDIRQS
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index baab62e..5a9c9f6 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_MFD_88PM800)	+= 88pm800.o 88pm80x.o
 obj-$(CONFIG_MFD_88PM805)	+= 88pm805.o 88pm80x.o
 obj-$(CONFIG_MFD_SM501)		+= sm501.o
 obj-$(CONFIG_MFD_ASIC3)		+= asic3.o tmio_core.o
+obj-$(CONFIG_MFD_CROS_EC)	+= cros_ec.o
 
 rtsx_pci-objs			:= rtsx_pcr.o rts5209.o rts5229.o rtl8411.o
 obj-$(CONFIG_MFD_RTSX_PCI)	+= rtsx_pci.o
diff --git a/drivers/mfd/cros_ec.c b/drivers/mfd/cros_ec.c
new file mode 100644
index 0000000..a3651cb
--- /dev/null
+++ b/drivers/mfd/cros_ec.c
@@ -0,0 +1,219 @@
+/*
+ * ChromeOS EC multi-function device
+ *
+ * Copyright (C) 2012 Google, Inc
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * The ChromeOS EC multi function device is used to mux all the requests
+ * to the EC device for its multiple features: keyboard controller,
+ * battery charging and regulator control, firmware update.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/cros_ec.h>
+#include <linux/mfd/cros_ec_commands.h>
+
+int cros_ec_prepare_tx(struct cros_ec_device *ec_dev,
+		       struct cros_ec_msg *msg)
+{
+	uint8_t *out;
+	int csum, i;
+
+	BUG_ON(msg->out_len > EC_HOST_PARAM_SIZE);
+	out = ec_dev->dout;
+	out[0] = EC_CMD_VERSION0 + msg->version;
+	out[1] = msg->cmd;
+	out[2] = msg->out_len;
+	csum = out[0] + out[1] + out[2];
+	for (i = 0; i < msg->out_len; i++)
+		csum += out[EC_MSG_TX_HEADER_BYTES + i] = msg->out_buf[i];
+	out[EC_MSG_TX_HEADER_BYTES + msg->out_len] = (uint8_t)(csum & 0xff);
+
+	return EC_MSG_TX_PROTO_BYTES + msg->out_len;
+}
+
+static int cros_ec_command_sendrecv(struct cros_ec_device *ec_dev,
+		uint16_t cmd, void *out_buf, int out_len,
+		void *in_buf, int in_len)
+{
+	struct cros_ec_msg msg;
+
+	msg.version = cmd >> 8;
+	msg.cmd = cmd & 0xff;
+	msg.out_buf = out_buf;
+	msg.out_len = out_len;
+	msg.in_buf = in_buf;
+	msg.in_len = in_len;
+
+	return ec_dev->command_xfer(ec_dev, &msg);
+}
+
+static int cros_ec_command_recv(struct cros_ec_device *ec_dev,
+		uint16_t cmd, void *buf, int buf_len)
+{
+	return cros_ec_command_sendrecv(ec_dev, cmd, NULL, 0, buf, buf_len);
+}
+
+static int cros_ec_command_send(struct cros_ec_device *ec_dev,
+		uint16_t cmd, void *buf, int buf_len)
+{
+	return cros_ec_command_sendrecv(ec_dev, cmd, buf, buf_len, NULL, 0);
+}
+
+struct cros_ec_device *__devinit cros_ec_alloc(const char *name)
+{
+	struct cros_ec_device *ec_dev;
+
+	ec_dev = kzalloc(sizeof(*ec_dev), GFP_KERNEL);
+	if (ec_dev == NULL) {
+		dev_err(ec_dev->dev, "cannot allocate\n");
+		return NULL;
+	}
+	ec_dev->name = name;
+
+	return ec_dev;
+}
+
+void __devexit cros_ec_free(struct cros_ec_device *ec)
+{
+	kfree(ec);
+}
+
+static irqreturn_t ec_irq_thread(int irq, void *data)
+{
+	struct cros_ec_device *ec_dev = data;
+
+	if (device_may_wakeup(ec_dev->dev))
+		pm_wakeup_event(ec_dev->dev, 0);
+
+	blocking_notifier_call_chain(&ec_dev->event_notifier, 1, ec_dev);
+
+	return IRQ_HANDLED;
+}
+
+static struct mfd_cell cros_devs[] = {
+	{
+		.name = "cros-ec-keyb",
+		.id = 1,
+	},
+};
+
+int __devinit cros_ec_register(struct cros_ec_device *ec_dev)
+{
+	struct device *dev = ec_dev->dev;
+	int err = 0;
+
+	BLOCKING_INIT_NOTIFIER_HEAD(&ec_dev->event_notifier);
+	BLOCKING_INIT_NOTIFIER_HEAD(&ec_dev->wake_notifier);
+
+	ec_dev->command_send = cros_ec_command_send;
+	ec_dev->command_recv = cros_ec_command_recv;
+	ec_dev->command_sendrecv = cros_ec_command_sendrecv;
+
+	if (ec_dev->din_size) {
+		ec_dev->din = kmalloc(ec_dev->din_size, GFP_KERNEL);
+		if (!ec_dev->din) {
+			err = -ENOMEM;
+			dev_err(dev, "cannot allocate din\n");
+			goto fail_din;
+		}
+	}
+	if (ec_dev->dout_size) {
+		ec_dev->dout = kmalloc(ec_dev->dout_size, GFP_KERNEL);
+		if (!ec_dev->dout) {
+			err = -ENOMEM;
+			dev_err(dev, "cannot allocate dout\n");
+			goto fail_dout;
+		}
+	}
+
+	if (!ec_dev->irq) {
+		dev_dbg(dev, "no valid IRQ: %d\n", ec_dev->irq);
+		goto fail_irq;
+	}
+
+	err = request_threaded_irq(ec_dev->irq, NULL, ec_irq_thread,
+				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				   "chromeos-ec", ec_dev);
+	if (err) {
+		dev_err(dev, "request irq %d: error %d\n", ec_dev->irq, err);
+		goto fail_irq;
+	}
+
+	err = mfd_add_devices(dev, 0, cros_devs,
+			      ARRAY_SIZE(cros_devs),
+			      NULL, ec_dev->irq, NULL);
+	if (err) {
+		dev_err(dev, "failed to add mfd devices");
+		goto fail_mfd;
+	}
+
+	dev_info(dev, "Chrome EC (%s)\n", ec_dev->name);
+
+	return 0;
+
+fail_mfd:
+	free_irq(ec_dev->irq, ec_dev);
+fail_irq:
+	kfree(ec_dev->dout);
+fail_dout:
+	kfree(ec_dev->din);
+fail_din:
+	return err;
+}
+
+int __devexit cros_ec_remove(struct cros_ec_device *ec_dev)
+{
+	mfd_remove_devices(ec_dev->dev);
+	free_irq(ec_dev->irq, ec_dev);
+	kfree(ec_dev->dout);
+	kfree(ec_dev->din);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+int cros_ec_suspend(struct cros_ec_device *ec_dev)
+{
+	struct device *dev = ec_dev->dev;
+
+	if (device_may_wakeup(dev))
+		ec_dev->wake_enabled = !enable_irq_wake(ec_dev->irq);
+
+	disable_irq(ec_dev->irq);
+
+	return 0;
+}
+
+int cros_ec_resume(struct cros_ec_device *ec_dev)
+{
+	/*
+	 * When the EC is not a wake source, then it could not have caused the
+	 * resume, so we should do the resume processing. This may clear the
+	 * EC's key scan buffer, for example. If the EC is a wake source (e.g.
+	 * the lid is open and the user might press a key to wake) then we
+	 * don't want to do resume processing (key scan buffer should be
+	 * preserved).
+	 */
+	if (!ec_dev->wake_enabled)
+		blocking_notifier_call_chain(&ec_dev->wake_notifier, 1, ec_dev);
+	enable_irq(ec_dev->irq);
+
+	if (ec_dev->wake_enabled) {
+		disable_irq_wake(ec_dev->irq);
+		ec_dev->wake_enabled = 0;
+	}
+
+	return 0;
+}
+#endif
diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
new file mode 100644
index 0000000..3d7cb40
--- /dev/null
+++ b/include/linux/mfd/cros_ec.h
@@ -0,0 +1,190 @@
+/*
+ * ChromeOS EC multi-function device
+ *
+ * Copyright (C) 2012 Google, Inc
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __LINUX_MFD_CROS_EC_H
+#define __LINUX_MFD_CROS_EC_H
+
+struct i2c_msg;
+
+#include <linux/mfd/cros_ec_commands.h>
+
+/*
+ * Command interface between EC and AP, for LPC, I2C and SPI interfaces.
+ */
+enum {
+	EC_MSG_TX_HEADER_BYTES	= 3,
+	EC_MSG_TX_TRAILER_BYTES	= 1,
+	EC_MSG_TX_PROTO_BYTES	= EC_MSG_TX_HEADER_BYTES +
+					EC_MSG_TX_TRAILER_BYTES,
+	EC_MSG_RX_PROTO_BYTES	= 3,
+
+	/* Max length of messages */
+	EC_MSG_BYTES		= EC_HOST_PARAM_SIZE + EC_MSG_TX_PROTO_BYTES,
+
+};
+
+/**
+ * struct cros_ec_msg - A message sent to the EC, and its reply
+ *
+ * @version: Command version number (often 0)
+ * @cmd: Command to send (EC_CMD_...)
+ * @out_buf: Outgoing payload (to EC)
+ * @outlen: Outgoing length
+ * @in_buf: Incoming payload (from EC)
+ * @in_len: Incoming length
+ */
+struct cros_ec_msg {
+	u8 version;
+	u8 cmd;
+	uint8_t *out_buf;
+	int out_len;
+	uint8_t *in_buf;
+	int in_len;
+};
+
+/**
+ * struct cros_ec_device - Information about a ChromeOS EC device
+ *
+ * @name: Name of this EC interface
+ * @priv: Private data
+ * @irq: Interrupt to use
+ * @din: input buffer (from EC)
+ * @dout: output buffer (to EC)
+ * \note
+ * These two buffers will always be dword-aligned and include enough
+ * space for up to 7 word-alignment bytes also, so we can ensure that
+ * the body of the message is always dword-aligned (64-bit).
+ *
+ * We use this alignment to keep ARM and x86 happy. Probably word
+ * alignment would be OK, there might be a small performance advantage
+ * to using dword.
+ * @din_size: size of din buffer
+ * @dout_size: size of dout buffer
+ * @command_send: send a command
+ * @command_recv: receive a command
+ * @get_name: return name of EC device (e.g. 'chromeos-ec')
+ * @get_phys_name: return name of physical comms layer (e.g. 'i2c-4')
+ * @get_parent: return pointer to parent device (e.g. i2c or spi device)
+ * @dev: Device pointer
+ * dev_lock: Lock to prevent concurrent access
+ * @wake_enabled: true if this device can wake the system from sleep
+ * @event_notifier: interrupt event notifier for transport devices
+ * @wake_notifier: wake notfier for client devices (e.g. keyboard). This
+ *	indicates to sub-drivers that we have woken up from resume but we
+ *	were not a wakeup source.
+ */
+struct cros_ec_device {
+	const char *name;
+	void *priv;
+	int irq;
+	uint8_t *din;
+	uint8_t *dout;
+	int din_size;
+	int dout_size;
+	int (*command_send)(struct cros_ec_device *ec,
+			uint16_t cmd, void *out_buf, int out_len);
+	int (*command_recv)(struct cros_ec_device *ec,
+			uint16_t cmd, void *in_buf, int in_len);
+	int (*command_sendrecv)(struct cros_ec_device *ec,
+			uint16_t cmd, void *out_buf, int out_len,
+			void *in_buf, int in_len);
+	int (*command_xfer)(struct cros_ec_device *ec,
+			struct cros_ec_msg *msg);
+
+	const char *(*get_name)(struct cros_ec_device *ec_dev);
+
+	const char *(*get_phys_name)(struct cros_ec_device *ec_dev);
+
+	struct device *(*get_parent)(struct cros_ec_device *ec_dev);
+
+	/* These are --private-- fields - do not assign */
+	struct device *dev;
+	struct mutex dev_lock;
+	bool wake_enabled;
+	struct blocking_notifier_head event_notifier;
+	struct blocking_notifier_head wake_notifier;
+};
+
+/**
+ * cros_ec_suspend - Handle a suspend operation for the ChromeOS EC device
+ *
+ * This can be called by drivers to handle a suspend event.
+ *
+ * ec_dev: Device to suspend
+ * @return 0 if ok, -ve on error
+ */
+int cros_ec_suspend(struct cros_ec_device *ec_dev);
+
+/**
+ * cros_ec_resume - Handle a resume operation for the ChromeOS EC device
+ *
+ * This can be called by drivers to handle a resume event.
+ *
+ * @ec_dev: Device to resume
+ * @return 0 if ok, -ve on error
+ */
+int cros_ec_resume(struct cros_ec_device *ec_dev);
+
+/**
+ * cros_ec_prepare_tx - Prepare an outgoing message in the output buffer
+ *
+ * This is intended to be used by all ChromeOS EC drivers, but at present
+ * only SPI uses it. Once LPC uses the same protocol it can start using it.
+ * I2C could use it now, with a refactor of the existing code.
+ *
+ * @ec_dev: Device to register
+ * @msg: Message to write
+ */
+int cros_ec_prepare_tx(struct cros_ec_device *ec_dev,
+		       struct cros_ec_msg *msg);
+
+/**
+ * cros_ec_remove - Remove a ChromeOS EC
+ *
+ * Call this to deregister a ChromeOS EC. After this you should call
+ * cros_ec_free().
+ *
+ * @ec_dev: Device to register
+ * @return 0 if ok, -ve on error
+ */
+int cros_ec_remove(struct cros_ec_device *ec_dev);
+
+/**
+ * cros_ec_register - Register a new ChromeOS EC, using the provided info
+ *
+ * Before calling this, call cros_ec_alloc() to get a pointer to a new device
+ * and then fill in all the fields up to the --private-- marker.
+ *
+ * @ec_dev: Device to register
+ * @return 0 if ok, -ve on error
+ */
+int cros_ec_register(struct cros_ec_device *ec_dev);
+
+/**
+ * cros_ec_alloc - Allocate a new ChromeOS EC
+ *
+ * @name: Name of EC (typically the interface it connects on)
+ * @return pointer to created device, or NULL on failure
+ */
+struct cros_ec_device *cros_ec_alloc(const char *name);
+
+/**
+ * cros_ec_free - Free a ChromeOS EC, the opposite of cros_ec_alloc().
+ *
+ * @ec_dev: Device to free (call cros_ec_remove() first)
+ */
+void cros_ec_free(struct cros_ec_device *ec_dev);
+
+#endif /* __LINUX_MFD_CROS_EC_H */
-- 
1.7.7.3

