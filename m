Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab1CAIfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:35:34 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35667 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab1CAIfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:35:32 -0500
Date: Tue, 1 Mar 2011 09:35:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
        torvalds@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-kbuild@vger.kernel.org, bp@amd64.org
Subject: [PATCH -v5] kbuild: Add extra gcc checks
Message-ID: <20110301083529.GA767@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Michal Marek <mmarek@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
	Sam Ravnborg <sam@ravnborg.org>, torvalds@linux-foundation.org,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, linux-kbuild@vger.kernel.org,
	bp@amd64.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

-v5: Document internal kbuild variable which is introduced by this.
Simplify assignment.

-v4: Enable this for gcc only. Also, check for options which are not
supported by every gcc version we use to build the kernel. Adding those
checks for _every_ option slows down the build noticeably so be sensible
here and add it only when your gcc version chokes on a particular
option.

-v[2..3]: move to Makefile.build

Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 Documentation/kbuild/kbuild.txt |    5 +++++
 Makefile                        |    5 +++++
 scripts/Makefile.build          |   35 ++++++++++++++++++++++++++++++++++-
 3 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/Documentation/kbuild/kbuild.txt b/Documentation/kbuild/kbuild.txt
index 4a99031..376538c 100644
--- a/Documentation/kbuild/kbuild.txt
+++ b/Documentation/kbuild/kbuild.txt
@@ -196,3 +196,8 @@ to be included in the databases, separated by blank space. E.g.:
 To get all available archs you can also specify all. E.g.:
 
     $ make ALLSOURCE_ARCHS=all tags
+
+KBUILD_ENABLE_EXTRA_GCC_CHECKS
+--------------------------------------------------
+If enabled over the make command line with "W=1", it turns on additional
+gcc -W... options for more extensive build-time checking.
diff --git a/Makefile b/Makefile
index c9c8c8f..8c4614f 100644
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
@@ -1262,6 +1266,7 @@ help:
 	@echo  '  make O=dir [targets] Locate all output files in "dir", including .config'
 	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
 	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
+	@echo  '  make W=1   [targets] Enable extra gcc checks'
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 4eb99ab..d5f925a 100644
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
@@ -403,7 +437,6 @@ ifneq ($(cmd_files),)
   include $(cmd_files)
 endif
 
-
 # Declare the contents of the .PHONY variable as phony.  We keep that
 # information in a variable se we can use it in if_changed and friends.
 
-- 
1.7.4.1.48.g5673d


-- 
Regards/Gruss,
    Boris.
