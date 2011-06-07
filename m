Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab1FGXzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 19:55:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61209 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab1FGXzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 19:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PKRMUuHDJLwMV6e4YTibsfDFW8Hbch9NEXWzA8ZHSQmImYggLaYMO0H+pUnGnLFGQy
         /ux6ylR9JrhaDRfGn1GYtrA8UOndgcHjhgnzvb3SDT3Y8U8J2rzht+FGx8tkoezQV7n3
         i2P9FWKRB6ke38QmghrWoKCg/vdIBJNqx8e6I=
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/6] perf utils: export parse_single_tracepoint_event
Date: Tue,  7 Jun 2011 17:55:26 -0600
Message-Id: <1307490926-24639-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For use by perf-record in later patch. Allow strp arg to be NULL
as well.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/parse-events.c |   13 ++++---------
 tools/perf/util/parse-events.h |   12 ++++++++++++
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 41982c3..c15a701 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -19,12 +19,6 @@ struct event_symbol {
 	const char	*alias;
 };
 
-enum event_result {
-	EVT_FAILED,
-	EVT_HANDLED,
-	EVT_HANDLED_ALL
-};
-
 char debugfs_path[MAXPATHLEN];
 
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
@@ -432,8 +426,8 @@ parse_generic_hw_event(const char **str, struct perf_event_attr *attr)
 	return EVT_HANDLED;
 }
 
-static enum event_result
-parse_single_tracepoint_event(char *sys_name,
+enum event_result
+parse_single_tracepoint_event(const char *sys_name,
 			      const char *evt_name,
 			      unsigned int evt_length,
 			      struct perf_event_attr *attr,
@@ -460,7 +454,8 @@ parse_single_tracepoint_event(char *sys_name,
 	id = atoll(id_buf);
 	attr->config = id;
 	attr->type = PERF_TYPE_TRACEPOINT;
-	*strp += strlen(sys_name) + evt_length + 1; /* + 1 for the ':' */
+	if (strp)
+		*strp += strlen(sys_name) + evt_length + 1; /* + 1 for the ':' */
 
 	attr->sample_type |= PERF_SAMPLE_RAW;
 	attr->sample_type |= PERF_SAMPLE_TIME;
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 746d3fc..e65f724 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -17,6 +17,12 @@ struct tracepoint_path {
 	struct tracepoint_path *next;
 };
 
+enum event_result {
+	EVT_FAILED,
+	EVT_HANDLED,
+	EVT_HANDLED_ALL
+};
+
 extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
 extern bool have_tracepoints(struct list_head *evlist);
 
@@ -26,6 +32,12 @@ extern const char *__event_name(int type, u64 config);
 
 extern int parse_events(const struct option *opt, const char *str, int unset);
 extern int parse_filter(const struct option *opt, const char *str, int unset);
+extern enum event_result
+parse_single_tracepoint_event(const char *sys_name,
+			      const char *evt_name,
+			      unsigned int evt_length,
+			      struct perf_event_attr *attr,
+			      const char **strp);
 
 #define EVENTS_HELP_MAX (128*1024)
 
-- 
1.7.5.2

