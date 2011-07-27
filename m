Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab1G0Amp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:42:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:52724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab1G0Aey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:34:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="30470969"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: mmarek@suse.cz, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] [2/98] kbuild: Fix passing -Wno-* options to gcc 4.4+
Message-Id: <20110727003454.062AE2403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:34:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Michal Marek <mmarek@suse.cz>

[ upstream commit 8417da6f2128008c431c7d130af6cd3d9079922e ]

Starting with 4.4, gcc will happily accept -Wno-<anything> in the
cc-option test and complain later when compiling a file that has some
other warning. This rather unexpected behavior is intentional as per
http://gcc.gnu.org/PR28322, so work around it by testing for support of
the opposite option (without the no-). Introduce a new Makefile function
cc-disable-warning that does this and update two uses of cc-option in
the toplevel Makefile.

Reported-and-tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/Documentation/kbuild/makefiles.txt
===================================================================
--- linux-2.6.35.y.orig/Documentation/kbuild/makefiles.txt
+++ linux-2.6.35.y/Documentation/kbuild/makefiles.txt
@@ -502,6 +502,18 @@ more details, with real examples.
 	gcc >= 3.00. For gcc < 3.00, -malign-functions=4 is used.
 	Note: cc-option-align uses KBUILD_CFLAGS for $(CC) options
 
+    cc-disable-warning
+	cc-disable-warning checks if gcc supports a given warning and returns
+	the commandline switch to disable it. This special function is needed,
+	because gcc 4.4 and later accept any unknown -Wno-* option and only
+	warn about it if there is another warning in the source file.
+
+	Example:
+		KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
+
+	In the above example, -Wno-unused-but-set-variable will be added to
+	KBUILD_CFLAGS only if gcc really accepts it.
+
     cc-version
 	cc-version returns a numerical version of the $(CC) compiler version.
 	The format is <major><minor> where both are two digits. So for example
Index: linux-2.6.35.y/Makefile
===================================================================
--- linux-2.6.35.y.orig/Makefile
+++ linux-2.6.35.y/Makefile
@@ -547,7 +547,7 @@ KBUILD_CFLAGS += $(call cc-option, -fno-
 endif
 
 # This warning generated too much noise in a regular build.
-KBUILD_CFLAGS += $(call cc-option, -Wno-unused-but-set-variable)
+KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
 
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
@@ -577,7 +577,7 @@ CHECKFLAGS     += $(NOSTDINC_FLAGS)
 KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 
 # disable pointer signed / unsigned warnings in gcc 4.0
-KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
+KBUILD_CFLAGS += $(call cc-disable-warning, pointer-sign)
 
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
Index: linux-2.6.35.y/scripts/Kbuild.include
===================================================================
--- linux-2.6.35.y.orig/scripts/Kbuild.include
+++ linux-2.6.35.y/scripts/Kbuild.include
@@ -118,6 +118,11 @@ cc-option-yn = $(call try-run,\
 cc-option-align = $(subst -functions=0,,\
 	$(call cc-option,-falign-functions=0,-malign-functions=0))
 
+# cc-disable-warning
+# Usage: cflags-y += $(call cc-disable-warning,unused-but-set-variable)
+cc-disable-warning = $(call try-run,\
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -W$(strip $(1)) -c -xc /dev/null -o "$$TMP",-Wno-$(strip $(1)))
+
 # cc-version
 # Usage gcc-ver := $(call cc-version)
 cc-version = $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-version.sh $(CC))
