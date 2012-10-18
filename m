Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab2JRXUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:20:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:20461 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594Ab2JRXT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:19:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,609,1344236400"; 
   d="scan'208";a="229462634"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 33/34] perf, tools: Default to cpu// for events v2
Date: Thu, 18 Oct 2012 16:19:41 -0700
Message-Id: <1350602382-12771-34-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
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
index de1cb9e..8b08140 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -765,6 +765,23 @@ int parse_events_name(struct list_head *list, char *name)
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
@@ -785,6 +802,26 @@ static int parse_events__scanner(const char *str, void *data, int start_token)
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

