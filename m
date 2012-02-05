Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab2BEWaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:30:13 -0500
Received: from 1wt.eu ([62.212.114.60]:62183 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab2BEWaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:30:07 -0500
Message-Id: <20120205220953.217942472@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:17 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 88/91] kbuild: Fix passing -Wno-* options to gcc 4.4+
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/kbuild/makefiles.txt |   12 ++++++++++++
 Makefile                           |    4 ++--
 scripts/Kbuild.include             |    5 +++++
 3 files changed, 19 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/Documentation/kbuild/makefiles.txt
===================================================================
--- longterm-2.6.27.orig/Documentation/kbuild/makefiles.txt	2012-02-05 22:34:32.253915069 +0100
+++ longterm-2.6.27/Documentation/kbuild/makefiles.txt	2012-02-05 22:34:47.409917106 +0100
@@ -471,6 +471,18 @@
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
Index: longterm-2.6.27/Makefile
===================================================================
--- longterm-2.6.27.orig/Makefile	2012-02-05 22:34:47.271916824 +0100
+++ longterm-2.6.27/Makefile	2012-02-05 22:34:47.412915249 +0100
@@ -531,7 +531,7 @@
 KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
 
 # This warning generated too much noise in a regular build.
-KBUILD_CFLAGS += $(call cc-option, -Wno-unused-but-set-variable)
+KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
 
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
@@ -561,7 +561,7 @@
 KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 
 # disable pointer signed / unsigned warnings in gcc 4.0
-KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
+KBUILD_CFLAGS += $(call cc-disable-warning, pointer-sign)
 
 # disable invalid "can't wrap" optimzations for signed / pointers
 KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
Index: longterm-2.6.27/scripts/Kbuild.include
===================================================================
--- longterm-2.6.27.orig/scripts/Kbuild.include	2012-02-05 22:34:32.256915061 +0100
+++ longterm-2.6.27/scripts/Kbuild.include	2012-02-05 22:34:47.418914568 +0100
@@ -117,6 +117,11 @@
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


