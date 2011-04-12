Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab1DLXxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 19:53:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:51932 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab1DLXxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 19:53:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,200,1301900400"; 
   d="scan'208";a="627660511"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, ming.m.lin@intel.com,
        peterz@infradead.org, mingo@elte.hu, eranian@gmail.com
Subject: [PATCH] perf: Add missing user space support for config1/config2
Date: Tue, 12 Apr 2011 16:52:50 -0700
Message-Id: <1302652370-3479-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The offcore_msr perf kernel code was merged into 2.6.39-rc*,
but the user space bits were not. This made it impossible
to set the extra mask and actually do the OFFCORE profiling

This patch fixes this. It adds a new syntax ':' to raw events
to specify additional event masks. I also added support
for setting config2, even though that is not needed currently.

[Note: the original version back in time used , -- but that
actually conflicted with event lists, so now it's :]

Cc: ming.m.lin@intel.com
Cc: peterz@infradead.org
Cc: mingo@elte.hu
Cc: eranian@gmail.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-list.txt |   11 +++++++++++
 tools/perf/util/parse-events.c         |   16 +++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 7a527f7..5a43169 100644
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
index 952b4ae..9122a16 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -688,9 +688,23 @@ parse_raw_event(const char **strp, struct perf_event_attr *attr)
 		return EVT_FAILED;
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
-		*strp = str + n + 1;
+		str += n + 1;
 		attr->type = PERF_TYPE_RAW;
 		attr->config = config;
+		if (*str == ':') {
+			str++;
+			n = hex2u64(str, (u64 *)&attr->config1);
+			if (n == 0)
+				return EVT_FAILED;
+			str += n;
+			if (*str == ':') {
+				str++;
+				n = hex2u64(str + 1, (u64 *)&attr->config2);
+				if (n == 0)
+					return EVT_FAILED;
+			}
+		}	
+		*strp = str;
 		return EVT_HANDLED;
 	}
 	return EVT_FAILED;
-- 
1.7.4.2

