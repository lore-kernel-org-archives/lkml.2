Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab1HKThs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:37:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15686 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab1HKThq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:37:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=vSf6lY+IdwfNeWYAQoUNeakz1apFZ/YvTNeb1xJ/f97dSmTEGtlvo8zLctZD97LU8
	x/qAIzzpDbxCWBa0ii26A==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 3/5] trace-cmd: Load plugins before parsing events in check-events
Date: Thu, 11 Aug 2011 12:37:37 -0700
Message-Id: <1313091459-12049-3-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313091459-12049-1-git-send-email-vnagarnaik@google.com>
References: <1313091459-12049-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The target check-events parses the event format strings on the local
machine and returns whether they can be parsed or not. The parsing
functionality is extended by loading plugins, if available.

This patch loads the plugins before starting parsing of the event
formats.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 trace-cmd.c   |   21 ++++++++++++++++++---
 trace-cmd.h   |    1 +
 trace-usage.c |    3 ++-
 trace-util.c  |   47 +++++++++++++++++++++++++++++++----------------
 4 files changed, 52 insertions(+), 20 deletions(-)

diff --git a/trace-cmd.c b/trace-cmd.c
index 5cfd97f..b5bcbb3 100644
--- a/trace-cmd.c
+++ b/trace-cmd.c
@@ -162,7 +162,19 @@ int main (int argc, char **argv)
 		char *tracing;
 		int ret;
 		struct pevent *pevent = NULL;
+		struct plugin_list *list = NULL;
 
+		while ((c = getopt(argc-1, argv+1, "+hN")) >= 0) {
+			switch (c) {
+			case 'h':
+			default:
+				usage(argv);
+				break;
+			case 'N':
+				tracecmd_disable_plugins = 1;
+				break;
+			}
+		}
 		tracing = tracecmd_find_tracing_dir();
 
 		if (!tracing) {
@@ -175,11 +187,14 @@ int main (int argc, char **argv)
 		}
 
 		ret = 0;
-		pevent = tracecmd_local_events(tracing);
+		pevent = pevent_alloc();
 		if (!pevent)
 			exit(EINVAL);
-		if (pevent->parsing_failures)
+		list = tracecmd_load_plugins(pevent);
+		ret = tracecmd_fill_local_events(tracing, pevent);
+		if (ret || pevent->parsing_failures)
 			ret = EINVAL;
+		tracecmd_unload_plugins(list);
 		pevent_free(pevent);
 		exit(ret);
 
diff --git a/trace-cmd.h b/trace-cmd.h
index 66cdb28..d2d0cef 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -38,6 +38,7 @@ void tracecmd_unload_plugins(struct plugin_list *list);
 char **tracecmd_event_systems(const char *tracing_dir);
 char **tracecmd_system_events(const char *tracing_dir, const char *system);
 struct pevent *tracecmd_local_events(const char *tracing_dir);
+int tracecmd_fill_local_events(const char *tracing_dir, struct pevent *pevent);
 char **tracecmd_local_plugins(const char *tracing_dir);
 
 char **tracecmd_add_list(char **list, const char *name, int len);
diff --git a/trace-usage.c b/trace-usage.c
index 58ef167..7314657 100644
--- a/trace-usage.c
+++ b/trace-usage.c
@@ -152,7 +152,8 @@ static struct usage_help usage_help[] = {
 	{
 		"check-events",
 		"parse trace event formats",
-		" %s check-format\n"
+		" %s check-format [-N]\n"
+		"          -N do not load any plugins\n"
 	},
 	{
 		NULL, NULL, NULL
diff --git a/trace-util.c b/trace-util.c
index 01894f8..e128188 100644
--- a/trace-util.c
+++ b/trace-util.c
@@ -714,6 +714,28 @@ static int read_header(struct pevent *pevent, const char *events_dir)
 struct pevent *tracecmd_local_events(const char *tracing_dir)
 {
 	struct pevent *pevent = NULL;
+
+	pevent = pevent_alloc();
+	if (!pevent)
+		return NULL;
+
+	if (tracecmd_fill_local_events(tracing_dir, pevent)) {
+		pevent_free(pevent);
+		pevent = NULL;
+	}
+
+	return pevent;
+}
+
+/**
+ * tracecmd_fill_local_events - Fill a pevent with the events on system
+ * @tracing_dir: The directory that contains the events.
+ * @pevent: Allocated pevent which will be filled
+ *
+ * Returns whether the operation succeeded
+ */
+int tracecmd_fill_local_events(const char *tracing_dir, struct pevent *pevent)
+{
 	struct dirent *dent;
 	char *events_dir;
 	struct stat st;
@@ -721,35 +743,27 @@ struct pevent *tracecmd_local_events(const char *tracing_dir)
 	int ret, failure = 0;
 
 	if (!tracing_dir)
-		return NULL;
+		return -1;
 
 	events_dir = append_file(tracing_dir, "events");
 	if (!events_dir)
-		return NULL;
+		return -1;
 
 	ret = stat(events_dir, &st);
 	if (ret < 0 || !S_ISDIR(st.st_mode)) {
-		failure = 1;
+		ret = -1;
 		goto out_free;
 	}
 
 	dir = opendir(events_dir);
 	if (!dir) {
-		failure = 1;
-		goto out_free;
-	}
-
-	pevent = pevent_alloc();
-	if (!pevent) {
-		failure = 1;
+		ret = -1;
 		goto out_free;
 	}
 
 	ret = read_header(pevent, events_dir);
 	if (ret < 0) {
-		pevent_free(pevent);
-		pevent = NULL;
-		failure = 1;
+		ret = -1;
 		goto out_free;
 	}
 
@@ -777,14 +791,15 @@ struct pevent *tracecmd_local_events(const char *tracing_dir)
 	}
 
 	closedir(dir);
+	/* always succeed because parsing failures are not critical */
+	ret = 0;
 
  out_free:
 	free(events_dir);
 
-	if (pevent)
-		pevent->parsing_failures = failure;
+	pevent->parsing_failures = failure;
 
-	return pevent;
+	return ret;
 }
 
 /**
-- 
1.7.3.1

