Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab0ENEnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 00:43:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab0ENEnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 00:43:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Use .cfi_sections
X-Fcc: ~/Mail/linus
Emacs: no job too big... no job.
Message-Id: <20100514044303.A6FE7400BE@magilla.sf.frob.com>
Date: Thu, 13 May 2010 21:43:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6a251b0ab67989f468f4cb65179e0cf40cf8c295:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../sameo/mfd-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git x86/cfi

Roland McGrath (1):
      x86: Use .cfi_sections

 arch/x86/Makefile             |    5 +++--
 arch/x86/include/asm/dwarf2.h |   12 ++++++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)


Thanks,
Roland
---
[PATCH] x86: Use .cfi_sections

The newer assemblers support the .cfi_sections directive so we can put
the CFI from .S files into the .debug_frame section that is preserved
in unstripped vmlinux and in separate debuginfo, rather than the
.eh_frame section that is now discarded by vmlinux.lds.S.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/Makefile             |    5 +++--
 arch/x86/include/asm/dwarf2.h |   12 ++++++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 0a43dc5..8aa1b59 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -95,8 +95,9 @@ sp-$(CONFIG_X86_64) := rsp
 cfi := $(call as-instr,.cfi_startproc\n.cfi_rel_offset $(sp-y)$(comma)0\n.cfi_endproc,-DCONFIG_AS_CFI=1)
 # is .cfi_signal_frame supported too?
 cfi-sigframe := $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1)
-KBUILD_AFLAGS += $(cfi) $(cfi-sigframe)
-KBUILD_CFLAGS += $(cfi) $(cfi-sigframe)
+cfi-sections := $(call as-instr,.cfi_sections .debug_frame,-DCONFIG_AS_CFI_SECTIONS=1)
+KBUILD_AFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections)
+KBUILD_CFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections)
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
 
diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index ae6253a..733f7e9 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -34,6 +34,18 @@
 #define CFI_SIGNAL_FRAME
 #endif
 
+#if defined(CONFIG_AS_CFI_SECTIONS) && defined(__ASSEMBLY__)
+	/*
+	 * Emit CFI data in .debug_frame sections, not .eh_frame sections.
+	 * The latter we currently just discard since we don't do DWARF
+	 * unwinding at runtime.  So only the offline DWARF information is
+	 * useful to anyone.  Note we should not use this directive if this
+	 * file is used in the vDSO assembly, or if vmlinux.lds.S gets
+	 * changed so it doesn't discard .eh_frame.
+	 */
+	.cfi_sections .debug_frame
+#endif
+
 #else
 
 /*
