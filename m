Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab2FKTsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 15:48:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32805 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2FKTst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 15:48:49 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de, tim.c.chen@linux.intel.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf report: delay sample_type checks in pipe mode
Date: Mon, 11 Jun 2012 13:48:41 -0600
Message-Id: <1339444121-26236-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pipeline:
  perf record -a -g -o - sleep 5 |perf inject -v -b  | perf report  -g -i -

generates the warning:
  Selected -g but no callchain data. Did you call 'perf record' without -g?

The problem is that the header data is not written to the pipe, so the
sample_type has not been available when perf_report__setup_sample_type is
called. For pipe mode, record dumps the sample type as part of the
synthesized events stream -- perf_event__synthesize_attrs(). Handle this
be detecting pipe mode and not doing early sanity checks on sample_type.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-report.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ebcb3e2..9b3e9e9 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -246,11 +246,12 @@ static int process_read_event(struct perf_tool *tool,
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
@@ -273,7 +274,8 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 	}
 
 	if (sort__branch_mode == 1) {
-		if (!(self->sample_type & PERF_SAMPLE_BRANCH_STACK)) {
+		if (!self->fd_pipe &&
+		    !(self->sample_type & PERF_SAMPLE_BRANCH_STACK)) {
 			ui__error("Selected -b but no branch data. "
 				  "Did you call perf record without -b?\n");
 			return -1;
-- 
1.7.10.1

