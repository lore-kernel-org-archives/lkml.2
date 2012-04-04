Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab2DDVRh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:17:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab2DDVQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:16:50 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/8] perf, tool: Separate 'mem:' event scanner bits
Date: Wed,  4 Apr 2012 23:16:13 +0200
Message-Id: <1333574176-11388-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separating 'mem:' scanner processing, so we can parse out
modifier specifically and dont clash with other rules.

This is just precaution for the future, so we dont need to worry
about the rules clashing where we need to parse out any sub-rule
of global rules.

Learning bison/flex as I go... ;)

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c |    1 +
 tools/perf/util/parse-events.l |   26 ++++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5110916..54bd4d0 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -888,6 +888,7 @@ int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 
 	parse_events__flush_buffer(buffer);
 	parse_events__delete_buffer(buffer);
+	parse_events_lex_destroy();
 
 	if (!ret) {
 		int entries = idx - evlist->nr_entries;
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index c867b34..aeadbbd 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -1,5 +1,6 @@
 
 %option prefix="parse_events_"
+%option stack
 
 %{
 #include <errno.h>
@@ -50,6 +51,8 @@ static int term(int type)
 
 %}
 
+%x mem
+
 num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
@@ -106,14 +109,13 @@ name			{ return term(PARSE_EVENTS__TERM_TYPE_NAME); }
 period			{ return term(PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
 
-mem:			{ return PE_PREFIX_MEM; }
+mem:			{ BEGIN(mem); return PE_PREFIX_MEM; }
 group=			{ return PE_PREFIX_GROUP; }
 r{num_raw_hex}		{ return raw(); }
 {num_dec}		{ return value(10); }
 {num_hex}		{ return value(16); }
 
 {modifier_event}	{ return str(PE_MODIFIER_EVENT); }
-{modifier_bp}		{ return str(PE_MODIFIER_BP); }
 {name}			{ return str(PE_NAME); }
 "/"			{ return '/'; }
 -			{ return '-'; }
@@ -123,6 +125,26 @@ r{num_raw_hex}		{ return raw(); }
 =			{ return '='; }
 \|			{ return '|'; }
 
+<mem>{
+{modifier_bp}		{ return str(PE_MODIFIER_BP); }
+:			{ return ':'; }
+{num_dec}		{ return value(10); }
+{num_hex}		{ return value(16); }
+	/*
+	 * We need to separate 'mem:' scanner part, in order to get specific
+	 * modifier bits parsed out. Othrewise we would need to handle PE_NAME
+	 * and we'd need to parse it manually. During the escape from <mem>
+	 * state we need to put the escaping char back, so we dont miss it.
+	 * TODO there should be better way..
+	 */
+.			{ unput(*parse_events_text); BEGIN(INITIAL); }
+	/*
+	 * We destroy the scanner after reaching EOF,
+	 * but anyway just to be sure get back to INIT state.
+	 */
+<<EOF>>			{ BEGIN(INITIAL); }
+}
+
 %%
 
 int parse_events_wrap(void)
-- 
1.7.7.6

