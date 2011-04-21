Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab1DUVjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:39:06 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:47777 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab1DUVjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:39:05 -0400
X-Greylist: delayed 1811 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Apr 2011 17:39:04 EDT
Date: Thu, 21 Apr 2011 23:39:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [RFC PATCH] kbuild: implement several W= levels
Message-ID: <20110421213903.GB9660@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building a kernel with "make W=1" produce far too much noise
to be usefull.

Divide the warning options in three groups:

W=1 - usefull warning options
W=2 - noisy but semi usefull warnign options
W=3 - almost pure noise options

I do not feel strongly about the distinction between
group 2 and 3. But we should consider what we add in group 1.


Sample run on my box (x86, 32bit allyesconfig build)
  CC      kernel/bounds.s
kernel/bounds.c:14: warning: no previous prototype for ‘foo’
  GEN     include/generated/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
In file included from include/linux/sched.h:73,
                 from arch/x86/kernel/asm-offsets.c:9:
include/linux/signal.h: In function ‘sigorsets’:
include/linux/signal.h:121: warning: nested extern declaration of ‘_NSIG_WORDS_is_unsupported_size’
include/linux/signal.h: In function ‘sigandsets’:
include/linux/signal.h:124: warning: nested extern declaration of ‘_NSIG_WORDS_is_unsupported_size’
include/linux/signal.h: In function ‘signandsets’:
include/linux/signal.h:127: warning: nested extern declaration of ‘_NSIG_WORDS_is_unsupported_size’
include/linux/signal.h: In function ‘signotset’:
include/linux/signal.h:151: warning: nested extern declaration of ‘_NSIG_WORDS_is_unsupported_size’
arch/x86/kernel/asm-offsets.c: At top level:
arch/x86/kernel/asm-offsets.c:30: warning: no previous prototype for ‘common’

the patch is only an RFC - and is not made on top
of an upstream kernel with no additiona stuff applied.

	Sam

diff --git a/Makefile b/Makefile
index b967b96..f0e138b 100644
--- a/Makefile
+++ b/Makefile
@@ -103,7 +103,7 @@ ifeq ("$(origin O)", "command line")
 endif
 
 ifeq ("$(origin W)", "command line")
-  export KBUILD_ENABLE_EXTRA_GCC_CHECKS := 1
+  export KBUILD_ENABLE_EXTRA_GCC_CHECKS := $(W)
 endif
 
 # That's our default target when none is given on the command line
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5f925a..b65f820 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -56,31 +56,43 @@ endif
 # $(call cc-option... ) handles gcc -W.. options which
 # are not supported by all versions of the compiler
 ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
-KBUILD_EXTRA_WARNINGS := -Wextra
-KBUILD_EXTRA_WARNINGS += -Wunused -Wno-unused-parameter
-KBUILD_EXTRA_WARNINGS += -Waggregate-return
-KBUILD_EXTRA_WARNINGS += -Wbad-function-cast
-KBUILD_EXTRA_WARNINGS += -Wcast-qual
-KBUILD_EXTRA_WARNINGS += -Wcast-align
-KBUILD_EXTRA_WARNINGS += -Wconversion
-KBUILD_EXTRA_WARNINGS += -Wdisabled-optimization
-KBUILD_EXTRA_WARNINGS += -Wlogical-op
-KBUILD_EXTRA_WARNINGS += -Wmissing-declarations
-KBUILD_EXTRA_WARNINGS += -Wmissing-format-attribute
-KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wmissing-include-dirs,)
-KBUILD_EXTRA_WARNINGS += -Wmissing-prototypes
-KBUILD_EXTRA_WARNINGS += -Wnested-externs
-KBUILD_EXTRA_WARNINGS += -Wold-style-definition
-KBUILD_EXTRA_WARNINGS += $(call cc-option, -Woverlength-strings,)
-KBUILD_EXTRA_WARNINGS += -Wpacked
-KBUILD_EXTRA_WARNINGS += -Wpacked-bitfield-compat
-KBUILD_EXTRA_WARNINGS += -Wpadded
-KBUILD_EXTRA_WARNINGS += -Wpointer-arith
-KBUILD_EXTRA_WARNINGS += -Wredundant-decls
-KBUILD_EXTRA_WARNINGS += -Wshadow
-KBUILD_EXTRA_WARNINGS += -Wswitch-default
-KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wvla,)
-KBUILD_CFLAGS += $(KBUILD_EXTRA_WARNINGS)
+warning-1 := -Wextra
+warning-1 += -Wunused -Wno-unused-parameter
+warning-2 += -Waggregate-return
+warning-2 += -Wbad-function-cast
+warning-2 += -Wcast-qual
+warning-2 += -Wcast-align
+warning-3 += -Wconversion
+warning-2 += -Wdisabled-optimization
+warning-2 += -Wlogical-op
+warning-1 += -Wmissing-declarations
+warning-1 += -Wmissing-format-attribute
+warning-1 += $(call cc-option, -Wmissing-include-dirs,)
+warning-1 += -Wmissing-prototypes
+warning-1 += -Wnested-externs
+warning-2 += -Wold-style-definition
+warning-2 += $(call cc-option, -Woverlength-strings,)
+warning-3 += -Wpacked
+warning-3 += -Wpacked-bitfield-compat
+warning-3 += -Wpadded
+warning-3 += -Wpointer-arith
+warning-2 += -Wredundant-decls
+warning-2 += -Wshadow
+warning-3 += -Wswitch-default
+warning-3 += $(call cc-option, -Wvla,)
+ifeq ($(KBUILD_ENABLE_EXTRA_GCC_CHECKS),1)
+        KBUILD_CFLAGS += $(warning-1)
+else
+        ifeq ($(KBUILD_ENABLE_EXTRA_GCC_CHECKS),2)
+                KBUILD_CFLAGS += $(warning-1) $(warning-2)
+        else
+                ifeq ($(KBUILD_ENABLE_EXTRA_GCC_CHECKS),3)
+                        KBUILD_CFLAGS += $(warning-1) $(warning-2) $(warning-3)
+                else
+                        $(error W=$(KBUILD_ENABLE_EXTRA_GCC_CHECKS) is unknown)
+                endif
+        endif
+endif
 endif
 
 include scripts/Makefile.lib
