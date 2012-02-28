Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965305Ab2B1Nhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:37:52 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:56893 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757224Ab2B1Nhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:37:32 -0500
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [RFC][PATCH 3/6] x86, mkpiggy: Don't open code put_unaligned_le32()
Date: Tue, 28 Feb 2012 13:37:22 +0000
Message-Id: <1330436245-24875-4-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
References: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Use the new headers in tools/include instead of rolling our own
put_unaligned_le32() implementation.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/Makefile  |    1 +
 arch/x86/boot/compressed/mkpiggy.c |   11 ++---------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index b123b9a..fd55a2f 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -22,6 +22,7 @@ LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
 
 hostprogs-y	:= mkpiggy
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
 VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index 46a8238..958a641 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -29,14 +29,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <inttypes.h>
-
-static uint32_t getle32(const void *p)
-{
-	const uint8_t *cp = p;
-
-	return (uint32_t)cp[0] + ((uint32_t)cp[1] << 8) +
-		((uint32_t)cp[2] << 16) + ((uint32_t)cp[3] << 24);
-}
+#include <tools/le_byteshift.h>
 
 int main(int argc, char *argv[])
 {
@@ -69,7 +62,7 @@ int main(int argc, char *argv[])
 	}
 
 	ilen = ftell(f);
-	olen = getle32(&olen);
+	olen = get_unaligned_le32(&olen);
 	fclose(f);
 
 	/*
-- 
1.7.4.4

