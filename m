Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511Ab2JTBBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:01:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36214 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab2JTBBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:01:43 -0400
Date: Fri, 19 Oct 2012 18:01:25 -0700
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
Message-ID: <tip-743df75ff10630f1f2a461f0f4b51f601f53ec44@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, rostedt@goodmis.org, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1349137408.22822.135.camel@gandalf.local.home>
References: <1349137408.22822.135.camel@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib traceevent:
  Fix missed freeing of subargs in free_arg() in filter
Git-Commit-ID: 743df75ff10630f1f2a461f0f4b51f601f53ec44
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 18:01:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  743df75ff10630f1f2a461f0f4b51f601f53ec44
Gitweb:     http://git.kernel.org/tip/743df75ff10630f1f2a461f0f4b51f601f53ec44
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Mon, 1 Oct 2012 20:23:28 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 16 Oct 2012 13:07:05 -0300

tools lib traceevent: Fix missed freeing of subargs in free_arg() in filter

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
