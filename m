Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1DURlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:41:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:36229 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab1DURlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:41:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/1] perf tools: Add missing user space support for config1/config2
Date: Thu, 21 Apr 2011 14:41:02 -0300
Message-Id: <1303407662-15564-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1303407662-15564-1-git-send-email-acme@infradead.org>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The offcore_msr perf kernel code was merged into 2.6.39-rc*, but the
user space bits were not. This made it impossible to set the extra mask
and actually do the OFFCORE profiling

This patch fixes this. It adds a new syntax ':' to raw events to specify
additional event masks. I also added support for setting config2, even
though that is not needed currently.

[Note: the original version back in time used , -- but that actually
conflicted with event lists, so now it's :]

Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Link: http://lkml.kernel.org/r/1302658203-4239-1-git-send-email-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-list.txt |   11 +++++++++++
 tools/perf/util/parse-events.c         |   18 +++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 7a527f7..f19f1e5 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -61,6 +61,17 @@ raw encoding of 0x1A8 can be used:
 You should refer to the processor specific documentation for getting these
 details. Some of them are referenced in the SEE ALSO section below.
 
+Some raw events -- like the Intel OFFCORE events -- support additional
+parameters. These can be appended after a ':'.
+
+For example on a multi socket Intel Nehalem:
+
+ perf stat -e r1b7:20ff -a sleep 1
+
+Profile the OFFCORE_RESPONSE.ANY_REQUEST with event mask REMOTE_DRAM_0
+that measures any access to DRAM on another socket.  Upto two parameters can
+be specified with additional ':'
+
 OPTIONS
 -------
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 952b4ae..fe9d079 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -688,9 +688,25 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 		return EVT_FAILED;
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
-		*strp = str + n + 1;
+		str += n + 1;
 		attr->type = PERF_TYPE_RAW;
 		attr->config = config;
+		if (*str == ':') {
+			str++;
+			n = hex2u64(str, &config);
+			if (n == 0)
+				return EVT_FAILED;
+			attr->config1 = config;
+			str += n;
+			if (*str == ':') {
+				str++;
+				n = hex2u64(str + 1, &config);
+				if (n == 0)
+					return EVT_FAILED;
+				attr->config2 = config;
+			}
+		}
+		*strp = str;
 		return EVT_HANDLED;
 	}
 	return EVT_FAILED;
-- 
1.6.2.5

