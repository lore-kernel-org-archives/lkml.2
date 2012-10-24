Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934648Ab2JXKL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:11:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55310 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab2JXKLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:11:55 -0400
Date: Wed, 24 Oct 2012 03:08:33 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-1d33d6dce11e2c900daeca8110d56b95f1174188@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, jolsa@redhat.com
In-Reply-To: <1349873598-12583-8-git-send-email-jolsa@redhat.com>
References: <1349873598-12583-8-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add support to specify hw event as PMU event term
Git-Commit-ID: 1d33d6dce11e2c900daeca8110d56b95f1174188
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:08:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d33d6dce11e2c900daeca8110d56b95f1174188
Gitweb:     http://git.kernel.org/tip/1d33d6dce11e2c900daeca8110d56b95f1174188
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 10 Oct 2012 14:53:17 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:41:27 +0200

perf tools: Add support to specify hw event as PMU event term

Add a way to specify hw event as PMU event term like:

 'cpu/event=cpu-cycles/u'
 'cpu/event=instructions,.../u'
 'cpu/cycles,.../u'

The 'event=cpu-cycles' term is replaced/translated by the hw events
term translation, which is exposed by sysfs 'events' group attribute.

Add parser bits, the rest is already handled by the PMU alias code.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349873598-12583-8-git-send-email-jolsa@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/util/parse-events.c |   18 ++++++++++++++++++
 tools/perf/util/parse-events.h |    2 ++
 tools/perf/util/parse-events.y |   18 ++++++++++++++++++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 75c7b0f..2fe1587 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1142,6 +1142,24 @@ int parse_events__term_str(struct parse_events__term **term,
 			config, str, 0);
 }
 
+int parse_events__term_sym_hw(struct parse_events__term **term,
+			      char *config, unsigned idx)
+{
+	struct event_symbol *sym;
+
+	BUG_ON(idx >= PERF_COUNT_HW_MAX);
+	sym = &event_symbols_hw[idx];
+
+	if (config)
+		return new_term(term, PARSE_EVENTS__TERM_TYPE_STR,
+				PARSE_EVENTS__TERM_TYPE_USER, config,
+				(char *) sym->symbol, 0);
+	else
+		return new_term(term, PARSE_EVENTS__TERM_TYPE_STR,
+				PARSE_EVENTS__TERM_TYPE_USER,
+				(char *) "event", (char *) sym->symbol, 0);
+}
+
 int parse_events__term_clone(struct parse_events__term **new,
 			     struct parse_events__term *term)
 {
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 839230c..ac9a6aa 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -76,6 +76,8 @@ int parse_events__term_num(struct parse_events__term **_term,
 			   int type_term, char *config, u64 num);
 int parse_events__term_str(struct parse_events__term **_term,
 			   int type_term, char *config, char *str);
+int parse_events__term_sym_hw(struct parse_events__term **term,
+			      char *config, unsigned idx);
 int parse_events__term_clone(struct parse_events__term **new,
 			     struct parse_events__term *term);
 void parse_events__free_terms(struct list_head *terms);
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index cd88209..0f9914a 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -352,6 +352,15 @@ PE_NAME '=' PE_VALUE
 	$$ = term;
 }
 |
+PE_NAME '=' PE_VALUE_SYM_HW
+{
+	struct parse_events__term *term;
+	int config = $3 & 255;
+
+	ABORT_ON(parse_events__term_sym_hw(&term, $1, config));
+	$$ = term;
+}
+|
 PE_NAME
 {
 	struct parse_events__term *term;
@@ -361,6 +370,15 @@ PE_NAME
 	$$ = term;
 }
 |
+PE_VALUE_SYM_HW
+{
+	struct parse_events__term *term;
+	int config = $1 & 255;
+
+	ABORT_ON(parse_events__term_sym_hw(&term, NULL, config));
+	$$ = term;
+}
+|
 PE_TERM '=' PE_NAME
 {
 	struct parse_events__term *term;
