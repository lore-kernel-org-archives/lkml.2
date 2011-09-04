Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab1IDPJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 11:09:19 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:35152 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1IDPJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 11:09:14 -0400
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        linux-perf-users@vger.kernel.org,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH] perf tools: Allow expressions in __print_symbolic() fields
Date: Sun,  4 Sep 2011 16:08:59 +0100
Message-Id: <1315148939-14313-1-git-send-email-stefanha@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __print_symbolic() function takes a sequence of key-value pairs for
pretty-printing a constant.  The new kvm:kvm_exit print fmt uses the
expression:

  __print_symbolic(..., { 0x040 + 1, "DB excp" }, ...)

Currently only atoms are supported and this print fmt fails to parse.
This patch adds support for expressions instead of just atoms so that
0x040 + 1 is parsed successfully.  Also add arg_num_eval() support for
the '+' operator.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
The kvm:kvm_exit event was not recording enough information to format it.  I
recently fixed this by introducing a __print_symbolic(), this commit has not
yet hit linux.git but I think it will soon.  In order to correctly format the
new kvm:kvm_exit, this patch to extend event parsing is required.

 tools/perf/util/trace-event-parse.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0a7ed5b..d0a4548 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1425,6 +1425,11 @@ static long long arg_num_eval(struct print_arg *arg)
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
@@ -1485,6 +1490,13 @@ process_fields(struct event *event, struct print_flag_sym **list, char **tok)
 
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
 
-- 
1.7.5.4

