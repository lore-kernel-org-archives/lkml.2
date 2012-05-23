Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965166Ab2EWPVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:21:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40813 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964930Ab2EWPVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:21:04 -0400
Date: Wed, 23 May 2012 08:19:47 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-08d2f762ac4af861b962e543fceab341f05c8886@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1337584373-2741-5-git-send-email-jolsa@redhat.com>
References: <1337584373-2741-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Separate 'mem:' event scanner bits
Git-Commit-ID: 08d2f762ac4af861b962e543fceab341f05c8886
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:19:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08d2f762ac4af861b962e543fceab341f05c8886
Gitweb:     http://git.kernel.org/tip/08d2f762ac4af861b962e543fceab341f05c8886
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 21 May 2012 09:12:52 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 11:24:04 -0300

perf tools: Separate 'mem:' event scanner bits

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
