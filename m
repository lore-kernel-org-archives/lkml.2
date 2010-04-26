Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab0DZVMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:12:00 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50064 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab0DZVL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:11:57 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
       "David S. Miller" <davem@davemloft.net>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, Nicolas Palix <npalix@diku.dk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       cocci@diku.dk
Subject: [PATCH 1/4] Add targets to use the Coccinelle checker
Date: Mon, 26 Apr 2010 23:11:16 +0200
Message-Id: <1272316279-12042-2-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272316279-12042-1-git-send-email-npalix@diku.dk>
References: <1272316279-12042-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Four targets are added. Each one generates a different
output kind: context, patch, org, report.
Every SmPL file in 'scripts/smpl' is given to the spatch frontend
(located in the 'scripts' directory), and applied to the entire
source tree.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
---
 MAINTAINERS       |   10 ++++++++++
 Makefile          |    9 +++++++++
 scripts/spatch.sh |   14 ++++++++++++++
 3 files changed, 33 insertions(+), 0 deletions(-)
 create mode 100755 scripts/spatch.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d29fa3..2aab763 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1533,6 +1533,16 @@ L:	platform-driver-x86@vger.kernel.org
 S:	Supported
 F:	drivers/platform/x86/classmate-laptop.c
 
+COCCINELLE
+M:	Julia Lawall <julia@diku.dk>
+M:	Gilles Muller <Gilles.Muller@lip6.fr>
+M:	Nicolas Palix <npalix@diku.dk>
+L:	cocci@diku.dk
+W:	http://coccinelle.lip6.fr/
+S:	Supported
+F:	scripts/smpl/
+F:	scripts/spatch.sh
+
 CODA FILE SYSTEM
 M:	Jan Harkes <jaharkes@cs.cmu.edu>
 M:	coda@cs.cmu.edu
diff --git a/Makefile b/Makefile
index 67c1001..293c88b 100644
--- a/Makefile
+++ b/Makefile
@@ -325,6 +325,7 @@ INSTALLKERNEL  := installkernel
 DEPMOD		= /sbin/depmod
 KALLSYMS	= scripts/kallsyms
 PERL		= perl
+SPATCH          = spatch
 CHECK		= sparse
 
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
@@ -1424,6 +1425,14 @@ versioncheck:
 		-name '*.[hcS]' -type f -print | sort \
 		| xargs $(PERL) -w $(srctree)/scripts/checkversion.pl
 
+coccicheck-context coccicheck-patch coccicheck-org coccicheck-report:
+	@echo "\nPlease, check for false positive in the output before submitting a patch.\n\n"\
+		"Take particularly attention when using the \"patch\" mode\n"\
+		"and carefully review the patch YOU are about to submit.\n"
+	@find $(srctree)/scripts/smpl/                        \
+		-name '*.cocci' -type f                       \
+		-exec $(srctree)/scripts/spatch.sh $(SPATCH) $(@:coccicheck-%=%) \{} $(srctree) \;
+
 namespacecheck:
 	$(PERL) $(srctree)/scripts/namespace.pl
 
diff --git a/scripts/spatch.sh b/scripts/spatch.sh
new file mode 100755
index 0000000..bdcca15
--- /dev/null
+++ b/scripts/spatch.sh
@@ -0,0 +1,14 @@
+#!/bin/sh
+
+SPATCH="$1"
+MODE="$2"
+COCCI="$3"
+DIR="$4"
+
+OPT=`grep "Option" $COCCI | cut -d':' -f2`
+FILE=`echo $COCCI | sed "s|$DIR/||"`
+
+echo Processing `basename $COCCI` with \"$OPT\"
+echo Message example to submit a patch:
+grep "^///" $COCCI | sed "s|///||" | sed "s|THISFILE|$FILE|"
+$SPATCH -D $MODE -very_quiet -sp_file $COCCI $OPT -dir $DIR
-- 
1.6.3.3

