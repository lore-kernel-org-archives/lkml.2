Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933935Ab2EXRTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:19:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56253 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab2EXRTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:19:31 -0400
Date: Thu, 24 May 2012 10:19:03 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-b3511d0530c7a2b4fa64d1f5218c5f073ae7b543@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, bp@alien8.de,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, bp@alien8.de, namhyung@gmail.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1337740619-27925-14-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-14-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib traceevent:
  Fix freeing arg on process_dynamic_array()
Git-Commit-ID: b3511d0530c7a2b4fa64d1f5218c5f073ae7b543
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 24 May 2012 10:19:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3511d0530c7a2b4fa64d1f5218c5f073ae7b543
Gitweb:     http://git.kernel.org/tip/b3511d0530c7a2b4fa64d1f5218c5f073ae7b543
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 23 May 2012 11:36:50 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 May 2012 11:33:53 -0300

tools lib traceevent: Fix freeing arg on process_dynamic_array()

The @arg paremeter should not be freed inside of process_XXX(),
because it'd be freed from the caller of process_arg(). We can
free it only after it was reused for local usage.

Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337740619-27925-14-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 445a43a..3559027 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2300,17 +2300,18 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 	arg = alloc_arg();
 	type = process_arg(event, arg, &token);
 	if (type == EVENT_ERROR)
-		goto out_free;
+		goto out_free_arg;
 
 	if (!test_type_token(type, token, EVENT_OP, "]"))
-		goto out_free;
+		goto out_free_arg;
 
 	free_token(token);
 	type = read_token_item(tok);
 	return type;
 
+ out_free_arg:
+	free_arg(arg);
  out_free:
-	free(arg);
 	free_token(token);
 	*tok = NULL;
 	return EVENT_ERROR;
