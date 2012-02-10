Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193Ab2BJLZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:25:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759179Ab2BJLZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:25:50 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] unwind, x86: Generate exception frames data for UNWIND_EH_FRAME option
Date: Fri, 10 Feb 2012 12:25:16 +0100
Message-Id: <1328873119-21553-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
References: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to compile in eh_frame_hdr/eh_frame unwind
data. Plus several symbols to properly access this data.

	__eh_frame_hdr_start
	__eh_frame_hdr_end
	__eh_frame_start
	__eh_frame_end

Adding this for x86 arch, tested for x86_64 only.
---
 arch/x86/Makefile                 |    8 +++++++-
 arch/x86/kernel/vmlinux.lds.S     |    5 +++++
 include/asm-generic/vmlinux.lds.h |   12 ++++++++++++
 3 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 209ba12..6d728fa 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -109,8 +109,14 @@ LDFLAGS := -m elf_$(UTS_MACHINE)
 KBUILD_CFLAGS += -pipe
 # Workaround for a gcc prelease that unfortunately was shipped in a suse release
 KBUILD_CFLAGS += -Wno-sign-compare
-#
+
+ifdef CONFIG_UNWIND_EH_FRAME
+LDFLAGS_vmlinux += --eh-frame-hdr
+else
+# do not generate ef_frame section by default
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
+endif
+
 # prevent gcc from generating any FP code by mistake
 KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
 
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 0f703f1..9cc7df0 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -114,6 +114,9 @@ SECTIONS
 
 	NOTES :text :note
 
+	/* Exception (header) frames */
+	EH_FRAME
+
 	EXCEPTION_TABLE(16) :text = 0x9090
 
 #if defined(CONFIG_DEBUG_RODATA)
@@ -335,7 +338,9 @@ SECTIONS
 
 	/* Sections to be discarded */
 	DISCARDS
+#ifndef CONFIG_UNWIND_EH_FRAME
 	/DISCARD/ : { *(.eh_frame) }
+#endif
 }
 
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b5e2e4c..94dc228 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -602,6 +602,18 @@
 #define TRACEDATA
 #endif
 
+#ifdef CONFIG_UNWIND_EH_FRAME
+#define EH_FRAME							\
+	VMLINUX_SYMBOL(__eh_frame_hdr_start) = .;			\
+	.eh_frame_hdr : { *(.eh_frame_hdr) }				\
+	VMLINUX_SYMBOL(__eh_frame_hdr_end) = .;				\
+	VMLINUX_SYMBOL(__eh_frame_start) = .;				\
+	.eh_frame : { *(.eh_frame) }					\
+	VMLINUX_SYMBOL(__eh_frame_end) = .;
+#else
+#define EH_FRAME
+#endif
+
 #define NOTES								\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__start_notes) = .;			\
-- 
1.7.1

