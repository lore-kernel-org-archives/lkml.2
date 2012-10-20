Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab2JTOdp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 10:33:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab2JTOdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 10:33:42 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 03/11] perf tool: Use PERF_EVENT_IOC_ID perf ioctl to read event id
Date: Sat, 20 Oct 2012 16:33:11 +0200
Message-Id: <1350743599-4805-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the way we retrieve the event ID. Instead of parsing out
the ID out of the read data, using the PERF_EVENT_IOC_ID ioctl.

Keeping the old way in place to support kernels without
PERF_EVENT_IOC_ID ioctl support.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evlist.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 561bdfb..ef13aab 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -290,19 +290,33 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 				  struct perf_evsel *evsel,
 				  int cpu, int thread, int fd)
 {
-	u64 read_data[4] = { 0, };
-	int id_idx = 1; /* The first entry is the counter value */
+	u64 id;
+	int ret;
 
-	if (!(evsel->attr.read_format & PERF_FORMAT_ID) ||
-	    read(fd, &read_data, sizeof(read_data)) == -1)
-		return -1;
+	ret = ioctl(fd, PERF_EVENT_IOC_ID, &id);
+	if (!ret)
+		goto add;
+
+	/* Legacy way to get event id.. All hail to old kernels! */
+	if (errno == ENOTTY) {
+		u64 read_data[4] = { 0, };
+		int id_idx = 1; /* The first entry is the counter value */
+
+		if (!(evsel->attr.read_format & PERF_FORMAT_ID) ||
+		    read(fd, &read_data, sizeof(read_data)) == -1)
+			return -1;
 
-	if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
-		++id_idx;
-	if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
-		++id_idx;
+		if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+			++id_idx;
+		if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+			++id_idx;
+
+		id = read_data[id_idx];
+	} else if (errno)
+		return -1;
 
-	perf_evlist__id_add(evlist, evsel, cpu, thread, read_data[id_idx]);
+ add:
+	perf_evlist__id_add(evlist, evsel, cpu, thread, id);
 	return 0;
 }
 
-- 
1.7.11.4

