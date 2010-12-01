Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab0LABUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:20:18 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44877 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab0LABUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:20:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Julia Lawall <julia@diku.dk>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf tools: fix event parsing of comma-separated tracepoint events
Date: Tue, 30 Nov 2010 23:19:50 -0200
Message-Id: <1291166390-19467-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291166390-19467-1-git-send-email-acme@infradead.org>
References: <1291166390-19467-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Ashford <cjashfor@linux.vnet.ibm.com>

There are number of issues that prevent the use of multiple tracepoint events
being specified in a -e/--event switch, separated by commas.

For example, perf stat -e irq:irq_handler_entry,irq:irq_handler_exit ...  fails
because the tracepoint event parsing code doesn't recognize the comma separator
properly.

This patch corrects those issues.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Michael Ellerman <michaele@au1.ibm.com>
LKML-Reference: <1291156021-17711-1-git-send-email-cjashfor@linux.vnet.ibm.com>
Signed-off-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 4af5bd5..c305305 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -434,7 +434,7 @@ parse_single_tracepoint_event(char *sys_name,
 	id = atoll(id_buf);
 	attr->config = id;
 	attr->type = PERF_TYPE_TRACEPOINT;
-	*strp = evt_name + evt_length;
+	*strp += strlen(sys_name) + evt_length + 1; /* + 1 for the ':' */
 
 	attr->sample_type |= PERF_SAMPLE_RAW;
 	attr->sample_type |= PERF_SAMPLE_TIME;
@@ -495,7 +495,7 @@ static enum event_result parse_tracepoint_event(const char **strp,
 				    struct perf_event_attr *attr)
 {
 	const char *evt_name;
-	char *flags;
+	char *flags = NULL, *comma_loc;
 	char sys_name[MAX_EVENT_LENGTH];
 	unsigned int sys_length, evt_length;
 
@@ -514,6 +514,11 @@ static enum event_result parse_tracepoint_event(const char **strp,
 	sys_name[sys_length] = '\0';
 	evt_name = evt_name + 1;
 
+	comma_loc = strchr(evt_name, ',');
+	if (comma_loc) {
+		/* take the event name up to the comma */
+		evt_name = strndup(evt_name, comma_loc - evt_name);
+	}
 	flags = strchr(evt_name, ':');
 	if (flags) {
 		/* split it out: */
@@ -524,9 +529,8 @@ static enum event_result parse_tracepoint_event(const char **strp,
 	evt_length = strlen(evt_name);
 	if (evt_length >= MAX_EVENT_LENGTH)
 		return EVT_FAILED;
-
 	if (strpbrk(evt_name, "*?")) {
-		*strp = evt_name + evt_length;
+		*strp += strlen(sys_name) + evt_length;
 		return parse_multiple_tracepoint_event(sys_name, evt_name,
 						       flags);
 	} else
-- 
1.6.2.5

