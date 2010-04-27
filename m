Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0D0M0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:26:47 -0400
Received: from hermes.ugcs.caltech.edu ([131.215.176.65]:54238 "EHLO
	hermes.ugcs.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab0D0M0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:26:42 -0400
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Apr 2010 08:26:42 EDT
Message-ID: <4BD6D59A.5070908@ugcs.caltech.edu>
Date: Tue, 27 Apr 2010 05:16:26 -0700
From: Matthew Ryan Maurer <maurer@ugcs.caltech.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100415 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>, Tejun Heo <tj@kernel.org>,
       Paul Mundt <lethal@linux-sh.org>, Mike Frysinger <vapier@gentoo.org>,
       Michal Simek <monstr@monstr.eu>, Tim Abbott <tabbott@ksplice.com>
CC: user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] UML: UML libc linking error fix
X-Enigmail-Version: 1.0.1
OpenPGP: id=6F0BA31E;
	url=http://pgp.ugcs.caltech.edu:11371/pks/lookup?op=get&search=0x518ED72D6F0BA31E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Maurer <maurer@ugcs.caltech.edu>

Fixes linking for UML against newer libcs by adding two hidden symbols
which are now expected.
Signed-off-by: Matthew Maurer <maurer@ugcs.caltech.edu>
---
Apologies ahead of time if I've missed something or if this has already
been fixed somewhere I couldn't find it.
diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index 7fcad58..85babf5 100644
--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -50,8 +50,21 @@ SECTIONS
   .rela.got       : { *(.rela.got) }
   .rel.bss        : { *(.rel.bss .rel.bss.* .rel.gnu.linkonce.b.*) }
   .rela.bss       : { *(.rela.bss .rela.bss.* .rela.gnu.linkonce.b.*) }
-  .rel.plt        : { *(.rel.plt) }
-  .rela.plt       : { *(.rela.plt) }
+  /* Deal with multilib libc */
+  .rel.plt        :
+  {
+    *(.rel.plt)
+    PROVIDE_HIDDEN (__rel_iplt_start = .);
+    *(.rel.iplt)
+    PROVIDE_HIDDEN (__rel_iplt_end = .);
+  }
+  .rela.plt       :
+  {
+    *(.rela.plt)
+    PROVIDE_HIDDEN (__rela_iplt_start = .);
+    *(.rela.iplt)
+    PROVIDE_HIDDEN (__rela_iplt_end = .);
+  }
   .init           : {
     KEEP (*(.init))
   } =0x90909090
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index e7a6cca..50d80e8 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -35,6 +35,21 @@ SECTIONS
     *(.gnu.warning)
     *(.gnu.linkonce.t*)
   }
+  /* Deal with multilib libc */
+  .rel.plt        :
+  {
+    *(.rel.plt)
+    PROVIDE_HIDDEN (__rel_iplt_start = .);
+    *(.rel.iplt)
+    PROVIDE_HIDDEN (__rel_iplt_end = .);
+  }
+  .rela.plt       :
+  {
+    *(.rela.plt)
+    PROVIDE_HIDDEN (__rela_iplt_start = .);
+    *(.rela.iplt)
+    PROVIDE_HIDDEN (__rela_iplt_end = .);
+  }

   . = ALIGN(PAGE_SIZE);
   .syscall_stub : {
Signed-off-by: Matthew Maurer <maurer@ugcs.caltech.edu>
