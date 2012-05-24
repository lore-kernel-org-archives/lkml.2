Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916Ab2EXRRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:17:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56206 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933683Ab2EXRRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:17:00 -0400
Date: Thu, 24 May 2012 10:16:28 -0700
From: tip-bot for Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Message-ID: <tip-00b9da7219cd027a1c51c3ef576aadbbd9fe38fe@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@gmail.com,
        fweisbec@gmail.com, rostedt@goodmis.org, stefanha@linux.vnet.ibm.com,
        tglx@linutronix.de, avi@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, fweisbec@gmail.com,
        stefanha@linux.vnet.ibm.com, rostedt@goodmis.org, tglx@linutronix.de,
        avi@redhat.com
In-Reply-To: <1337740619-27925-6-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-6-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib traceevent:
  Allow expressions in __print_symbolic() fields
Git-Commit-ID: 00b9da7219cd027a1c51c3ef576aadbbd9fe38fe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 24 May 2012 10:16:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00b9da7219cd027a1c51c3ef576aadbbd9fe38fe
Gitweb:     http://git.kernel.org/tip/00b9da7219cd027a1c51c3ef576aadbbd9fe38fe
Author:     Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
AuthorDate: Wed, 23 May 2012 11:36:42 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 May 2012 11:29:25 -0300

tools lib traceevent: Allow expressions in __print_symbolic() fields

The __print_symbolic() function takes a sequence of key-value pairs for
pretty-printing a constant.  The new kvm:kvm_exit print fmt uses the
expression:

  __print_symbolic(..., { 0x040 + 1, "DB excp" }, ...)

Currently only atoms are supported and this print fmt fails to parse.
This patch adds support for expressions instead of just atoms so that
0x040 + 1 is parsed successfully.

Cc: Avi Kivity <avi@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337740619-27925-6-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 9985349..33450c9 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2124,6 +2124,13 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 
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
 
