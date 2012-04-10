Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2DJKNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:13:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51652 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2DJKNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:13:31 -0400
Date: Tue, 10 Apr 2012 12:13:28 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, mingo@elte.hu, peterz@infradead.org, dsahern@gmail.com,
        namhyung.kim@lge.com
Subject: [PATCH] perf report: fix error with -g in pipe mode
Message-ID: <20120410101327.GA8104@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pipe mode, we cannot check the validity of sample_type
or the branch view mode until we start processing the events.
There is no meta-data information at the beginning of the pipe
mode stream. Instead, all the meta data is pushed via pseudo
records and those get processed by process_sample_events().

Without this patch:
  $ perf record -g -o - foo | perf inject -b | perf report -g -i -
  Selected -g but no callchain data. Did you call 'perf record' without -g?

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2e31743..c338b97 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -249,6 +249,13 @@ static int perf_report__setup_sample_type(struct perf_report *rep)
 {
 	struct perf_session *self = rep->session;
 
+	/*
+	 * cannot determine sample type, branch mode until we have
+	 * processed the meta-data pseudo records via process_sample_events()
+	 */
+	if (self->fd_pipe)
+		return 0;
+
 	if (!(self->sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
 			ui__warning("Selected --sort parent, but no "
