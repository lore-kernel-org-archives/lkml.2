Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab1BTTjM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 14:39:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37660 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab1BTTjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 14:39:10 -0500
Date: Sun, 20 Feb 2011 20:39:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, torvalds@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: Add extra gcc checks
Message-ID: <20110220193906.GC6713@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
	torvalds@linux-foundation.org, x86@kernel.org,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	linux-kbuild@vger.kernel.org
References: <1298219710-9846-1-git-send-email-bp@alien8.de>
 <20110220175709.GA5178@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110220175709.GA5178@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 06:57:09PM +0100, Sam Ravnborg wrote:
> I like the idea.
> But can we avoid polluting the top-level Makefile?
> That file is full of unreadable stuff, and adding more
> is not good.
> 
> Makefile.lib or Makefile.build seems like a better place for this.

You're right, ./Makefile shouldn't get any fatter than it is right now :).

Here's a second version; Ingo, I've left your ack in even though it was
referencing the initial version since the idea is kept the same - only
the code placement is different.

Thanks.

--
From: Borislav Petkov <bp@alien8.de>
Date: Sun, 20 Feb 2011 17:18:40 +0100
Subject: [PATCH] kbuild: Add extra gcc checks

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
 Makefile               |   10 ++++++++++
 scripts/Makefile.build |   28 +++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index c9c8c8f..03989a1 100644
--- a/Makefile
+++ b/Makefile
@@ -102,6 +102,15 @@ ifeq ("$(origin O)", "command line")
   KBUILD_OUTPUT := $(O)
 endif
 
+ifeq ("$(origin W)", "command line")
+  KBUILD_ENABLE_EXTRA_GCC_CHECKS = 1
+endif
+ifndef KBUILD_ENABLE_EXTRA_GCC_CHECKS
+  KBUILD_ENABLE_EXTRA_GCC_CHECKS = 0
+endif
+
+export KBUILD_ENABLE_EXTRA_GCC_CHECKS
+
 # That's our default target when none is given on the command line
 PHONY := _all
 _all:
@@ -1262,6 +1271,7 @@ help:
 	@echo  '  make O=dir [targets] Locate all output files in "dir", including .config'
 	@echo  '  make C=1   [targets] Check all c source with $$CHECK (sparse by default)'
 	@echo  '  make C=2   [targets] Force check of all c source with $$CHECK'
+	@echo  '  make W=1   [targets] Enable extra gcc checks'
 	@echo  ''
 	@echo  'Execute "make" or "make all" to build all targets marked with [*] '
 	@echo  'For further info see the ./README file'
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 4eb99ab..5bf9f40 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -30,6 +30,33 @@ ldflags-y  :=
 subdir-asflags-y :=
 subdir-ccflags-y :=
 
+# make W=1 settings
+ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
+EXTRA_CFLAGS += -Wextra -Wno-unused
+EXTRA_CFLAGS += -Waggregate-return
+EXTRA_CFLAGS += -Wbad-function-cast
+EXTRA_CFLAGS += -Wcast-qual
+EXTRA_CFLAGS += -Wcast-align
+EXTRA_CFLAGS += -Wconversion
+EXTRA_CFLAGS += -Wdisabled-optimization
+EXTRA_CFLAGS += -Wlogical-op
+EXTRA_CFLAGS += -Wmissing-declarations
+EXTRA_CFLAGS += -Wmissing-format-attribute
+EXTRA_CFLAGS += -Wmissing-include-dirs
+EXTRA_CFLAGS += -Wmissing-prototypes
+EXTRA_CFLAGS += -Wnested-externs
+EXTRA_CFLAGS += -Wold-style-definition
+EXTRA_CFLAGS += -Woverlength-strings
+EXTRA_CFLAGS += -Wpacked
+EXTRA_CFLAGS += -Wpacked-bitfield-compat
+EXTRA_CFLAGS += -Wpadded
+EXTRA_CFLAGS += -Wpointer-arith
+EXTRA_CFLAGS += -Wredundant-decls
+EXTRA_CFLAGS += -Wshadow
+EXTRA_CFLAGS += -Wswitch-default
+EXTRA_CFLAGS += -Wvla
+endif
+
 # Read auto.conf if it exists, otherwise ignore
 -include include/config/auto.conf
 
@@ -403,7 +430,6 @@ ifneq ($(cmd_files),)
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
