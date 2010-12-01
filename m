Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab0LAJPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 04:15:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:54329 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab0LAJPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 04:15:18 -0500
Date: Wed, 1 Dec 2010 09:14:14 GMT
From: tip-bot for Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        julia@diku.dk, hpa@zytor.com, mingo@redhat.com, michaele@au1.ibm.com,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, julia@diku.dk, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, michaele@au1.ibm.com,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1291156021-17711-1-git-send-email-cjashfor@linux.vnet.ibm.com>
References: <1291156021-17711-1-git-send-email-cjashfor@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: fix event parsing of comma-separated tracepoint events
Message-ID: <tip-4c635a4e04700a371ef7e4d4bb33ed88747e801e@git.kernel.org>
Git-Commit-ID: 4c635a4e04700a371ef7e4d4bb33ed88747e801e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 01 Dec 2010 09:14:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c635a4e04700a371ef7e4d4bb33ed88747e801e
Gitweb:     http://git.kernel.org/tip/4c635a4e04700a371ef7e4d4bb33ed88747e801e
Author:     Corey Ashford <cjashfor@linux.vnet.ibm.com>
AuthorDate: Tue, 30 Nov 2010 14:27:01 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 30 Nov 2010 23:04:39 -0200

perf tools: fix event parsing of comma-separated tracepoint events

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
