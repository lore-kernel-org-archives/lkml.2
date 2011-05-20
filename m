Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934975Ab1ETAMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:12:08 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52893 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934741Ab1ETAMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:12:00 -0400
X-Sasl-enc: bzc0OAsi7DRQBhXHorPtAZoOAsKlR+f7Ie4sQFrDRHge 1305850319
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Waychison <mikew@google.com>, San Mehat <san@google.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/44] driver: Google Memory Console
Date: Thu, 19 May 2011 17:10:49 -0700
Message-Id: <1305850262-9575-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

This patch introduces the 'memconsole' driver.

Our firmware gives us access to an in-memory log of the firmware's
output.   This gives us visibility in a data-center of headless machines
as to what the firmware is doing.

The memory console is found by the driver by finding a header block in
the EBDA.  The buffer is then copied out, and is exported to userland in
the file /sys/firmware/log.

Signed-off-by: San Mehat <san@google.com>
Signed-off-by: Mike Waychison <mikew@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/ABI/testing/sysfs-firmware-log |    7 +
 drivers/firmware/google/Kconfig              |    8 ++
 drivers/firmware/google/Makefile             |    1 +
 drivers/firmware/google/memconsole.c         |  166 ++++++++++++++++++++++++++
 4 files changed, 182 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-log
 create mode 100644 drivers/firmware/google/memconsole.c

diff --git a/Documentation/ABI/testing/sysfs-firmware-log b/Documentation/ABI/testing/sysfs-firmware-log
new file mode 100644
index 0000000..9b58e7c
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-log
@@ -0,0 +1,7 @@
+What:		/sys/firmware/log
+Date:		February 2011
+Contact:	Mike Waychison <mikew@google.com>
+Description:
+		The /sys/firmware/log is a binary file that represents a
+		read-only copy of the firmware's log if one is
+		available.
diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
index 4a03835..640dc6b 100644
--- a/drivers/firmware/google/Kconfig
+++ b/drivers/firmware/google/Kconfig
@@ -7,3 +7,11 @@ config GOOGLE_SMI
 	  platforms.  This provides an interface for writing to and
 	  clearing the EFI event log and reading and writing NVRAM
 	  variables.
+
+config GOOGLE_MEMCONSOLE
+	tristate "Firmware Memory Console"
+	depends on DMI
+	help
+	  This option enables the kernel to search for a firmware log in
+	  the EBDA on Google servers.  If found, this log is exported to
+	  userland in the file /sys/firmware/log.
diff --git a/drivers/firmware/google/Makefile b/drivers/firmware/google/Makefile
index fb127d7..54a294e 100644
--- a/drivers/firmware/google/Makefile
+++ b/drivers/firmware/google/Makefile
@@ -1,2 +1,3 @@
 
 obj-$(CONFIG_GOOGLE_SMI)		+= gsmi.o
+obj-$(CONFIG_GOOGLE_MEMCONSOLE)		+= memconsole.o
diff --git a/drivers/firmware/google/memconsole.c b/drivers/firmware/google/memconsole.c
new file mode 100644
index 0000000..2a90ba6
--- /dev/null
+++ b/drivers/firmware/google/memconsole.c
@@ -0,0 +1,166 @@
+/*
+ * memconsole.c
+ *
+ * Infrastructure for importing the BIOS memory based console
+ * into the kernel log ringbuffer.
+ *
+ * Copyright 2010 Google Inc. All rights reserved.
+ */
+
+#include <linux/ctype.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/kobject.h>
+#include <linux/module.h>
+#include <linux/dmi.h>
+#include <asm/bios_ebda.h>
+
+#define BIOS_MEMCONSOLE_V1_MAGIC	0xDEADBABE
+#define BIOS_MEMCONSOLE_V2_MAGIC	(('M')|('C'<<8)|('O'<<16)|('N'<<24))
+
+struct biosmemcon_ebda {
+	u32 signature;
+	union {
+		struct {
+			u8  enabled;
+			u32 buffer_addr;
+			u16 start;
+			u16 end;
+			u16 num_chars;
+			u8  wrapped;
+		} __packed v1;
+		struct {
+			u32 buffer_addr;
+			/* Misdocumented as number of pages! */
+			u16 num_bytes;
+			u16 start;
+			u16 end;
+		} __packed v2;
+	};
+} __packed;
+
+static char *memconsole_baseaddr;
+static size_t memconsole_length;
+
+static ssize_t memconsole_read(struct file *filp, struct kobject *kobp,
+			       struct bin_attribute *bin_attr, char *buf,
+			       loff_t pos, size_t count)
+{
+	return memory_read_from_buffer(buf, count, &pos, memconsole_baseaddr,
+				       memconsole_length);
+}
+
+static struct bin_attribute memconsole_bin_attr = {
+	.attr = {.name = "log", .mode = 0444},
+	.read = memconsole_read,
+};
+
+
+static void found_v1_header(struct biosmemcon_ebda *hdr)
+{
+	printk(KERN_INFO "BIOS console v1 EBDA structure found at %p\n", hdr);
+	printk(KERN_INFO "BIOS console buffer at 0x%.8x, "
+	       "start = %d, end = %d, num = %d\n",
+	       hdr->v1.buffer_addr, hdr->v1.start,
+	       hdr->v1.end, hdr->v1.num_chars);
+
+	memconsole_length = hdr->v1.num_chars;
+	memconsole_baseaddr = phys_to_virt(hdr->v1.buffer_addr);
+}
+
+static void found_v2_header(struct biosmemcon_ebda *hdr)
+{
+	printk(KERN_INFO "BIOS console v2 EBDA structure found at %p\n", hdr);
+	printk(KERN_INFO "BIOS console buffer at 0x%.8x, "
+	       "start = %d, end = %d, num_bytes = %d\n",
+	       hdr->v2.buffer_addr, hdr->v2.start,
+	       hdr->v2.end, hdr->v2.num_bytes);
+
+	memconsole_length = hdr->v2.end - hdr->v2.start;
+	memconsole_baseaddr = phys_to_virt(hdr->v2.buffer_addr
+					   + hdr->v2.start);
+}
+
+/*
+ * Search through the EBDA for the BIOS Memory Console, and
+ * set the global variables to point to it.  Return true if found.
+ */
+static bool found_memconsole(void)
+{
+	unsigned int address;
+	size_t length, cur;
+
+	address = get_bios_ebda();
+	if (!address) {
+		printk(KERN_INFO "BIOS EBDA non-existent.\n");
+		return false;
+	}
+
+	/* EBDA length is byte 0 of EBDA (in KB) */
+	length = *(u8 *)phys_to_virt(address);
+	length <<= 10; /* convert to bytes */
+
+	/*
+	 * Search through EBDA for BIOS memory console structure
+	 * note: signature is not necessarily dword-aligned
+	 */
+	for (cur = 0; cur < length; cur++) {
+		struct biosmemcon_ebda *hdr = phys_to_virt(address + cur);
+
+		/* memconsole v1 */
+		if (hdr->signature == BIOS_MEMCONSOLE_V1_MAGIC) {
+			found_v1_header(hdr);
+			return true;
+		}
+
+		/* memconsole v2 */
+		if (hdr->signature == BIOS_MEMCONSOLE_V2_MAGIC) {
+			found_v2_header(hdr);
+			return true;
+		}
+	}
+
+	printk(KERN_INFO "BIOS console EBDA structure not found!\n");
+	return false;
+}
+
+static struct dmi_system_id memconsole_dmi_table[] __initdata = {
+	{
+		.ident = "Google Board",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Google, Inc."),
+		},
+	},
+	{}
+};
+MODULE_DEVICE_TABLE(dmi, memconsole_dmi_table);
+
+static int __init memconsole_init(void)
+{
+	int ret;
+
+	if (!dmi_check_system(memconsole_dmi_table))
+		return -ENODEV;
+
+	if (!found_memconsole())
+		return -ENODEV;
+
+	memconsole_bin_attr.size = memconsole_length;
+
+	ret = sysfs_create_bin_file(firmware_kobj, &memconsole_bin_attr);
+
+	return ret;
+}
+
+static void __exit memconsole_exit(void)
+{
+	sysfs_remove_bin_file(firmware_kobj, &memconsole_bin_attr);
+}
+
+module_init(memconsole_init);
+module_exit(memconsole_exit);
+
+MODULE_AUTHOR("Google, Inc.");
+MODULE_LICENSE("GPL");
-- 
1.7.4.2

