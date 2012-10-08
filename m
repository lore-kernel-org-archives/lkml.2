Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab2JHRSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:18:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39941 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab2JHRSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:18:44 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: [PATCH 09/12] perf kvm: split out tracepoints from record args
Date: Mon,  8 Oct 2012 11:17:33 -0600
Message-Id: <1349716656-48165-10-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed by kvm live command. Make record_args a local while we are
messing with the args.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c |   30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 43fd71c..f6091d2 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -784,16 +784,11 @@ exit:
 	return ret;
 }
 
-static const char * const record_args[] = {
-	"record",
-	"-R",
-	"-f",
-	"-m", "1024",
-	"-c", "1",
-	"-e", "kvm:kvm_entry",
-	"-e", "kvm:kvm_exit",
-	"-e", "kvm:kvm_mmio",
-	"-e", "kvm:kvm_pio",
+static const char * const kvm_events_tp[] = {
+	"kvm:kvm_entry",
+	"kvm:kvm_exit",
+	"kvm:kvm_mmio",
+	"kvm:kvm_pio",
 };
 
 #define STRDUP_FAIL_EXIT(s)		\
@@ -808,8 +803,16 @@ static int kvm_events_record(struct perf_kvm *kvm, int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
+	const char * const record_args[] = {
+		"record",
+		"-R",
+		"-f",
+		"-m", "1024",
+		"-c", "1",
+	};
 
-	rec_argc = ARRAY_SIZE(record_args) + argc + 2;
+	rec_argc = ARRAY_SIZE(record_args) + argc + 2 +
+		   ARRAY_SIZE(kvm_events_tp);
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
 	if (rec_argv == NULL)
@@ -818,6 +821,11 @@ static int kvm_events_record(struct perf_kvm *kvm, int argc, const char **argv)
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
 		rec_argv[i] = STRDUP_FAIL_EXIT(record_args[i]);
 
+	for (j = 0; j < ARRAY_SIZE(kvm_events_tp); j++) {
+		rec_argv[i++] = "-e";
+		rec_argv[i++] = STRDUP_FAIL_EXIT(kvm_events_tp[j]);
+	}
+
 	rec_argv[i++] = STRDUP_FAIL_EXIT("-o");
 	rec_argv[i++] = STRDUP_FAIL_EXIT(kvm->file_name);
 
-- 
1.7.10.1

