Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0KUMBs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 07:01:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:58883 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab0KUMBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 07:01:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,231,1288594800"; 
   d="scan'208";a="859885774"
Subject: [RFC PATCH 3/3 v2] perf: Update perf tool to monitor uncore events
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Nov 2010 20:01:47 +0800
Message-Id: <1290340907.2245.125.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uncore events are monitored with raw events with "ru" prefix("u" for uncore).

$ ./perf stat -C 0 -e ru0101 -- ls

 Performance counter stats for 'ls':

            1033791  raw 0x101               

        0.003027583  seconds time elapsed

$ sudo ./perf top -e ru0101

--------------------------------------------------------------------------------------------------------------------
   PerfTop:      22 irqs/sec  kernel:68.2%  exact:  0.0% [1000Hz raw 0x101],  (all, 8 CPUs)
--------------------------------------------------------------------------------------------------------------------

             samples  pcnt function               DSO
             _______ _____ ______________________ ____________________________________

                8.00 18.6% kallsyms_expand_symbol [kernel.kallsyms]                   
                5.00 11.6% rb_next                /home/mlin/linux-2.6/tools/perf/perf
                5.00 11.6% clear_page_c           [kernel.kallsyms]

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/util/parse-events.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 898aa94..b03457a 100644
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
1.7.2.3





