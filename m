Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab1GAP0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:26:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:42675 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555Ab1GAP0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:26:18 -0400
Date: Fri, 1 Jul 2011 15:26:01 GMT
From: tip-bot for Zhengyu He <zhengyuh@google.com>
Message-ID: <tip-3ae9a34d747f9abf2bcc85dc0e77b951513ccdf2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, zhengyuh@google.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu, venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, zhengyuh@google.com, acme@ghostprotocols.net,
        fweisbec@gmail.com, tglx@linutronix.de, venki@google.com,
        mingo@elte.hu
In-Reply-To: <1308861942-4945-1-git-send-email-zhengyuh@google.com>
References: <1308861942-4945-1-git-send-email-zhengyuh@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Add noise output for csv mode
Git-Commit-ID: 3ae9a34d747f9abf2bcc85dc0e77b951513ccdf2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:26:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ae9a34d747f9abf2bcc85dc0e77b951513ccdf2
Gitweb:     http://git.kernel.org/tip/3ae9a34d747f9abf2bcc85dc0e77b951513ccdf2
Author:     Zhengyu He <zhengyuh@google.com>
AuthorDate: Thu, 23 Jun 2011 13:45:42 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 12:52:40 +0200

perf stat: Add noise output for csv mode

Previously, when you want perf-stat to output the statistics in
csv mode, no information of the noise will be printed out.

For example right now we output this --repeat information:

 ./perf stat -r3 -x, sleep 1
 1.164789,task-clock
 8,context-switches
 0,CPU-migrations
 219,page-faults
 3337800,cycles

With this patch, the output will be appended with an additional
entry for the noise value:

 ./perf stat -r3 -x, sleep 1
 1.164789,task-clock,3.75%
 8,context-switches,75.00%
 0,CPU-migrations,100.00%
 219,page-faults,0.00%
 3337800,cycles,3.36%

Signed-off-by: Zhengyu He <zhengyuh@google.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Stephane Eranian <eranian@google.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1308861942-4945-1-git-send-email-zhengyuh@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 784ed6d..1d08c80 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -517,7 +517,10 @@ static void print_noise_pct(double total, double avg)
 	if (avg)
 		pct = 100.0*total/avg;
 
-	fprintf(stderr, "  ( +-%6.2f%% )", pct);
+	if (csv_output)
+		fprintf(stderr, "%s%.2f%%", csv_sep, pct);
+	else
+		fprintf(stderr, "  ( +-%6.2f%% )", pct);
 }
 
 static void print_noise(struct perf_evsel *evsel, double avg)
@@ -882,13 +885,13 @@ static void print_counter_aggr(struct perf_evsel *counter)
 	else
 		abs_printout(-1, counter, avg);
 
+	print_noise(counter, avg);
+
 	if (csv_output) {
 		fputc('\n', stderr);
 		return;
 	}
 
-	print_noise(counter, avg);
-
 	if (scaled) {
 		double avg_enabled, avg_running;
 
