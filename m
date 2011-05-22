Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab1EVIIZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 04:08:25 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4155 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab1EVIIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 04:08:15 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Arend van Spriel" <arend@broadcom.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "Arend van Spriel" <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "Dan Carpenter" <error27@gmail.com>
Subject: [RFC] lib: crc8: add new library module providing crc8
 algorithm
Date: Sun, 22 May 2011 10:08:00 +0200
Message-ID: <1306051680-2354-1-git-send-email-arend@broadcom.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
X-WSS-ID: 61C61ACC3IC4225463-06-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The brcm80211 driver in staging tree uses a crc8 function. Based on
feedback from John Linville to move this to lib directory, the linux
source has been searched. Although there is currently only one other
kernel driver using this algorithm (ie. drivers/ssb) we are providing
this as a library function for others to use.

V1:
- functionality taken from brcm80211 utility function as is.
- documented the crc8 header file using kernel-doc syntax.
- compilation verified in-kernel and as module for x86, x86_64, arm, and mips.

V2:
- ran checkpatch after sending V1 (sorry for that mortal sin) so fixed that.

Cc: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Carpenter <error27@gmail.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 include/linux/crc8.h |   61 +++++++++++++++++++++++++++++++++++++++
 lib/Kconfig          |    7 ++++
 lib/Makefile         |    1 +
 lib/crc8.c           |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 146 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/crc8.h
 create mode 100644 lib/crc8.c

diff --git a/include/linux/crc8.h b/include/linux/crc8.h
new file mode 100644
index 0000000..4048a34
--- /dev/null
+++ b/include/linux/crc8.h
@@ -0,0 +1,61 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef __CRC8_H_
+#define __CRC8_H_
+
+#include <linux/types.h>
+
+/**
+ * enum - CRC8 constants
+ *
+ * @CRC8_INIT_VALUE: Initial CRC8 checksum value
+ * @CRC8_GOOD_VALUE: Good final CRC8 checksum value
+ *
+ * Constants for the crc8() function. Refer to its
+ * documentation how to use these values.
+ */
+enum CRC8 {
+	CRC8_INIT_VALUE	= 0xff,
+	CRC8_GOOD_VALUE	= 0x9f
+};
+
+/**
+ * crc8() - calculate a crc8 over the given input data
+ *
+ * @pdata:	pointer to data buffer.
+ * @nbytes:	number of bytes in data buffer.
+ * @crc:	previous returned crc8 value.
+ *
+ * The CRC8 is calculated using the polynomial given below.
+ *
+ * x^8 + x^7 +x^6 + x^4 + x^2 + 1
+ *
+ * The caller provides the initial value (either %CRC8_INIT_VALUE
+ * or the previous returned value) to allow for processing of
+ * discontiguous blocks of data.  When generating the CRC the
+ * caller is responsible for complementing the final return value
+ * and inserting it into the byte stream.  When validating a byte
+ * stream (including CRC8), a final return value of %CRC8_GOOD_VALUE
+ * indicates the byte stream data can be considered valid.
+ *
+ * Reference:
+ * "A Painless Guide to CRC Error Detection Algorithms", ver 3, Aug 1993
+ * Williams, Ross N., ross<at>ross.net
+ * (see URL http://www.ross.net/crc/download/crc_v3.txt).
+ */
+u8 crc8(u8 *pdata, uint nbytes, u8 crc);
+
+#endif /* __CRC8_H_ */
diff --git a/lib/Kconfig b/lib/Kconfig
index 9c10e38..ff9e5a3 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -89,6 +89,13 @@ config LIBCRC32C
 	  require M here.  See Castagnoli93.
 	  Module will be libcrc32c.
 
+config CRC8
+	tristate "CRC8 function"
+	help
+	  This option provides CRC8 function. Drivers may select this
+	  when they need to do cyclic redundancy check according CRC8
+	  algorithm. Module will be called crc8.
+
 config AUDIT_GENERIC
 	bool
 	depends on AUDIT && !AUDIT_ARCH
diff --git a/lib/Makefile b/lib/Makefile
index 4b49a24..704959d 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_CRC_ITU_T)	+= crc-itu-t.o
 obj-$(CONFIG_CRC32)	+= crc32.o
 obj-$(CONFIG_CRC7)	+= crc7.o
 obj-$(CONFIG_LIBCRC32C)	+= libcrc32c.o
+obj-$(CONFIG_CRC8)	+= crc8.o
 obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
 
 obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
diff --git a/lib/crc8.c b/lib/crc8.c
new file mode 100644
index 0000000..342aeec
--- /dev/null
+++ b/lib/crc8.c
@@ -0,0 +1,77 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <linux/module.h>
+#include <linux/crc8.h>
+
+/*
+ * table for crc8 calculation based on following polynomial:
+ *	x^8 + x^7 +x^6 + x^4 + x^2 + 1
+ */
+static const u8 crc8_table[256] = {
+	0x00, 0xF7, 0xB9, 0x4E, 0x25, 0xD2, 0x9C, 0x6B,
+	0x4A, 0xBD, 0xF3, 0x04, 0x6F, 0x98, 0xD6, 0x21,
+	0x94, 0x63, 0x2D, 0xDA, 0xB1, 0x46, 0x08, 0xFF,
+	0xDE, 0x29, 0x67, 0x90, 0xFB, 0x0C, 0x42, 0xB5,
+	0x7F, 0x88, 0xC6, 0x31, 0x5A, 0xAD, 0xE3, 0x14,
+	0x35, 0xC2, 0x8C, 0x7B, 0x10, 0xE7, 0xA9, 0x5E,
+	0xEB, 0x1C, 0x52, 0xA5, 0xCE, 0x39, 0x77, 0x80,
+	0xA1, 0x56, 0x18, 0xEF, 0x84, 0x73, 0x3D, 0xCA,
+	0xFE, 0x09, 0x47, 0xB0, 0xDB, 0x2C, 0x62, 0x95,
+	0xB4, 0x43, 0x0D, 0xFA, 0x91, 0x66, 0x28, 0xDF,
+	0x6A, 0x9D, 0xD3, 0x24, 0x4F, 0xB8, 0xF6, 0x01,
+	0x20, 0xD7, 0x99, 0x6E, 0x05, 0xF2, 0xBC, 0x4B,
+	0x81, 0x76, 0x38, 0xCF, 0xA4, 0x53, 0x1D, 0xEA,
+	0xCB, 0x3C, 0x72, 0x85, 0xEE, 0x19, 0x57, 0xA0,
+	0x15, 0xE2, 0xAC, 0x5B, 0x30, 0xC7, 0x89, 0x7E,
+	0x5F, 0xA8, 0xE6, 0x11, 0x7A, 0x8D, 0xC3, 0x34,
+	0xAB, 0x5C, 0x12, 0xE5, 0x8E, 0x79, 0x37, 0xC0,
+	0xE1, 0x16, 0x58, 0xAF, 0xC4, 0x33, 0x7D, 0x8A,
+	0x3F, 0xC8, 0x86, 0x71, 0x1A, 0xED, 0xA3, 0x54,
+	0x75, 0x82, 0xCC, 0x3B, 0x50, 0xA7, 0xE9, 0x1E,
+	0xD4, 0x23, 0x6D, 0x9A, 0xF1, 0x06, 0x48, 0xBF,
+	0x9E, 0x69, 0x27, 0xD0, 0xBB, 0x4C, 0x02, 0xF5,
+	0x40, 0xB7, 0xF9, 0x0E, 0x65, 0x92, 0xDC, 0x2B,
+	0x0A, 0xFD, 0xB3, 0x44, 0x2F, 0xD8, 0x96, 0x61,
+	0x55, 0xA2, 0xEC, 0x1B, 0x70, 0x87, 0xC9, 0x3E,
+	0x1F, 0xE8, 0xA6, 0x51, 0x3A, 0xCD, 0x83, 0x74,
+	0xC1, 0x36, 0x78, 0x8F, 0xE4, 0x13, 0x5D, 0xAA,
+	0x8B, 0x7C, 0x32, 0xC5, 0xAE, 0x59, 0x17, 0xE0,
+	0x2A, 0xDD, 0x93, 0x64, 0x0F, 0xF8, 0xB6, 0x41,
+	0x60, 0x97, 0xD9, 0x2E, 0x45, 0xB2, 0xFC, 0x0B,
+	0xBE, 0x49, 0x07, 0xF0, 0x9B, 0x6C, 0x22, 0xD5,
+	0xF4, 0x03, 0x4D, 0xBA, 0xD1, 0x26, 0x68, 0x9F
+};
+
+/*
+ * crc8 - calculate a crc8 over the given input data
+ *
+ * pdata:	pointer to data buffer.
+ * nbytes:	number of bytes in data buffer.
+ * crc:	previous returned crc8 value.
+ */
+u8 crc8(u8 *pdata, uint nbytes, u8 crc)
+{
+	/* loop over the buffer data */
+	while (nbytes-- > 0)
+		crc = crc8_table[(crc ^ *pdata++) & 0xff];
+
+	return crc;
+}
+EXPORT_SYMBOL(crc8);
+
+MODULE_DESCRIPTION("CRC8 (by Williams, Ross N.) function");
+MODULE_AUTHOR("Broadcom Corporation");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
1.7.4.1


