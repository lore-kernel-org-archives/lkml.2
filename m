Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab2EEITz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 04:19:55 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:29980 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab2EEISu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 04:18:50 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 6/8] kbuild: move arch definitions from top-level Makefile to scripts/Kbuild.arch
Date: Sat,  5 May 2012 10:18:44 +0200
Message-Id: <1336205926-13946-6-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20120505080640.GA13773@merkur.ravnborg.org>
References: <20120505080640.GA13773@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify top-level Makefile by moving a bunch of definitions
to a separate file.
Use a consistent style in Kbuild.arch (indents are always 8 spaces).

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile            |  104 +------------------------------------------------
 scripts/Kbuild.arch |  106 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+), 101 deletions(-)
 create mode 100644 scripts/Kbuild.arch

diff --git a/Makefile b/Makefile
index aee40e2..c2864b9 100644
--- a/Makefile
+++ b/Makefile
@@ -503,107 +503,9 @@ endif
 
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
-ifneq ($(CONFIG_FRAME_WARN),0)
-KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
-endif
-
-# Force gcc to behave correct even for buggy distributions
-ifndef CONFIG_CC_STACKPROTECTOR
-KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
-endif
-
-# This warning generated too much noise in a regular build.
-# Use make W=1 to enable this warning (see scripts/Makefile.build)
-KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
-
-ifdef CONFIG_FRAME_POINTER
-KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
-else
-# Some targets (ARM with Thumb2, for example), can't be built with frame
-# pointers.  For those, we don't have FUNCTION_TRACER automatically
-# select FRAME_POINTER.  However, FUNCTION_TRACER adds -pg, and this is
-# incompatible with -fomit-frame-pointer with current GCC, so we don't use
-# -fomit-frame-pointer with FUNCTION_TRACER.
-ifndef CONFIG_FUNCTION_TRACER
-KBUILD_CFLAGS	+= -fomit-frame-pointer
-endif
-endif
-
-ifdef CONFIG_DEBUG_INFO
-KBUILD_CFLAGS	+= -g
-KBUILD_AFLAGS	+= -gdwarf-2
-endif
-
-ifdef CONFIG_DEBUG_INFO_REDUCED
-KBUILD_CFLAGS 	+= $(call cc-option, -femit-struct-debug-baseonly)
-endif
-
-ifdef CONFIG_FUNCTION_TRACER
-KBUILD_CFLAGS	+= -pg
-ifdef CONFIG_DYNAMIC_FTRACE
-	ifdef CONFIG_HAVE_C_RECORDMCOUNT
-		BUILD_C_RECORDMCOUNT := y
-		export BUILD_C_RECORDMCOUNT
-	endif
-endif
-endif
-
-# We trigger additional mismatches with less inlining
-ifdef CONFIG_DEBUG_SECTION_MISMATCH
-KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
-endif
-
-# arch Makefile may override CC so keep this after arch Makefile is included
-NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
-CHECKFLAGS     += $(NOSTDINC_FLAGS)
-
-# warn about C99 declaration after statement
-KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
-
-# disable pointer signed / unsigned warnings in gcc 4.0
-KBUILD_CFLAGS += $(call cc-disable-warning, pointer-sign)
-
-# disable invalid "can't wrap" optimizations for signed / pointers
-KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
-
-# conserve stack if available
-KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
-
-# use the deterministic mode of AR if available
-KBUILD_ARFLAGS := $(call ar-option,D)
-
-# check for 'asm goto'
-ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
-	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
-endif
-
-# Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
-# But warn user when we do so
-warn-assign = \
-$(warning "WARNING: Appending $$K$(1) ($(K$(1))) from $(origin K$(1)) to kernel $$$(1)")
-
-ifneq ($(KCPPFLAGS),)
-        $(call warn-assign,CPPFLAGS)
-        KBUILD_CPPFLAGS += $(KCPPFLAGS)
-endif
-ifneq ($(KAFLAGS),)
-        $(call warn-assign,AFLAGS)
-        KBUILD_AFLAGS += $(KAFLAGS)
-endif
-ifneq ($(KCFLAGS),)
-        $(call warn-assign,CFLAGS)
-        KBUILD_CFLAGS += $(KCFLAGS)
-endif
-
-# Use --build-id when available.
-LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
-			      $(call cc-ldoption, -Wl$(comma)--build-id,))
-KBUILD_LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
-LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
-
-ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
-LDFLAGS_vmlinux	+= $(call ld-option, -X,)
-endif
+# Definitions which require arch makefile
+$(srctree)/scripts/Kbuild.arch: ;
+include $(srctree)/scripts/Kbuild.arch
 
 # Default kernel image to build when no specific target is given.
 # KBUILD_IMAGE may be overruled on the command line or
diff --git a/scripts/Kbuild.arch b/scripts/Kbuild.arch
new file mode 100644
index 0000000..230050f
--- /dev/null
+++ b/scripts/Kbuild.arch
@@ -0,0 +1,106 @@
+#
+# CC options etc. that requires arch/$(ARCH)/Makefile to be included
+# before they can be defined
+
+ifneq ($(CONFIG_FRAME_WARN),0)
+        KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
+endif
+
+# Force gcc to behave correct even for buggy distributions
+ifndef CONFIG_CC_STACKPROTECTOR
+        KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
+endif
+
+# This warning generated too much noise in a regular build.
+# Use make W=1 to enable this warning (see scripts/Makefile.build)
+KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
+
+ifdef CONFIG_FRAME_POINTER
+        KBUILD_CFLAGS += -fno-omit-frame-pointer -fno-optimize-sibling-calls
+else
+        # Some targets (ARM with Thumb2, for example), can't be built with
+        # frame pointers.  For those, we don't have FUNCTION_TRACER
+        # automatically select FRAME_POINTER.
+        # However, FUNCTION_TRACER adds -pg, and this is incompatible with
+        # -fomit-frame-pointer with current GCC, so we don't use
+        # -fomit-frame-pointer with FUNCTION_TRACER.
+        ifndef CONFIG_FUNCTION_TRACER
+                KBUILD_CFLAGS += -fomit-frame-pointer
+        endif
+endif
+
+ifdef CONFIG_DEBUG_INFO
+        KBUILD_CFLAGS += -g
+        KBUILD_AFLAGS += -gdwarf-2
+endif
+
+ifdef CONFIG_DEBUG_INFO_REDUCED
+        KBUILD_CFLAGS += $(call cc-option, -femit-struct-debug-baseonly)
+endif
+
+ifdef CONFIG_FUNCTION_TRACER
+        KBUILD_CFLAGS += -pg
+        ifdef CONFIG_DYNAMIC_FTRACE
+                ifdef CONFIG_HAVE_C_RECORDMCOUNT
+                        export BUILD_C_RECORDMCOUNT := y
+                endif
+        endif
+endif
+
+# We trigger additional mismatches with less inlining
+ifdef CONFIG_DEBUG_SECTION_MISMATCH
+        KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
+endif
+
+# arch Makefile may override CC so keep this after arch Makefile is included
+NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
+CHECKFLAGS     += $(NOSTDINC_FLAGS)
+
+# warn about C99 declaration after statement
+KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
+
+# disable pointer signed / unsigned warnings in gcc 4.0
+KBUILD_CFLAGS += $(call cc-disable-warning, pointer-sign)
+
+# disable invalid "can't wrap" optimizations for signed / pointers
+KBUILD_CFLAGS += $(call cc-option,-fno-strict-overflow)
+
+# conserve stack if available
+KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
+
+# use the deterministic mode of AR if available
+KBUILD_ARFLAGS := $(call ar-option,D)
+
+# check for 'asm goto'
+ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
+        KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
+endif
+
+# Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
+# But warn user when we do so
+warn-assign = \
+$(warning "WARNING: Appending $$K$(1) ($(K$(1))) from $(origin K$(1)) to kernel $$$(1)")
+
+ifneq ($(KCPPFLAGS),)
+        $(call warn-assign,CPPFLAGS)
+        KBUILD_CPPFLAGS += $(KCPPFLAGS)
+endif
+ifneq ($(KAFLAGS),)
+        $(call warn-assign,AFLAGS)
+        KBUILD_AFLAGS += $(KAFLAGS)
+endif
+ifneq ($(KCFLAGS),)
+        $(call warn-assign,CFLAGS)
+        KBUILD_CFLAGS += $(KCFLAGS)
+endif
+
+# Use --build-id when available.
+LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
+         $(call cc-ldoption, -Wl$(comma)--build-id,))
+KBUILD_LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
+LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
+
+ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
+        LDFLAGS_vmlinux += $(call ld-option, -X,)
+endif
+
-- 
1.6.0.6

