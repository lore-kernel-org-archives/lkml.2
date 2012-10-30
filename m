Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab2J3Iyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:54:49 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:50292 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239Ab2J3Iyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:54:46 -0400
Date: Tue, 30 Oct 2012 09:54:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Vagin <avagin@openvz.org>,
        Borislav Petkov <bp@amd64.org>, David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] perf tools: Further speed up the perf build
Message-ID: <20121030085441.GC8245@gmail.com>
References: <1351261913-28250-1-git-send-email-acme@infradead.org>
 <20121026145451.GA14379@gmail.com>
 <20121026170503.GC20695@ghostprotocols.net>
 <20121027131935.GA30001@gmail.com>
 <20121030081807.GA8245@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030081807.GA8245@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's another source of overhead in the perf version string 
generator:

   git update-index -q --refresh

... which will iterate the whole checked out tree. This can be 
pretty slow on NFS volumes, but takes some time even with local 
SSD disks and a fully cached kernel tree:

 $ perf stat --null --repeat 3 --pre "rm -f PERF-VERSION-FILE" util/PERF-VERSION-GEN 
 PERF_VERSION = 3.7.rc3.g5399b3b.dirty
 PERF_VERSION = 3.7.rc3.g5399b3b.dirty
 PERF_VERSION = 3.7.rc3.g5399b3b.dirty

 Performance counter stats for 'util/PERF-VERSION-GEN' (3 runs):

       0.306999221 seconds time elapsed                                          ( +-  0.56% )

So remove the .dirty differentiator as well - it adds little 
information because locally patched git trees are common, but 
seldom are the perf tools modified.

So a lot of version strings are reported as 'dirty' while in 
fact they are pristine perf builds. For example 99% of my perf 
builds are not patched but the kernel tree is slightly patched, 
which adds the .dirty tag.

Eliminating that tag speeds up version generation by another 
order of magnitude:

 $ perf stat --null --repeat 3 --sync --pre "rm -f PERF-VERSION-FILE" util/PERF-VERSION-GEN 
 PERF_VERSION = 3.7.rc3.g4b0bd3
 PERF_VERSION = 3.7.rc3.g4b0bd3
 PERF_VERSION = 3.7.rc3.g4b0bd3

 Performance counter stats for 'util/PERF-VERSION-GEN' (3 runs):

       0.021270923 seconds time elapsed                                          ( +-  1.94% )

(Also clean up some of the comments around this code.)

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/util/PERF-VERSION-GEN | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index c774b89..6fb1cc8 100755
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
-	VN=$(echo $(git tag --list "v[0-9].[0-9]*" | tail -1)"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD) 2>/dev/null) &&
-	case "$VN" in
-	*$LF*) (exit 1) ;;
-	v[0-9]*)
-		git update-index -q --refresh
-		test -z "$(git diff-index --name-only HEAD --)" ||
-		VN="$VN-dirty" ;;
-	esac
+	VN=$(echo $(git tag --list "v[0-9].[0-9]*" | tail -1)"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD) 2>/dev/null)
 then
 	VN=$(echo "$VN" | sed -e 's/-/./g');
 else
