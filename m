Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab2KNGdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 01:33:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab2KNGdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 01:33:43 -0500
Date: Tue, 13 Nov 2012 22:32:09 -0800
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-acddedfba0df1e47fa99035a04661082b679ee9c@git.kernel.org>
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
In-Reply-To: <20121030084600.GB8245@gmail.com>
References: <20121030084600.GB8245@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Speed up the perf build time by simplifying the perf --version string generation
Git-Commit-ID: acddedfba0df1e47fa99035a04661082b679ee9c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:32:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  acddedfba0df1e47fa99035a04661082b679ee9c
Gitweb:     http://git.kernel.org/tip/acddedfba0df1e47fa99035a04661082b679ee9c
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Tue, 30 Oct 2012 09:46:00 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 31 Oct 2012 12:17:49 -0200

perf tools: Speed up the perf build time by simplifying the perf --version string generation

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
 1 files changed, 1 insertions(+), 1 deletions(-)

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
