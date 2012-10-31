Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965738Ab2JaOtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:49:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43612 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965266Ab2JaOtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:49:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/6] perf tools: Handle --version string generation on machines without git
Date: Wed, 31 Oct 2012 12:49:02 -0200
Message-Id: <1351694943-7188-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351694943-7188-1-git-send-email-acme@infradead.org>
References: <1351694943-7188-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

If git is installed we'll have a 'perf --version' output of this form:

$ make -j8 -C tools/perf/ O=/home/acme/git/build/perf install
$ perf --version
perf version 3.7.rc3.g3afad6

Now on a machine without git installed:

$ mv  /home/acme/bin/git /home/acme/bin/git.OFF
$ make -j8 -C tools/perf/ O=/home/acme/git/build/perf install
$ perf --version
perf version 3.7.0-rc2

That is, no error message due to git not being installed will appear on the
screen and instead the version string in the top level Makefile will be
used.

Requested-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-am6yp6phvxyjmyndxogpunjv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/PERF-VERSION-GEN |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
index ac418a1..6aa34e5 100755
--- a/tools/perf/util/PERF-VERSION-GEN
+++ b/tools/perf/util/PERF-VERSION-GEN
@@ -14,8 +14,9 @@ LF='
 # otherwise try to get the version from the kernel Makefile
 #
 if test -d ../../.git -o -f ../../.git &&
-	VN=$(echo $(git tag -l "v[0-9].[0-9]*" | tail -1)"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD) 2>/dev/null)
+	VN=$(git tag 2>/dev/null | tail -1 | grep -E "v[0-9].[0-9]*")
 then
+	VN=$(echo $VN"-g"$(git log -1 --abbrev=4 --pretty=format:"%h" HEAD))
 	VN=$(echo "$VN" | sed -e 's/-/./g');
 else
 	VN=$(MAKEFLAGS= make -sC ../.. kernelversion)
-- 
1.7.9.2.358.g22243

