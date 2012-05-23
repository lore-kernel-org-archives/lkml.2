Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964902Ab2EWCjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:39:20 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50090 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933547Ab2EWCjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:08 -0400
X-AuditID: 9c93016f-b7c3cae000001954-ab-4fbc4dc7bd68
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 10/22] lib/traceevent: Fix a possible memory leak
Date: Wed, 23 May 2012 11:36:47 +0900
Message-Id: <1337740619-27925-11-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If event_read_fields failed in the middle, each member of
struct format_field should be freed also.

Link: http://lkml.kernel.org/r/1333940074-19052-6-git-send-email-namhyung.kim@lge.com

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 760e7831390a..0fa09c62a14a 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1437,8 +1437,11 @@ static int event_read_fields(struct event_format *event, struct format_field **f
 fail:
 	free_token(token);
 fail_expect:
-	if (field)
+	if (field) {
+		free(field->type);
+		free(field->name);
 		free(field);
+	}
 	return -1;
 }
 
-- 
1.7.10.1

