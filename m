Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502Ab2LHOzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:55:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49560 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483Ab2LHOzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:55:51 -0500
Date: Sat, 8 Dec 2012 06:55:32 -0800
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-6064803313bad9ae4cae233a9d56678adb2b6e7c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1352643651-13891-1-git-send-email-namhyung@kernel.org>
References: <1352643651-13891-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Use sscanf for parsing /proc/pid/maps
Git-Commit-ID: 6064803313bad9ae4cae233a9d56678adb2b6e7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 08 Dec 2012 06:55:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6064803313bad9ae4cae233a9d56678adb2b6e7c
Gitweb:     http://git.kernel.org/tip/6064803313bad9ae4cae233a9d56678adb2b6e7c
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Sun, 11 Nov 2012 23:20:50 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Nov 2012 16:51:40 -0300

perf tools: Use sscanf for parsing /proc/pid/maps

When reading those files to synthesize MMAP events.  It makes the code
shorter and cleaner.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1352643651-13891-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c | 74 +++++++++++++++++++++----------------------------
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
 
