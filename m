Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab2F0TWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:22:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:59469 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230Ab2F0TVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:21:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/7] perf report: Delay sample_type checks in pipe mode
Date: Wed, 27 Jun 2012 16:20:53 -0300
Message-Id: <1340824854-3005-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340824854-3005-1-git-send-email-acme@infradead.org>
References: <1340824854-3005-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
-- 
1.7.1

