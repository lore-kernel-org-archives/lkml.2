Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1GUKKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:10:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:60150 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab1GUKKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:10:06 -0400
Date: Thu, 21 Jul 2011 10:09:47 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-0111919da268e1ced315e009ad0d0435a2fb32ac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, jolsa@redhat.com,
        mingo@elte.hu
In-Reply-To: <20110713205818.GB7827@jolsa.brq.redhat.com>
References: <20110713205818.GB7827@jolsa.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add missing 'node' alias to the hw_cache[] array
Git-Commit-ID: 0111919da268e1ced315e009ad0d0435a2fb32ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:09:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0111919da268e1ced315e009ad0d0435a2fb32ac
Gitweb:     http://git.kernel.org/tip/0111919da268e1ced315e009ad0d0435a2fb32ac
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 13 Jul 2011 22:58:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 09:54:51 +0200

perf tools: Add missing 'node' alias to the hw_cache[] array

Add "node" as a simple alias for NODE cache events.

The addition of NODE cache events broke the parse_alias
function, so any mismatched event caused the segfault, like:

  # ./perf stat -e krava ls

The hw_cache/hw_cache_op/hw_cache_result arrays needs to follow
PERF_COUNT_HW_CACHE_*MAX enums. Adding those MAXs to be size
of those arrays, so possible ommision in future wil not lead to
segfault.

Adding read/write/prefetch as allowed operations for node cache
event.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: acme@redhat.com
Link: http://lkml.kernel.org/r/20110713205818.GB7827@jolsa.brq.redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/parse-events.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 41982c3..c0e21ae 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -86,22 +86,24 @@ static const char *sw_event_names[PERF_COUNT_SW_MAX] = {
 
 #define MAX_ALIASES 8
 
-static const char *hw_cache[][MAX_ALIASES] = {
+static const char *hw_cache[PERF_COUNT_HW_CACHE_MAX][MAX_ALIASES] = {
  { "L1-dcache",	"l1-d",		"l1d",		"L1-data",		},
  { "L1-icache",	"l1-i",		"l1i",		"L1-instruction",	},
- { "LLC",	"L2"							},
+ { "LLC",	"L2",							},
  { "dTLB",	"d-tlb",	"Data-TLB",				},
  { "iTLB",	"i-tlb",	"Instruction-TLB",			},
  { "branch",	"branches",	"bpu",		"btb",		"bpc",	},
+ { "node",								},
 };
 
-static const char *hw_cache_op[][MAX_ALIASES] = {
+static const char *hw_cache_op[PERF_COUNT_HW_CACHE_OP_MAX][MAX_ALIASES] = {
  { "load",	"loads",	"read",					},
  { "store",	"stores",	"write",				},
  { "prefetch",	"prefetches",	"speculative-read", "speculative-load",	},
 };
 
-static const char *hw_cache_result[][MAX_ALIASES] = {
+static const char *hw_cache_result[PERF_COUNT_HW_CACHE_RESULT_MAX]
+				  [MAX_ALIASES] = {
  { "refs",	"Reference",	"ops",		"access",		},
  { "misses",	"miss",							},
 };
@@ -124,6 +126,7 @@ static unsigned long hw_cache_stat[C(MAX)] = {
  [C(DTLB)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
  [C(ITLB)]	= (CACHE_READ),
  [C(BPU)]	= (CACHE_READ),
+ [C(NODE)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
 };
 
 #define for_each_subsystem(sys_dir, sys_dirent, sys_next)	       \
@@ -393,7 +396,7 @@ parse_generic_hw_event(const char **str, struct perf_event_attr *attr)
 						PERF_COUNT_HW_CACHE_OP_MAX);
 			if (cache_op >= 0) {
 				if (!is_cache_op_valid(cache_type, cache_op))
-					return 0;
+					return EVT_FAILED;
 				continue;
 			}
 		}
