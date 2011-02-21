Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab1BUCX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 21:23:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50090 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab1BUCXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 21:23:23 -0500
Date: Mon, 21 Feb 2011 03:23:16 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, torvalds@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, linux-kbuild@vger.kernel.org
Subject: [PATCH -v3] kbuild: Add extra gcc checks
Message-ID: <20110221022316.GA18332@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
	torvalds@linux-foundation.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	linux-kbuild@vger.kernel.org
References: <1298219710-9846-1-git-send-email-bp@alien8.de>
 <20110220175709.GA5178@merkur.ravnborg.org>
 <20110220193906.GC6713@liondog.tnic>
 <20110220195222.GA12915@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110220195222.GA12915@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 08:52:22PM +0100, Sam Ravnborg wrote:

..

> Use of EXTRA_CFLAGS is deprecated - so that is not the right choice.
> I suggest to use KBUILD_CFLAGS that is an KBUILD internal variable.

Hey Sam,

thanks for the suggestions/review, here's hopefully a better version:

--
From: Borislav Petkov <bp@alien8.de>
Date: Sun, 20 Feb 2011 17:18:40 +0100
Subject: [PATCH -v3] kbuild: Add extra gcc checks

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
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 Makefile               |    6 ++++++
 scripts/Makefile.build |   29 ++++++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index c9c8c8f..c3bca9c 100644
--- a/Makefile
+++ b/Makefile
@@ -102,6 +102,11 @@ ifeq ("$(origin O)", "command line")
   KBUILD_OUTPUT := $(O)
 endif
 
+ifeq ("$(origin W)", "command line")
+  KBUILD_ENABLE_EXTRA_GCC_CHECKS = 1
+  export KBUILD_ENABLE_EXTRA_GCC_CHECKS
+endif
+
 # That's our default target when none is given on the command line
 PHONY := _all
 _all:
@@ -1262,6 +1267,7 @@ help:
 	@echo  '  make O=dir [targets] Locate all output files in "dir", including .config'
 	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
 	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
+	@echo  '  make W=1   [targets] Enable extra gcc checks'
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 4eb99ab..b4d7661 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -49,6 +49,34 @@ ifeq ($(KBUILD_NOPEDANTIC),)
                 $(error CFLAGS was changed in "$(kbuild-file)". Fix it to use EXTRA_CFLAGS)
         endif
 endif
+
+# make W=1 settings
+ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
+KBUILD_CFLAGS += -Wextra -Wno-unused
+KBUILD_CFLAGS += -Waggregate-return
+KBUILD_CFLAGS += -Wbad-function-cast
+KBUILD_CFLAGS += -Wcast-qual
+KBUILD_CFLAGS += -Wcast-align
+KBUILD_CFLAGS += -Wconversion
+KBUILD_CFLAGS += -Wdisabled-optimization
+KBUILD_CFLAGS += -Wlogical-op
+KBUILD_CFLAGS += -Wmissing-declarations
+KBUILD_CFLAGS += -Wmissing-format-attribute
+KBUILD_CFLAGS += -Wmissing-include-dirs
+KBUILD_CFLAGS += -Wmissing-prototypes
+KBUILD_CFLAGS += -Wnested-externs
+KBUILD_CFLAGS += -Wold-style-definition
+KBUILD_CFLAGS += -Woverlength-strings
+KBUILD_CFLAGS += -Wpacked
+KBUILD_CFLAGS += -Wpacked-bitfield-compat
+KBUILD_CFLAGS += -Wpadded
+KBUILD_CFLAGS += -Wpointer-arith
+KBUILD_CFLAGS += -Wredundant-decls
+KBUILD_CFLAGS += -Wshadow
+KBUILD_CFLAGS += -Wswitch-default
+KBUILD_CFLAGS += -Wvla
+endif
+
 include scripts/Makefile.lib
 
 ifdef host-progs
@@ -403,7 +431,6 @@ ifneq ($(cmd_files),)
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
