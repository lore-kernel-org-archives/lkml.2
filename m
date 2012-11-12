Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab2KLRjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:39:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab2KLRjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:39:53 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/5] perf tool: Add basic event modifier sanity check
Date: Mon, 12 Nov 2012 18:34:04 +0100
Message-Id: <1352741644-16809-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1352741644-16809-1-git-send-email-jolsa@redhat.com>
References: <1352741644-16809-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating event parser to allow any non zero string containing
[ukhpGH] characters for event modifier.

The modifier sanity is checked later in parse-event object logic.
The check validates modifier to contain only one instance of any
modifier (apart from 'p') present.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c | 20 ++++++++++++++++++++
 tools/perf/util/parse-events.l |  2 +-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c0b785b..b321d43 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -722,6 +722,23 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
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
@@ -730,6 +747,9 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add)
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
1.7.11.7

