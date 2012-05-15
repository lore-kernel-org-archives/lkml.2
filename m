Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965143Ab2EOCwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:52:00 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53384 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965102Ab2EOCRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 096/179] uml: fix CONFIG_STATIC_LINK=y build failure with newer glibc
Date: Mon, 14 May 2012 22:13:12 -0400
Message-ID: <1337048075-6132-97-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit aa5fb4dbfd121296ca97c68cf90043a7ea97579d upstream.

With glibc 2.11 or later that was built with --enable-multi-arch, the UML
link fails with undefined references to __rel_iplt_start and similar
symbols.  In recent binutils, the default linker script defines these
symbols (see ld --verbose).  Fix the UML linker scripts to match the new
defaults for these sections.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/um/kernel/dyn.lds.S |   14 ++++++++++++--
 arch/um/kernel/uml.lds.S |   17 +++++++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index 7fcad58..3d6b43f 100644
--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -50,8 +50,18 @@ SECTIONS
   .rela.got       : { *(.rela.got) }
   .rel.bss        : { *(.rel.bss .rel.bss.* .rel.gnu.linkonce.b.*) }
   .rela.bss       : { *(.rela.bss .rela.bss.* .rela.gnu.linkonce.b.*) }
-  .rel.plt        : { *(.rel.plt) }
-  .rela.plt       : { *(.rela.plt) }
+  .rel.plt : {
+	*(.rel.plt)
+	PROVIDE_HIDDEN(__rel_iplt_start = .);
+	*(.rel.iplt)
+	PROVIDE_HIDDEN(__rel_iplt_end = .);
+  }
+  .rela.plt : {
+	*(.rela.plt)
+	PROVIDE_HIDDEN(__rela_iplt_start = .);
+	*(.rela.iplt)
+	PROVIDE_HIDDEN(__rela_iplt_end = .);
+  }
   .init           : {
     KEEP (*(.init))
   } =0x90909090
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index 664f942..79a077a 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -43,6 +43,23 @@ SECTIONS
 	__syscall_stub_end = .;
   }
 
+  /*
+   * These are needed even in a static link, even if they wind up being empty.
+   * Newer glibc needs these __rel{,a}_iplt_{start,end} symbols.
+   */
+  .rel.plt : {
+	*(.rel.plt)
+	PROVIDE_HIDDEN(__rel_iplt_start = .);
+	*(.rel.iplt)
+	PROVIDE_HIDDEN(__rel_iplt_end = .);
+  }
+  .rela.plt : {
+	*(.rela.plt)
+	PROVIDE_HIDDEN(__rela_iplt_start = .);
+	*(.rela.iplt)
+	PROVIDE_HIDDEN(__rela_iplt_end = .);
+  }
+
   #include "asm/common.lds.S"
 
   init.data : { INIT_DATA }
-- 
1.7.9.6

