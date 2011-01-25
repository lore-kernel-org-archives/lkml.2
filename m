Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1AYAZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:25:19 -0500
Received: from smtp-out.google.com ([216.239.44.51]:31985 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab1AYAZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:25:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=s19uM8qApSNiRls5bGyGHECFvZMEMkGU54wb4zlhCqwv7W96TOQyfdd1voerZC7J7
	Xs6ovBGGgl14S//zE8wTw==
Subject: [PATCH v1 6/6] driver: Google Memory Console
To: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org
From: Mike Waychison <mikew@google.com>
Cc: San Mehat <san@google.com>, Aaron Durbin <adurbin@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Date: Mon, 24 Jan 2011 16:25:05 -0800
Message-ID: <20110125002505.12637.84140.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the 'memconsole' driver.

Our firmware gives us access to an in-memory log of the firmware's
output.   This gives us visibility in a data-center of headless machines
as to what the firmware is doing.

The memory console is found by the driver by finding a header block in
the EBDA.  The buffer is then copied out, and is currently prepended
to the kernel's dmesg ring-buffer.

Signed-off-by: San Mehat <san@google.com>
Signed-off-by: Mike Waychison <mikew@google.com>
---
 drivers/firmware/google/Kconfig      |    8 ++
 drivers/firmware/google/Makefile     |    1 
 drivers/firmware/google/memconsole.c |  136 ++++++++++++++++++++++++++++++++++
 3 files changed, 145 insertions(+), 0 deletions(-)
 create mode 100644 drivers/firmware/google/memconsole.c

diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
index 0490a62..7218671 100644
--- a/drivers/firmware/google/Kconfig
+++ b/drivers/firmware/google/Kconfig
@@ -28,4 +28,12 @@ config GOOGLE_BOOTLOG
 	  This enables support for displaying boot log information in dmesg
 	  as well as logging the kernel shutdown reasons.
 
+config GOOGLE_MEMCONSOLE
+	bool "Firmware Memory Console"
+	default y
+	help
+	  This option enables the kernel to search for a firmware log in
+	  the EBDA.  If found, this log is prepended to the kernel's
+	  dmesg logs so they are visible to the user.
+
 endmenu
diff --git a/drivers/firmware/google/Makefile b/drivers/firmware/google/Makefile
index d45e10c..cb8598e 100644
--- a/drivers/firmware/google/Makefile
+++ b/drivers/firmware/google/Makefile
@@ -1,3 +1,4 @@
 
 obj-$(CONFIG_GOOGLE_SMI)		+= gsmi.o
 obj-$(CONFIG_GOOGLE_BOOTLOG)		+= bootlog.o
+obj-$(CONFIG_GOOGLE_MEMCONSOLE)		+= memconsole.o
diff --git a/drivers/firmware/google/memconsole.c b/drivers/firmware/google/memconsole.c
new file mode 100644
index 0000000..6777a64
--- /dev/null
+++ b/drivers/firmware/google/memconsole.c
@@ -0,0 +1,136 @@
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
+#include <asm/bios_ebda.h>
+
+#define BIOS_MEMCONSOLE_V1_MAGIC	0xDEADBABE
+#define BIOS_MEMCONSOLE_V2_MAGIC	(('M')|('C'<<8)|('O'<<16)|('N'<<24))
+
+struct biosmemcon_ebda {
+	uint32_t signature;
+	union {
+		struct {
+			uint8_t  enabled;
+			uint32_t buffer_addr;
+			uint16_t start;
+			uint16_t end;
+			uint16_t num_chars;
+			uint8_t  wrapped;
+		} __packed v1;
+		struct {
+			uint32_t buffer_addr;
+			/* Misdocumented as number of pages! */
+			uint16_t  num_bytes;
+			uint16_t start;
+			uint16_t end;
+		} __packed v2;
+	} ptr;
+} __packed;
+
+static void __init sanitize_buffer(char *buffer, size_t length) {
+	size_t cur;
+
+	/* sanitize BIOS output by converting non-ascii into space */
+	for (cur = 0; cur < length; cur++) {
+		if (!isascii(buffer[cur]) || buffer[cur] == 0)
+			buffer[cur] = ' ';
+	}
+}
+
+/*
+ * Search through the EBDA for the BIOS Memory Console, and
+ * prepend it to our ring buffer
+ */
+static int __init inject_memconsole(void)
+{
+	static struct biosmemcon_ebda __initdata hdr = {0};
+	unsigned int address;
+	size_t length, cur;
+	uint32_t *bp;
+	char *virtp;
+	int found = 0;
+
+	address = get_bios_ebda();
+	if (!address) {
+		printk(KERN_INFO "BIOS EBDA non-existent.\n");
+		return 0;
+	}
+
+	/* EBDA length is byte 0 of EBDA (in KB) */
+	length = *(uint8_t *)phys_to_virt(address);
+	length <<= 10; /* convert to bytes */
+
+	/*
+	 * Search through EBDA for BIOS memory console structure
+	 * note: signature is not necessarily dword-aligned
+	 */
+	for (cur = 0; cur < length; cur++) {
+		bp = phys_to_virt(address + cur);
+
+		/* memconsole v1 */
+		if (*bp == BIOS_MEMCONSOLE_V1_MAGIC) {
+			memcpy(&hdr, bp, sizeof(hdr));
+			found = 1;
+			break;
+		}
+
+		/* memconsole v2 */
+		if (*bp == BIOS_MEMCONSOLE_V2_MAGIC) {
+			memcpy(&hdr, bp, sizeof(hdr));
+			found = 2;
+			break;
+		}
+	}
+
+	/*
+	 * At this point hdr points to the EBDA structure
+	 * Shift the contents of the kernel ring by the size of
+	 * the contents in the bios ring.
+	 */
+
+	switch (found) {
+	case 1:
+		printk(KERN_INFO "BIOS console v1 EBDA structure found at %p\n",
+		       bp);
+		printk(KERN_INFO "BIOS console buffer at 0x%.8x, "
+		       "start = %d, end = %d, num = %d\n",
+		       hdr.ptr.v1.buffer_addr, hdr.ptr.v1.start,
+		       hdr.ptr.v1.end, hdr.ptr.v1.num_chars);
+
+		length = hdr.ptr.v1.num_chars;
+		virtp = phys_to_virt(hdr.ptr.v1.buffer_addr);
+		sanitize_buffer(virtp, length);
+		prepend_to_dmesg(virtp, length);
+
+		break;
+	case 2:
+		printk(KERN_INFO "BIOS console v2 EBDA structure found at %p\n",
+		       bp);
+		printk(KERN_INFO "BIOS console buffer at 0x%.8x, "
+		       "start = %d, end = %d, num_bytes = %d\n",
+		       hdr.ptr.v2.buffer_addr, hdr.ptr.v2.start,
+		       hdr.ptr.v2.end, hdr.ptr.v2.num_bytes);
+
+		length = hdr.ptr.v2.end - hdr.ptr.v2.start;
+		virtp = phys_to_virt(hdr.ptr.v2.buffer_addr + hdr.ptr.v2.start);
+		sanitize_buffer(virtp, length);
+		prepend_to_dmesg(virtp, length);
+
+		break;
+	case 0:
+	default:
+		printk("BIOS console EBDA structure not found!\n");
+	}
+	return 0;
+}
+device_initcall(inject_memconsole);

