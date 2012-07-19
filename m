Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab2GSVyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 17:54:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab2GSVy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:54:29 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/4] perf, tool: Add support to update event modifier
Date: Thu, 19 Jul 2012 23:53:55 +0200
Message-Id: <1342734837-1825-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1342734837-1825-1-git-send-email-jolsa@redhat.com>
References: <1342734837-1825-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evsel.h        |    2 ++
 tools/perf/util/parse-events.c |   74 +++++++++++++++++++++++++++++++++-------
 tools/perf/util/parse-events.h |    2 +-
 tools/perf/util/parse-events.y |    2 +-
 4 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 67cc503..fbbdfa0 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -66,6 +66,8 @@ struct perf_evsel {
 		void		*data;
 	} handler;
 	bool 			supported;
+	/* parse modifier helper */
+	int			exclude_GH;
 };
 
 struct cpu_map;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 82938df..a191f4c 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -631,14 +631,38 @@ void parse_events_update_lists(struct list_head *list_event,
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
@@ -682,13 +706,39 @@ int parse_events__modifier_event(struct list_head *list, char *str)
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
index c2f2ed9..84228d5 100644
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
index 11b6972..f879acf 100644
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
-- 
1.7.10.4

