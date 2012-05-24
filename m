Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab2EXQlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:41:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49181 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953Ab2EXQkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:40:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/6] tools lib traceevent: Fix a possible memory leak
Date: Thu, 24 May 2012 13:40:09 -0300
Message-Id: <1337877613-15133-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1337877613-15133-1-git-send-email-acme@infradead.org>
References: <1337877613-15133-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If event_read_fields failed in the middle, each member of
struct format_field should be freed also.

Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337740619-27925-11-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 33450c9..d598b37 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1434,8 +1434,11 @@ static int event_read_fields(struct event_format *event, struct format_field **f
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
1.7.9.2.358.g22243

