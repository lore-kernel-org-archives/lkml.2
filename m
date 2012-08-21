Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab2HUQQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:16:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60867 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2HUQP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:15:59 -0400
Date: Tue, 21 Aug 2012 09:15:23 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-8peaey3e2qc9dwtkvzbi4wmx@git.kernel.org>
Cc: acme@redhat.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, peterz@infradead.org, jolsa@redhat.com,
        drepper@gmail.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, namhyung@kernel.org,
        mingo@elte.hu
Reply-To: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, acme@ghostprotocols.net,
        namhyung@kernel.org, jolsa@redhat.com, drepper@gmail.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add support to update event modifier
Git-Commit-ID: f5b1135bf79557563a814e53ecd610cce663c1e3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:15:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5b1135bf79557563a814e53ecd610cce663c1e3
Gitweb:     http://git.kernel.org/tip/f5b1135bf79557563a814e53ecd610cce663c1e3
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 8 Aug 2012 12:21:54 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Aug 2012 17:03:47 -0300

perf tools: Add support to update event modifier

Adding support to update already defined event's attribute with
event modifier. This change will allow to use group modifier as
an update to the existing event modifiers.

Adding 'add' parameter to the parse_events__modifier_event function.
Calling it with 'add' = false/true, the event modifier is
initialized/updated respectively.

Added exclude_GH flag to evsel struct, because we need to remember
if one of 'GH' modifiers was used for event. The reason is that the
default settings for exclude_guest is 1 and during the group
modifier processing we have no other way of knowing if it was set
by default or by event modifier.

Keeping the current behaviour, that any event/group modifier reset
the defaults for exclude_host (0) and exclude_guest (1).

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/n/tip-8peaey3e2qc9dwtkvzbi4wmx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.h        |    2 +
 tools/perf/util/parse-events.c |   74 +++++++++++++++++++++++++++++++++------
 tools/perf/util/parse-events.h |    2 +-
 tools/perf/util/parse-events.y |    2 +-
 4 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index a56c457..6a258c9 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -68,6 +68,8 @@ struct perf_evsel {
 	} handler;
 	unsigned int		sample_size;
 	bool 			supported;
+	/* parse modifier helper */
+	int			exclude_GH;
 };
 
 struct cpu_map;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 57d5809..4364575 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -633,14 +633,38 @@ void parse_events_update_lists(struct list_head *list_event,
 	free(list_event);
 }
 
-int parse_events__modifier_event(struct list_head *list, char *str)
+struct event_modifier {
+	int eu;
+	int ek;
+	int eh;
+	int eH;
+	int eG;
+	int precise;
+	int exclude_GH;
+};
+
+static int get_event_modifier(struct event_modifier *mod, char *str,
+			       struct perf_evsel *evsel)
 {
-	struct perf_evsel *evsel;
-	int exclude = 0, exclude_GH = 0;
-	int eu = 0, ek = 0, eh = 0, eH = 0, eG = 0, precise = 0;
+	int eu = evsel ? evsel->attr.exclude_user : 0;
+	int ek = evsel ? evsel->attr.exclude_kernel : 0;
+	int eh = evsel ? evsel->attr.exclude_hv : 0;
+	int eH = evsel ? evsel->attr.exclude_host : 0;
+	int eG = evsel ? evsel->attr.exclude_guest : 0;
+	int precise = evsel ? evsel->attr.precise_ip : 0;
 
-	if (str == NULL)
-		return 0;
+	int exclude = eu | ek | eh;
+	int exclude_GH = evsel ? evsel->exclude_GH : 0;
+
+	/*
+	 * We are here for group and 'GH' was not set as event
+	 * modifier and whatever event/group modifier override
+	 * default 'GH' setup.
+	 */
+	if (evsel && !exclude_GH)
+		eH = eG = 0;
+
+	memset(mod, 0, sizeof(*mod));
 
 	while (*str) {
 		if (*str == 'u') {
@@ -684,13 +708,39 @@ int parse_events__modifier_event(struct list_head *list, char *str)
 	if (precise > 3)
 		return -EINVAL;
 
+	mod->eu = eu;
+	mod->ek = ek;
+	mod->eh = eh;
+	mod->eH = eH;
+	mod->eG = eG;
+	mod->precise = precise;
+	mod->exclude_GH = exclude_GH;
+	return 0;
+}
+
+int parse_events__modifier_event(struct list_head *list, char *str, bool add)
+{
+	struct perf_evsel *evsel;
+	struct event_modifier mod;
+
+	if (str == NULL)
+		return 0;
+
+	if (!add && get_event_modifier(&mod, str, NULL))
+		return -EINVAL;
+
 	list_for_each_entry(evsel, list, node) {
-		evsel->attr.exclude_user   = eu;
-		evsel->attr.exclude_kernel = ek;
-		evsel->attr.exclude_hv     = eh;
-		evsel->attr.precise_ip     = precise;
-		evsel->attr.exclude_host   = eH;
-		evsel->attr.exclude_guest  = eG;
+
+		if (add && get_event_modifier(&mod, str, evsel))
+			return -EINVAL;
+
+		evsel->attr.exclude_user   = mod.eu;
+		evsel->attr.exclude_kernel = mod.ek;
+		evsel->attr.exclude_hv     = mod.eh;
+		evsel->attr.precise_ip     = mod.precise;
+		evsel->attr.exclude_host   = mod.eH;
+		evsel->attr.exclude_guest  = mod.eG;
+		evsel->exclude_GH          = mod.exclude_GH;
 	}
 
 	return 0;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index c3bb04c..75a6800 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -79,7 +79,7 @@ int parse_events__term_str(struct parse_events__term **_term,
 int parse_events__term_clone(struct parse_events__term **new,
 			     struct parse_events__term *term);
 void parse_events__free_terms(struct list_head *terms);
-int parse_events__modifier_event(struct list_head *list, char *str);
+int parse_events__modifier_event(struct list_head *list, char *str, bool add);
 int parse_events__modifier_group(struct list_head *list, char *event_mod);
 int parse_events_add_tracepoint(struct list_head **list, int *idx,
 				char *sys, char *event);
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 15e6e97..084c35f 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -153,7 +153,7 @@ event_def PE_MODIFIER_EVENT
 	 * (there could be more events added for multiple tracepoint
 	 * definitions via '*?'.
 	 */
-	ABORT_ON(parse_events__modifier_event(list, $2));
+	ABORT_ON(parse_events__modifier_event(list, $2, false));
 	$$ = list;
 }
 |
