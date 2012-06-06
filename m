Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab2FFVac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:30:32 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:15613 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2FFVa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:30:29 -0400
Date: Wed, 6 Jun 2012 23:30:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] kbuild: always show verbose section mismatch warnings
Message-ID: <20120606213026.GA17374@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7a299bd90526f46c72620110ab04a116311dd141 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 6 Jun 2012 23:23:30 +0200
Subject: [PATCH] kbuild: always show verbose section mismatch warnings

The number of section mismatch warnings are down on an acceptable level.
So lets always see the full warning - in the vain hope that
users will recognize the function names and fix them.

This patch enable section mismatch analysis for each link,
but you need to enable CONFIG_DEBUG_SECTION_MISMATCH to
have vmlinux.o analyzed.
This saves us from one time-consuming link step in the final
link of the kernel (which we hit for all changes).

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---

Steven triggered this patch with a comment on G+:
https://plus.google.com/116317370665849559569/posts/RvEpCqrWPLU

And I had in mind to do it anyway..

 lib/Kconfig.debug        |   14 ++++----------
 scripts/Makefile.build   |    4 +---
 scripts/Makefile.modpost |    1 -
 scripts/link-vmlinux.sh  |   12 ++++++------
 4 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a42d3ae..5b03f74 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -145,16 +145,10 @@ config DEBUG_SECTION_MISMATCH
 	    the analysis would not catch the illegal reference.
 	    This option tells gcc to inline less (but it does result in
 	    a larger kernel).
-	  - Run the section mismatch analysis for each module/built-in.o file.
-	    When we run the section mismatch analysis on vmlinux.o, we
-	    lose valueble information about where the mismatch was
-	    introduced.
-	    Running the analysis for each module/built-in.o file
-	    tells where the mismatch happens much closer to the
-	    source. The drawback is that the same mismatch is
-	    reported at least twice.
-	  - Enable verbose reporting from modpost in order to help resolve
-	    the section mismatches that are reported.
+	  - Run the section mismatch analysis on vmlinux.o.
+	    This will in most cases duplicate already reported warnings,
+	    but may catch section mismatchs involving diferent parts
+	    of the kernel.
 
 config DEBUG_KERNEL
 	bool "Kernel debugging"
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index ff1720d..db81790 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -159,9 +159,7 @@ ifneq ($(KBUILD_CHECKSRC),0)
 endif
 
 # Do section mismatch analysis for each module/built-in.o
-ifdef CONFIG_DEBUG_SECTION_MISMATCH
-  cmd_secanalysis = ; scripts/mod/modpost $@
-endif
+cmd_secanalysis = ; scripts/mod/modpost $@
 
 # Compile C sources (.c)
 # ---------------------------------------------------------------------------
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 08dce14..5dc9086 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -79,7 +79,6 @@ modpost = scripts/mod/modpost                    \
  $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
  $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(KBUILD_EXTRA_SYMBOLS))) \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
- $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w) \
  $(if $(cross_build),-c)
 
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index cd9c6c6..a2f89e6 100644
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -129,12 +129,12 @@ fi
 # We need access to CONFIG_ symbols
 . ./.config
 
-#link vmlinux.o
-info LD vmlinux.o
-modpost_link vmlinux.o
-
-# modpost vmlinux.o to check for section mismatches
-${MAKE} -f "${srctree}/scripts/Makefile.modpost" vmlinux.o
+# Section mismatch check on vmlinux.o
+if [ ! -n "${CONFIG_DEBUG_SECTION_MISMATCH}" ]; then
+	info LD vmlinux.o
+	modpost_link vmlinux.o
+	${MAKE} -f "${srctree}/scripts/Makefile.modpost" vmlinux.o
+fi
 
 # Update version
 info GEN .version
-- 
1.6.0.6

