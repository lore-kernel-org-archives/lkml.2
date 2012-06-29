Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab2F2QUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:20:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44552 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277Ab2F2QUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:20:30 -0400
Date: Fri, 29 Jun 2012 09:20:11 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-300aa941650e98966ad85847527537df5b11a87e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        tim.c.chen@linux.intel.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1339444121-26236-1-git-send-email-dsahern@gmail.com>
References: <1339444121-26236-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Delay sample_type checks in pipe mode
Git-Commit-ID: 300aa941650e98966ad85847527537df5b11a87e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 29 Jun 2012 09:20:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  300aa941650e98966ad85847527537df5b11a87e
Gitweb:     http://git.kernel.org/tip/300aa941650e98966ad85847527537df5b11a87e
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 11 Jun 2012 13:48:41 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Jun 2012 13:19:14 -0300

perf report: Delay sample_type checks in pipe mode

The pipeline:
  perf record -a -g -o - sleep 5 |perf inject -v -b  | perf report  -g -i -

generates the warning:
  Selected -g but no callchain data. Did you call 'perf record' without -g?

The problem is that the header data is not written to the pipe, so the
sample_type has not been available when perf_report__setup_sample_type
is called. For pipe mode, record dumps the sample type as part of the
synthesized events stream -- perf_event__synthesize_attrs(). Handle this
be detecting pipe mode and not doing early sanity checks on sample_type.

Signed-off-by: David Ahern <dsahern@gmail.com>
Tested-by: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Link: http://lkml.kernel.org/r/1339444121-26236-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 40b0ffc..69b1c11 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -245,11 +245,12 @@ static int process_read_event(struct perf_tool *tool,
 	return 0;
 }
 
+/* For pipe mode, sample_type is not currently set */
 static int perf_report__setup_sample_type(struct perf_report *rep)
 {
 	struct perf_session *self = rep->session;
 
-	if (!(self->sample_type & PERF_SAMPLE_CALLCHAIN)) {
+	if (!self->fd_pipe && !(self->sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
 			ui__error("Selected --sort parent, but no "
 				    "callchain data. Did you call "
@@ -272,7 +273,8 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 	}
 
 	if (sort__branch_mode == 1) {
-		if (!(self->sample_type & PERF_SAMPLE_BRANCH_STACK)) {
+		if (!self->fd_pipe &&
+		    !(self->sample_type & PERF_SAMPLE_BRANCH_STACK)) {
 			ui__error("Selected -b but no branch data. "
 				  "Did you call perf record without -b?\n");
 			return -1;
