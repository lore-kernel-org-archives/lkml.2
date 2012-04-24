Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab2DXBIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:08:39 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48061 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab2DXBIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:08:38 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-49-4f95fd146bf4
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] parse-events: Free flag/sym field on failure path
Date: Tue, 24 Apr 2012 10:07:49 +0900
Message-Id: <1335229669-6989-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <87ty0aro42.fsf@sejong.aot.lge.com>
References: <87ty0aro42.fsf@sejong.aot.lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If parsing flag/sym field failed after allocating it, it
should be freed. As Steven advises, make the field NULL
and check it at out_free instead of adding more goto labels.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/parse-events.c b/parse-events.c
index bd078ba..3ccedd9 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -2147,6 +2147,7 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 		if (test_type_token(type, token, EVENT_OP, "{"))
 			break;
 
+		field = NULL;
 		arg = alloc_arg();
 
 		free_token(token);
@@ -2199,6 +2200,10 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 	return type;
 
 out_free:
+	if (field) {
+		free(field->value);
+		free(field);
+	}
 	free_arg(arg);
 	free_token(token);
 	*tok = NULL;
-- 
1.7.10

