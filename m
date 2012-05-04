Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab2EDUq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:46:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57129 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab2EDUqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:46:52 -0400
Message-Id: <20120504204228.559400369@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [ 49/75] x86, mkpiggy: Dont open code put_unaligned_le32()
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit 12871c568305a0b20f116315479a18cd46882e9b upstream.

Use the new headers in tools/include instead of rolling our own
put_unaligned_le32() implementation.

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1330436245-24875-4-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/Makefile  |    1 +
 arch/x86/boot/compressed/mkpiggy.c |   11 ++---------
 2 files changed, 3 insertions(+), 9 deletions(-)

--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -22,6 +22,7 @@ LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
 
 hostprogs-y	:= mkpiggy
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
 VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
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


