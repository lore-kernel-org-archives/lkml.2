Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab0EJQZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:25:58 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:43841 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab0EJQYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:24:45 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Randy Dunlap <rdunlap@xenotime.net>, Roland Dreier <rdreier@cisco.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Nicolas Palix <npalix@diku.dk>, Julia Lawall <julia@diku.dk>
Subject: [PATCH 1/4] Add targets to use the Coccinelle checker
Date: Mon, 10 May 2010 18:24:24 +0200
Message-Id: <1273508667-5152-2-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273508667-5152-1-git-send-email-npalix@diku.dk>
References: <1273508667-5152-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Four targets are added. Each one generates a different
output kind: context, patch, org, report.
Every SmPL file in 'scripts/coccinelle' is given to the spatch frontend
(located in the 'scripts' directory), and applied to the entire
source tree.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 MAINTAINERS           |   10 ++++++++++
 Makefile              |   20 ++++++++++++++++++--
 scripts/coccinelle.sh |   28 ++++++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 2 deletions(-)
 create mode 100755 scripts/coccinelle.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index d5b0b1b..84f527a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1543,6 +1543,16 @@ L:	platform-driver-x86@vger.kernel.org
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
+F:	scripts/coccinelle.sh
+
 CODA FILE SYSTEM
 M:	Jan Harkes <jaharkes@cs.cmu.edu>
 M:	coda@cs.cmu.edu
diff --git a/Makefile b/Makefile
index 701bc65..7bf168f 100644
--- a/Makefile
+++ b/Makefile
@@ -325,6 +325,7 @@ INSTALLKERNEL  := installkernel
 DEPMOD		= /sbin/depmod
 KALLSYMS	= scripts/kallsyms
 PERL		= perl
+COCCINELLE      = spatch
 CHECK		= sparse
 
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
@@ -411,7 +412,8 @@ endif
 no-dot-config-targets := clean mrproper distclean \
 			 cscope TAGS tags help %docs check% \
 			 include/linux/version.h headers_% \
-			 kernelrelease kernelversion
+			 kernelrelease kernelversion        \
+			 coccicheck-%
 
 config-targets := 0
 mixed-targets  := 0
@@ -1264,7 +1266,8 @@ help:
 	@echo  '  includecheck    - Check for duplicate included header files'
 	@echo  '  export_report   - List the usages of all exported symbols'
 	@echo  '  headers_check   - Sanity check on exported headers'
-	@echo  '  headerdep       - Detect inclusion cycles in headers'; \
+	@echo  '  headerdep       - Detect inclusion cycles in headers'
+	@echo  '  coccicheck-<m>  - Check with Coccinelle in <m> mode (report, context, patch, org)'; \
 	 echo  ''
 	@echo  'Kernel packaging:'
 	@$(MAKE) $(build)=$(package-dir) help
@@ -1424,6 +1427,19 @@ versioncheck:
 		-name '*.[hcS]' -type f -print | sort \
 		| xargs $(PERL) -w $(srctree)/scripts/checkversion.pl
 
+coccicheck-context coccicheck-patch coccicheck-org coccicheck-report:
+	@echo ''
+	@echo 'Please check for false positives in the output before submitting a patch.'
+	@echo 'When using "patch" mode, carefully review the patch before submitting it.'
+	@echo ''
+	@if [ "$(COCCI)" = "" ] ; then                         \
+	find $(srctree)/scripts/coccinelle/                    \
+		-name '*.cocci' -type f                        \
+		-exec $(srctree)/scripts/coccinelle.sh $(COCCINELLE) $(@:coccicheck-%=%) \{} $(srctree) \; ; \
+	else                                                                                                 \
+		$(srctree)/scripts/coccinelle.sh $(COCCINELLE) $(@:coccicheck-%=%) $(COCCI) $(srctree)     ; \
+	fi
+
 namespacecheck:
 	$(PERL) $(srctree)/scripts/namespace.pl
 
diff --git a/scripts/coccinelle.sh b/scripts/coccinelle.sh
new file mode 100755
index 0000000..0d29e93
--- /dev/null
+++ b/scripts/coccinelle.sh
@@ -0,0 +1,28 @@
+#!/bin/sh
+
+SPATCH="`which $1`"
+MODE="$2"
+COCCI="$3"
+DIR="$4"
+
+OPT=`grep "Option" $COCCI | cut -d':' -f2`
+FILE=`echo $COCCI | sed "s|$DIR/||"`
+
+if [ -x "$SPATCH" ]; then
+
+    echo "Processing `basename $COCCI` with option(s) \"$(OPT)\""
+    echo 'Message example to submit a patch:'
+    sed -e '/\/\/\//!d' -e 's|^///||' $COCCI
+
+    echo ' The semantic patch that makes this change is available'
+    echo " in $FILE."
+    echo ''
+    echo ' More information about semantic patching is available at'
+    echo ' http://coccinelle.lip6.fr/'
+    echo ''
+
+    $SPATCH -D $MODE -very_quiet -sp_file $COCCI $OPT -dir $DIR
+
+else
+    echo 'spatch is part of the Coccinelle project and is available at http://coccinelle.lip6.fr/'
+fi
-- 
1.7.0.4

