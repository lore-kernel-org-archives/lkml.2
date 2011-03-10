Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab1CJW4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:56:22 -0500
Received: from smtp-out.google.com ([216.239.44.51]:56984 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1CJW4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:56:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=EzJ0yYwkW2Z0LElsTz47nnpGCQzAzrmxlE9ogL+GD7Ni2PoxdPIZSlhhhYWVO77jL
	Tm7Izz+LhwHWMNuSyBJJw==
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>
Subject: [PATCH perf 1/2] perf: trace-event-parse: support additional operators: '!', '~',  and '!='
Date: Thu, 10 Mar 2011 14:55:55 -0800
Message-Id: <1299797756-13546-2-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299797756-13546-1-git-send-email-dhsharp@google.com>
References: <1299797756-13546-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the unary operators '!' and '~', and support '!=' so that
it is differentiated from '!'.

Signed-off-by: David Sharp <dhsharp@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/trace-event-parse.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 73a0222..67fe01a 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1107,6 +1107,9 @@ static int get_op_prio(char *op)
 {
 	if (!op[1]) {
 		switch (op[0]) {
+		case '~':
+		case '!':
+			return 4;
 		case '*':
 		case '/':
 		case '%':
@@ -1184,6 +1187,7 @@ process_op(struct event *event, struct print_arg *arg, char **tok)
 			return EVENT_ERROR;
 		}
 		switch (token[0]) {
+		case '~':
 		case '!':
 		case '+':
 		case '-':
@@ -2109,6 +2113,21 @@ static unsigned long long eval_num_arg(void *data, int size,
 		left = eval_num_arg(data, size, event, arg->op.left);
 		right = eval_num_arg(data, size, event, arg->op.right);
 		switch (arg->op.op[0]) {
+		case '!':
+			switch (arg->op.op[1]) {
+			case 0:
+				val = !right;
+				break;
+			case '=':
+				val = left != right;
+				break;
+			default:
+				die("unknown op '%s'", arg->op.op);
+			}
+			break;
+		case '~':
+			val = ~right;
+			break;
 		case '|':
 			if (arg->op.op[1])
 				val = left || right;
-- 
1.7.3.1

