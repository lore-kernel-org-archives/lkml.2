Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab2KROeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:34:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36578 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2KROaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/32] perf tools: Add basic event modifier sanity check
Date: Sun, 18 Nov 2012 11:29:47 -0300
Message-Id: <1353248997-30763-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Updating event parser to allow any non zero string containing [ukhpGH]
characters for event modifier.

The modifier sanity is checked later in parse-event object logic.  The
check validates modifier to contain only one instance of any modifier
(apart from 'p') present.

v2:
  - added length check suggested Namhyung Kim

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20121113143258.GA2481@krava.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |   24 ++++++++++++++++++++++++
 tools/perf/util/parse-events.l |    2 +-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c0b785b..020323a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -722,6 +722,27 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 	return 0;
 }
 
+/*
+ * Basic modifier sanity check to validate it contains only one
+ * instance of any modifier (apart from 'p') present.
+ */
+static int check_modifier(char *str)
+{
+	char *p = str;
+
+	/* The sizeof includes 0 byte as well. */
+	if (strlen(str) > (sizeof("ukhGHppp") - 1))
+		return -1;
+
+	while (*p) {
+		if (*p != 'p' && strchr(p + 1, *p))
+			return -1;
+		p++;
+	}
+
+	return 0;
+}
+
 int parse_events__modifier_event(struct list_head *list, char *str, bool add)
 {
 	struct perf_evsel *evsel;
@@ -730,6 +751,9 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add)
 	if (str == NULL)
 		return 0;
 
+	if (check_modifier(str))
+		return -EINVAL;
+
 	if (!add && get_event_modifier(&mod, str, NULL))
 		return -EINVAL;
 
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 66959fa..e9d1134 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -82,7 +82,7 @@ num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
 name_minus	[a-zA-Z_*?][a-zA-Z0-9\-_*?]*
-modifier_event	[ukhpGH]{1,8}
+modifier_event	[ukhpGH]+
 modifier_bp	[rwx]{1,3}
 
 %%
-- 
1.7.9.2.358.g22243

