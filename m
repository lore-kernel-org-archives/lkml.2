Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010Ab2EWCnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:43:37 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49362 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933518Ab2EWCjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:05 -0400
X-AuditID: 9c93016f-b7c3cae000001954-7f-4fbc4dc54b1a
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>
Subject: [PATCH 05/22] lib/traceevent: Allow expressions in __print_symbolic() fields
Date: Wed, 23 May 2012 11:36:42 +0900
Message-Id: <1337740619-27925-6-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
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

Link: http://lkml.kernel.org/r/1315131959-7452-1-git-send-email-stefanha@linux.vnet.ibm.com

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/lib/traceevent/event-parse.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 9216aef78394..59534e299590 100644
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
1.7.10.1

