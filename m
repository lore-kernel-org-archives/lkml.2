Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab0F2JY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 05:24:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:39228 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab0F2JYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 05:24:24 -0400
Date: Tue, 29 Jun 2010 09:24:00 GMT
From: tip-bot for Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, chase.douglas@canonical.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, chase.douglas@canonical.com
In-Reply-To: <1276619355-18116-1-git-send-email-chase.douglas@canonical.com>
References: <1276619355-18116-1-git-send-email-chase.douglas@canonical.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/function-graph: Use correct string size for snprintf
Message-ID: <tip-d62f85d1e22e537192ce494c89540e1ac0d8bfc7@git.kernel.org>
Git-Commit-ID: d62f85d1e22e537192ce494c89540e1ac0d8bfc7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 09:24:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d62f85d1e22e537192ce494c89540e1ac0d8bfc7
Gitweb:     http://git.kernel.org/tip/d62f85d1e22e537192ce494c89540e1ac0d8bfc7
Author:     Chase Douglas <chase.douglas@canonical.com>
AuthorDate: Tue, 15 Jun 2010 12:29:15 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 28 Jun 2010 21:11:39 -0400

tracing/function-graph: Use correct string size for snprintf

The nsecs_str string is a local variable defined as:

char nsecs_str[5];

It is possible for the snprintf call to use a size value larger than the
size of the string. This should not cause a buffer overrun as it is
written now due to the value for the string format "%03lu" can not be
larger than 1000. However, this change makes it correct. By making the
size correct we guard against potential future changes that could actually
cause a buffer overrun.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
LKML-Reference: <1276619355-18116-1-git-send-email-chase.douglas@canonical.com>

[ added 'UL' to number 8 to fix gcc warning comparing it to sizeof() ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 79f4bac..6bff236 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -641,7 +641,8 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
 
 	/* Print nsecs (we don't want to exceed 7 numbers) */
 	if (len < 7) {
-		snprintf(nsecs_str, 8 - len, "%03lu", nsecs_rem);
+		snprintf(nsecs_str, min(sizeof(nsecs_str), 8UL - len), "%03lu",
+			 nsecs_rem);
 		ret = trace_seq_printf(s, ".%s", nsecs_str);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
