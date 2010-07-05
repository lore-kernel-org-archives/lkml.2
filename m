Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab0GEIAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:00:04 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:36971 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab0GEH7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 03:59:51 -0400
From: Thavidu Ranatunga <tharan@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Thavidu Ranatunga <tharan@au1.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf: Version String fix, for fallback if not from git
Date: Mon,  5 Jul 2010 18:00:15 +1000
Message-Id: <1278316815-6099-2-git-send-email-tharan@au1.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gets rid of the default version fallback for Perf and changes it so that it
returns the version of the kernel from it's Makefile (if sources were not from
git, ie. if it was downloaded from a tarball)

Signed-off-by: Thavidu Ranatunga <tharan@au1.ibm.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/util/PERF-VERSION-GEN |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 1b32e8c..97d7656 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -5,17 +5,13 @@ if [ $# -eq 1 ]  ; then
 fi
 
 GVF=${OUTPUT}PERF-VERSION-FILE
-DEF_VER=v0.0.2.PERF
 
 LF='
 '
 
-# First see if there is a version file (included in release tarballs),
-# then try git-describe, then default.
-if test -f version
-then
-	VN=$(cat version) || VN="$DEF_VER"
-elif test -d ../../.git -o -f ../../.git &&
+# First check if there is a .git to get the version from git describe
+# otherwise try to get the version from the kernel makefile
+if test -d ../../.git -o -f ../../.git &&
 	VN=$(git describe --abbrev=4 HEAD 2>/dev/null) &&
 	case "$VN" in
 	*$LF*) (exit 1) ;;
@@ -27,7 +23,12 @@ elif test -d ../../.git -o -f ../../.git &&
 then
 	VN=$(echo "$VN" | sed -e 's/-/./g');
 else
-	VN="$DEF_VER"
+	eval `grep '^VERSION\s*=' ../../Makefile|tr -d ' '`
+	eval `grep '^PATCHLEVEL\s*=' ../../Makefile|tr -d ' '`
+	eval `grep '^SUBLEVEL\s*=' ../../Makefile|tr -d ' '`
+	eval `grep '^EXTRAVERSION\s*=' ../../Makefile|tr -d ' '`
+
+	VN="${VERSION}.${PATCHLEVEL}.${SUBLEVEL}${EXTRAVERSION}"
 fi
 
 VN=$(expr "$VN" : v*'\(.*\)')
-- 
1.6.3.3

