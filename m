Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2DONlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 09:41:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106Ab2DONlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 09:41:06 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/6] perf, tool: Separate 'mem:' event scanner bits
Date: Sun, 15 Apr 2012 15:40:33 +0200
Message-Id: <1334497234-5441-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334497234-5441-1-git-send-email-jolsa@redhat.com>
References: <1334497234-5441-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separating 'mem:' scanner processing, so we can parse out
modifier specifically and dont clash with other rules.

This is just precaution for the future, so we dont need to worry
about the rules clashing where we need to parse out any sub-rule
of global rules.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c |    1 +
 tools/perf/util/parse-events.l |   25 +++++++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4025e18..59324e7 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -787,6 +787,7 @@ int parse_events(struct perf_evlist *evlist, const char *str, int unset __used)
 
 	parse_events__flush_buffer(buffer);
 	parse_events__delete_buffer(buffer);
+	parse_events_lex_destroy();
 
 	if (!ret) {
 		int entries = idx - evlist->nr_entries;
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 05d766e..84644dd 100644
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
@@ -105,13 +108,12 @@ config2			{ return term(PARSE_EVENTS__TERM_TYPE_CONFIG2); }
 period			{ return term(PARSE_EVENTS__TERM_TYPE_SAMPLE_PERIOD); }
 branch_type		{ return term(PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE); }
 
-mem:			{ return PE_PREFIX_MEM; }
+mem:			{ BEGIN(mem); return PE_PREFIX_MEM; }
 r{num_raw_hex}		{ return raw(); }
 {num_dec}		{ return value(10); }
 {num_hex}		{ return value(16); }
 
 {modifier_event}	{ return str(PE_MODIFIER_EVENT); }
-{modifier_bp}		{ return str(PE_MODIFIER_BP); }
 {name}			{ return str(PE_NAME); }
 "/"			{ return '/'; }
 -			{ return '-'; }
@@ -119,6 +121,25 @@ r{num_raw_hex}		{ return raw(); }
 :			{ return ':'; }
 =			{ return '='; }
 
+<mem>{
+{modifier_bp}		{ return str(PE_MODIFIER_BP); }
+:			{ return ':'; }
+{num_dec}		{ return value(10); }
+{num_hex}		{ return value(16); }
+	/*
+	 * We need to separate 'mem:' scanner part, in order to get specific
+	 * modifier bits parsed out. Otherwise we would need to handle PE_NAME
+	 * and we'd need to parse it manually. During the escape from <mem>
+	 * state we need to put the escaping char back, so we dont miss it.
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

