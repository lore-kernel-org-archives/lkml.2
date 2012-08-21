Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab2HUPLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:11:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49690 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab2HUPLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:11:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 1/4] ARM: autogenerate mach-foo/* and plat-foo/* header redirects
Date: Tue, 21 Aug 2012 17:11:17 +0200
Message-Id: <1345561880-13231-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1345561880-13231-1-git-send-email-arnd@arndb.de>
References: <1345561880-13231-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:aZpJp1OZ8m60xgXX/z02iYB9qjekIiO0vcaD+zY3Quu
 DTVLC8Wef+0myqMQLOTu5ubn1w3hDLahboyNMfBcOIhdu9cWQV
 Ashg/x/pxmL3snaeRcUJl081PtOWQBTVyLaLukkDLLK+HuzOTZ
 YuWcXwgxBqqAiF8fPdaswQe5DPsU3ZsJSomwFYRHt7lplP7+CE
 5tg9pr/BOMdHFFKc8oVP1pxOhq2naLc+HkKTrKJLiOsL65mtHF
 ceRZZ1YCapvViIZZcGh0EaaG7l0A6p71fl/lQ0m2TPaB1M2qb3
 /ohmtndkkyUAwdys2N57GXTUuuzegeOBJV6gvLVOkDI77pAwNo
 xXmxCOdUm9iM0ctBSdfV0zHgy1ILtaO7KLtkrPU1bjvhNBv2Ai
 3xhKZS4yOQhHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an attempt to simplify the duplicate header problem for
multiplatform kernels, in multiple steps:

1. (this patch)
   for each arch/arm/mach-${MACHINE}/include/mach-${MACHINE}/*.h file,
   generate a arch/arm/include/generated/mach/*.h file at build time,
   same for plat-*.

2. rename all arch/arm/mach-${MACHINE}/include/mach/*.h to
   arch/arm/mach-${MACHINE}/include/mach-${MACHINE}/*.h and
   arch/arm/plat-${PLAT}/include/plat/*.h to
   arch/arm/plat-${PLAT}/include/plat-${PLAT}/*.h

3. change all includes of <mach/*.h> to <mach-${MACHINE}/*.h>
   in all files where ${MACHINE} is known.

4. ...

5. Revert this patch again.

We can apply this patch at any time, and do step 2 at the end
of the next merge window to minimize the potential for conflicts.
We will also still need to deal with any inclusion of a mach/*
file, but out of the 6355 ones we have today, I expect only a
few hundred to remain after step 3 and they will be much easier
to spot.

I've picked the format <mach-foo/bar.h> to get a unique name because
it matches the directory name under arch/arm, but other names
would work with the same script, <mach/foo-bar.h> and <foo/bar.h>
have been suggested previously.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Makefile          |    1 +
 arch/arm/tools/Makefile    |    5 ++++
 arch/arm/tools/gen-headers |   57 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)
 create mode 100755 arch/arm/tools/gen-headers

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 30eae87..761b077 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -274,6 +274,7 @@ boot := arch/arm/boot
 
 archprepare:
 	$(Q)$(MAKE) $(build)=arch/arm/tools include/generated/mach-types.h
+	$(Q)$(MAKE) $(build)=arch/arm/tools plat="$(plat-y)" machine="$(machine-y)" gen_headers
 
 # Convert bzImage to zImage
 bzImage: zImage
diff --git a/arch/arm/tools/Makefile b/arch/arm/tools/Makefile
index 635cb18..6e18ca9 100644
--- a/arch/arm/tools/Makefile
+++ b/arch/arm/tools/Makefile
@@ -8,3 +8,8 @@ include/generated/mach-types.h: $(src)/gen-mach-types $(src)/mach-types
 	@echo '  Generating $@'
 	@mkdir -p $(dir $@)
 	$(Q)$(AWK) -f $^ > $@ || { rm -f $@; /bin/false; }
+
+gen_headers:
+	$(Q)bash $(srctree)/$(src)/gen-headers $(srctree) $(objtree) $(machine) $(plat)
+
+.PHONY: gen_headers
diff --git a/arch/arm/tools/gen-headers b/arch/arm/tools/gen-headers
new file mode 100755
index 0000000..caa6a9a
--- /dev/null
+++ b/arch/arm/tools/gen-headers
@@ -0,0 +1,57 @@
+#!/bin/bash
+
+SRC=$1
+OBJ=$2
+MACH=$3
+PLAT1=$4
+PLAT2=$5
+
+# create $3 to include $2 if it doesn't already have the correct
+# contents, or remove it if it's no longer needed.
+mkfile()
+{
+	if [ -e $1/$2 ] ; then
+		if [ ! -e $3 ] ; then
+			mkdir -p ${3%/*}
+			echo "#include <${2}>" > $3
+		elif [ "`cat $3`" != "#include <${2#./}>" ] ; then
+			echo "#include <${2}>" > $3
+		fi
+	elif [ ! -e $1/$2 -a -e $3 ] ; then
+		rm -f $3
+	fi
+}
+
+# list any header files that are present in the source or
+# destination directories
+find_files()
+{
+	pushd ${SRC}/arch/arm/$1-$2/include/$1-$2 >/dev/null 2>&1 &&
+	find . -type f -name \*.h -o -name \*.S &&
+	popd > /dev/null 2>&1
+	pushd ${OBJ}/arch/arm/include/generated/$1 >/dev/null 2>&1 &&
+	find . -type f -name \*.h -o -name \*.S &&
+	popd > /dev/null 2>&1
+}
+
+# process files in either mach-{MACH} or plat-${PLAT}
+mkfiles()
+{
+	mkdir -p ${OBJ}/arch/arm/include/generated/$1
+
+	FILES=`find_files $1 $2 | sort -u`
+	for i in ${FILES} ; do
+		mkfile "${SRC}/arch/arm/$1-$2/include/" "$1-$2/${i#./}" \
+			"${OBJ}/arch/arm/include/generated/$1/$i"
+	done
+}
+
+# always process mach-*
+mkfiles mach ${MACH}
+# process plat-* if applicable
+if [ -d ${SRC}/arch/arm/plat-${PLAT1} ]; then
+	mkfiles plat ${PLAT1}
+fi
+if [ -d ${SRC}/arch/arm/plat-${PLAT2} ]; then
+	mkfiles plat ${PLAT2}
+fi
-- 
1.7.10

