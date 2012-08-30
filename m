Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2H3J3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 05:29:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab2H3J30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 05:29:26 -0400
From: Thomas Renninger <trenn@suse.de>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, robert.moore@intel.com,
        ming.m.lin@intel.com, initramfs@vger.kernel.org, bigeasy@linutronix.de,
        vojcek@tlen.pl, eric.piel@tremplin-utc.net, linux-acpi@vger.kernel.org,
        yinghai@kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH 1/2] lib: Add early cpio decoder
Date: Thu, 30 Aug 2012 11:29:16 +0200
Message-Id: <1346318957-5831-2-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1346318957-5831-1-git-send-email-trenn@suse.de>
References: <1346318957-5831-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Add a simple cpio decoder without library dependencies for the purpose
of extracting components from the initramfs blob for early kernel
uses.  Intended consumers so far are microcode and ACPI override.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
CC: Thomas Renninger <trenn@suse.de>
Link: http://lkml.kernel.org/r/201203261651.29640.trenn@suse.de
Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 include/linux/earlycpio.h |   13 ++++
 lib/Makefile              |    2 +-
 lib/earlycpio.c           |  173 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 187 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/earlycpio.h
 create mode 100644 lib/earlycpio.c

diff --git a/include/linux/earlycpio.h b/include/linux/earlycpio.h
new file mode 100644
index 0000000..06db026
--- /dev/null
+++ b/include/linux/earlycpio.h
@@ -0,0 +1,13 @@
+#ifndef _LINUX_EARLYCPIO_H
+#define _LINUX_EARLYCPIO_H
+
+#include <linux/types.h>
+
+struct cpio_data {
+	void *data;
+	size_t size;
+};
+
+struct cpio_data find_cpio_data(const char *name, const void *data, size_t len);
+
+#endif /* _LINUX_EARLYCPIO_H */
diff --git a/lib/Makefile b/lib/Makefile
index 42d283e..0924041 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o
+	 is_single_threaded.o plist.o decompress.o earlycpio.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff --git a/lib/earlycpio.c b/lib/earlycpio.c
new file mode 100644
index 0000000..b16b80b
--- /dev/null
+++ b/lib/earlycpio.c
@@ -0,0 +1,173 @@
+/* ----------------------------------------------------------------------- *
+ *
+ *   Copyright 2012 Intel Corporation; author H. Peter Anvin
+ *
+ *   This file is part of the Linux kernel, and is made available
+ *   under the terms of the GNU General Public License version 2, as
+ *   published by the Free Software Foundation.
+ *
+ *   This program is distributed in the hope it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *   General Public License for more details.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * earlycpio.c
+ *
+ * Find a specific cpio member; must precede any compressed content.
+ * This is used to locate data items in the initramfs used by the
+ * kernel itself during early boot (before the main initramfs is
+ * decompressed.)  It is the responsibility of the initramfs creator
+ * to ensure that these items are uncompressed at the head of the
+ * blob.  Depending on the boot loader or package tool that may be a
+ * separate file or part of the same file.
+ *
+ * For some architectures, e.g. i386, this file must compile to have
+ * no relocations and no library dependencies, so it can be called from
+ * a nonstandard environment.  Therefore some normal library functions
+ * are inlined in this file.
+ */
+
+#include <linux/earlycpio.h>
+#include <linux/kernel.h>
+
+enum cpio_fields {
+	C_MAGIC,
+	C_INO,
+	C_MODE,
+	C_UID,
+	C_GID,
+	C_NLINK,
+	C_MTIME,
+	C_FILESIZE,
+	C_MAJ,
+	C_MIN,
+	C_RMAJ,
+	C_RMIN,
+	C_NAMESIZE,
+	C_CHKSUM,
+	C_NFIELDS
+};
+
+#ifdef CONFIG_X86
+static inline size_t strlen(const char *name)
+{
+	size_t n = -1;
+
+	asm("repne; scasb"
+	    : "+D" (name), "+c" (n)
+	    : "a" (0));
+
+	return -2 - n;
+}
+
+static inline int memcmp(const void *p1, const void *p2, size_t n)
+{
+	unsigned char rv;
+
+	asm("repe; cmpsb; setne %0"
+	    : "=r" (rv), "+S" (p1), "+D" (p2), "+c" (n));
+
+	return rv;
+}
+#else
+static inline size_t strlen(const char *name)
+{
+	size_t n = 0;
+
+	while (*name++)
+		n++;
+
+	return n;
+}
+
+static inline int memcmp(const void *p1, const void *p2, size_t n)
+{
+	const unsigned char *u1 = p1;
+	const unsigned char *u2 = p2;
+	int d;
+
+	while (n--) {
+		d = *u2++ - *u1++;
+		if (d)
+			return d;
+	}
+	return 0;
+}
+#endif
+
+struct cpio_data __cpuinit find_cpio_data(const char *name,
+					  const void *data, size_t len)
+{
+	const size_t cpio_header_len = 8*C_NFIELDS - 2;
+	struct cpio_data cd = { NULL, 0 };
+	const char *p, *dptr, *nptr;
+	unsigned int ch[C_NFIELDS], *chp, v;
+	unsigned char c, x;
+	size_t mynamesize = strlen(name) + 1;
+	int i, j;
+
+	p = data;
+
+	while (len > cpio_header_len) {
+		if (!*p) {
+			/* All cpio headers need to be 4-byte aligned */
+			p += 4;
+			len -= 4;
+			continue;
+		}
+
+		j = 6;		/* The magic field is only 6 characters */
+		chp = ch;
+		for (i = C_NFIELDS; i; i--) {
+			v = 0;
+			while (j--) {
+				v <<= 4;
+				c = *p++;
+
+				x = c - '0';
+				if (x < 10) {
+					v += x;
+					continue;
+				}
+
+				x = (c | 0x20) - 'a';
+				if (x < 6) {
+					v += x + 10;
+					continue;
+				}
+
+				goto quit; /* Invalid hexadecimal */
+			}
+			*chp++ = v;
+			j = 8;	/* All other fields are 8 characters */
+		}
+
+		if ((ch[C_MAGIC] - 0x070701) > 1)
+			goto quit; /* Invalid magic */
+
+		len -= cpio_header_len;
+
+		dptr = PTR_ALIGN(p + ch[C_NAMESIZE], 4);
+		nptr = PTR_ALIGN(dptr + ch[C_FILESIZE], 4);
+
+		if (nptr > p + len || dptr < p || nptr < dptr)
+			goto quit; /* Buffer overrun */
+
+		if ((ch[C_MODE] & 0170000) == 0100000 &&
+		    ch[C_NAMESIZE] == mynamesize &&
+		    !memcmp(p, name, mynamesize)) {
+			cd.data = (void *)dptr;
+			cd.size = ch[C_FILESIZE];
+			return cd; /* Found it! */
+		}
+
+		len -= (nptr - p);
+		p = nptr;
+	}
+
+quit:
+	return cd;
+}
-- 
1.7.6.1

