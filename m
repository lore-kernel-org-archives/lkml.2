Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab0KBH3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 03:29:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:62640 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756384Ab0KBH3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 03:29:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,279,1286175600"; 
   d="scan'208";a="569498758"
Subject: [DRAFT PATCH 3/3] perf: Update perf tool to monitor uncore events
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephane Eranian <eranian@google.com>, robert.richter@amd.com,
        Cyrill Gorcunov <gorcunov@gmail.com>, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 15:28:53 +0800
Message-ID: <1288682933.12061.110.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uncore events are monitored with raw events with "ru" prefix("u" for uncore).

./perf stat -e ru0101 -- ls

Performance counter stats for 'ls':

             795920  raw 0x101               

        0.002110130  seconds time elapsed

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/util/parse-events.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4af5bd5..637266a 100644
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
@@ -655,14 +655,20 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
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
1.7.1




