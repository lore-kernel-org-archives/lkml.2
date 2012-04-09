Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2DICzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:55:54 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53136 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab2DICyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:54:39 -0400
X-AuditID: 9c930197-b7b09ae000000a5d-c2-4f824f6cc8e5
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/7] parse-events: Introduce extend_token()
Date: Mon,  9 Apr 2012 11:54:30 +0900
Message-Id: <1333940074-19052-4-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
References: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __read_token() function has some duplicated code to handle
internal buffer overflow. Factor them out to new extend_token().

According to the man pages of realloc/free(3), they can handle
NULL pointer input so that it can be ended up to compact the code.
Also handle error path correctly.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |   48 ++++++++++++++++++++++--------------------------
 1 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index f90af1a..0b1e40a 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -771,6 +771,23 @@ int pevent_peek_char(void)
 	return __peek_char();
 }
 
+static int extend_token(char **tok, char *buf, int size)
+{
+	char *newtok = realloc(*tok, size);
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
+	return 0;
+}
+
 static enum event_type force_token(const char *str, char **tok);
 
 static enum event_type __read_token(char **tok)
@@ -855,17 +872,10 @@ static enum event_type __read_token(char **tok)
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
@@ -904,17 +914,10 @@ static enum event_type __read_token(char **tok)
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
@@ -923,14 +926,7 @@ static enum event_type __read_token(char **tok)
 
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
1.7.7.6

