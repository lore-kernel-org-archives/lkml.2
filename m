Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0LIJib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:38:31 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:53326 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897Ab0LIJi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:38:28 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 008/211] unicore32: new file arch/unicore32/boot/compressed/misc.c
Date: Thu, 9 Dec 2010 17:38:26 +0800
Message-ID: <01da01cb9784$d44c0460$7ce40d20$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuXhNP0y/6QfpikR3uC1ifOkX3fyQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

	decompress_kernel call wrapper in c function

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/boot/compressed/misc.c |  143
+++++++++++++++++++++++++++++++++
 1 files changed, 143 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/boot/compressed/misc.c
b/arch/unicore32/boot/compressed/misc.c
new file mode 100644
index 0000000..28dda37
--- /dev/null
+++ b/arch/unicore32/boot/compressed/misc.c
@@ -0,0 +1,143 @@
+/*
+ * linux/arch/unicore32/boot/compressed/misc.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/unaligned.h>
+#include <asm/mach/uncompress.h>
+
+/*
+ * gzip delarations
+ */
+unsigned char *output_data;
+unsigned long output_ptr;
+
+unsigned int free_mem_ptr;
+unsigned int free_mem_end_ptr;
+
+#define STATIC static
+#define STATIC_RW_DATA	/* non-static please */
+
+/*
+ * arch-dependent implementations
+ */
+#ifndef ARCH_HAVE_DECOMP_ERROR
+#define arch_decomp_error(x)
+#endif
+
+#ifndef ARCH_HAVE_DECOMP_SETUP
+#define	arch_decomp_setup()
+#endif
+
+#ifndef ARCH_HAVE_DECOMP_PUTS
+#define arch_decomp_puts(p)
+#endif
+
+/* Diagnostic functions */
+#ifdef DEBUG
+#  define Assert(cond, msg)	{ if (!(cond)) error(msg); }
+#  define Trace(x)		fprintf x
+#  define Tracev(x)		{ if (verbose)			fprintf x; }
+#  define Tracevv(x)		{ if (verbose > 1)		fprintf x; }
+#  define Tracec(c, x)		{ if (verbose && (c))		fprintf x; }
+#  define Tracecv(c, x)		{ if ((verbose > 1) && (c))
fprintf x; }
+#else
+#  define Assert(cond, msg)
+#  define Trace(x)
+#  define Tracev(x)
+#  define Tracevv(x)
+#  define Tracec(c, x)
+#  define Tracecv(c, x)
+#endif
+
+void *memcpy(void *__dest, __const void *__src, size_t __n)
+{
+	int i = 0;
+	unsigned char *d = (unsigned char *)__dest, *s = (unsigned char
*)__src;
+
+	for (i = __n >> 3; i > 0; i--) {
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+	}
+
+	if (__n & 1 << 2) {
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+		*d++ = *s++;
+	}
+
+	if (__n & 1 << 1) {
+		*d++ = *s++;
+		*d++ = *s++;
+	}
+
+	if (__n & 1)
+		*d++ = *s++;
+
+	return __dest;
+}
+
+void error(char *x)
+{
+
+	arch_decomp_puts("\n\n");
+	arch_decomp_puts(x);
+	arch_decomp_puts("\n\n -- System halted");
+
+	arch_decomp_error(x);
+
+	do { } while (1); /* Halt */
+}
+
+/* Heap size should be adjusted for different decompress method */
+#ifdef CONFIG_KERNEL_GZIP
+#include "../../../../lib/decompress_inflate.c"
+#endif
+
+#ifdef CONFIG_KERNEL_BZIP2
+#include "../../../../lib/decompress_bunzip2.c"
+#endif
+
+#ifdef CONFIG_KERNEL_LZO
+#include "../../../../lib/decompress_unlzo.c"
+#endif
+
+#ifdef CONFIG_KERNEL_LZMA
+#include "../../../../lib/decompress_unlzma.c"
+#endif
+
+unsigned long
+decompress_kernel(unsigned long output_start, unsigned long free_mem_ptr_p,
+		unsigned long free_mem_ptr_end_p)
+{
+	unsigned char *tmp;
+
+	output_data		= (unsigned char *)output_start;
+	free_mem_ptr		= free_mem_ptr_p;
+	free_mem_end_ptr	= free_mem_ptr_end_p;
+
+	arch_decomp_setup();
+
+	tmp = (unsigned char *) (((unsigned long)input_data_end) - 4);
+	output_ptr = get_unaligned_le32(tmp);
+
+	arch_decomp_puts("Uncompressing Linux...");
+	decompress(input_data, input_data_end - input_data, NULL, NULL,
+			output_data, NULL, error);
+	arch_decomp_puts(" done, booting the kernel.\n");
+	return output_ptr;
+}

