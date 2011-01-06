Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab1AFKGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:06:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab1AFKGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:06:04 -0500
From: Han Pingtian <phan@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Han Pingtian <phan@redhat.com>
Subject: [PATCH] perf: fix buffer overflow error caused by specifying all tracepoints with -e option
Date: Thu,  6 Jan 2011 18:08:08 +0800
Message-Id: <1294308488-13475-2-git-send-email-phan@redhat.com>
In-Reply-To: <1294308488-13475-1-git-send-email-phan@redhat.com>
References: <1294308488-13475-1-git-send-email-phan@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found when specifying all tracepoints with -e to one of subcommand,
such as 'top', the program will trigger a buffer overflow error, like
this:

*** buffer overflow detected ***: ./perf terminated
======= Backtrace: =========
/lib64/libc.so.6(__fortify_fail+0x37)[0x382cefb2c7]
/lib64/libc.so.6[0x382cef91c0]
/lib64/libc.so.6[0x382cef82f4]
./perf[0x4250ee]
./perf[0x425ab6]
./perf[0x42437b]
./perf[0x4245b8]
./perf[0x424b80]
./perf[0x41548a]
./perf[0x405764]
./perf[0x4061b6]
/lib64/libc.so.6(__libc_start_main+0xfd)[0x382ce1ec5d]
./perf[0x405499]
======= Memory map: ========
00400000-0051d000 r-xp 00000000 fd:06 4573549 /home/hpt/temp/linux/perf/linux-2.6/tools/perf/perf
....
The tracepoints are separated by comma, something like this:

perf top -e ...,kmem:kmalloc,kmem:kfree,kmem:kmem_cache_free,...

This comment will fix this problem.

The root reason of this problem is that store_event_type() is called
with all the events, and will overflow the 'filename' at

    strncat(filename, orgname, strlen(orgname));

The comments will try to call store_event_type() when the event name has
been found out.

Signed-off-by: Han Pingtian <phan@redhat.com>
---
 tools/perf/util/parse-events.c |   62 ++++++++++++++++++++--------------------
 1 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c305305..7183fce 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -491,6 +491,32 @@ parse_multiple_tracepoint_event(char *sys_name, const char *evt_exp,
 }
 
 
+static int store_event_type(const char *orgname)
+{
+	char filename[PATH_MAX], *c;
+	FILE *file;
+	int id, n;
+
+	sprintf(filename, "%s/", debugfs_path);
+	strncat(filename, orgname, strlen(orgname));
+	strcat(filename, "/id");
+
+	c = strchr(filename, ':');
+	if (c)
+		*c = '/';
+
+	file = fopen(filename, "r");
+	if (!file)
+		return 0;
+	n = fscanf(file, "%i", &id);
+	fclose(file);
+	if (n < 1) {
+		pr_err("cannot store event ID\n");
+		return -EINVAL;
+	}
+	return perf_header__push_event(id, orgname);
+}
+
 static enum event_result parse_tracepoint_event(const char **strp,
 				    struct perf_event_attr *attr)
 {
@@ -533,9 +559,13 @@ static enum event_result parse_tracepoint_event(const char **strp,
 		*strp += strlen(sys_name) + evt_length;
 		return parse_multiple_tracepoint_event(sys_name, evt_name,
 						       flags);
-	} else
+	} else {
+		if (store_event_type(evt_name) < 0)
+			return EVT_FAILED;
+
 		return parse_single_tracepoint_event(sys_name, evt_name,
 						     evt_length, attr, strp);
+	}
 }
 
 static enum event_result
@@ -778,41 +808,11 @@ modifier:
 	return ret;
 }
 
-static int store_event_type(const char *orgname)
-{
-	char filename[PATH_MAX], *c;
-	FILE *file;
-	int id, n;
-
-	sprintf(filename, "%s/", debugfs_path);
-	strncat(filename, orgname, strlen(orgname));
-	strcat(filename, "/id");
-
-	c = strchr(filename, ':');
-	if (c)
-		*c = '/';
-
-	file = fopen(filename, "r");
-	if (!file)
-		return 0;
-	n = fscanf(file, "%i", &id);
-	fclose(file);
-	if (n < 1) {
-		pr_err("cannot store event ID\n");
-		return -EINVAL;
-	}
-	return perf_header__push_event(id, orgname);
-}
-
 int parse_events(const struct option *opt __used, const char *str, int unset __used)
 {
 	struct perf_event_attr attr;
 	enum event_result ret;
 
-	if (strchr(str, ':'))
-		if (store_event_type(str) < 0)
-			return -1;
-
 	for (;;) {
 		if (nr_counters == MAX_COUNTERS)
 			return -1;
-- 
1.7.1

