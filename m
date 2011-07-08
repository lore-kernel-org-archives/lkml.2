Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1GIGGA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:06:00 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:38557 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770Ab1GIGBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:01:10 -0400
X-Sasl-enc: r7T8STZ+xxsTiAZRTVEiamCYLNrreP8Vk9yPwiK7+etK 1310191269
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 16:01:11 2011
Message-Id: <20110708230111.814821833@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 16:00:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland McGrath <roland@redhat.com>, Jeff Dike <jdike@addtoit.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [23/35] uml: fix CONFIG_STATIC_LINK=y build failure with newer glibc
In-Reply-To: <20110708230122.GA18807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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

---
 arch/um/kernel/dyn.lds.S |   14 ++++++++++++--
 arch/um/kernel/uml.lds.S |   17 +++++++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

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


