Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab0K3W13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:27:29 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45454 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab0K3W11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:27:27 -0500
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Julia Lawall <julia@diku.dk>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Subject: [PATCH] perf tools: fix event parsing of comma-separated tracepoint events
Date: Tue, 30 Nov 2010 14:27:01 -0800
Message-Id: <1291156021-17711-1-git-send-email-cjashfor@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are number of issues that prevent the use of multiple tracepoint
events being specified in a -e/--event switch, separated by commas.

For example, perf stat -e irq:irq_handler_entry,irq:irq_handler_exit ...
fails because the tracepoint event parsing code doesn't recognize the
comma separator properly.

This patch corrects those issues.

Reported-by: Michael Ellerman <michaele@au1.ibm.com>
Signed-off-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
---
 tools/perf/util/parse-events.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 898aa94..73215e7 100644
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
1.7.3.2

