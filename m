Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504Ab1EXUXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 16:23:36 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3209 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab1EXUXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 16:23:35 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Arend van Spriel" <arend@broadcom.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
cc: "Arend van Spriel" <arend@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "Dan Carpenter" <error27@gmail.com>,
        "George Spelvin" <linux@horizon.com>
Subject: [RFC] lib: crc8: add new library module providing crc8
 algorithm
Date: Tue, 24 May 2011 22:23:21 +0200
Message-ID: <1306268601-10729-1-git-send-email-arend@broadcom.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
X-WSS-ID: 61C2CB164NS11543722-01-01
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

V3:
- added function crc8_create().
- crc8_create() takes polynomial and bit direction as parameters.

Cc: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: George Spelvin <linux@horizon.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 include/linux/crc8.h |   92 +++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig          |    7 +++
 lib/Makefile         |    1 +
 lib/crc8.c           |  105 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 205 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/crc8.h
 create mode 100644 lib/crc8.c

diff --git a/include/linux/crc8.h b/include/linux/crc8.h
new file mode 100644
index 0000000..2525ca0
--- /dev/null
+++ b/include/linux/crc8.h
@@ -0,0 +1,92 @@
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
+/* see usage of this value in crc8() description */
+#define CRC8_INIT_VALUE		0xFF
+
+/* this return value of crc8() upon validating data indicates success */
+#define CRC8_GOOD_VALUE(_table)	(_table[0xFF])
+
+/* required table size for crc8 algorithm */
+#define CRC8_TABLE_SIZE			256
+
+/* helper macro assuring right table size is used */
+#define DECLARE_CRC8_TABLE(_table) \
+	static u8 _table[CRC8_TABLE_SIZE]
+
+/**
+ * enum - determine bit direction of the crc algorithm.
+ *
+ * @crc8_dir_msb_first: direction is in reverse order.
+ * @crc8_dir_lsb_first: direction is in regular order.
+ */
+enum crc8_direction {
+	crc8_dir_msb_first,
+	crc8_dir_lsb_first
+};
+
+/**
+ * crc8_create - fill crc table for given polynomial and bit direction.
+ *
+ * @table:	table to be filled.
+ * @polynomial:	polynomial for which table is to be filled.
+ * @direction:	bit order for which the table is to be filled.
+ *
+ * This function fills the provided table according the polynomial and
+ * the direction provided. Polynomials in CRC algorithms are typically
+ * represented as shown below.
+ *
+ *	poly = x^8 + x^7 + x^6 + x^4 + x^2 + 1
+ *
+ * For lsb_first direction x^7 maps to the lsb and for msb_first
+ * direction x^7 maps to the msb. So the polynomials are as below.
+ *
+ * - lsb first: poly = 10101011(1) = 0xAB
+ *
+ * - msb first: poly = (1)11010101 = 0xD5
+ *
+ * Reference:
+ * "A Painless Guide to CRC Error Detection Algorithms", ver 3, Aug 1993
+ * Williams, Ross N., ross<at>ross.net
+ * (see URL http://www.ross.net/crc/download/crc_v3.txt).
+ */
+void crc8_create(u8 *table, u8 polynomial, enum crc8_direction direction);
+
+/**
+ * crc8() - calculate a crc8 over the given input data.
+ *
+ * @table:	crc table used for calculation.
+ * @pdata:	pointer to data buffer.
+ * @nbytes:	number of bytes in data buffer.
+ * @crc:	previous returned crc8 value.
+ *
+ * The CRC8 is calculated using the polynomial given in crc8_create().
+ *
+ * The caller provides the initial value (either %CRC8_INIT_VALUE
+ * or the previous returned value) to allow for processing of
+ * discontiguous blocks of data.  When generating the CRC the
+ * caller is responsible for complementing the final return value
+ * and inserting it into the byte stream.  When validating a byte
+ * stream (including CRC8), a final return value of %CRC8_GOOD_VALUE
+ * indicates the byte stream data can be considered valid.
+ */
+u8 crc8(u8 *table, u8 *pdata, uint nbytes, u8 crc);
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
index 0000000..b17b487
--- /dev/null
+++ b/lib/crc8.c
@@ -0,0 +1,105 @@
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
+#define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
+#include <linux/module.h>
+#include <linux/crc8.h>
+#include <linux/printk.h>
+
+/*
+ * crc8_create_msb_first - creates crc table for reverse (msb first) bit order.
+ *
+ * table: table to be filled.
+ * polynomial: polynomial for which table is to be filled.
+ */
+static void crc8_create_msb_first(u8 *table, u8 polynomial)
+{
+	int i, j;
+	const u8 msbit = 0x80;
+	u8 t = msbit;
+
+	table[0] = 0;
+
+	for (i = 1; i < CRC8_TABLE_SIZE; i *= 2) {
+		t = (t << 1) ^ (t & msbit ? polynomial : 0);
+		for (j = 0; j < i; j++)
+			table[i+j] = table[j] ^ t;
+	}
+}
+
+/*
+ * crc8_create_msb_first - creates crc table for regular (lsb first) bit order.
+ *
+ * table: table to be filled.
+ * polynomial: polynomial for which table is to be filled.
+ */
+static void crc8_create_lsb_first(u8 *table, u8 polynomial)
+{
+	int i, j;
+	u8 t = 1;
+
+	table[0] = 0;
+
+	for (i = (CRC8_TABLE_SIZE >> 1); i; i >>= 1) {
+		t = (t >> 1) ^ (t & 1 ? polynomial : 0);
+		for (j = 0; j < CRC8_TABLE_SIZE; j += 2*i)
+			table[i+j] = table[j] ^ t;
+	}
+}
+
+/*
+ * crc8_create - fill crc table for given polynomial and bit direction.
+ *
+ * table: table to be filled.
+ * polynomial: polynomial for which table is to be filled.
+ * direction: bit order for which the table is to be filled.
+ */
+void crc8_create(u8 *table, u8 polynomial, enum crc8_direction direction)
+{
+	switch (direction) {
+	case crc8_dir_msb_first:
+		crc8_create_msb_first(table, polynomial);
+		break;
+	case crc8_dir_lsb_first:
+		crc8_create_lsb_first(table, polynomial);
+		break;
+	default:
+		pr_err("invalid direction provided\n");
+		return;
+	}
+}
+EXPORT_SYMBOL(crc8_create);
+
+/*
+ * crc8 - calculate a crc8 over the given input data.
+ *
+ * table: crc table used for calculation.
+ * pdata: pointer to data buffer.
+ * nbytes: number of bytes in data buffer.
+ * crc:	previous returned crc8 value.
+ */
+u8 crc8(u8 *table, u8 *pdata, uint nbytes, u8 crc)
+{
+	/* loop over the buffer data */
+	while (nbytes-- > 0)
+		crc = table[(crc ^ *pdata++) & 0xff];
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


