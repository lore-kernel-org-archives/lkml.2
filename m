Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab0DHOjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 10:39:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36251 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758781Ab0DHOjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 10:39:01 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 6/6] perf trace: Ignore "overwrite" field if present in /events/header_page
Date: Thu,  8 Apr 2010 11:38:49 -0300
Message-Id: <1270737529-24258-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1270737529-24258-1-git-send-email-acme@infradead.org>
References: <1270737529-24258-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

That is not used in perf where we have the LOST events.

Without this patch we get:

[root@doppio ~]# perf lock report | head -3
  Warning: Error: expected 'data' but read 'overwrite'

So, to make the same perf command work with kernels with and without
this field, introduce variants for the parsing routines to not warn the
user in such case.

Discussed-with: Steven Rostedt <rostedt@goodmis.org>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-parse.c |   49 ++++++++++++++++++++++++----------
 1 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 9b3c20f..3b81250 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -37,6 +37,8 @@ int header_page_ts_offset;
 int header_page_ts_size;
 int header_page_size_offset;
 int header_page_size_size;
+int header_page_overwrite_offset;
+int header_page_overwrite_size;
 int header_page_data_offset;
 int header_page_data_size;
 
@@ -628,23 +630,32 @@ static int test_type(enum event_type type, enum event_type expect)
 	return 0;
 }
 
-static int test_type_token(enum event_type type, char *token,
-		    enum event_type expect, const char *expect_tok)
+static int __test_type_token(enum event_type type, char *token,
+			     enum event_type expect, const char *expect_tok,
+			     bool warn)
 {
 	if (type != expect) {
-		warning("Error: expected type %d but read %d",
-		    expect, type);
+		if (warn)
+			warning("Error: expected type %d but read %d",
+				expect, type);
 		return -1;
 	}
 
 	if (strcmp(token, expect_tok) != 0) {
-		warning("Error: expected '%s' but read '%s'",
-		    expect_tok, token);
+		if (warn)
+			warning("Error: expected '%s' but read '%s'",
+				expect_tok, token);
 		return -1;
 	}
 	return 0;
 }
 
+static int test_type_token(enum event_type type, char *token,
+			   enum event_type expect, const char *expect_tok)
+{
+	return __test_type_token(type, token, expect, expect_tok, true);
+}
+
 static int __read_expect_type(enum event_type expect, char **tok, int newline_ok)
 {
 	enum event_type type;
@@ -661,7 +672,8 @@ static int read_expect_type(enum event_type expect, char **tok)
 	return __read_expect_type(expect, tok, 1);
 }
 
-static int __read_expected(enum event_type expect, const char *str, int newline_ok)
+static int __read_expected(enum event_type expect, const char *str,
+			   int newline_ok, bool warn)
 {
 	enum event_type type;
 	char *token;
@@ -672,21 +684,26 @@ static int __read_expected(enum event_type expect, const char *str, int newline_
 	else
 		type = read_token_item(&token);
 
-	ret = test_type_token(type, token, expect, str);
+	ret = __test_type_token(type, token, expect, str, warn);
 
 	free_token(token);
 
 	return ret;
 }
 
+static int read_expected_warn(enum event_type expect, const char *str, bool warn)
+{
+	return __read_expected(expect, str, 1, warn);
+}
+
 static int read_expected(enum event_type expect, const char *str)
 {
-	return __read_expected(expect, str, 1);
+	return __read_expected(expect, str, 1, true);
 }
 
 static int read_expected_item(enum event_type expect, const char *str)
 {
-	return __read_expected(expect, str, 0);
+	return __read_expected(expect, str, 0, true);
 }
 
 static char *event_read_name(void)
@@ -3088,7 +3105,7 @@ static void print_args(struct print_arg *args)
 }
 
 static void parse_header_field(const char *field,
-			       int *offset, int *size)
+			       int *offset, int *size, bool warn)
 {
 	char *token;
 	int type;
@@ -3103,7 +3120,7 @@ static void parse_header_field(const char *field,
 		goto fail;
 	free_token(token);
 
-	if (read_expected(EVENT_ITEM, field) < 0)
+	if (read_expected_warn(EVENT_ITEM, field, warn) < 0)
 		return;
 	if (read_expected(EVENT_OP, ";") < 0)
 		return;
@@ -3160,11 +3177,13 @@ int parse_header_page(char *buf, unsigned long size)
 	init_input_buf(buf, size);
 
 	parse_header_field("timestamp", &header_page_ts_offset,
-			   &header_page_ts_size);
+			   &header_page_ts_size, true);
 	parse_header_field("commit", &header_page_size_offset,
-			   &header_page_size_size);
+			   &header_page_size_size, true);
+	parse_header_field("overwrite", &header_page_overwrite_offset,
+			   &header_page_overwrite_size, false);
 	parse_header_field("data", &header_page_data_offset,
-			   &header_page_data_size);
+			   &header_page_data_size, true);
 
 	return 0;
 }
-- 
1.6.2.5

