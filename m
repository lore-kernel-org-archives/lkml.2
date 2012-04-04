Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2DDVQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:16:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635Ab2DDVQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:16:47 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/8] perf, tool: Use PERF_EVENT_IOC_ID perf ioctl to read event id
Date: Wed,  4 Apr 2012 23:16:12 +0200
Message-Id: <1333574176-11388-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the way we retrieve the event ID. Instead of parsing out
the ID out of the read data, using the PERF_EVENT_IOC_ID ioctl.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evlist.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 486f939..0ffae44 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -339,19 +339,12 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 				  struct perf_evsel *evsel,
 				  int cpu, int thread, int fd)
 {
-	u64 read_data[4] = { 0, };
-	int id_idx = 1; /* The first entry is the counter value */
+	u64 id;
 
-	if (!(evsel->attr.read_format & PERF_FORMAT_ID) ||
-	    read(fd, &read_data, sizeof(read_data)) == -1)
-		return -1;
-
-	if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
-		++id_idx;
-	if (evsel->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
-		++id_idx;
+	if (ioctl(fd, PERF_EVENT_IOC_ID, &id))
+		return -EFAULT;
 
-	perf_evlist__id_add(evlist, evsel, cpu, thread, read_data[id_idx]);
+	perf_evlist__id_add(evlist, evsel, cpu, thread, id);
 	return 0;
 }
 
-- 
1.7.7.6

