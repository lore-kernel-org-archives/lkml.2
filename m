Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab1BLBe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 20:34:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:44414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165Ab1BLBex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 20:34:53 -0500
Date: Sat, 12 Feb 2011 01:34:23 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Fix initializion of annotate symbol priv area
Message-ID: <tip-0849327d13a0bd7f6512b7c21f4b3e79efb2076d@git.kernel.org>
Git-Commit-ID: 0849327d13a0bd7f6512b7c21f4b3e79efb2076d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 12 Feb 2011 01:34:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0849327d13a0bd7f6512b7c21f4b3e79efb2076d
Gitweb:     http://git.kernel.org/tip/0849327d13a0bd7f6512b7c21f4b3e79efb2076d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 11 Feb 2011 12:09:54 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Feb 2011 12:09:54 -0200

perf report: Fix initializion of annotate symbol priv area

We only allocate it when in TUI mode. In --stdio mode unconditionally
initializing this area leads to memory corruption.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f403ace..f9a99a1 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -44,6 +44,7 @@ static const char	default_pretty_printing_style[] = "normal";
 static const char	*pretty_printing_style = default_pretty_printing_style;
 
 static char		callchain_default_opt[] = "fractal,0.5";
+static symbol_filter_t	annotate_init;
 
 static struct hists *perf_session__hists_findnew(struct perf_session *self,
 						 u64 event_stream, u32 type,
@@ -167,7 +168,7 @@ static int process_sample_event(union perf_event *event,
 	struct perf_event_attr *attr;
 
 	if (perf_event__preprocess_sample(event, session, &al, sample,
-					  symbol__annotate_init) < 0) {
+					  annotate_init) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
@@ -520,6 +521,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	 */
 	if (use_browser > 0) {
 		symbol_conf.priv_size = sizeof(struct annotation);
+		annotate_init	      = symbol__annotate_init;
 		/*
  		 * For searching by name on the "Browse map details".
  		 * providing it only in verbose mode not to bloat too
