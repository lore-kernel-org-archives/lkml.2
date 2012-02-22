Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab2BVQCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:02:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50922 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2BVQCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:02:37 -0500
Date: Wed, 22 Feb 2012 08:01:40 -0800
From: tip-bot for Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Message-ID: <tip-a5a178e1ae0192e405830f1bba84548992124e88@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, stefanha@linux.vnet.ibm.com, rostedt@goodmis.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, rostedt@goodmis.org, stefanha@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1315148939-14313-1-git-send-email-stefanha@linux.vnet.ibm.com>
References: <1315148939-14313-1-git-send-email-stefanha@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Allow expressions in __print_symbolic(
 ) fields
Git-Commit-ID: a5a178e1ae0192e405830f1bba84548992124e88
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 22 Feb 2012 08:02:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5a178e1ae0192e405830f1bba84548992124e88
Gitweb:     http://git.kernel.org/tip/a5a178e1ae0192e405830f1bba84548992124e88
Author:     Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
AuthorDate: Sun, 4 Sep 2011 16:08:59 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Feb 2012 16:34:08 -0200

perf tools: Allow expressions in __print_symbolic() fields

The __print_symbolic() function takes a sequence of key-value pairs for
pretty-printing a constant.  The new kvm:kvm_exit print fmt uses the
expression:

  __print_symbolic(..., { 0x040 + 1, "DB excp" }, ...)

Currently only atoms are supported and this print fmt fails to parse.
This patch adds support for expressions instead of just atoms so that
0x040 + 1 is parsed successfully.  Also add arg_num_eval() support for
the '+' operator.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1315148939-14313-1-git-send-email-stefanha@linux.vnet.ibm.com
Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index e0a4f65..a4088ce 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1423,6 +1423,11 @@ static long long arg_num_eval(struct print_arg *arg)
 				die("unknown op '%s'", arg->op.op);
 			}
 			break;
+		case '+':
+			left = arg_num_eval(arg->op.left);
+			right = arg_num_eval(arg->op.right);
+			val = left + right;
+			break;
 		default:
 			die("unknown op '%s'", arg->op.op);
 		}
@@ -1483,6 +1488,13 @@ process_fields(struct event *event, struct print_flag_sym **list, char **tok)
 
 		free_token(token);
 		type = process_arg(event, arg, &token);
+
+		if (type == EVENT_OP)
+			type = process_op(event, arg, &token);
+
+		if (type == EVENT_ERROR)
+			goto out_free;
+
 		if (test_type_token(type, token, EVENT_DELIM, ","))
 			goto out_free;
 
