Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933259Ab1LFKdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 05:33:07 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:1313
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933146Ab1LFKdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 05:33:04 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVS2MS-02-F8I-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 06/10] perf report: Setup browser if stdout is a pipe
Date: Tue, 6 Dec 2011 11:32:36 +0100
Message-ID: <1323167560-2282-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
References: <1323167560-2282-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The decision to setup the browser should be made if stdout is pipe,
not stdin.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 tools/perf/builtin-report.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4d7c834..88ca2d4 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -504,6 +504,8 @@ static const struct option options[] = {
 
 int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
+	struct stat st;
+
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
 	if (use_stdio)
@@ -514,10 +516,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	if (inverted_callchain)
 		callchain_param.order = ORDER_CALLER;
 
-	if (strcmp(input_name, "-") != 0)
-		setup_browser(true);
-	else
+	if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
 		use_browser = 0;
+	else
+		setup_browser(true);
+
 	/*
 	 * Only in the newt browser we are doing integrated annotation,
 	 * so don't allocate extra space that won't be used in the stdio
-- 
1.7.7


