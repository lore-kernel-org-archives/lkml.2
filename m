Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab2I0Fim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:38:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54109 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2I0Fik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:38:40 -0400
Date: Wed, 26 Sep 2012 22:38:22 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-f8c49d2645e5028e48ba15ec72728be121eddf95@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1348037924-17568-4-git-send-email-namhyung@kernel.org>
References: <1348037924-17568-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Free field if an error occurs on process_fields
Git-Commit-ID: f8c49d2645e5028e48ba15ec72728be121eddf95
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:38:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f8c49d2645e5028e48ba15ec72728be121eddf95
Gitweb:     http://git.kernel.org/tip/f8c49d2645e5028e48ba15ec72728be121eddf95
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 19 Sep 2012 15:58:43 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 12:02:38 -0300

tools lib traceevent: Free field if an error occurs on process_fields

The field should be freed on error paths.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1348037924-17568-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 27088c5..a776ed5 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2186,10 +2186,10 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 
 		value = arg_eval(arg);
 		if (value == NULL)
-			goto out_free;
+			goto out_free_field;
 		field->value = strdup(value);
 		if (field->value == NULL)
-			goto out_free;
+			goto out_free_field;
 
 		free_arg(arg);
 		arg = alloc_arg();
@@ -2197,14 +2197,14 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 		free_token(token);
 		type = process_arg(event, arg, &token);
 		if (test_type_token(type, token, EVENT_OP, "}"))
-			goto out_free;
+			goto out_free_field;
 
 		value = arg_eval(arg);
 		if (value == NULL)
-			goto out_free;
+			goto out_free_field;
 		field->str = strdup(value);
 		if (field->str == NULL)
-			goto out_free;
+			goto out_free_field;
 		free_arg(arg);
 		arg = NULL;
 
@@ -2218,6 +2218,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 	*tok = token;
 	return type;
 
+out_free_field:
+	free_flag_sym(field);
 out_free:
 	free_arg(arg);
 	free_token(token);
