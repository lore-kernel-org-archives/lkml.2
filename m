Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab1LOLLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 06:11:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662Ab1LOLLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 06:11:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] FRV: Remove the .gnu.build-id note when producing the
 loadable image
To: torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Thu, 15 Dec 2011 11:11:48 +0000
Message-ID: <20111215111148.395.72074.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111215111137.395.21724.stgit@warthog.procyon.org.uk>
References: <20111215111137.395.21724.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the .gnu.build-id note when producing the loadable image as this is
marked Allocatable in the ELF section table and is marked as being loaded at
address 0 if the linker is recent enough to generate it:

  [ 1] .note.gnu.build-i NOTE            00000000 004000 000024 00   A  0   0  4

This is a problem for objcopying the vmlinux file to the loadable image file as
the objcopy -O binary starts writing the file from the base address of the
lowest entry in the ELF program headers table:

  LOAD           0x004000 0x00000000 0x00000000 0x00024  0x00024  R   0x4000
  LOAD           0x008000 0xc0000000 0xc0000000 0x2a6138 0x2c9e8c RWE 0x4000
  NOTE           0x004000 0x00000000 0x00000000 0x00024  0x00024  R   0x4

The kernel actually resides at 0xc0000000 and so objcopy pads the output file
between the note (at 0) and the kernel, resulting in a 3.3GB file - which
confuses things like TFTP and RedBoot (when loading raw binary data).

The old linker - which doesn't produce this note - shows this:

  LOAD           0x001000 0xc0000000 0xc0000000 0x2aa260 0x2aaa54 RWE 0x1000
  LOAD           0x2ab000 0xc02ac000 0xc02ac000 0x00000  0x21d8c  RW  0x1000

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/boot/Makefile |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)


diff --git a/arch/frv/boot/Makefile b/arch/frv/boot/Makefile
index 6ae3254..6359c49 100644
--- a/arch/frv/boot/Makefile
+++ b/arch/frv/boot/Makefile
@@ -31,19 +31,21 @@ Image: $(obj)/Image
 
 targets: $(obj)/Image
 
+REMOVE_SECTIONS	:= -R .note -R .comment -R .note.gnu.build-id
+
 $(obj)/Image: vmlinux FORCE
-	$(OBJCOPY) -O binary -R .note -R .comment -S vmlinux $@
+	$(OBJCOPY) -O binary $(REMOVE_SECTIONS) -S vmlinux $@
 
 #$(obj)/Image:	$(CONFIGURE) $(SYSTEM)
-#	$(OBJCOPY) -O binary -R .note -R .comment -g -S $(SYSTEM) $@
+#	$(OBJCOPY) -O binary $(REMOVE_SECTIONS) -g -S $(SYSTEM) $@
 
 bzImage: zImage
 
 zImage:	$(CONFIGURE) compressed/$(LINUX)
-	$(OBJCOPY) -O binary -R .note -R .comment -S compressed/$(LINUX) $@
+	$(OBJCOPY) -O binary $(REMOVE_SECTIONS) -S compressed/$(LINUX) $@
 
 bootpImage: bootp/bootp
-	$(OBJCOPY) -O binary -R .note -R .comment -S bootp/bootp $@
+	$(OBJCOPY) -O binary $(REMOVE_SECTIONS) -S bootp/bootp $@
 
 compressed/$(LINUX): $(LINUX) dep
 	@$(MAKE) -C compressed $(LINUX)

