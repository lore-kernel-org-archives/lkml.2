Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab0LBFSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 00:18:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:65043 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab0LBFSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 00:18:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,286,1288594800"; 
   d="scan'208";a="632271319"
Subject: [RFC PATCH 3/3 v3] perf: Update perf tool to monitor uncore events
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 13:20:38 +0800
Message-ID: <1291267238.2405.315.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uncore events are monitored with raw events with "ru" prefix("u" for uncore).
Note that, per-task uncore event is not allowed.

$ ./perf stat -e ru0101 -- ls
No permission to collect stats.
Consider tweaking /proc/sys/kernel/perf_event_paranoid.

./perf stat -a -C 0 -e ru0101 -- ls

 Performance counter stats for 'ls':

             949585  raw 0x101               

        0.001741513  seconds time elapsed

TODO:

- Add a new sub-command for uncore events statistics.
For example, perf package -p <package-id> -e <event>

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/util/parse-events.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 73215e7..81df119 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -278,7 +278,7 @@ const char *__event_name(int type, u64 config)
 {
 	static char buf[32];
 
-	if (type == PERF_TYPE_RAW) {
+	if (type == PERF_TYPE_RAW || type == PERF_TYPE_UNCORE) {
 		sprintf(buf, "raw 0x%llx", config);
 		return buf;
 	}
@@ -659,14 +659,20 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
 	u64 config;
+	int uncore = 0;
 	int n;
 
 	if (*str != 'r')
 		return EVT_FAILED;
-	n = hex2u64(str + 1, &config);
+	if (*(str+1) == 'u')
+		uncore = 1;
+	n = hex2u64(str + 1 + uncore, &config);
 	if (n > 0) {
-		*strp = str + n + 1;
-		attr->type = PERF_TYPE_RAW;
+		*strp = str + n + 1 + uncore;
+		if (!uncore)
+			attr->type = PERF_TYPE_RAW;
+		else
+			attr->type = PERF_TYPE_UNCORE;
 		attr->config = config;
 		return EVT_HANDLED;
 	}
-- 
1.5.3



