Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab2I1EgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:36:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:46887 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab2I1Eby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="198218539"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 05/31] perf, tools: Add :c,:t event modifiers in perf tools
Date: Thu, 27 Sep 2012 21:31:10 -0700
Message-Id: <1348806696-31170-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Haswell supports new per event qualifiers for TSX transactions and
checkpointed transaction qualifiers that can be used to compute the
events discarded due to aborts.

Implement it in the usertool as :t and :c

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-list.txt |    6 ++++++
 tools/perf/util/evsel.c                |   14 ++++++++++++--
 tools/perf/util/parse-events.c         |    7 +++++++
 tools/perf/util/parse-events.l         |    2 +-
 4 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index ddc2252..52ea166 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -34,6 +34,12 @@ Intel PEBS and can be specified multiple times:
 
 The PEBS implementation now supports up to 2.
 
+On Intel Haswell CPUs t and c can be specified to request that the event
+is only counted inside transactions ('t') or that the counter is rolled
+back to the beginning of the transaction on a abort ('c'). This can
+be used to account for transaction residency and cycles lost to transaction
+aborts.
+
 RAW HARDWARE EVENT DESCRIPTOR
 -----------------------------
 Even when an event is not available in a symbolic form within perf right now,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2eaae14..cda3805 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -93,11 +93,12 @@ static int perf_evsel__add_modifiers(struct perf_evsel *evsel, char *bf, size_t
 	struct perf_event_attr *attr = &evsel->attr;
 	bool exclude_guest_default = false;
 
-#define MOD_PRINT(context, mod)	do {					\
-		if (!attr->exclude_##context) {				\
+#define __MOD_PRINT(test, mod)	do {				\
+		if (test) {					\
 			if (!colon) colon = ++r;			\
 			r += scnprintf(bf + r, size - r, "%c", mod);	\
 		} } while(0)
+#define MOD_PRINT(context, mod) __MOD_PRINT(!attr->exclude_##context, mod)
 
 	if (attr->exclude_kernel || attr->exclude_user || attr->exclude_hv) {
 		MOD_PRINT(kernel, 'k');
@@ -113,11 +114,20 @@ static int perf_evsel__add_modifiers(struct perf_evsel *evsel, char *bf, size_t
 		exclude_guest_default = true;
 	}
 
+	if (attr->intx || attr->intx_checkpointed) {
+		__MOD_PRINT(attr->intx_checkpointed, 'c');
+		__MOD_PRINT(attr->intx, 't');
+		/* Set the bizarro flag: */
+		exclude_guest_default = true;
+	}
+
 	if (attr->exclude_host || attr->exclude_guest == exclude_guest_default) {
 		MOD_PRINT(host, 'H');
 		MOD_PRINT(guest, 'G');
 	}
+
 #undef MOD_PRINT
+#undef __MOD_PRINT
 	if (colon)
 		bf[colon - 1] = ':';
 	return r;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 74a5af4..5668ca6 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -628,6 +628,7 @@ int parse_events_modifier(struct list_head *list, char *str)
 	struct perf_evsel *evsel;
 	int exclude = 0, exclude_GH = 0;
 	int eu = 0, ek = 0, eh = 0, eH = 0, eG = 0, precise = 0;
+	int intx = 0, intx_cp = 0;
 
 	if (str == NULL)
 		return 0;
@@ -655,6 +656,10 @@ int parse_events_modifier(struct list_head *list, char *str)
 			eH = 0;
 		} else if (*str == 'p') {
 			precise++;
+		} else if (*str == 't') {
+			intx = 1;
+		} else if (*str == 'c') {
+			intx_cp = 1;
 		} else
 			break;
 
@@ -681,6 +686,8 @@ int parse_events_modifier(struct list_head *list, char *str)
 		evsel->attr.precise_ip     = precise;
 		evsel->attr.exclude_host   = eH;
 		evsel->attr.exclude_guest  = eG;
+		evsel->attr.intx_checkpointed = intx_cp;
+		evsel->attr.intx	     = intx;
 	}
 
 	return 0;
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 384ca74..96ab100 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -75,7 +75,7 @@ num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
-modifier_event	[ukhpGH]{1,8}
+modifier_event	[ukhpGHct]+
 modifier_bp	[rwx]{1,3}
 
 %%
-- 
1.7.7.6

