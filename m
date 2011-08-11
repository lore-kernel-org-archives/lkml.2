Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1HKTht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:37:49 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15687 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1HKThq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:37:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=apSTcdg5Jcpx82K6dzYPJ2ozU6tk0CL2TiGDq2vBpFlIKDVXThtOZgB2dFZDjNuYz
	tBwakiHLXdGQNnW/tKmMw==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 4/5] trace-cmd: Add --check-events to report
Date: Thu, 11 Aug 2011 12:37:38 -0700
Message-Id: <1313091459-12049-4-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313091459-12049-1-git-send-email-vnagarnaik@google.com>
References: <1313091459-12049-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new option --check-events to the report target which makes sure
that the event formats in the trace data file can be parsed correctly on
the machine that trace-cmd is running on. It returns EINVAL(22) for
parsing failures and 0 for success.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 trace-input.c |   16 ++++++++++------
 trace-read.c  |   20 ++++++++++++++++++--
 trace-usage.c |    1 +
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/trace-input.c b/trace-input.c
index 723d47f..8c2b858 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -342,10 +342,12 @@ static int read_ftrace_file(struct tracecmd_input *handle,
 		return -1;
 	}
 
-	if (print)
+	if (print) {
 		printf("%.*s\n", (int)size, buf);
-	else
-		pevent_parse_event(pevent, buf, size, "ftrace");
+	} else {
+		if (pevent_parse_event(pevent, buf, size, "ftrace"))
+			pevent->parsing_failures = 1;
+	}
 	free(buf);
 
 	return 0;
@@ -367,10 +369,12 @@ static int read_event_file(struct tracecmd_input *handle,
 		return -1;
 	}
 
-	if (print)
+	if (print) {
 		printf("%.*s\n", (int)size, buf);
-	else
-		pevent_parse_event(pevent, buf, size, system);
+	} else {
+		if (pevent_parse_event(pevent, buf, size, system))
+			pevent->parsing_failures = 1;
+	}
 	free(buf);
 
 	return 0;
diff --git a/trace-read.c b/trace-read.c
index 38e3534..2e45bff 100644
--- a/trace-read.c
+++ b/trace-read.c
@@ -826,6 +826,7 @@ static void process_plugin_option(char *option)
 }
 
 enum {
+	OPT_check_event_parsing	= 252,
 	OPT_kallsyms	= 253,
 	OPT_events	= 254,
 	OPT_cpu		= 255,
@@ -848,6 +849,8 @@ void trace_report (int argc, char **argv)
 	int test_filters = 0;
 	int raw = 0;
 	int neg = 0;
+	int ret = 0;
+	int check_event_parsing = 0;
 	int c;
 
 	list_head_init(&handle_list);
@@ -868,6 +871,8 @@ void trace_report (int argc, char **argv)
 			{"events", no_argument, NULL, OPT_events},
 			{"filter-test", no_argument, NULL, 'T'},
 			{"kallsyms", required_argument, NULL, OPT_kallsyms},
+			{"check-events", no_argument, NULL,
+				OPT_check_event_parsing},
 			{"help", no_argument, NULL, '?'},
 			{NULL, 0, NULL, 0}
 		};
@@ -948,6 +953,9 @@ void trace_report (int argc, char **argv)
 		case OPT_kallsyms:
 			functions = optarg;
 			break;
+		case OPT_check_event_parsing:
+			check_event_parsing = 1;
+			break;
 		default:
 			usage(argv);
 		}
@@ -1005,8 +1013,16 @@ void trace_report (int argc, char **argv)
 			return;
 		}
 
-		if (tracecmd_read_headers(handle) < 0)
-			return;
+		ret = tracecmd_read_headers(handle);
+		if (check_event_parsing) {
+			if (ret || pevent->parsing_failures)
+				exit(EINVAL);
+			else
+				exit(0);
+		} else {
+			if (ret)
+				return;
+		}
 
 		if (show_funcs) {
 			pevent_print_funcs(pevent);
diff --git a/trace-usage.c b/trace-usage.c
index 7314657..0e2194e 100644
--- a/trace-usage.c
+++ b/trace-usage.c
@@ -91,6 +91,7 @@ static struct usage_help usage_help[] = {
 		"          -w show wakeup latencies\n"
 		"          -l show latency format (default with latency tracers)\n"
 		"          -O plugin option -O [plugin:]var[=val]\n"
+		"          --check-events return whether all event formats can be parsed\n"
 	},
 	{
 		"split",
-- 
1.7.3.1

