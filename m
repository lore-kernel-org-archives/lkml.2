Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1AGPbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:31:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:54822 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab1AGPbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:31:13 -0500
Date: Fri, 7 Jan 2011 15:30:54 GMT
From: tip-bot for Han Pingtian <phan@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, phan@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, phan@redhat.com, tglx@linutronix.de
In-Reply-To: <20110106093922.GB6713@hpt.nay.redhat.com>
References: <20110106093922.GB6713@hpt.nay.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix buffer overflow error when specifying all tracepoints
Message-ID: <tip-f006d25a15216a483cec71e886786874f66f9452@git.kernel.org>
Git-Commit-ID: f006d25a15216a483cec71e886786874f66f9452
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 Jan 2011 15:30:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f006d25a15216a483cec71e886786874f66f9452
Gitweb:     http://git.kernel.org/tip/f006d25a15216a483cec71e886786874f66f9452
Author:     Han Pingtian <phan@redhat.com>
AuthorDate: Thu, 6 Jan 2011 17:39:22 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 6 Jan 2011 18:04:46 -0200

perf tools: Fix buffer overflow error when specifying all tracepoints

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
