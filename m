Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052Ab2EVRlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:41:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:60451 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab2EVRkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:40:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/19] perf tools: Separate 'mem:' event scanner bits
Date: Tue, 22 May 2012 14:40:02 -0300
Message-Id: <1337708407-24522-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1337708407-24522-1-git-send-email-acme@infradead.org>
References: <1337708407-24522-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Separating 'mem:' scanner processing, so we can parse out modifier
specifically and dont clash with other rules.

This is just precaution for the future, so we dont need to worry about
the rules clashing where we need to parse out any sub-rule of global
rules.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337584373-2741-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index 1fcf1bb..331d28a 100644
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
1.7.9.2.358.g22243

