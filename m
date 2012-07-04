Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606Ab2GDFmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:42:05 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63523 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238Ab2GDFjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:39:44 -0400
X-AuditID: 9c930179-b7cceae000004195-57-4ff3d71c225d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 07/16] tools lib traceevent: Introduce extend_token()
Date: Wed,  4 Jul 2012 14:35:21 +0900
Message-Id: <1341380130-23863-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341380130-23863-1-git-send-email-namhyung@kernel.org>
References: <1341380068-23806-1-git-send-email-namhyung@kernel.org>
 <1341380130-23863-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The __read_token() function has some duplicated code to handle
internal buffer overflow. Factor them out to new extend_token().

According to the man pages of realloc/free(3), they can handle NULL
pointer input so that it can be ended up to compact the code.  Also
handle error path correctly.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1333940074-19052-4-git-send-email-namhyung.kim@lge.com
[rostedt@goodmis.org: added some extra whitespace]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |   50 +++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 7815b8d2eabd..768fab5fbcb7 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -781,6 +781,25 @@ int pevent_peek_char(void)
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
@@ -865,17 +884,10 @@ static enum event_type __read_token(char **tok)
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
@@ -914,17 +926,10 @@ static enum event_type __read_token(char **tok)
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
@@ -933,14 +938,7 @@ static enum event_type __read_token(char **tok)
 
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
1.7.10.4

