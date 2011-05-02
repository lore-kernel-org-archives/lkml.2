Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab1EBMNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 08:13:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab1EBMNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 08:13:20 -0400
From: Michal Marek <mmarek@suse.cz>
To: sfr@canb.auug.org.au
Cc: davej@redhat.com, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        sam@ravnborg.org
Subject: [PATCH] kbuild: Fix passing -Wno-* options to gcc 4.4+
Date: Mon,  2 May 2011 14:13:01 +0200
Message-Id: <1304338381-3772-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110502111337.GA15769@sepie.suse.cz>
References: <20110502111337.GA15769@sepie.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting with 4.4, gcc will happily accept -Wno-<anything> in the
cc-option test and complain later when compiling a file that has some
other warning. This rather unexpected behavior is intentional as per
http://gcc.gnu.org/PR28322, so work around it by testing for support of
the opposite option (without the no-). Introduce a new Makefile function
cc-disable-warning that does this and update two uses of cc-option in
the toplevel Makefile.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Documentation/kbuild/makefiles.txt |   12 ++++++++++++
 Makefile                           |    4 ++--
 scripts/Kbuild.include             |    5 +++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 835b64a..47435e5 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
@@ -501,6 +501,18 @@ more details, with real examples.
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
diff --git a/Makefile b/Makefile
index 4527dc2..f919209 100644
--- a/Makefile
+++ b/Makefile
@@ -569,7 +569,7 @@ endif
 
 # This warning generated too much noise in a regular build.
 # Use make W=1 to enable this warning (see scripts/Makefile.build)
-KBUILD_CFLAGS += $(call cc-option, -Wno-unused-but-set-variable)
+KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
 
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
@@ -616,7 +616,7 @@ CHECKFLAGS     += $(NOSTDINC_FLAGS)
 KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 
 # disable pointer signed / unsigned warnings in gcc 4.0
-KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
+KBUILD_CFLAGS += $(call cc-disable-warning, pointer-sign)
 
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index fae2d8d..c034dd7 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
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
-- 
1.7.4.1

