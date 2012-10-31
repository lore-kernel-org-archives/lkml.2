Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965799Ab2JaOtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:49:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:48020 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965759Ab2JaOtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:49:24 -0400
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
Subject: [PATCH 3/6] perf tools: Speed up the perf build time by simplifying the perf --version string generation
Date: Wed, 31 Oct 2012 12:49:00 -0200
Message-Id: <1351694943-7188-4-git-send-email-acme@infradead.org>
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

Building perf is pretty slow on trees that have a lot of commits
relative to the nearest Git tag. This slowness manifests itself during
version string generation:

 $ perf stat --null --repeat 3 --sync --pre "rm -f PERF-VERSION-FILE" util/PERF-VERSION-GEN
 PERF_VERSION = 3.7.rc3.1458.g5399b3b
 PERF_VERSION = 3.7.rc3.1458.g5399b3b
 PERF_VERSION = 3.7.rc3.1458.g5399b3b

 Performance counter stats for 'util/PERF-VERSION-GEN' (3 runs):

       2.857503976 seconds time elapsed                                          ( +-  0.22% )

The build can be even slower than that, when one over NFS volumes.

The reason for the slowness is that util/PERF-VERSION-GEN uses "git
describe" to generate the string, which has to count the "number of
commits distance" from the nearest tag - the ".1458." count in the
output above. For that Git had to extract and decompress 1458 Git
objects, which takes time and bandwidth.

But this "number of commits" value is mostly irrelevant in practice. We
either want to know an approximate tag name, or we want to know the
precise sha1.

So this patch simplifies the version string to:

 PERF_VERSION = 3.7.rc3.g5399b3b.dirty

which speeds up the version string generation script by an order of
magnitude:

 $ perf stat --null --repeat 3 --sync --pre "rm -f PERF-VERSION-FILE" util/PERF-VERSION-GEN
 PERF_VERSION = 3.7.rc3.g5399b3b.dirty
 PERF_VERSION = 3.7.rc3.g5399b3b.dirty
 PERF_VERSION = 3.7.rc3.g5399b3b.dirty

 Performance counter stats for 'util/PERF-VERSION-GEN' (3 runs):

       0.307633559 seconds time elapsed                                          ( +-  0.84% )

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
Link: http://lkml.kernel.org/r/20121030084600.GB8245@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/PERF-VERSION-GEN |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index 95264f3..f6e8ee2 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -12,7 +12,7 @@ LF='
 # First check if there is a .git to get the version from git describe
 # otherwise try to get the version from the kernel makefile
 if test -d ../../.git -o -f ../../.git &&
-	VN=$(git describe --match 'v[0-9].[0-9]*' --abbrev=4 HEAD 2>/dev/null) &&
+	VN=$(echo $(git tag -l "v[0-9].[0-9]*" | tail -1)"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD) 2>/dev/null) &&
 	case "$VN" in
 	*$LF*) (exit 1) ;;
 	v[0-9]*)
-- 
1.7.9.2.358.g22243

