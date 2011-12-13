Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1LMKkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:40:19 -0500
Received: from warthog.procyon.org.uk ([90.155.74.18]:52178 "EHLO
	warthog.procyon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab1LMKkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:40:15 -0500
From: David Howells <dhowells@redhat.com>
To: sfr@canb.auug.org.au, torvalds@linux-foundation.org
Cc: arnd@arndb.de, dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 03/17] UAPI: elf_read_implies_exec() is a kernel-only feature - so hide from userspace
Date: Tue, 13 Dec 2011 10:03:59 +0000
Message-Id: <1323770653-19177-4-git-send-email-dhowells@redhat.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
References: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
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
index 31f0508..999b4f5 100644
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
@@ -414,6 +405,13 @@ typedef struct elf64_note {
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
@@ -437,6 +435,8 @@ extern Elf64_Dyn _DYNAMIC [];
 #endif
 
 /* Optional callbacks to write extra ELF notes. */
+struct file;
+
 #ifndef ARCH_HAVE_EXTRA_ELF_NOTES
 static inline int elf_coredump_extra_notes_size(void) { return 0; }
 static inline int elf_coredump_extra_notes_write(struct file *file,
-- 
1.7.7.4

