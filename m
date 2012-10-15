Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab2JOLoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 07:44:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab2JOLoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 07:44:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/4] FRV: Fix linux/elf-fdpic.h
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, uclinux-dev@uclinux.org
Date: Mon, 15 Oct 2012 12:44:04 +0100
Message-ID: <20121015114404.1042.75225.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121015114343.1042.81528.stgit@warthog.procyon.org.uk>
References: <20121015114343.1042.81528.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems I accidentally switched the guard on linux/elf-fdpic.h from #ifdef
__KERNEL__ to #ifndef __KERNEL__ when attempting to expand the guarded region
to cover the elf_fdpic_params struct when doing the UAPI split - with the
result that the struct became unavailable to kernel code.

Move incorrectly guarded bits back to the kernelspace header.

Whilst we're at it, the __KERNEL__ guards can be deleted as they're no longer
necessary.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Fengguang Wu <fengguang.wu@intel.com>
cc: Lars-Peter Clausen <lars@metafoo.de>
cc: uclinux-dev@uclinux.org
---

 include/uapi/linux/elf-fdpic.h |   42 +++-------------------------------------
 1 file changed, 3 insertions(+), 39 deletions(-)


diff --git a/include/uapi/linux/elf-fdpic.h b/include/uapi/linux/elf-fdpic.h
index 1065078..3921e33 100644
--- a/include/uapi/linux/elf-fdpic.h
+++ b/include/uapi/linux/elf-fdpic.h
@@ -9,8 +9,8 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#ifndef _LINUX_ELF_FDPIC_H
-#define _LINUX_ELF_FDPIC_H
+#ifndef _UAPI_LINUX_ELF_FDPIC_H
+#define _UAPI_LINUX_ELF_FDPIC_H
 
 #include <linux/elf.h>
 
@@ -31,40 +31,4 @@ struct elf32_fdpic_loadmap {
 
 #define ELF32_FDPIC_LOADMAP_VERSION	0x0000
 
-#ifndef __KERNEL__
-/*
- * binfmt binary parameters structure
- */
-struct elf_fdpic_params {
-	struct elfhdr			hdr;		/* ref copy of ELF header */
-	struct elf_phdr			*phdrs;		/* ref copy of PT_PHDR table */
-	struct elf32_fdpic_loadmap	*loadmap;	/* loadmap to be passed to userspace */
-	unsigned long			elfhdr_addr;	/* mapped ELF header user address */
-	unsigned long			ph_addr;	/* mapped PT_PHDR user address */
-	unsigned long			map_addr;	/* mapped loadmap user address */
-	unsigned long			entry_addr;	/* mapped entry user address */
-	unsigned long			stack_size;	/* stack size requested (PT_GNU_STACK) */
-	unsigned long			dynamic_addr;	/* mapped PT_DYNAMIC user address */
-	unsigned long			load_addr;	/* user address at which to map binary */
-	unsigned long			flags;
-#define ELF_FDPIC_FLAG_ARRANGEMENT	0x0000000f	/* PT_LOAD arrangement flags */
-#define ELF_FDPIC_FLAG_INDEPENDENT	0x00000000	/* PT_LOADs can be put anywhere */
-#define ELF_FDPIC_FLAG_HONOURVADDR	0x00000001	/* PT_LOAD.vaddr must be honoured */
-#define ELF_FDPIC_FLAG_CONSTDISP	0x00000002	/* PT_LOADs require constant
-							 * displacement */
-#define ELF_FDPIC_FLAG_CONTIGUOUS	0x00000003	/* PT_LOADs should be contiguous */
-#define ELF_FDPIC_FLAG_EXEC_STACK	0x00000010	/* T if stack to be executable */
-#define ELF_FDPIC_FLAG_NOEXEC_STACK	0x00000020	/* T if stack not to be executable */
-#define ELF_FDPIC_FLAG_EXECUTABLE	0x00000040	/* T if this object is the executable */
-#define ELF_FDPIC_FLAG_PRESENT		0x80000000	/* T if this object is present */
-};
-
-#ifdef CONFIG_MMU
-extern void elf_fdpic_arch_lay_out_mm(struct elf_fdpic_params *exec_params,
-				      struct elf_fdpic_params *interp_params,
-				      unsigned long *start_stack,
-				      unsigned long *start_brk);
-#endif
-#endif /* __KERNEL__ */
-
-#endif /* _LINUX_ELF_FDPIC_H */
+#endif /* _UAPI_LINUX_ELF_FDPIC_H */

