Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab2EXQkd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:40:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:44655 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab2EXQka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:40:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/6] tools lib traceevent: Allow expressions in __print_symbolic() fields
Date: Thu, 24 May 2012 13:40:08 -0300
Message-Id: <1337877613-15133-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1337877613-15133-1-git-send-email-acme@infradead.org>
References: <1337877613-15133-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>

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
 1 file changed, 7 insertions(+)

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
 
-- 
1.7.9.2.358.g22243

