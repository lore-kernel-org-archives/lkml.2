Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab1KWBDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:03:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154Ab1KWAdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:33:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:08 2011
Message-Id: <20111123002208.684095615@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:21:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Marek <mmarek@suse.cz>
Subject: [18/25] kbuild: Fix passing -Wno-* options to gcc 4.4+
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 3254
Lines: 78

From: Michal Marek <mmarek@suse.cz>

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
--- a/Makefile
+++ b/Makefile
@@ -538,7 +538,7 @@ KBUILD_CFLAGS += $(call cc-option, -fno-
 endif
 
 # This warning generated too much noise in a regular build.
-KBUILD_CFLAGS += $(call cc-option, -Wno-unused-but-set-variable)
+KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)
 
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
@@ -568,7 +568,7 @@ CHECKFLAGS     += $(NOSTDINC_FLAGS)
 KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 
 # disable pointer signed / unsigned warnings in gcc 4.0
-KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
+KBUILD_CFLAGS += $(call cc-disable-warning, pointer-sign)
 
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
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


