Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab0GEIq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 04:46:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:47262 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758115Ab0GEIq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:46:26 -0400
Date: Mon, 5 Jul 2010 08:45:58 GMT
From: tip-bot for Thavidu Ranatunga <tharan@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       tharan@au1.ibm.com, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, imunsie@au1.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, tharan@au1.ibm.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, imunsie@au1.ibm.com,
       mingo@elte.hu
In-Reply-To: <1278316815-6099-2-git-send-email-tharan@au1.ibm.com>
References: <1278316815-6099-2-git-send-email-tharan@au1.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Version String fix, for fallback if not from git
Message-ID: <tip-869599ceda4a035cdb3345c563b74cdeef10f790@git.kernel.org>
Git-Commit-ID: 869599ceda4a035cdb3345c563b74cdeef10f790
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 05 Jul 2010 08:45:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  869599ceda4a035cdb3345c563b74cdeef10f790
Gitweb:     http://git.kernel.org/tip/869599ceda4a035cdb3345c563b74cdeef10f790
Author:     Thavidu Ranatunga <tharan@au1.ibm.com>
AuthorDate: Mon, 5 Jul 2010 18:00:15 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Jul 2010 10:42:58 +0200

perf: Version String fix, for fallback if not from git

This gets rid of the default version fallback for Perf and
changes it so that it returns the version of the kernel from
it's Makefile (if sources were not from git, ie. if it was
downloaded from a tarball)

Signed-off-by: Thavidu Ranatunga <tharan@au1.ibm.com>
Acked-by: Ian Munsie <imunsie@au1.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1278316815-6099-2-git-send-email-tharan@au1.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
