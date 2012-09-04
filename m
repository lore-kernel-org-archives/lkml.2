Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab2IDPN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:13:27 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:11976 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab2IDPKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:10:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnkCAGIWRlBbdWObgWdsb2JhbABFhgW1JSIBARYmJ4IgAQEFIwQLAUYQIAUCJgICVwYTiBGne5JggSGQDIESA5VZkn8
X-IronPort-AV: E=Sophos;i="4.80,367,1344204000"; 
   d="scan'208";a="561821820"
From: =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        =?UTF-8?q?Samuel=20Iglesias=20Gons=C3=A1lvez?= 
	<siglesias@igalia.com>
Subject: [PATCH 08/16] Staging: ipack: implement ipack device table.
Date: Tue,  4 Sep 2012 17:01:13 +0200
Message-Id: <1346770881-4723-9-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
References: <1346770881-4723-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

The modaliases look like ipack:fXvNdM, where X is the format version (8
bit) and N and M are the vendor and device ID represented as 32 bit
hexadecimal numbers each. Using 32 bits allows us to define IPACK_ANY_ID
as (~0) without interfering with the valid ids.

The resulting modalias string for ipoctal.ko looks like this (once
ipoctal provides a device table):
alias:          ipack:f01v000000F0d00000048*
alias:          ipack:f01v000000F0d0000002A*
alias:          ipack:f01v000000F0d00000022*
(output from modinfo)

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
---
 drivers/staging/ipack/ipack.h     |   26 ++++++++++++++++++++++++++
 drivers/staging/ipack/ipack_ids.h |   27 +++++++++++++++++++++++++++
 include/linux/mod_devicetable.h   |    7 +++++++
 scripts/mod/file2alias.c          |   15 +++++++++++++++
 4 files changed, 75 insertions(+)
 create mode 100644 drivers/staging/ipack/ipack_ids.h

diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index e3609b1..703142d 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -9,6 +9,7 @@
  * Software Foundation; version 2 of the License.
  */
 
+#include <linux/mod_devicetable.h>
 #include <linux/device.h>
 
 #define IPACK_IDPROM_OFFSET_I			0x01
@@ -95,6 +96,7 @@ struct ipack_driver_ops {
  */
 struct ipack_driver {
 	struct device_driver driver;
+	const struct ipack_device_id *id_table;
 	struct ipack_driver_ops *ops;
 };
 
@@ -169,3 +171,27 @@ void ipack_driver_unregister(struct ipack_driver *edrv);
  */
 struct ipack_device *ipack_device_register(struct ipack_bus_device *bus, int slot, int irqv);
 void ipack_device_unregister(struct ipack_device *dev);
+
+/**
+ * DEFINE_IPACK_DEVICE_TABLE - macro used to describe a IndustryPack table
+ * @_table: device table name
+ *
+ * This macro is used to create a struct ipack_device_id array (a device table)
+ * in a generic manner.
+ */
+#define DEFINE_IPACK_DEVICE_TABLE(_table) \
+	const struct ipack_device_id _table[] __devinitconst
+
+/**
+ * IPACK_DEVICE - macro used to describe a specific IndustryPack device
+ * @_format: the format version (currently either 1 or 2, 8 bit value)
+ * @vend:    the 8 or 24 bit IndustryPack Vendor ID
+ * @dev:     the 8 or 16  bit IndustryPack Device ID
+ *
+ * This macro is used to create a struct ipack_device_id that matches a specific
+ * device.
+ */
+#define IPACK_DEVICE(_format, vend, dev) \
+	 .format = (_format), \
+	 .vendor = (vend), \
+	 .device = (dev)
diff --git a/drivers/staging/ipack/ipack_ids.h b/drivers/staging/ipack/ipack_ids.h
new file mode 100644
index 0000000..ba85ec5
--- /dev/null
+++ b/drivers/staging/ipack/ipack_ids.h
@@ -0,0 +1,27 @@
+/*
+ * IndustryPack Fromat, Vendor and Device IDs.
+ */
+
+/* ID section format versions */
+#define IPACK_ID_VERSION_INVALID	0x00
+#define IPACK_ID_VERSION_1		0x01
+#define IPACK_ID_VERSION_2		0x02
+
+/* Vendors and devices. Sort key: vendor first, device next. */
+#define IPACK1_VENDOR_ID_RESERVED1	0x00
+#define IPACK1_VENDOR_ID_RESERVED2	0xFF
+#define IPACK1_VENDOR_ID_UNREGISTRED01	0x01
+#define IPACK1_VENDOR_ID_UNREGISTRED02	0x02
+#define IPACK1_VENDOR_ID_UNREGISTRED03	0x03
+#define IPACK1_VENDOR_ID_UNREGISTRED04	0x04
+#define IPACK1_VENDOR_ID_UNREGISTRED05	0x05
+#define IPACK1_VENDOR_ID_UNREGISTRED06	0x06
+#define IPACK1_VENDOR_ID_UNREGISTRED07	0x07
+#define IPACK1_VENDOR_ID_UNREGISTRED08	0x08
+#define IPACK1_VENDOR_ID_UNREGISTRED09	0x09
+#define IPACK1_VENDOR_ID_UNREGISTRED10	0x0A
+#define IPACK1_VENDOR_ID_UNREGISTRED11	0x0B
+#define IPACK1_VENDOR_ID_UNREGISTRED12	0x0C
+#define IPACK1_VENDOR_ID_UNREGISTRED13	0x0D
+#define IPACK1_VENDOR_ID_UNREGISTRED14	0x0E
+#define IPACK1_VENDOR_ID_UNREGISTRED15	0x0F
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 6955045..999c4c2 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -600,4 +600,11 @@ struct x86_cpu_id {
 #define X86_MODEL_ANY  0
 #define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */
 
+#define IPACK_ANY_ID (~0)
+struct ipack_device_id {
+	__u8  format;			/* Format version or IPACK_ANY_ID */
+	__u32 vendor;			/* Vendor ID or IPACK_ANY_ID */
+	__u32 device;			/* Device ID or IPACK_ANY_ID */
+};
+
 #endif /* LINUX_MOD_DEVICETABLE_H */
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 7ed6864..3c22bda 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -966,6 +966,21 @@ static int do_isapnp_entry(const char *filename,
 }
 ADD_TO_DEVTABLE("isapnp", struct isapnp_device_id, do_isapnp_entry);
 
+/* Looks like: "ipack:fNvNdN". */
+static int do_ipack_entry(const char *filename,
+			  struct ipack_device_id *id, char *alias)
+{
+	id->vendor = TO_NATIVE(id->vendor);
+	id->device = TO_NATIVE(id->device);
+	strcpy(alias, "ipack:");
+	ADD(alias, "f", id->format != IPACK_ANY_ID, id->format);
+	ADD(alias, "v", id->vendor != IPACK_ANY_ID, id->vendor);
+	ADD(alias, "d", id->device != IPACK_ANY_ID, id->device);
+	add_wildcard(alias);
+	return 1;
+}
+ADD_TO_DEVTABLE("ipack", struct ipack_device_id, do_ipack_entry);
+
 /*
  * Append a match expression for a single masked hex digit.
  * outp points to a pointer to the character at which to append.
-- 
1.7.10.4

