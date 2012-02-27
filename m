Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab2B0WXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 17:23:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48570 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab2B0WXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 17:23:06 -0500
Date: Mon, 27 Feb 2012 14:21:55 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-0bf6276392e990dd0da0ccd8e10f42597d503f29@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, hjl.tools@gmail.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu,
        hjl.tools@gmail.com
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/x32] x32:
  Warn and disable rather than error if binutils too old
Git-Commit-ID: 0bf6276392e990dd0da0ccd8e10f42597d503f29
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Feb 2012 14:22:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bf6276392e990dd0da0ccd8e10f42597d503f29
Gitweb:     http://git.kernel.org/tip/0bf6276392e990dd0da0ccd8e10f42597d503f29
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Mon, 27 Feb 2012 14:09:10 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 27 Feb 2012 14:09:10 -0800

x32: Warn and disable rather than error if binutils too old

If X32 is enabled in .config, but the binutils can't build it, issue a
warning and disable the feature rather than erroring out.

In order to support this, have CONFIG_X86_X32 be the option set in
Kconfig, and CONFIG_X86_X32_ABI be the option set by the Makefile when
it is enabled and binutils has been found to be functional.

Requested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: H. J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/1329696488-16970-1-git-send-email-hpa@zytor.com
---
 arch/x86/Kconfig  |    4 ++--
 arch/x86/Makefile |   16 ++++++++++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c9d6c9e..e2b38b4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2175,7 +2175,7 @@ config IA32_AOUT
 	---help---
 	  Support old a.out binaries in the 32bit emulation.
 
-config X86_X32_ABI
+config X86_X32
 	bool "x32 ABI for 64-bit mode (EXPERIMENTAL)"
 	depends on X86_64 && IA32_EMULATION && EXPERIMENTAL
 	---help---
@@ -2190,7 +2190,7 @@ config X86_X32_ABI
 
 config COMPAT
 	def_bool y
-	depends on IA32_EMULATION || X86_X32_ABI
+	depends on IA32_EMULATION || X86_X32
 
 config COMPAT_FOR_U64_ALIGNMENT
 	def_bool COMPAT
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 209ba12..31bb1eb 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -82,6 +82,22 @@ ifdef CONFIG_CC_STACKPROTECTOR
         endif
 endif
 
+ifdef CONFIG_X86_X32
+	x32_ld_ok := $(call try-run,\
+			/bin/echo -e '1: .quad 1b' | \
+			$(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" - && \
+			$(OBJCOPY) -O elf32-x86-64 "$$TMP" "$$TMPO" && \
+			$(LD) -m elf32_x86_64 "$$TMPO" -o "$$TMP",y,n)
+	ifeq ($(x32_ld_ok),y)
+		CONFIG_X86_X32_ABI := y
+		KBUILD_AFLAGS += -DCONFIG_X86_X32_ABI
+		KBUILD_CFLAGS += -DCONFIG_X86_X32_ABI
+	else
+		$(warning CONFIG_X86_X32 enabled but no binutils support)
+	endif
+endif
+export CONFIG_X86_X32_ABI
+
 # Don't unroll struct assignments with kmemcheck enabled
 ifeq ($(CONFIG_KMEMCHECK),y)
 	KBUILD_CFLAGS += $(call cc-option,-fno-builtin-memcpy)
