Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166Ab2JaAf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 20:35:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:31172 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759527Ab2JaAej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 20:34:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,683,1344236400"; 
   d="scan'208";a="234886232"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, jolsa@redhat.com,
        eranian@google.com, mingo@kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 31/32] perf, tools: Default to cpu// for events v3
Date: Tue, 30 Oct 2012 17:34:22 -0700
Message-Id: <1351643663-23828-32-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351643663-23828-1-git-send-email-andi@firstfloor.org>
References: <1351643663-23828-1-git-send-email-andi@firstfloor.org>
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
v3: Move to separate function
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/parse-events.c |   45 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5b97a2b..70cbd1c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -768,6 +768,47 @@ int parse_events_name(struct list_head *list, char *name)
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
+static int parse_events__scanner(const char *str, void *data, int start_token);
+
+static int parse_events_fixup(int ret, const char *str, void *data,
+			      int start_token)
+{
+	char *o = strdup(str);
+	char *s = NULL;
+	char *t = o;
+	char *p;
+	int len = 0;
+
+	if (!o)
+		return ret;
+	while ((p = strsep(&t, ",")) != NULL) {
+		if (s)
+			str_append(&s, &len, ",");
+		str_append(&s, &len, "cpu/");
+		str_append(&s, &len, p);
+		str_append(&s, &len, "/");
+	}
+	free(o);
+	return parse_events__scanner(s, data, start_token);
+}
+
 static int parse_events__scanner(const char *str, void *data, int start_token)
 {
 	YY_BUFFER_STATE buffer;
@@ -788,7 +829,9 @@ static int parse_events__scanner(const char *str, void *data, int start_token)
 	parse_events__flush_buffer(buffer, scanner);
 	parse_events__delete_buffer(buffer, scanner);
 	parse_events_lex_destroy(scanner);
-	return ret;
+	if (ret && !strchr(str, '/'))
+		ret = parse_events_fixup(ret, str, data, start_token);
+ 	return ret;
 }
 
 /*
-- 
1.7.7.6

