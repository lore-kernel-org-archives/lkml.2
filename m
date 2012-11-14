Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab2KNGdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:33:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43096 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2KNGdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:33:43 -0500
Date: Tue, 13 Nov 2012 22:33:09 -0800
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-0e2af956693a8797d658d076ff4c0da4147f0131@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        eranian@gmail.com, namhyung@kernel.org, bp@amd64.org,
        avagin@openvz.org, jolsa@redhat.com, dhowells@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        avagin@openvz.org, bp@amd64.org, namhyung@kernel.org,
        eranian@gmail.com, jolsa@redhat.com, fweisbec@gmail.com,
        dhowells@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20121030085441.GC8245@gmail.com>
References: <20121030085441.GC8245@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Further speed up the perf build
Git-Commit-ID: 0e2af956693a8797d658d076ff4c0da4147f0131
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:33:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e2af956693a8797d658d076ff4c0da4147f0131
Gitweb:     http://git.kernel.org/tip/0e2af956693a8797d658d076ff4c0da4147f0131
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Tue, 30 Oct 2012 09:54:41 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 31 Oct 2012 12:17:49 -0200

perf tools: Further speed up the perf build

There's another source of overhead in the perf version string generator:

   git update-index -q --refresh

... which will iterate the whole checked out tree. This can be pretty
slow on NFS volumes, but takes some time even with local SSD disks and a
fully cached kernel tree:

 $ perf stat --null --repeat 3 --pre "rm -f PERF-VERSION-FILE" util/PERF-VERSION-GEN
 PERF_VERSION = 3.7.rc3.g5399b3b.dirty
 PERF_VERSION = 3.7.rc3.g5399b3b.dirty
 PERF_VERSION = 3.7.rc3.g5399b3b.dirty

 Performance counter stats for 'util/PERF-VERSION-GEN' (3 runs):

       0.306999221 seconds time elapsed                                          ( +-  0.56% )

So remove the .dirty differentiator as well - it adds little information
because locally patched git trees are common, but seldom are the perf
tools modified.

So a lot of version strings are reported as 'dirty' while in fact they
are pristine perf builds. For example 99% of my perf builds are not
patched but the kernel tree is slightly patched, which adds the .dirty
tag.

Eliminating that tag speeds up version generation by another order of
magnitude:

 $ perf stat --null --repeat 3 --sync --pre "rm -f PERF-VERSION-FILE" util/PERF-VERSION-GEN
 PERF_VERSION = 3.7.rc3.g4b0bd3
 PERF_VERSION = 3.7.rc3.g4b0bd3
 PERF_VERSION = 3.7.rc3.g4b0bd3

 Performance counter stats for 'util/PERF-VERSION-GEN' (3 runs):

       0.021270923 seconds time elapsed                                          ( +-  1.94% )

(Also clean up some of the comments around this code.)

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Borislav Petkov <bp@amd64.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20121030085441.GC8245@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/PERF-VERSION-GEN |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index f6e8ee2..ac418a1 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -9,17 +9,12 @@ GVF=${OUTPUT}PERF-VERSION-FILE
 LF='
 '
 
+#
 # First check if there is a .git to get the version from git describe
-# otherwise try to get the version from the kernel makefile
+# otherwise try to get the version from the kernel Makefile
+#
 if test -d ../../.git -o -f ../../.git &&
-	VN=$(echo $(git tag -l "v[0-9].[0-9]*" | tail -1)"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD) 2>/dev/null) &&
-	case "$VN" in
-	*$LF*) (exit 1) ;;
-	v[0-9]*)
-		git update-index -q --refresh
-		test -z "$(git diff-index --name-only HEAD --)" ||
-		VN="$VN-dirty" ;;
-	esac
+	VN=$(echo $(git tag -l "v[0-9].[0-9]*" | tail -1)"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD) 2>/dev/null)
 then
 	VN=$(echo "$VN" | sed -e 's/-/./g');
 else
