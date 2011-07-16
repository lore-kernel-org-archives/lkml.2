Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab1GPDA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 23:00:58 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61940 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab1GPDAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 23:00:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=k9rFYLLzlOgzPhyHRBlvnazcj+JKNY0dTtmbG4cf0ERpnIraXl6Jq7PQL4AGfiX7B
	ttQdkLQXb6muwVz/PVxMQ==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 1/4] trace-cmd: Add parse error checking target
Date: Fri, 15 Jul 2011 20:00:38 -0700
Message-Id: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add another target 'check-events' which parses all the event formats and
returns whether there are any issues with the print format strings.

With an error in the format, the return value is 22 (EINVAL) and for
success, it is 0.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 trace-capture.c |    2 +-
 trace-cmd.c     |   22 ++++++++++++++++++++++
 trace-cmd.h     |    2 +-
 trace-usage.c   |    5 +++++
 trace-util.c    |   48 ++++++++++++++++++++++++++++++++----------------
 5 files changed, 61 insertions(+), 18 deletions(-)

diff --git a/trace-capture.c b/trace-capture.c
index 61ff165..5708945 100644
--- a/trace-capture.c
+++ b/trace-capture.c
@@ -1295,7 +1295,7 @@ static void tracing_dialog(struct shark_info *info, const char *tracing)
 	/* Send parse warnings to status display */
 	trace_dialog_register_alt_warning(vpr_stat);
 
-	pevent = tracecmd_local_events(tracing);
+	tracecmd_local_events(tracing, &pevent);
 	trace_dialog_register_alt_warning(NULL);
 
 	cap.pevent = pevent;
diff --git a/trace-cmd.c b/trace-cmd.c
index bff5bbf..a2b6b91 100644
--- a/trace-cmd.c
+++ b/trace-cmd.c
@@ -158,6 +158,28 @@ int main (int argc, char **argv)
 	} else if (strcmp(argv[1], "stack") == 0) {
 		trace_stack(argc, argv);
 		exit(0);
+	} else if (strcmp(argv[1], "check-events") == 0) {
+		char *tracing;
+		int ret;
+		struct pevent *pevent = NULL;
+
+		tracing = tracecmd_find_tracing_dir();
+
+		if (!tracing) {
+			printf("Can not find or mount tracing directory!\n"
+				"Either tracing is not configured for this "
+				"kernel\n"
+				"or you do not have the proper permissions to "
+				"mount the directory");
+			exit(EINVAL);
+		}
+
+		ret = tracecmd_local_events(tracing, &pevent);
+		if (pevent)
+			pevent_free(pevent);
+
+		ret ? exit(0) : exit(EINVAL);
+
 	} else if (strcmp(argv[1], "record") == 0 ||
 		   strcmp(argv[1], "start") == 0 ||
 		   strcmp(argv[1], "extract") == 0 ||
diff --git a/trace-cmd.h b/trace-cmd.h
index f436845..6aa4744 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -37,7 +37,7 @@ void tracecmd_unload_plugins(struct plugin_list *list);
 
 char **tracecmd_event_systems(const char *tracing_dir);
 char **tracecmd_system_events(const char *tracing_dir, const char *system);
-struct pevent *tracecmd_local_events(const char *tracing_dir);
+int tracecmd_local_events(const char *tracing_dir, struct pevent **event);
 char **tracecmd_local_plugins(const char *tracing_dir);
 
 char **tracecmd_add_list(char **list, const char *name, int len);
diff --git a/trace-usage.c b/trace-usage.c
index 39c8fc1..58ef167 100644
--- a/trace-usage.c
+++ b/trace-usage.c
@@ -150,6 +150,11 @@ static struct usage_help usage_help[] = {
 		"          --reset  reset the maximum stack found\n"
 	},
 	{
+		"check-events",
+		"parse trace event formats",
+		" %s check-format\n"
+	},
+	{
 		NULL, NULL, NULL
 	}
 };
diff --git a/trace-util.c b/trace-util.c
index 674f37e..91ec5a7 100644
--- a/trace-util.c
+++ b/trace-util.c
@@ -621,22 +621,22 @@ static int read_file(const char *file, char **buffer)
 	return len;
 }
 
-static void load_events(struct pevent *pevent, const char *system,
+static int load_events(struct pevent *pevent, const char *system,
 			const char *sys_dir)
 {
 	struct dirent *dent;
 	struct stat st;
 	DIR *dir;
 	int len = 0;
-	int ret;
+	int ret = 0, failure = 0;
 
 	ret = stat(sys_dir, &st);
 	if (ret < 0 || !S_ISDIR(st.st_mode))
-		return;
+		return EINVAL;
 
 	dir = opendir(sys_dir);
 	if (!dir)
-		return;
+		return errno;
 
 	while ((dent = readdir(dir))) {
 		const char *name = dent->d_name;
@@ -662,15 +662,18 @@ static void load_events(struct pevent *pevent, const char *system,
 		if (len < 0)
 			goto free_format;
 
-		pevent_parse_event(pevent, buf, len, system);
+		ret = pevent_parse_event(pevent, buf, len, system);
 		free(buf);
  free_format:
 		free(format);
  free_event:
 		free(event);
+		if (ret)
+			failure = ret;
 	}
 
 	closedir(dir);
+	return failure;
 }
 
 static int read_header(struct pevent *pevent, const char *events_dir)
@@ -704,42 +707,50 @@ static int read_header(struct pevent *pevent, const char *events_dir)
 /**
  * tracecmd_local_events - create a pevent from the events on system
  * @tracing_dir: The directory that contains the events.
+ * @event: The pointer where the list of parsed events will be returned
  *
- * Returns a pevent structure that contains the pevents local to
- * the system.
+ * Returns an int indicating if the parsing was without any errors. Success is
+ * 1.
  */
-struct pevent *tracecmd_local_events(const char *tracing_dir)
+int tracecmd_local_events(const char *tracing_dir, struct pevent **event)
 {
 	struct pevent *pevent = NULL;
 	struct dirent *dent;
 	char *events_dir;
 	struct stat st;
 	DIR *dir;
-	int ret;
+	int ret, failure = 0;
 
 	if (!tracing_dir)
-		return NULL;
+		return 0;
 
 	events_dir = append_file(tracing_dir, "events");
 	if (!events_dir)
-		return NULL;
+		return 0;
 
 	ret = stat(events_dir, &st);
-	if (ret < 0 || !S_ISDIR(st.st_mode))
+	if (ret < 0 || !S_ISDIR(st.st_mode)) {
+		failure = 1;
 		goto out_free;
+	}
 
 	dir = opendir(events_dir);
-	if (!dir)
+	if (!dir) {
+		failure = 1;
 		goto out_free;
+	}
 
 	pevent = pevent_alloc();
-	if (!pevent)
+	if (!pevent) {
+		failure = 1;
 		goto out_free;
+	}
 
 	ret = read_header(pevent, events_dir);
 	if (ret < 0) {
 		pevent_free(pevent);
 		pevent = NULL;
+		failure = 1;
 		goto out_free;
 	}
 
@@ -758,9 +769,12 @@ struct pevent *tracecmd_local_events(const char *tracing_dir)
 			continue;
 		}
 
-		load_events(pevent, name, sys);
+		ret = load_events(pevent, name, sys);
 
 		free(sys);
+
+		if (ret)
+			failure = 1;
 	}
 
 	closedir(dir);
@@ -768,7 +782,9 @@ struct pevent *tracecmd_local_events(const char *tracing_dir)
  out_free:
 	free(events_dir);
 
-	return pevent;
+	*event = pevent;
+
+	return !failure;
 }
 
 /**
-- 
1.7.3.1

