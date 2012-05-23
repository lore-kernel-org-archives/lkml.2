Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964956Ab2EWCmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:42:46 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43911 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab2EWCjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:06 -0400
X-AuditID: 9c93016f-b7c3cae000001954-97-4fbc4dc67444
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
Subject: [PATCH 08/22] lib/traceevent: Introduce extend_token()
Date: Wed, 23 May 2012 11:36:45 +0900
Message-Id: <1337740619-27925-9-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __read_token() function has some duplicated code to handle
internal buffer overflow. Factor them out to new extend_token().

According to the man pages of realloc/free(3), they can handle
NULL pointer input so that it can be ended up to compact the code.
Also handle error path correctly.

Link: http://lkml.kernel.org/r/1333940074-19052-4-git-send-email-namhyung.kim@lge.com

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>

[ added some extra whitespace ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c |   50 +++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 58fa6eb6aa59..bdfc29607b49 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -775,6 +775,25 @@ int pevent_peek_char(void)
 	return __peek_char();
 }
 
+static int extend_token(char **tok, char *buf, int size)
+{
+	char *newtok = realloc(*tok, size);
+
+	if (!newtok) {
+		free(*tok);
+		*tok = NULL;
+		return -1;
+	}
+
+	if (!*tok)
+		strcpy(newtok, buf);
+	else
+		strcat(newtok, buf);
+	*tok = newtok;
+
+	return 0;
+}
+
 static enum event_type force_token(const char *str, char **tok);
 
 static enum event_type __read_token(char **tok)
@@ -859,17 +878,10 @@ static enum event_type __read_token(char **tok)
 		do {
 			if (i == (BUFSIZ - 1)) {
 				buf[i] = 0;
-				if (*tok) {
-					*tok = realloc(*tok, tok_size + BUFSIZ);
-					if (!*tok)
-						return EVENT_NONE;
-					strcat(*tok, buf);
-				} else
-					*tok = strdup(buf);
+				tok_size += BUFSIZ;
 
-				if (!*tok)
+				if (extend_token(tok, buf, tok_size) < 0)
 					return EVENT_NONE;
-				tok_size += BUFSIZ;
 				i = 0;
 			}
 			last_ch = ch;
@@ -908,17 +920,10 @@ static enum event_type __read_token(char **tok)
 	while (get_type(__peek_char()) == type) {
 		if (i == (BUFSIZ - 1)) {
 			buf[i] = 0;
-			if (*tok) {
-				*tok = realloc(*tok, tok_size + BUFSIZ);
-				if (!*tok)
-					return EVENT_NONE;
-				strcat(*tok, buf);
-			} else
-				*tok = strdup(buf);
+			tok_size += BUFSIZ;
 
-			if (!*tok)
+			if (extend_token(tok, buf, tok_size) < 0)
 				return EVENT_NONE;
-			tok_size += BUFSIZ;
 			i = 0;
 		}
 		ch = __read_char();
@@ -927,14 +932,7 @@ static enum event_type __read_token(char **tok)
 
  out:
 	buf[i] = 0;
-	if (*tok) {
-		*tok = realloc(*tok, tok_size + i);
-		if (!*tok)
-			return EVENT_NONE;
-		strcat(*tok, buf);
-	} else
-		*tok = strdup(buf);
-	if (!*tok)
+	if (extend_token(tok, buf, tok_size + i + 1) < 0)
 		return EVENT_NONE;
 
 	if (type == EVENT_ITEM) {
-- 
1.7.10.1

