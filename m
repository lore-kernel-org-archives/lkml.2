Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab2JQRWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:22:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:46069 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540Ab2JQRUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:20:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/11] tools lib traceevent: Fix missed freeing of subargs in free_arg() in filter
Date: Wed, 17 Oct 2012 14:19:43 -0300
Message-Id: <1350494387-10987-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1350494387-10987-1-git-send-email-acme@infradead.org>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Some of args were missed in free_args(), as well as subargs.

That is args like FILTER_ARG_NUM have left and right pointers to other
args that also need to be freed.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1349137408.22822.135.camel@gandalf.local.home
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.7.1

