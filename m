Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab2KROa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:30:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36535 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2KROaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:13 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/32] perf tools: Use sscanf for parsing /proc/pid/maps
Date: Sun, 18 Nov 2012 11:29:42 -0300
Message-Id: <1353248997-30763-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

When reading those files to synthesize MMAP events.  It makes the code
shorter and cleaner.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1352643651-13891-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |   74 ++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 43 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index ca9ca28..3cf2c3e 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -193,55 +193,43 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
 	event->header.misc = PERF_RECORD_MISC_USER;
 
 	while (1) {
-		char bf[BUFSIZ], *pbf = bf;
-		int n;
+		char bf[BUFSIZ];
+		char prot[5];
+		char execname[PATH_MAX];
+		char anonstr[] = "//anon";
 		size_t size;
+
 		if (fgets(bf, sizeof(bf), fp) == NULL)
 			break;
 
+		/* ensure null termination since stack will be reused. */
+		strcpy(execname, "");
+
 		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
-		n = hex2u64(pbf, &event->mmap.start);
-		if (n < 0)
-			continue;
-		pbf += n + 1;
-		n = hex2u64(pbf, &event->mmap.len);
-		if (n < 0)
+		sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %*x:%*x %*u %s\n",
+		       &event->mmap.start, &event->mmap.len, prot,
+		       &event->mmap.pgoff, execname);
+
+		if (prot[2] != 'x')
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
+		if (!strcmp(execname, ""))
+			strcpy(execname, anonstr);
+
+		size = strlen(execname) + 1;
+		memcpy(event->mmap.filename, execname, size);
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
1.7.9.2.358.g22243

