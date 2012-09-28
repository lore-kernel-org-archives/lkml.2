Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115Ab2I1XVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:21:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759080Ab2I1XV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:21:26 -0400
X-Authority-Analysis: v=2.0 cv=WKj9rwQR c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=jP5pJCdp8XgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=9_Y18JphmB8A:10 a=wgmH0LZER7GGQFl2Q6kA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=WDsIavl1ejhTTvC1:21 a=893I3yTxVRpRAqq7:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348874483.22822.100.camel@gandalf.local.home>
Subject: [PATCH] tools lib traceevent: Fix missed freeing of subargs in
 free_arg() in filter
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>
Date: Fri, 28 Sep 2012 19:21:23 -0400
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
 tools/lib/traceevent/parse-filter.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index ad17855..2d907cb 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -209,7 +209,12 @@ static void free_arg(struct filter_arg *arg)
 	switch (arg->type) {
 	case FILTER_ARG_NONE:
 	case FILTER_ARG_BOOLEAN:
+		break;
+
 	case FILTER_ARG_NUM:
+	case FILTER_ARG_EXP:
+		free_arg(arg->op.left);
+		free_arg(arg->op.right);
 		break;
 
 	case FILTER_ARG_STR:
@@ -218,6 +223,12 @@ static void free_arg(struct filter_arg *arg)
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



