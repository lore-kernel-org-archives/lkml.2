Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1DTNuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:50:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:59347 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab1DTNud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:50:33 -0400
Date: Wed, 20 Apr 2011 15:50:31 +0200
From: Michal Marek <mmarek@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the kbuild tree
Message-ID: <20110420135030.GA1901@sepie.suse.cz>
References: <20110420082514.a9ec4d68.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420082514.a9ec4d68.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 08:25:14AM +1000, Stephen Rothwell wrote:
> Hi Michal,
> 
> After merging the kbuild tree, today's linux-next build (s390 allnoconfig)
> failed like this:
> 
> /opt/crosstool/gcc-4.3.2-nolibc/bin/s390x-linux-ar: illegal option -- D
> 
> Caused by commit 09ff9fecc039 ("kbuild: Use the deterministic mode of ar").
> 
> $ /opt/crosstool/gcc-4.3.2-nolibc/bin/s390x-linux-ar --version
> GNU ar (GNU Binutils) 2.19
> 
> I presume that this version of ar is now too old to build the kernel?
> Documentation/Changes only mentions Binutils verion 2.12.

Sorry about that, the following patch should fix it.

Michal


Subject: [PATCH] kbuild: Fix build with binutils <= 2.19

The D option of ar is only available in newer versions.

Signed-off-by: Michal Marek <mmarek@suse.cz>

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 5d145bb..40e082b 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -955,6 +955,11 @@ When kbuild executes, the following steps are followed (roughly):
 	used when linking modules. This is often a linker script.
 	From commandline LDFLAGS_MODULE shall be used (see kbuild.txt).
 
+    KBUILD_ARFLAGS   Options for $(AR) when creating archives
+
+	$(KBUILD_ARFLAGS) set by the top level Makefile to "D" (deterministic
+	mode) if this option is supported by $(AR).
+
 --- 6.2 Add prerequisites to archprepare:
 
 	The archprepare: rule is used to list prerequisites that need to be
diff --git a/Makefile b/Makefile
index c3bd316..d7c4231 100644
--- a/Makefile
+++ b/Makefile
@@ -382,6 +382,7 @@ export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE CFLAGS_GCOV
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
 export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
+export KBUILD_ARFLAGS
 
 # When compiling out-of-tree modules, put MODVERDIR in the module
 # tree rather than in the kernel tree. The kernel tree might
@@ -612,6 +613,9 @@ KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
 # conserve stack if available
 KBUILD_CFLAGS   += $(call cc-option,-fconserve-stack)
 
+# use the deterministic mode of AR if available
+KBUILD_ARFLAGS := $(call ar-option,D)
+
 # check for 'asm goto'
 ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
 	KBUILD_CFLAGS += -DCC_HAVE_ASM_GOTO
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index ed2773e..fae2d8d 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -141,6 +141,11 @@ cc-ldoption = $(call try-run,\
 ld-option = $(call try-run,\
 	$(CC) /dev/null -c -o "$$TMPO" ; $(LD) $(1) "$$TMPO" -o "$$TMP",$(1),$(2))
 
+# ar-option
+# Usage: KBUILD_ARFLAGS := $(call ar-option,D)
+# Important: no spaces around options
+ar-option = $(call try-run, $(AR) rc$(1) "$$TMP",$(1),$(2))
+
 ######
 
 ###
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 5f87d37..e1244ef 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -345,7 +345,7 @@ quiet_cmd_link_o_target = LD      $@
 cmd_link_o_target = $(if $(strip $(obj-y)),\
 		      $(LD) $(ld_flags) -r -o $@ $(filter $(obj-y), $^) \
 		      $(cmd_secanalysis),\
-		      rm -f $@; $(AR) rcsD $@)
+		      rm -f $@; $(AR) rcs$(KBUILD_ARFLAGS) $@)
 
 $(builtin-target): $(obj-y) FORCE
 	$(call if_changed,link_o_target)
@@ -371,7 +371,7 @@ $(modorder-target): $(subdir-ym) FORCE
 #
 ifdef lib-target
 quiet_cmd_link_l_target = AR      $@
-cmd_link_l_target = rm -f $@; $(AR) rcsD $@ $(lib-y)
+cmd_link_l_target = rm -f $@; $(AR) rcs$(KBUILD_ARFLAGS) $@ $(lib-y)
 
 $(lib-target): $(lib-y) FORCE
 	$(call if_changed,link_l_target)
