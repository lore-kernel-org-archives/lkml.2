Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab1G0Vts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:49:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:43559 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752Ab1G0Vt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="33043907"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: roland@redhat.com, jdike@addtoit.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [86/99] uml: fix CONFIG_STATIC_LINK=y build failure with newer glibc
Message-Id: <20110727214925.D2C3C2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Roland McGrath <roland@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/um/kernel/dyn.lds.S |   14 ++++++++++++--
 arch/um/kernel/uml.lds.S |   17 +++++++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/arch/um/kernel/dyn.lds.S
===================================================================
--- linux-2.6.35.y.orig/arch/um/kernel/dyn.lds.S
+++ linux-2.6.35.y/arch/um/kernel/dyn.lds.S
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
Index: linux-2.6.35.y/arch/um/kernel/uml.lds.S
===================================================================
--- linux-2.6.35.y.orig/arch/um/kernel/uml.lds.S
+++ linux-2.6.35.y/arch/um/kernel/uml.lds.S
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
