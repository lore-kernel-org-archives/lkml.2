Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1AFUSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:18:17 -0500
Received: from canuck.infradead.org ([134.117.69.58]:56035 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab1AFUSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:18:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Han Pingtian <phan@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf tools: Fix buffer overflow error when specifying all tracepoints
Date: Thu,  6 Jan 2011 18:18:08 -0200
Message-Id: <1294345089-7461-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1294345089-7461-1-git-send-email-acme@infradead.org>
References: <1294345089-7461-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Han Pingtian <phan@redhat.com>

I found when specifying all tracepoints with -e to one of subcommand,
such as 'stat', the program will trigger a buffer overflow error, like
this:

*** buffer overflow detected ***: ./perf terminated
======= Backtrace: =========
/lib64/libc.so.6(__fortify_fail+0x37)[0x382cefb2c7]
....

The tracepoints are separated by comma, something like this:

$ perf stat -a -e `perf list |grep Tracepoint|awk -F'[' '{gsub(/[[:space:]]+/,"",$1);array[FNR]=$1}END{outputs=array[1];for (i=2;i<=FNR;i++){ outputs=outputs "," array[i];};print outputs}'`

The root reason of this problem is that store_event_type() is called for all
events, and will overflow the 'filename' at:

    strncat(filename, orgname, strlen(orgname));

This patch fixes it by calling store_event_type() only when the event name has
been found.

LKML-Reference: <20110106093922.GB6713@hpt.nay.redhat.com>
Signed-off-by: Han Pingtian <phan@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |   61 +++++++++++++++++++--------------------
 1 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 649083f..917a0ca 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -490,6 +490,31 @@ parse_multiple_tracepoint_event(char *sys_name, const char *evt_exp,
 	return EVT_HANDLED_ALL;
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
 
 static enum event_result parse_tracepoint_event(const char **strp,
 				    struct perf_event_attr *attr)
@@ -533,9 +558,13 @@ static enum event_result parse_tracepoint_event(const char **strp,
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
@@ -778,41 +807,11 @@ modifier:
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
 		memset(&attr, 0, sizeof(attr));
 		ret = parse_event_symbols(&str, &attr);
-- 
1.6.2.5

