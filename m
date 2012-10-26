Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078Ab2JZUfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:35:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:35823 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759092Ab2JZUa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:30:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,656,1344236400"; 
   d="scan'208";a="240686956"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 27/33] tools, perf: Add a precise event qualifier
Date: Fri, 26 Oct 2012 13:30:09 -0700
Message-Id: <1351283415-13170-28-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
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
index 409da3e..f800765 100644
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
index 839230c..0c78bb8 100644
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
index ef602f0..c2e5142 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -168,6 +168,7 @@ period			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
 ,			{ return ','; }
 "/"			{ BEGIN(INITIAL); return '/'; }
+precise			{ return term(yyscanner, PARSE_EVENTS__TERM_TYPE_PRECISE); }
 }
 
 mem:			{ BEGIN(mem); return PE_PREFIX_MEM; }
-- 
1.7.7.6

