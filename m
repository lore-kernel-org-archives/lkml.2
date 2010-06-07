Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab0FGMf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 08:35:56 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:54016 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab0FGMfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 08:35:53 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/7] Add a target to use the Coccinelle checker
Date: Mon, 7 Jun 2010 14:35:45 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       cocci@diku.dk, Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       "Am?rico Wang" <xiyou.wangcong@gmail.com>,
       Andy Isaacson <adi@hexapodia.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, walter harms <wharms@bfs.de>,
       Joerg Roedel <joro@8bytes.org>, Jan Engelhardt <jengelh@medozas.de>
References: <1275837307-4283-1-git-send-email-npalix@diku.dk> <1275837307-4283-2-git-send-email-npalix@diku.dk> <20100606181607.GA15535@merkur.ravnborg.org>
In-Reply-To: <20100606181607.GA15535@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201006071435.46175.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3765ca033cd6ffe8a1044bc5bbcb9264de042f57 Mon Sep 17 00:00:00 2001
From: Nicolas Palix <npalix@diku.dk>
Date: Mon, 7 Jun 2010 14:28:41 +0200
Subject: [PATCH 1/7] Add a target to use the Coccinelle checker

A 'coccicheck' target is added. It can be called with four different
modes. Each one generates a different kind of output, i.e. context,
patch, org, report, according to the corresponding mode to be
activated.

The new target calls the 'coccicheck' front-end in the 'scripts'
directory with the MODE argument. Every SmPL file in the
subdirectories of 'scripts/coccinelle' is then given to the front-end
and applied to the entire source tree.

The four modes behave as follows:

'report' generates a list in the following format:
  file:line:column-column: message

'patch' proposes a fix, when possible.

'context' highlights lines of interest and their context in a
diff-like style. Lines of interest are indicated with '-'.

'org' generates a report in the Org mode format of Emacs.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---

I figure out that the support for "C=1" and "C=2" was missing
in the previous patch. This new version adds it.

Sorry, for the inconvenience.


 MAINTAINERS           |   10 ++++++
 Makefile              |   10 ++++--
 scripts/Makefile.help |    3 ++
 scripts/coccicheck    |   80 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+), 3 deletions(-)
 create mode 100644 scripts/Makefile.help
 create mode 100755 scripts/coccicheck

diff --git a/MAINTAINERS b/MAINTAINERS
index 67accd7..5b3c95e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1569,6 +1569,16 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Supported
 F:	drivers/platform/x86/classmate-laptop.c
 
+COCCINELLE/Semantic Patches (SmPL)
+M:	Julia Lawall <julia@diku.dk>
+M:	Gilles Muller <Gilles.Muller@lip6.fr>
+M:	Nicolas Palix <npalix@diku.dk>
+L:	cocci@diku.dk (moderated for non-subscribers)
+W:	http://coccinelle.lip6.fr/
+S:	Supported
+F:	scripts/coccinelle/
+F:	scripts/coccicheck
+
 CODA FILE SYSTEM
 M:	Jan Harkes <jaharkes@cs.cmu.edu>
 M:	coda@cs.cmu.edu
diff --git a/Makefile b/Makefile
index 654c31a..09d9d08 100644
--- a/Makefile
+++ b/Makefile
@@ -412,7 +412,7 @@ endif
 # of make so .config is not included in this case either (for *config).
 
 no-dot-config-targets := clean mrproper distclean \
-			 cscope TAGS tags help %docs check% \
+			 cscope TAGS tags help %docs check% coccicheck \
 			 include/linux/version.h headers_% \
 			 kernelrelease kernelversion
 
@@ -1279,8 +1279,9 @@ help:
 	@echo  '  includecheck    - Check for duplicate included header files'
 	@echo  '  export_report   - List the usages of all exported symbols'
 	@echo  '  headers_check   - Sanity check on exported headers'
-	@echo  '  headerdep       - Detect inclusion cycles in headers'; \
-	 echo  ''
+	@echo  '  headerdep       - Detect inclusion cycles in headers'
+	@$(MAKE) -f $(srctree)/scripts/Makefile.help checker-help
+	@echo  ''
 	@echo  'Kernel packaging:'
 	@$(MAKE) $(build)=$(package-dir) help
 	@echo  ''
@@ -1439,6 +1440,9 @@ versioncheck:
 		-name '*.[hcS]' -type f -print | sort \
 		| xargs $(PERL) -w $(srctree)/scripts/checkversion.pl
 
+coccicheck:
+	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/$@
+
 namespacecheck:
 	$(PERL) $(srctree)/scripts/namespace.pl
 
diff --git a/scripts/Makefile.help b/scripts/Makefile.help
new file mode 100644
index 0000000..d03608f
--- /dev/null
+++ b/scripts/Makefile.help
@@ -0,0 +1,3 @@
+
+checker-help:
+	@echo  '  coccicheck      - Check with Coccinelle.'
diff --git a/scripts/coccicheck b/scripts/coccicheck
new file mode 100755
index 0000000..0d83b6f
--- /dev/null
+++ b/scripts/coccicheck
@@ -0,0 +1,80 @@
+#!/bin/sh
+
+SPATCH="`which ${SPATCH:=spatch}`"
+
+if [ "$C" = "1" -o "$C" = "2" ]; then
+    ONLINE=1
+
+# This requires Coccinelle >= 0.2.3
+#    FLAGS="-ignore_unknown_options -very_quiet"
+#    OPTIONS=$*
+
+# Workaround for Coccinelle < 0.2.3
+    FLAGS="-I $srctree/include -very_quiet"
+    shift $(( $# - 1 ))
+    OPTIONS=$1
+else
+    ONLINE=0
+    FLAGS="-very_quiet"
+fi
+
+if [ ! -x "$SPATCH" ]; then
+    echo 'spatch is part of the Coccinelle project and is available at http://coccinelle.lip6.fr/'
+    exit 1
+fi
+
+if [ "$MODE" = "" ] ; then
+    if [ "$ONLINE" = "0" ] ; then
+	echo 'You have not explicitly specify the mode to use. Fallback to "report".'
+	echo 'You can specify the mode with "make coccicheck MODE=<mode>"'
+	echo 'Available modes are: report, patch, context, org'
+    fi
+    MODE="report"
+fi
+
+if [ "$ONLINE" = "0" ] ; then
+    echo ''
+    echo 'Please check for false positives in the output before submitting a patch.'
+    echo 'When using "patch" mode, carefully review the patch before submitting it.'
+    echo ''
+fi
+
+coccinelle () {
+    COCCI="$1"
+
+    OPT=`grep "Option" $COCCI | cut -d':' -f2`
+
+#   The option '-parse_cocci' can be used to syntaxically check the SmPL files.
+#
+#    $SPATCH -D $MODE $FLAGS -parse_cocci $COCCI $OPT > /dev/null
+
+    if [ "$ONLINE" = "0" ] ; then
+
+	FILE=`echo $COCCI | sed "s|$DIR/||"`
+
+	echo "Processing `basename $COCCI` with option(s) \"$OPT\""
+	echo 'Message example to submit a patch:'
+
+	sed -e '/\/\/\//!d' -e 's|^///||' $COCCI
+
+	echo ' The semantic patch that makes this change is available'
+	echo " in $FILE."
+	echo ''
+	echo ' More information about semantic patching is available at'
+	echo ' http://coccinelle.lip6.fr/'
+	echo ''
+
+	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT -dir $srctree || exit 1
+    else
+	$SPATCH -D $MODE $FLAGS -sp_file $COCCI $OPT $OPTIONS || exit 1
+    fi
+
+}
+
+if [ "$COCCI" = "" ] ; then
+    for f in `find $srctree/scripts/coccinelle/ -name '*.cocci' -type f | sort`; do
+	coccinelle $f
+    done
+else
+    coccinelle $COCCI
+fi
-- 
1.7.0.4

