Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2KGH1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:27:24 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50186 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab2KGH1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:27:22 -0500
X-AuditID: 9c930179-b7c8bae000003559-5a-509a0d57eeba
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/6] perf tools: Synthesize data mmap events for threads
Date: Wed,  7 Nov 2012 16:27:09 +0900
Message-Id: <1352273234-28912-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352273234-28912-1-git-send-email-namhyung@kernel.org>
References: <1352273234-28912-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current perf_event__synthesize_mmap_events() only deals with
executable mappings.  With upcoming memory access sampling,
non-executable data mappings are needed also.

While at it, convert parsing code to use sscanf which makes
the code cleaner IMHO.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/event.c | 78 ++++++++++++++++++++++---------------------------
 1 file changed, 35 insertions(+), 43 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index ca9ca285406a..068acf606b40 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -193,55 +193,47 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 	event->header.misc = PERF_RECORD_MISC_USER;
 
 	while (1) {
-		char bf[BUFSIZ], *pbf = bf;
-		int n;
+		char bf[BUFSIZ];
+		char prot[5], *pprot = prot;
 		size_t size;
+		char exec_name[PATH_MAX], *pexec = exec_name;
+		char anonstr[] = "//anon";
+
 		if (fgets(bf, sizeof(bf), fp) == NULL)
 			break;
 
+		/* ensure null termination since stack will be reused */
+		strcpy(exec_name, "");
+
 		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
-		n = hex2u64(pbf, &event->mmap.start);
-		if (n < 0)
-			continue;
-		pbf += n + 1;
-		n = hex2u64(pbf, &event->mmap.len);
-		if (n < 0)
+		sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %*x:%*x %*u %s\n",
+		       &event->mmap.start, &event->mmap.len, pprot,
+		       &event->mmap.pgoff, pexec);
+
+		if (prot[2] == 'x' && !strcmp(exec_name, ""))
+			strcpy(exec_name, anonstr);
+
+		/* ignore non-executable anon mappings */
+		if (!strcmp(exec_name, ""))
 			continue;
-		pbf += n + 3;
-		if (*pbf == 'x') { /* vm_exec */
-			char anonstr[] = "//anon\n";
-			char *execname = strchr(bf, '/');
-
-			/* Catch VDSO */
-			if (execname == NULL)
-				execname = strstr(bf, "[vdso]");
-
-			/* Catch anonymous mmaps */
-			if ((execname == NULL) && !strstr(bf, "["))
-				execname = anonstr;
-
-			if (execname == NULL)
-				continue;
-
-			pbf += 3;
-			n = hex2u64(pbf, &event->mmap.pgoff);
-
-			size = strlen(execname);
-			execname[size - 1] = '\0'; /* Remove \n */
-			memcpy(event->mmap.filename, execname, size);
-			size = PERF_ALIGN(size, sizeof(u64));
-			event->mmap.len -= event->mmap.start;
-			event->mmap.header.size = (sizeof(event->mmap) -
-					        (sizeof(event->mmap.filename) - size));
-			memset(event->mmap.filename + size, 0, machine->id_hdr_size);
-			event->mmap.header.size += machine->id_hdr_size;
-			event->mmap.pid = tgid;
-			event->mmap.tid = pid;
-
-			if (process(tool, event, &synth_sample, machine) != 0) {
-				rc = -1;
-				break;
-			}
+
+		if (prot[2] != 'x')
+			event->header.misc |= PERF_RECORD_MISC_MMAP_DATA;
+
+		size = strlen(exec_name) + 1;
+		memcpy(event->mmap.filename, exec_name, size);
+		size = PERF_ALIGN(size, sizeof(u64));
+		event->mmap.len -= event->mmap.start;
+		event->mmap.header.size = (sizeof(event->mmap) -
+					   (sizeof(event->mmap.filename) - size));
+		memset(event->mmap.filename + size, 0, machine->id_hdr_size);
+		event->mmap.header.size += machine->id_hdr_size;
+		event->mmap.pid = tgid;
+		event->mmap.tid = pid;
+
+		if (process(tool, event, &synth_sample, machine) != 0) {
+			rc = -1;
+			break;
 		}
 	}
 
-- 
1.7.11.7

