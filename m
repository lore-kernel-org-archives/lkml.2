Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab2LKW4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:56:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43857 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab2LKWsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 20/37] perf buildid-list: We need to check if a file is ELF first
Date: Tue, 11 Dec 2012 19:48:06 -0300
Message-Id: <1355266103-17238-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

I.e. before we try to use it as a perf.data file by calling
perf_session__new, otherwise we lose the feature that shows the
build id for the given ELF file, this one:

[root@sandy redhat-perfdata-mtech-15]# perf buildid-list -i /root/.debug/.build-id/97/54896de655b6ac088ec2bf5113b35c06f72709
9754896de655b6ac088ec2bf5113b35c06f72709
[root@sandy redhat-perfdata-mtech-15]# perf buildid-list -i /lib/libc-2.12.so
38adaeff4f7c21899b13b28c1a2e6c199ca4c744
[root@sandy redhat-perfdata-mtech-15]#

Regression introduced in:

efad1415 "perf report: Accept fifos as input file"

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3ktgyg83fwpqyfpoj0t2ezp0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-list.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index a82d99f..4c770d2 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -49,18 +49,16 @@ static int perf_session__list_build_ids(bool force, bool with_hits)
 	struct perf_session *session;
 
 	symbol__elf_init();
-
-	session = perf_session__new(input_name, O_RDONLY, force, false,
-				    &build_id__mark_dso_hit_ops);
-	if (session == NULL)
-		return -1;
-
 	/*
 	 * See if this is an ELF file first:
 	 */
-	if (filename__fprintf_build_id(session->filename, stdout))
+	if (filename__fprintf_build_id(input_name, stdout))
 		goto out;
 
+	session = perf_session__new(input_name, O_RDONLY, force, false,
+				    &build_id__mark_dso_hit_ops);
+	if (session == NULL)
+		return -1;
 	/*
 	 * in pipe-mode, the only way to get the buildids is to parse
 	 * the record stream. Buildids are stored as RECORD_HEADER_BUILD_ID
@@ -69,8 +67,8 @@ static int perf_session__list_build_ids(bool force, bool with_hits)
 		perf_session__process_events(session, &build_id__mark_dso_hit_ops);
 
 	perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
-out:
 	perf_session__delete(session);
+out:
 	return 0;
 }
 
-- 
1.7.9.2.358.g22243

