Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0LIJfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 04:35:54 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:53319 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410Ab0LIJfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 04:35:53 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 006/211] unicore32: new file arch/unicore32/boot/compressed/Makefile
Date: Thu, 9 Dec 2010 17:35:44 +0800
Message-ID: <01d601cb9784$741aecf0$5c50c6d0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcuXhGmWmESiv1O6RYiTqZ3qBlZv1g==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

	Makefile for uncompressed head, with autogenerate piggy.S and
ld-script

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/boot/compressed/Makefile |   71
+++++++++++++++++++++++++++++++
 1 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/boot/compressed/Makefile
b/arch/unicore32/boot/compressed/Makefile
new file mode 100644
index 0000000..79f8889
--- /dev/null
+++ b/arch/unicore32/boot/compressed/Makefile
@@ -0,0 +1,71 @@
+#
+# linux/arch/unicore32/boot/compressed/Makefile
+#
+# create a compressed vmlinuz image from the original vmlinux
+#
+# This file is subject to the terms and conditions of the GNU General
Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 2001~2010 GUAN Xue-tao
+#
+
+EXTRA_CFLAGS	:= -fpic -fno-builtin
+EXTRA_AFLAGS	:= -Wa,-march=all
+
+AFLAGS_head.o	+= -DTEXT_OFFSET=$(TEXT_OFFSET)
+OBJS		:= misc.o
+
+# font.c and font.o
+CFLAGS_font.o	:= -Dstatic=
+$(obj)/font.c: $(srctree)/drivers/video/console/font_8x8.c
+	$(call cmd,shipped)
+
+# piggy.S and piggy.o
+suffix_$(CONFIG_KERNEL_GZIP)	:= gzip
+suffix_$(CONFIG_KERNEL_BZIP2)	:= bz2
+suffix_$(CONFIG_KERNEL_LZO)	:= lzo
+suffix_$(CONFIG_KERNEL_LZMA)	:= lzma
+
+$(obj)/piggy.$(suffix_y): $(obj)/../Image FORCE
+	$(call if_changed,$(suffix_y))
+
+SEDFLAGS_piggy	= s/DECOMP_SUFFIX/$(suffix_y)/
+$(obj)/piggy.S: $(obj)/piggy.S.in
+	@sed "$(SEDFLAGS_piggy)" < $< > $@
+
+$(obj)/piggy.o:  $(obj)/piggy.$(suffix_y) $(obj)/piggy.S FORCE
+
+targets		:= vmlinux vmlinux.lds font.o font.c head.o misc.o \
+			piggy.$(suffix_y) piggy.o piggy.S \
+
+# Make sure files are removed during clean
+extra-y		+= piggy.gzip piggy.bz2 piggy.lzo piggy.lzma
+
+# Supply zreladdr to the decompressor via a linker symbol.
+LDFLAGS_vmlinux := --defsym zreladdr=$(TEXT_OFFSET)
+# ?
+LDFLAGS_vmlinux += -p
+# Report unresolved symbol references
+LDFLAGS_vmlinux += --no-undefined
+# Delete all temporary local symbols
+LDFLAGS_vmlinux += -X
+# Next argument is a linker script
+LDFLAGS_vmlinux += -T
+
+# For uidivmod
+$(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/head.o $(obj)/piggy.o \
+		$(obj)/misc.o FORCE
+	$(call if_changed,ld)
+	@:
+
+# We now have a PIC decompressor implementation.  Decompressors running
+# from RAM should not define ZTEXTADDR.  Decompressors running directly
+# from ROM or Flash must define ZTEXTADDR (preferably via the config)
+ZTEXTADDR	:= 0
+ZBSSADDR	:= ALIGN(4)
+
+SEDFLAGS_lds	= s/TEXT_START/$(ZTEXTADDR)/;s/BSS_START/$(ZBSSADDR)/
+$(obj)/vmlinux.lds: $(obj)/vmlinux.lds.in arch/unicore32/boot/Makefile
$(KCONFIG_CONFIG)
+	@sed "$(SEDFLAGS_lds)" < $< > $@
+


