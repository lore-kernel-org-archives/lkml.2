Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab2JIRUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:20:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60763 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2JIRUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:20:15 -0400
Date: Tue, 9 Oct 2012 10:19:21 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-32caf0d1fe14eb69191e7828701e381b1edb340d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1349413336-26936-2-git-send-email-namhyung@kernel.org>
References: <1349413336-26936-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Validate target task/user/cpu argument
Git-Commit-ID: 32caf0d1fe14eb69191e7828701e381b1edb340d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 09 Oct 2012 10:19:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  32caf0d1fe14eb69191e7828701e381b1edb340d
Gitweb:     http://git.kernel.org/tip/32caf0d1fe14eb69191e7828701e381b1edb340d
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 5 Oct 2012 14:02:13 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 5 Oct 2012 12:47:54 -0300

perf trace: Validate target task/user/cpu argument

Those target options are mutually exclusive so check it before setting
up target thread/cpu maps.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1349413336-26936-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index dec8ced..f01fa6f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -323,14 +323,21 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_END()
 	};
 	int err;
+	char bf[BUFSIZ];
 
 	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
 	if (argc)
 		usage_with_options(trace_usage, trace_options);
 
+	err = perf_target__validate(&trace.opts.target);
+	if (err) {
+		perf_target__strerror(&trace.opts.target, err, bf, sizeof(bf));
+		printf("%s", bf);
+		return err;
+	}
+
 	err = perf_target__parse_uid(&trace.opts.target);
 	if (err) {
-		char bf[BUFSIZ];
 		perf_target__strerror(&trace.opts.target, err, bf, sizeof(bf));
 		printf("%s", bf);
 		return err;
