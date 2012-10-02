Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab2JBAXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:23:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17746 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab2JBAX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:23:29 -0400
X-Authority-Analysis: v=2.0 cv=WKj9rwQR c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=udcLN6VZdtcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=jsGWfXWySJAA:10 a=wgmH0LZER7GGQFl2Q6kA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=G-BA0hi1qGWvP-pH:21 a=oH1lGft6cS6U0tNZ:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349137408.22822.135.camel@gandalf.local.home>
Subject: [PATCH v2] tools lib traceevent: Fix missed freeing of subargs in
 free_arg() in filter
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>
Date: Mon, 01 Oct 2012 20:23:28 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of args were missed in free_args(), as well as subargs.
That is args like FILTER_ARG_NUM have left and right pointers to
other args that also need to be freed.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/parse-filter.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index ad17855..5ea4326 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -209,7 +209,16 @@ static void free_arg(struct filter_arg *arg)
 	switch (arg->type) {
 	case FILTER_ARG_NONE:
 	case FILTER_ARG_BOOLEAN:
+		break;
+
 	case FILTER_ARG_NUM:
+		free_arg(arg->num.left);
+		free_arg(arg->num.right);
+		break;
+
+	case FILTER_ARG_EXP:
+		free_arg(arg->exp.left);
+		free_arg(arg->exp.right);
 		break;
 
 	case FILTER_ARG_STR:
@@ -218,6 +227,12 @@ static void free_arg(struct filter_arg *arg)
 		free(arg->str.buffer);
 		break;
 
+	case FILTER_ARG_VALUE:
+		if (arg->value.type == FILTER_STRING ||
+		    arg->value.type == FILTER_CHAR)
+			free(arg->value.str);
+		break;
+
 	case FILTER_ARG_OP:
 		free_arg(arg->op.left);
 		free_arg(arg->op.right);
-- 
1.7.3.4



