Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab1G1Pv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:51:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755791Ab1G1Pvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:51:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/40] UAPI: elf_read_implies_exec() is a kernel-only feature
 - so hide from userspace [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:51:47 +0100
Message-ID: <20110728155146.16618.91167.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

elf_read_implies_exec() is a kernel-only feature as the second parameter is a
constant that isn't exported to userspace.  Not only that, but the
arch-specific overrides are not exported either.

So hide the macro from userspace.

Similarly, struct file should not be predeclared in userspace.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/elf.h |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/elf.h b/include/linux/elf.h
index 110821c..411d7b8 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -7,15 +7,6 @@
 #include <asm/elf.h>
 #endif
 
-struct file;
-
-#ifndef elf_read_implies_exec
-  /* Executables for which elf_read_implies_exec() returns TRUE will
-     have the READ_IMPLIES_EXEC personality flag set automatically.
-     Override in asm/elf.h as needed.  */
-# define elf_read_implies_exec(ex, have_pt_gnu_stack)	0
-#endif
-
 /* 32-bit ELF base types. */
 typedef __u32	Elf32_Addr;
 typedef __u16	Elf32_Half;
@@ -413,6 +404,13 @@ typedef struct elf64_note {
 } Elf64_Nhdr;
 
 #ifdef __KERNEL__
+#ifndef elf_read_implies_exec
+  /* Executables for which elf_read_implies_exec() returns TRUE will
+     have the READ_IMPLIES_EXEC personality flag set automatically.
+     Override in asm/elf.h as needed.  */
+# define elf_read_implies_exec(ex, have_pt_gnu_stack)	0
+#endif
+
 #if ELF_CLASS == ELFCLASS32
 
 extern Elf32_Dyn _DYNAMIC [];
@@ -436,6 +434,8 @@ extern Elf64_Dyn _DYNAMIC [];
 #endif
 
 /* Optional callbacks to write extra ELF notes. */
+struct file;
+
 #ifndef ARCH_HAVE_EXTRA_ELF_NOTES
 static inline int elf_coredump_extra_notes_size(void) { return 0; }
 static inline int elf_coredump_extra_notes_write(struct file *file,

