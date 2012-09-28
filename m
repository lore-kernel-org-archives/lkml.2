Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab2I1Ehs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:37:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:41984 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab2I1Eby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="199033675"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 23/31] perf, tools: Add support for generic transaction events to perf userspace
Date: Thu, 27 Sep 2012 21:31:28 -0700
Message-Id: <1348806696-31170-24-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add the generic transaction events with aliases to the parser, lexer
and the reverse map code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/evsel.c        |   40 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c |   24 ++++++++++++++++++++++++
 tools/perf/util/parse-events.l |   19 ++++++++++++++++++-
 tools/perf/util/parse-events.y |    4 ++--
 4 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ff084b0..8790069 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -288,6 +288,42 @@ static int perf_evsel__hw_cache_name(struct perf_evsel *evsel, char *bf, size_t
 	return ret + perf_evsel__add_modifiers(evsel, bf + ret, size - ret);
 }
 
+static const char *transaction_name[] = {
+ [PERF_COUNT_HW_TRANSACTION_START]  = "transaction-start",
+ [PERF_COUNT_HW_TRANSACTION_COMMIT] = "transaction-commit",
+ [PERF_COUNT_HW_TRANSACTION_ABORT]  = "transaction-abort",
+ [PERF_COUNT_HW_ELISION_START]      = "elision-start",
+ [PERF_COUNT_HW_ELISION_COMMIT]     = "elision-commit",
+ [PERF_COUNT_HW_ELISION_ABORT]      = "elision-abort",
+};
+
+static const char *transaction_reason[] = {
+ [PERF_COUNT_HW_ABORT_ALL]          = "all",
+ [PERF_COUNT_HW_ABORT_CONFLICT]     = "conflict",
+ [PERF_COUNT_HW_ABORT_CAPACITY]     = "capacity",
+};
+
+static int perf_evsel__transaction_name(struct perf_evsel *evsel, char *bf,
+					size_t size)
+{
+	u64 config = evsel->attr.config;
+	u8 name = config & 0xff, reason = (config >> 8) & 0xff;
+
+	if (name < PERF_COUNT_HW_TRANSACTION_MAX &&
+	    reason < PERF_COUNT_HW_ABORT_MAX) {
+		const char *sep = "", *rtxt = "";
+		if (name == PERF_COUNT_HW_TRANSACTION_ABORT ||
+		    name == PERF_COUNT_HW_ELISION_ABORT) {
+			sep = "-";
+			rtxt = transaction_reason[reason];
+		}
+		return scnprintf(bf, size, "%s%s%s", transaction_name[name],
+						     sep, rtxt);
+	}
+
+	return scnprintf(bf, size, "invalid-transaction");
+}
+
 static int perf_evsel__raw_name(struct perf_evsel *evsel, char *bf, size_t size)
 {
 	int ret = scnprintf(bf, size, "raw 0x%" PRIx64, evsel->attr.config);
@@ -326,6 +362,10 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 		perf_evsel__bp_name(evsel, bf, sizeof(bf));
 		break;
 
+	case PERF_TYPE_HW_TRANSACTION:
+		perf_evsel__transaction_name(evsel, bf, sizeof(bf));
+		break;
+
 	default:
 		scnprintf(bf, sizeof(bf), "%s", "unknown attr type");
 		break;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5668ca6..e24a490 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -110,6 +110,20 @@ static struct event_symbol event_symbols_sw[PERF_COUNT_SW_MAX] = {
 	},
 };
 
+static struct event_symbol event_symbols_txn[] = {
+	{ .symbol = "transaction-start",          .alias = "tx-start"    },
+	{ .symbol = "transaction-commit",         .alias = "tx-commit"   },
+	{ .symbol = "transaction-abort-all",      .alias = "tx-abort"    },
+	{ .symbol = "transaction-abort-capacity", .alias = "tx-capacity" },
+	{ .symbol = "transaction-abort-conflict", .alias = "tx-conflict" },
+	{ .symbol = "elision-start",              .alias = "le-start"    },
+	{ .symbol = "elision-commit",             .alias = "le-commit"   },
+	{ .symbol = "elision-abort-all",          .alias = "le-abort"    },
+	{ .symbol = "elision-abort-capacity",     .alias = "le-capacity" },
+	{ .symbol = "elision-abort-conflict",     .alias = "le-conflict" },
+
+};
+
 #define __PERF_EVENT_FIELD(config, name) \
 	((config & PERF_EVENT_##name##_MASK) >> PERF_EVENT_##name##_SHIFT)
 
@@ -232,6 +246,9 @@ const char *event_type(int type)
 	case PERF_TYPE_HW_CACHE:
 		return "hardware-cache";
 
+	case PERF_TYPE_HW_TRANSACTION:
+		return "hardware-transaction";
+
 	default:
 		break;
 	}
@@ -800,6 +817,7 @@ static const char * const event_type_descriptors[] = {
 	"Hardware cache event",
 	"Raw hardware event descriptor",
 	"Hardware breakpoint",
+	"Hardware transaction event",
 };
 
 /*
@@ -909,6 +927,9 @@ void print_events_type(u8 type)
 {
 	if (type == PERF_TYPE_SOFTWARE)
 		__print_events_type(type, event_symbols_sw, PERF_COUNT_SW_MAX);
+	else if (type == PERF_TYPE_HW_TRANSACTION)
+		__print_events_type(type, event_symbols_txn,
+				    ARRAY_SIZE(event_symbols_txn));
 	else
 		__print_events_type(type, event_symbols_hw, PERF_COUNT_HW_MAX);
 }
@@ -984,6 +1005,9 @@ void print_events(const char *event_glob)
 
 	print_hwcache_events(event_glob);
 
+	print_symbol_events(event_glob, PERF_TYPE_HW_TRANSACTION,
+			    event_symbols_txn, ARRAY_SIZE(event_symbols_txn));
+
 	if (event_glob != NULL)
 		return;
 
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 96ab100..2c9dd04 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -56,7 +56,8 @@ static int sym(yyscan_t scanner, int type, int config)
 	YYSTYPE *yylval = parse_events_get_lval(scanner);
 
 	yylval->num = (type << 16) + config;
-	return type == PERF_TYPE_HARDWARE ? PE_VALUE_SYM_HW : PE_VALUE_SYM_SW;
+	return type == PERF_TYPE_HARDWARE || type == PERF_TYPE_HW_TRANSACTION ?
+	       PE_VALUE_SYM_HW : PE_VALUE_SYM_SW;
 }
 
 static int term(yyscan_t scanner, int type)
@@ -67,6 +68,11 @@ static int term(yyscan_t scanner, int type)
 	return PE_TERM;
 }
 
+#define txn(t)		sym(yyscanner, PERF_TYPE_HW_TRANSACTION, \
+                            PERF_COUNT_HW_##t)
+#define txn_abort(t, a) sym(yyscanner, PERF_TYPE_HW_TRANSACTION, \
+			    PERF_COUNT_HW_##t | ((PERF_COUNT_HW_ABORT_##a)<<8))
+
 %}
 
 %x mem
@@ -127,6 +133,17 @@ speculative-read|speculative-load	|
 refs|Reference|ops|access		|
 misses|miss				{ return str(yyscanner, PE_NAME_CACHE_OP_RESULT); }
 
+transaction-start|tx-start		{ return txn(TRANSACTION_START);  }
+transaction-commit|tx-commit		{ return txn(TRANSACTION_COMMIT); }
+transaction-abort-all|tx-aborts?	{ return txn_abort(TRANSACTION_ABORT, ALL); }
+transaction-abort-conflict|tx-conflict  { return txn_abort(TRANSACTION_ABORT, CONFLICT); }
+transaction-abort-capacity|tx-capacity  { return txn_abort(TRANSACTION_ABORT, CAPACITY); }
+elision-start|le-start			{ return txn(ELISION_START);  }
+elision-commit|le-commit		{ return txn(ELISION_COMMIT); }
+elision-abort-all|le-aborts?		{ return txn_abort(ELISION_ABORT, ALL); }
+elision-abort-conflict|le-conflict	{ return txn_abort(ELISION_ABORT, CONFLICT); }
+elision-abort-capacity|le-capacity	{ return txn_abort(ELISION_ABORT, CAPACITY); }
+
 	/*
 	 * These are event config hardcoded term names to be specified
 	 * within xxx/.../ syntax. So far we dont clash with other names,
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 2bc5fbf..6485eb3 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -122,7 +122,7 @@ value_sym '/' event_config '/'
 	struct parse_events_data__events *data = _data;
 	struct list_head *list = NULL;
 	int type = $1 >> 16;
-	int config = $1 & 255;
+	int config = $1 & 0xffff;
 
 	ABORT_ON(parse_events_add_numeric(&list, &data->idx,
 					  type, config, $3));
@@ -135,7 +135,7 @@ value_sym sep_slash_dc
 	struct parse_events_data__events *data = _data;
 	struct list_head *list = NULL;
 	int type = $1 >> 16;
-	int config = $1 & 255;
+	int config = $1 & 0xffff;
 
 	ABORT_ON(parse_events_add_numeric(&list, &data->idx,
 					  type, config, NULL));
-- 
1.7.7.6

