Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab2HOUGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:06:49 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63087 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab2HOTwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Borislav Petkov <bp@alien8.de>, Michal Marek <mmarek@suse.cz>,
        <linux-kbuild@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 127/165] kbuild: Add extra gcc checks
Date: Wed, 15 Aug 2012 15:47:51 -0400
Message-ID: <1345060109-9187-128-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4a5838ad9d2d4f7354a310982483f4c76aa0abeb upstream.

Add a 'W=1' Makefile switch which adds additional checking per build
object.

The idea behind this option is targeted at developers who, in the
process of writing their code, want to do the occasional

make W=1 [target.o]

and let gcc do more extensive code checking for them. Then, they
could eyeball the output for valid gcc warnings about various
bugs/discrepancies which are not reported during the normal build
process.

For more background information and a use case, read through this
thread: http://marc.info/?l=kernel-janitors&m=129802065918147&w=2

Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Michal Marek <mmarek@suse.cz>
[PG: used for 2.6.34 to better control new compilers on older code]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Documentation/kbuild/kbuild.txt |  5 +++++
 Makefile                        |  5 +++++
 scripts/Makefile.build          | 35 ++++++++++++++++++++++++++++++++++-
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index 6f8c1ca..6c35f63 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -162,3 +162,8 @@ For tags/TAGS/cscope targets, you can specify more than one arch
 to be included in the databases, separated by blank space. E.g.:
 
     $ make ALLSOURCE_ARCHS="x86 mips arm" tags
+
+KBUILD_ENABLE_EXTRA_GCC_CHECKS
+--------------------------------------------------
+If enabled over the make command line with "W=1", it turns on additional
+gcc -W... options for more extensive build-time checking.
diff --git a/Makefile b/Makefile
index eb9038f..e922e609 100644
--- a/Makefile
+++ b/Makefile
@@ -102,6 +102,10 @@ ifeq ("$(origin O)", "command line")
   KBUILD_OUTPUT := $(O)
 endif
 
+ifeq ("$(origin W)", "command line")
+  export KBUILD_ENABLE_EXTRA_GCC_CHECKS := 1
+endif
+
 # That's our default target when none is given on the command line
 PHONY := _all
 _all:
@@ -1291,6 +1295,7 @@ help:
 	@echo  '  make O=dir [targets] Locate all output files in "dir", including .config'
 	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
 	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
+	@echo  '  make W=1   [targets] Enable extra gcc checks'
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 0b94d2f..bd9d518 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -49,6 +49,40 @@ ifeq ($(KBUILD_NOPEDANTIC),)
                 $(error CFLAGS was changed in "$(kbuild-file)". Fix it to use EXTRA_CFLAGS)
         endif
 endif
+
+#
+# make W=1 settings
+#
+# $(call cc-option... ) handles gcc -W.. options which
+# are not supported by all versions of the compiler
+ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
+KBUILD_EXTRA_WARNINGS := -Wextra
+KBUILD_EXTRA_WARNINGS += -Wunused -Wno-unused-parameter
+KBUILD_EXTRA_WARNINGS += -Waggregate-return
+KBUILD_EXTRA_WARNINGS += -Wbad-function-cast
+KBUILD_EXTRA_WARNINGS += -Wcast-qual
+KBUILD_EXTRA_WARNINGS += -Wcast-align
+KBUILD_EXTRA_WARNINGS += -Wconversion
+KBUILD_EXTRA_WARNINGS += -Wdisabled-optimization
+KBUILD_EXTRA_WARNINGS += -Wlogical-op
+KBUILD_EXTRA_WARNINGS += -Wmissing-declarations
+KBUILD_EXTRA_WARNINGS += -Wmissing-format-attribute
+KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wmissing-include-dirs,)
+KBUILD_EXTRA_WARNINGS += -Wmissing-prototypes
+KBUILD_EXTRA_WARNINGS += -Wnested-externs
+KBUILD_EXTRA_WARNINGS += -Wold-style-definition
+KBUILD_EXTRA_WARNINGS += $(call cc-option, -Woverlength-strings,)
+KBUILD_EXTRA_WARNINGS += -Wpacked
+KBUILD_EXTRA_WARNINGS += -Wpacked-bitfield-compat
+KBUILD_EXTRA_WARNINGS += -Wpadded
+KBUILD_EXTRA_WARNINGS += -Wpointer-arith
+KBUILD_EXTRA_WARNINGS += -Wredundant-decls
+KBUILD_EXTRA_WARNINGS += -Wshadow
+KBUILD_EXTRA_WARNINGS += -Wswitch-default
+KBUILD_EXTRA_WARNINGS += $(call cc-option, -Wvla,)
+KBUILD_CFLAGS += $(KBUILD_EXTRA_WARNINGS)
+endif
+
 include scripts/Makefile.lib
 
 ifdef host-progs
@@ -384,7 +418,6 @@ ifneq ($(cmd_files),)
   include $(cmd_files)
 endif
 
-
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable se we can use it in if_changed and friends.
 
-- 
1.7.12.rc2

