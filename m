Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211Ab2JaAhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:37:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:31172 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759282Ab2JaAei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:34:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,683,1344236400"; 
   d="scan'208";a="234886227"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 25/32] tools, perf: Add a precise event qualifier
Date: Tue, 30 Oct 2012 17:34:16 -0700
Message-Id: <1351643663-23828-26-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351643663-23828-1-git-send-email-andi@firstfloor.org>
References: <1351643663-23828-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a precise qualifier, like cpu/event=0x3c,precise=1/

This is needed so that the kernel can request enabling PEBS
for TSX events. The parser bails out on any sysfs parse errors,
so this is needed in any case to handle any event on the TSX
perf kernel.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/parse-events.c |    6 ++++++
 tools/perf/util/parse-events.h |    1 +
 tools/perf/util/parse-events.l |    1 +
 3 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c0b785b..5b97a2b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -526,6 +526,12 @@ do {								\
 	case PARSE_EVENTS__TERM_TYPE_NAME:
 		CHECK_TYPE_VAL(STR);
 		break;
+	case PARSE_EVENTS__TERM_TYPE_PRECISE:
+		CHECK_TYPE_VAL(NUM);
+		if ((unsigned)term->val.num > 2)
+			return -EINVAL;
+		attr->precise_ip = term->val.num;
+		break;
 	default:
 		return -EINVAL;
 	}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index ac9a6aa..c1166dd 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -49,6 +49,7 @@ enum {
 	PARSE_EVENTS__TERM_TYPE_NAME,
 	PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD,
 	PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE,
+	PARSE_EVENTS__TERM_TYPE_PRECISE,
 };
 
 struct parse_events__term {
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 66959fa..892297f 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -169,6 +169,7 @@ period			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
 ,			{ return ','; }
 "/"			{ BEGIN(INITIAL); return '/'; }
+precise			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_PRECISE); }
 {name_minus}		{ return str(yyscanner, PE_NAME); }
 }
 
-- 
1.7.7.6

