Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab2JTOeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 10:34:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab2JTOeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 10:34:08 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 05/11] perf tool: Fix event ID retrieval for group format read case
Date: Sat, 20 Oct 2012 16:33:13 +0200
Message-Id: <1350743599-4805-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to fail the event ID retrieval in case both following
conditions are true:
  - we are on kernel with no PERF_EVENT_IOC_ID support
  - PERF_FORMAT_GROUP read format is set

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evlist.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b1c8f35..b7c64c3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -302,6 +302,13 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 		u64 read_data[4] = { 0, };
 		int id_idx = 1; /* The first entry is the counter value */
 
+		/*
+		 * This way does not work with group format read, so bail
+		 * out in that case.
+		 */
+		if (perf_evlist__read_format(evlist) & PERF_FORMAT_GROUP)
+			return -1;
+
 		if (!(evsel->attr.read_format & PERF_FORMAT_ID) ||
 		    read(fd, &read_data, sizeof(read_data)) == -1)
 			return -1;
-- 
1.7.11.4

