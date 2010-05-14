Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab0ENFtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 01:49:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:42261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab0ENFtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 01:49:02 -0400
Date: Fri, 14 May 2010 05:48:45 GMT
From: tip-bot for Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       roland@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, tglx@linutronix.de
In-Reply-To: <20100514044303.A6FE7400BE@magilla.sf.frob.com>
References: <20100514044303.A6FE7400BE@magilla.sf.frob.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Use .cfi_sections for assembly code
Message-ID: <tip-9e565292270a2d55524be38835104c564ac8f795@git.kernel.org>
Git-Commit-ID: 9e565292270a2d55524be38835104c564ac8f795
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 14 May 2010 05:48:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e565292270a2d55524be38835104c564ac8f795
Gitweb:     http://git.kernel.org/tip/9e565292270a2d55524be38835104c564ac8f795
Author:     Roland McGrath <roland@redhat.com>
AuthorDate: Thu, 13 May 2010 21:43:03 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 13 May 2010 22:15:18 -0700

x86: Use .cfi_sections for assembly code

The newer assemblers support the .cfi_sections directive so we can put
the CFI from .S files into the .debug_frame section that is preserved
in unstripped vmlinux and in separate debuginfo, rather than the
.eh_frame section that is now discarded by vmlinux.lds.S.

Signed-off-by: Roland McGrath <roland@redhat.com>
LKML-Reference: <20100514044303.A6FE7400BE@magilla.sf.frob.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
