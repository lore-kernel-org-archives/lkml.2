Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab2HOUHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:07:53 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63084 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab2HOTwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Michal Marek <mmarek@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 135/165] kbuild: Fix passing -Wno-* options to gcc 4.4+
Date: Wed, 15 Aug 2012 15:47:59 -0400
Message-ID: <1345060109-9187-136-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Marek <mmarek@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 8417da6f2128008c431c7d130af6cd3d9079922e upstream.

Starting with 4.4, gcc will happily accept -Wno-<anything> in the
cc-option test and complain later when compiling a file that has some
other warning. This rather unexpected behavior is intentional as per
http://gcc.gnu.org/PR28322, so work around it by testing for support of
the opposite option (without the no-). Introduce a new Makefile function
cc-disable-warning that does this and update two uses of cc-option in
the toplevel Makefile.

Reported-and-tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Documentation/kbuild/makefiles.txt | 12 ++++++++++++
 Makefile                           |  4 ++--
 scripts/Kbuild.include             |  5 +++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
index 71c602d..ab8689b 100644
--- a/Documentation/kbuild/makefiles.txt
+++ b/Documentation/kbuild/makefiles.txt
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
diff --git a/Makefile b/Makefile
index e9fafd0..92da473 100644
--- a/Makefile
+++ b/Makefile
@@ -549,7 +549,7 @@ endif
 
 # This warning generated too much noise in a regular build.
 # Use make W=1 to enable this warning (see scripts/Makefile.build)
-KBUILD_CFLAGS += $(call cc-option, -Wno-unused-but-set-variable)
+KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
 
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
@@ -579,7 +579,7 @@ CHECKFLAGS     += $(NOSTDINC_FLAGS)
 KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 
 # disable pointer signed / unsigned warnings in gcc 4.0
-KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
+KBUILD_CFLAGS += $(call cc-disable-warning, pointer-sign)
 
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index ed2773e..ba25c44 100644
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
1.7.12.rc2

