Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965822Ab2JaOt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:49:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:48022 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965713Ab2JaOt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:49:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/6] perf tools: Further speed up the perf build
Date: Wed, 31 Oct 2012 12:49:01 -0200
Message-Id: <1351694943-7188-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351694943-7188-1-git-send-email-acme@infradead.org>
References: <1351694943-7188-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

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
 1 file changed, 4 insertions(+), 9 deletions(-)

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
-- 
1.7.9.2.358.g22243

