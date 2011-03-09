Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1CIX7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:59:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17366 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491Ab1CIX7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:59:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=dYgSnszWIFsG8PuCf69QN3RA51orYr+547Hf6e2Jrotw/wTFzvZVAEtblEcGMMqAG
	hGNaJGeAG8aDpHOmu0pkg==
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Cc: mrubin@google.com, David Sharp <dhsharp@google.com>
Subject: [PATCH trace-cmd 2/3] parse-events: support additional operators: '!', '~',  and '!='
Date: Wed,  9 Mar 2011 15:58:56 -0800
Message-Id: <1299715137-22768-2-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1299715137-22768-1-git-send-email-dhsharp@google.com>
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the unary operators '!' and '~', and support '!=' so that
it is differentiated from '!'.

Signed-off-by: David Sharp <dhsharp@google.com>
---
 parse-events.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index bfb7ff5..507621b 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -1564,6 +1564,9 @@ static int get_op_prio(char *op)
 {
 	if (!op[1]) {
 		switch (op[0]) {
+		case '~':
+		case '!':
+			return 4;
 		case '*':
 		case '/':
 		case '%':
@@ -1642,6 +1645,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 			goto out_free;
 		}
 		switch (token[0]) {
+		case '~':
 		case '!':
 		case '+':
 		case '-':
@@ -2981,6 +2985,21 @@ eval_num_arg(void *data, int size, struct event_format *event, struct print_arg
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

