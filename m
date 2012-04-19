Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2DSINs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 04:13:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41016 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab2DSINn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 04:13:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7c0cae000001518-94-4f8fc935db9f
From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] perf stat: fix output selection introduced in 56f3bae7
Date: Thu, 19 Apr 2012 10:13:25 +0200
Message-id: <1334823205-15754-1-git-send-email-l.stelmach@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Organization: Samsung Poland R&D Center
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

56f3bae7 makes perf require either --output or --log-fd. Without them
perf exited after erroneously trying to open stdout (file descriptor 0
by default) for writing.

Signed-off-by: Łuaksz Stelmach <l.stelmach@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 tools/perf/builtin-stat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c941bb6..c0f8129 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -196,7 +196,7 @@ static bool			csv_output			= false;
 static bool			group				= false;
 static const char		*output_name			= NULL;
 static FILE			*output				= NULL;
-static int			output_fd;
+static int			output_fd			= -1;
 
 static volatile int done = 0;
 
@@ -1146,7 +1146,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 	if (output_name && strcmp(output_name, "-"))
 		output = NULL;
 
-	if (output_name && output_fd) {
+	if (output_name && output_fd >= 0) {
 		fprintf(stderr, "cannot use both --output and --log-fd\n");
 		usage_with_options(stat_usage, options);
 	}
@@ -1161,7 +1161,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		}
 		clock_gettime(CLOCK_REALTIME, &tm);
 		fprintf(output, "# started on %s\n", ctime(&tm.tv_sec));
-	} else if (output_fd != 2) {
+	} else if (output_fd >= 0) {
 		mode = append_file ? "a" : "w";
 		output = fdopen(output_fd, mode);
 		if (!output) {
-- 
1.7.9.5

