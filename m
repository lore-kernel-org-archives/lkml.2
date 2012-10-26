Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422650Ab2JZUcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 16:32:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:50702 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759147Ab2JZUab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 16:30:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,656,1344236400"; 
   d="scan'208";a="211355423"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 32/33] perf, tools: Default to cpu// for events v2
Date: Fri, 26 Oct 2012 13:30:14 -0700
Message-Id: <1351283415-13170-33-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When an event fails to parse and it's not in a new style format,
try to parse it again as a cpu event.

This allows to use sysfs exported events directly without //, so I can use

perf record -e tx-aborts ...

instead of

perf record -e cpu/tx-aborts/

v2: Handle multiple events
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/parse-events.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index f800765..ee6a73c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -768,6 +768,23 @@ int parse_events_name(struct list_head *list, char *name)
 	return 0;
 }
 
+static void str_append(char **s, int *len, const char *a)
+{
+	int olen = *s ? strlen(*s) : 0;
+	int nlen = olen + strlen(a) + 1;
+	if (*len < nlen) { 
+		*len = *len * 2;
+		if (*len < nlen)
+			*len = nlen;
+		*s = realloc(*s, *len);
+		if (!*s) 
+			exit(ENOMEM);
+		if (olen == 0)
+			**s = 0;
+	}
+	strcat(*s, a);
+}
+
 static int parse_events__scanner(const char *str, void *data, int start_token)
 {
 	YY_BUFFER_STATE buffer;
@@ -788,6 +805,26 @@ static int parse_events__scanner(const char *str, void *data, int start_token)
 	parse_events__flush_buffer(buffer, scanner);
 	parse_events__delete_buffer(buffer, scanner);
 	parse_events_lex_destroy(scanner);
+
+	if (ret && !strchr(str, '/')) {
+		char *o = strdup(str);
+		char *s = NULL;
+		char *t = o;
+		char *p;
+		int len = 0;
+
+		if (!o)
+			return ret;
+		while ((p = strsep(&t, ",")) != NULL) {
+			if (s)
+				str_append(&s, &len, ",");
+			str_append(&s, &len, "cpu/");
+			str_append(&s, &len, p);
+			str_append(&s, &len, "/");
+		}
+		free(o);
+		ret = parse_events__scanner(s, data, start_token);
+	}
 	return ret;
 }
 
-- 
1.7.7.6

