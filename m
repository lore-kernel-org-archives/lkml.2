Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2LHPBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 10:01:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49650 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab2LHPBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 10:01:09 -0500
Date: Sat, 8 Dec 2012 07:00:45 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-534123f458f196bcc269f97d20ccf125925c2e7b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20121113143258.GA2481@krava.brq.redhat.com>
References: <20121113143258.GA2481@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add basic event modifier sanity check
Git-Commit-ID: 534123f458f196bcc269f97d20ccf125925c2e7b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 08 Dec 2012 07:00:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  534123f458f196bcc269f97d20ccf125925c2e7b
Gitweb:     http://git.kernel.org/tip/534123f458f196bcc269f97d20ccf125925c2e7b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 13 Nov 2012 15:32:58 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Nov 2012 16:52:24 -0300

perf tools: Add basic event modifier sanity check

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
 tools/perf/util/parse-events.c | 24 ++++++++++++++++++++++++
 tools/perf/util/parse-events.l |  2 +-
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
