Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab0FFPPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 11:15:42 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51333 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942Ab0FFPPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 11:15:24 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       =?UTF-8?q?Am=C3=A9rico=20Wang?= <xiyou.wangcong@gmail.com>,
       Andy Isaacson <adi@hexapodia.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, walter harms <wharms@bfs.de>,
       Joerg Roedel <joro@8bytes.org>, Jan Engelhardt <jengelh@medozas.de>
Cc: Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 1/7] Add a target to use the Coccinelle checker
Date: Sun,  6 Jun 2010 17:15:01 +0200
Message-Id: <1275837307-4283-2-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275837307-4283-1-git-send-email-npalix@diku.dk>
References: <1275837307-4283-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 MAINTAINERS           |   10 +++++++++
 Makefile              |   10 ++++++--
 scripts/Makefile.help |    3 ++
 scripts/coccicheck    |   54 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+), 3 deletions(-)
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
index 0000000..037424b
--- /dev/null
+++ b/scripts/coccicheck
@@ -0,0 +1,54 @@
+#!/bin/sh
+
+SPATCH="`which ${SPATCH:=spatch}`"
+
+if [ ! -x "$SPATCH" ]; then
+    echo 'spatch is part of the Coccinelle project and is available at http://coccinelle.lip6.fr/'
+    exit 1
+fi
+
+if [ "$MODE" = "" ] ; then
+    echo 'You have not explicitly specify the mode to use. Fallback to "report".'
+    echo 'You can specify the mode with "make coccicheck MODE=<mode>"'
+    echo 'Available modes are: report, patch, context, org'
+    MODE="report"
+fi
+
+echo ''
+echo 'Please check for false positives in the output before submitting a patch.'
+echo 'When using "patch" mode, carefully review the patch before submitting it.'
+echo ''
+
+function coccinelle {
+    COCCI="$1"
+    DIR="$2"
+
+    OPT=`grep "Option" $COCCI | cut -d':' -f2`
+    FILE=`echo $COCCI | sed "s|$DIR/||"`
+
+    echo "Processing `basename $COCCI` with option(s) \"$OPT\""
+    echo 'Message example to submit a patch:'
+
+    sed -e '/\/\/\//!d' -e 's|^///||' $COCCI
+
+    echo ' The semantic patch that makes this change is available'
+    echo " in $FILE."
+    echo ''
+    echo ' More information about semantic patching is available at'
+    echo ' http://coccinelle.lip6.fr/'
+    echo ''
+
+#   The option '-parse_cocci' can be used to syntaxically check the SmPL files.
+#
+#    $SPATCH -D $MODE -very_quiet -parse_cocci $COCCI $OPT > /dev/null
+
+    $SPATCH -D $MODE -very_quiet -sp_file $COCCI $OPT -dir $DIR
+}
+
+if [ "$COCCI" = "" ] ; then
+    for f in `find $srctree/scripts/coccinelle/ -name '*.cocci' -type f | sort`; do
+	coccinelle $f $srctree;
+    done
+else
+    coccinelle $COCCI $srctree
+fi
-- 
1.7.0.4

