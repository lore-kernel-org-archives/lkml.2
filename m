Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab1ALFdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 00:33:40 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:55554 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1ALFdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 00:33:38 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, device-drivers-devel@blackfin.uclinux.org
Subject: =?UTF-8?q?=5BPATCH=5D=20sigma-firmware=3A=20loader=20for=20Analog=20Devices=27=20SigmaStudio?=
Date: Wed, 12 Jan 2011 00:41:31 -0500
Message-Id: <1294810891-23348-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Analog Devices' SigmaStudio can produce firmware blobs for devices with
these DSPs embedded (like some audio codecs).  Allow these device drivers
to easily parse and load them.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/firmware/Kconfig  |   12 +++++
 drivers/firmware/Makefile |    1 +
 drivers/firmware/sigma.c  |  110 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/sigma.h     |   60 ++++++++++++++++++++++++
 4 files changed, 183 insertions(+), 0 deletions(-)
 create mode 100644 drivers/firmware/sigma.c
 create mode 100644 include/linux/sigma.h

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index e8b6a13..8f4f7b2 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -134,4 +134,16 @@ config ISCSI_IBFT
 	  detect iSCSI boot parameters dynamically during system boot, say Y.
 	  Otherwise, say N.
 
+config SIGMA
+	tristate "SigmaStudio firmware loader"
+	depends on I2C
+	select CRC32
+	default n
+	help
+	  Enable helper functions for working with Analog Devices SigmaDSP
+	  parts and binary firmwares produced by Analog Devices SigmaStudio.
+
+	  If unsure, say N here.  Drivers that need these helpers will select
+	  this option automatically.
+
 endmenu
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 1c3c173..ede9722 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_DMIID)		+= dmi-id.o
 obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
 obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
+obj-$(CONFIG_SIGMA)		+= sigma.o
diff --git a/drivers/firmware/sigma.c b/drivers/firmware/sigma.c
new file mode 100644
index 0000000..e2945be
--- /dev/null
+++ b/drivers/firmware/sigma.c
@@ -0,0 +1,110 @@
+/*
+ * Load Analog Devices SigmaStudio firmware files
+ *
+ * Copyright 2009 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/crc32.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/sigma.h>
+
+/* Return: 0==OK, <0==error, =1 ==no more actions */
+int process_sigma_action(struct i2c_client *client, struct sigma_firmware *ssfw)
+{
+	struct sigma_action *sa = (void *)(ssfw->fw->data + ssfw->pos);
+	size_t len = sigma_action_len(sa);
+	int ret = 0;
+
+	pr_debug("%s: instr:%i addr:%#x len:%zu\n", __func__,
+		sa->instr, sa->addr, len);
+
+	switch (sa->instr) {
+		case SIGMA_ACTION_WRITEXBYTES:
+		case SIGMA_ACTION_WRITESINGLE:
+		case SIGMA_ACTION_WRITESAFELOAD:
+			if (ssfw->fw->size < ssfw->pos + len)
+				return -EINVAL;
+			ret = i2c_master_send(client, (void *)&sa->addr, len);
+			if (ret < 0)
+				return -EINVAL;
+			break;
+
+		case SIGMA_ACTION_DELAY:
+			ret = 0;
+			udelay(len);
+			len = 0;
+			break;
+
+		case SIGMA_ACTION_END:
+			return 1;
+
+		default:
+			return -EINVAL;
+	}
+
+	/* when arrive here ret=0 or sent data */
+	ssfw->pos += sigma_action_size(sa, len);
+	return ssfw->pos == ssfw->fw->size;
+}
+
+int process_sigma_actions(struct i2c_client *client, struct sigma_firmware *ssfw)
+{
+	pr_debug("%s: processing %p\n", __func__, ssfw);
+
+	while (1) {
+		int ret = process_sigma_action(client, ssfw);
+		pr_debug("%s: action returned %i\n", __func__, ret);
+		if (ret == 1)
+			return 0;
+		else if (ret)
+			return ret;
+	}
+}
+
+int process_sigma_firmware(struct i2c_client *client, const char *name)
+{
+	int ret;
+	struct sigma_firmware_header *ssfw_head;
+	struct sigma_firmware ssfw;
+	const struct firmware *fw;
+
+	pr_debug("%s: loading firmware %s\n", __func__, name);
+
+	/* first load the blob */
+	ret = request_firmware(&fw, name, &client->dev);
+	if (ret) {
+		pr_debug("%s: request_firmware() failed with %i\n", __func__, ret);
+		return ret;
+	}
+	ssfw.fw = fw;
+
+	/* then verify the header */
+	if (fw->size < sizeof(*ssfw_head)) {
+		ret = -ENODATA;
+		goto done;
+	}
+	ssfw_head = (void *)fw->data;
+	if (memcmp(ssfw_head->magic, SIGMA_MAGIC, ARRAY_SIZE(ssfw_head->magic))) {
+		ret = -EINVAL;
+		goto done;
+	}
+	pr_debug("%s: crc=%x\n", __func__, crc32(0, fw->data, fw->size));
+
+	ssfw.pos = sizeof(*ssfw_head);
+
+	/* finally process all of the actions */
+	ret = process_sigma_actions(client, &ssfw);
+
+ done:
+	release_firmware(fw);
+
+	pr_debug("%s: loaded %s\n", __func__, name);
+
+	return ret;
+}
+EXPORT_SYMBOL(process_sigma_firmware);
diff --git a/include/linux/sigma.h b/include/linux/sigma.h
new file mode 100644
index 0000000..510765f
--- /dev/null
+++ b/include/linux/sigma.h
@@ -0,0 +1,60 @@
+/*
+ * Load firmware files from Analog Devices SigmaStudio
+ *
+ * Copyright 2009 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef __SIGMA_FIRMWARE_H__
+#define __SIGMA_FIRMWARE_H__
+
+#include <linux/firmware.h>
+#include <linux/types.h>
+
+#define SIGMA_MAGIC "ADISIGM"
+
+struct sigma_firmware {
+	const struct firmware *fw;
+	size_t pos;
+};
+
+struct sigma_firmware_header {
+	unsigned char magic[7];
+	u8 version;
+	u32 crc;
+};
+
+enum {
+	SIGMA_ACTION_WRITEXBYTES = 0,
+	SIGMA_ACTION_WRITESINGLE,
+	SIGMA_ACTION_WRITESAFELOAD,
+	SIGMA_ACTION_DELAY,
+	SIGMA_ACTION_PLLWAIT,
+	SIGMA_ACTION_NOOP,
+	SIGMA_ACTION_END,
+};
+
+struct sigma_action {
+	u8 instr;
+	u8 len_hi;
+	u16 len;
+	u16 addr;
+	unsigned char payload[];
+};
+
+static inline u32 sigma_action_len(struct sigma_action *sa)
+{
+	return (sa->len_hi << 16) | sa->len;
+}
+
+static inline size_t sigma_action_size(struct sigma_action *sa, u32 payload_len)
+{
+	return sizeof(*sa) + payload_len + (payload_len % 2);
+}
+
+struct i2c_client;
+
+extern int process_sigma_firmware(struct i2c_client *client, const char *name);
+
+#endif
-- 
1.7.4.rc1

