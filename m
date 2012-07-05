Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2GEPtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:49:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:59129 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030209Ab2GEPpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:36 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 07/20] tools lib traceevent: Introduce extend_token()
Date: Thu,  5 Jul 2012 12:45:05 -0300
Message-Id: <1341503118-13198-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
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
index 7815b8d..768fab5 100644
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
1.7.9.2.358.g22243

