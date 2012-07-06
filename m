Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab2GFLOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:14:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52010 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab2GFLOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:14:10 -0400
Date: Fri, 6 Jul 2012 04:13:40 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-deba3fb26fd1ed3235b00dccced9784a7f76ec3c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        namhyung.kim@lge.com, namhyung@kernel.org, bp@alien8.de,
        fweisbec@gmail.com, rostedt@goodmis.org, acme@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        namhyung.kim@lge.com, bp@alien8.de, namhyung@kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, acme@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1333940074-19052-4-git-send-email-namhyung.kim@lge.com>
References: <1333940074-19052-4-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Introduce extend_token()
Git-Commit-ID: deba3fb26fd1ed3235b00dccced9784a7f76ec3c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:13:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  deba3fb26fd1ed3235b00dccced9784a7f76ec3c
Gitweb:     http://git.kernel.org/tip/deba3fb26fd1ed3235b00dccced9784a7f76ec3c
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 9 Apr 2012 11:54:30 +0900
Committer:  Namhyung Kim <namhyung@kernel.org>
CommitDate: Wed, 4 Jul 2012 13:40:31 +0900

tools lib traceevent: Introduce extend_token()

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
 tools/lib/traceevent/event-parse.c |   52 +++++++++++++++++------------------
 1 files changed, 25 insertions(+), 27 deletions(-)

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
