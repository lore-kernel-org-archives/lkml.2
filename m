Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab0KKX6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:58:33 -0500
Received: from claw.goop.org ([74.207.240.146]:33442 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250Ab0KKX6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:58:16 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen-devel <xen-devel@lists.xensource.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 3/3] xen/microcode: partially enable even for non-privileged kernels
Date: Thu, 11 Nov 2010 15:58:06 -0800
Message-Id: <049ad0809c51dedebab0b8e4bfcf58f5f26375b7.1289519130.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289519130.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1289519130.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1289519130.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1289519130.git.jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Don't attempt to load microcode on non-privileged kernels.  Kernels
compiled without privileged support just get vestigial Xen detection
to skip loading altogether; kernels with privileged support will
load microcode if running privileged.  In either case, the normal
Intel/AMD microcode loader is skipped under Xen.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/microcode.h |    2 +-
 arch/x86/kernel/Makefile         |    2 +-
 arch/x86/xen/Kconfig             |    6 +++++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index e15fca1..3e61afe 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -55,7 +55,7 @@ static inline struct microcode_ops * __init init_amd_microcode(void)
 }
 #endif
 
-#ifdef CONFIG_MICROCODE_XEN
+#ifdef CONFIG_MICROCODE_XEN_LOADER
 extern struct microcode_ops * __init init_xen_microcode(void);
 #else
 static inline struct microcode_ops * __init init_xen_microcode(void)
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0036150..768c5dc 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -104,7 +104,7 @@ obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
 microcode-y				:= microcode_core.o
 microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
 microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
-microcode-$(CONFIG_MICROCODE_XEN)	+= microcode_xen.o
+microcode-$(CONFIG_MICROCODE_XEN_LOADER)	+= microcode_xen.o
 obj-$(CONFIG_MICROCODE)			+= microcode.o
 
 obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 384e0a5..9a0d2fc 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -51,4 +51,8 @@ config XEN_DEBUG_FS
 
 config MICROCODE_XEN
        def_bool y
-       depends on XEN_DOM0 && MICROCODE
\ No newline at end of file
+       depends on XEN && MICROCODE
+
+config MICROCODE_XEN_LOADER
+	def_bool y
+	depends on MICROCODE_XEN && DOM0
-- 
1.7.2.3

