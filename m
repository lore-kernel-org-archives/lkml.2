Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035Ab0EACyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 22:54:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63375 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758598Ab0EACx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 22:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=ObBPZY7VCCaepfeBHxKfxGYTzT1GpXDe6KQK/hJ/OEngjKMoPeN4lnJTVZIVdFobdb
         Y1N8qH/d01Z2D/I+h+P7e5e4E+O/RBqxyxWSHxzjl8NURU8doq81724JdTi56XedFO3D
         gRhAZK/ohjxF8sbEjwZoG6/+bW7+dHB6l3Yvw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/8] perf: Fix warning while reading ring buffer headers
Date: Sat,  1 May 2010 04:53:49 +0200
Message-Id: <1272682436-10682-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
References: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e9e94e3bd862d31777335722e747e97d9821bc1d
"perf trace: Ignore "overwrite" field if present in
/events/header_page" makes perf trace launching spurious warnings
about unexpected tokens read:

	Warning: Error: expected type 6 but read 4

This change tries to handle the overcommit field in the header_page
file whenever this field is present or not.

The problem is that if this field is not present, we try to find it
and give up in the middle of the line when we realize we are actually
dealing with another field, which is the "data" one. And this failure
abandons the file pointer in the middle of the "data" description
line:

	field: u64 timestamp;	offset:0;	size:8;	signed:0;
	field: local_t commit;	offset:8;	size:8;	signed:1;
	field: char data;	offset:16;	size:4080;	signed:1;
                      ^^^
                      Here

What happens next is that we want to read this line to parse the data
field, but we fail because the pointer is not in the beginning of the
line.

We could probably fix that by rewinding the pointer. But in fact we
don't care much about these headers that only concern the ftrace
ring-buffer. We don't use them from perf.

Just skip this part of perf.data, but don't remove it from recording
to stay compatible with olders perf.data

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/trace-event-parse.c |   89 -----------------------------------
 tools/perf/util/trace-event-read.c  |   12 +++--
 tools/perf/util/trace-event.h       |    1 -
 3 files changed, 7 insertions(+), 95 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index d6ef414..069f261 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -691,11 +691,6 @@ static int __read_expected(enum event_type expect, const char *str,
 	return ret;
 }
 
-static int read_expected_warn(enum event_type expect, const char *str, bool warn)
-{
-	return __read_expected(expect, str, 1, warn);
-}
-
 static int read_expected(enum event_type expect, const char *str)
 {
 	return __read_expected(expect, str, 1, true);
@@ -3104,90 +3099,6 @@ static void print_args(struct print_arg *args)
 	}
 }
 
-static void parse_header_field(const char *field,
-			       int *offset, int *size, bool warn)
-{
-	char *token;
-	int type;
-
-	if (read_expected(EVENT_ITEM, "field") < 0)
-		return;
-	if (read_expected(EVENT_OP, ":") < 0)
-		return;
-
-	/* type */
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		goto fail;
-	free_token(token);
-
-	if (read_expected_warn(EVENT_ITEM, field, warn) < 0)
-		return;
-	if (read_expected(EVENT_OP, ";") < 0)
-		return;
-	if (read_expected(EVENT_ITEM, "offset") < 0)
-		return;
-	if (read_expected(EVENT_OP, ":") < 0)
-		return;
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		goto fail;
-	*offset = atoi(token);
-	free_token(token);
-	if (read_expected(EVENT_OP, ";") < 0)
-		return;
-	if (read_expected(EVENT_ITEM, "size") < 0)
-		return;
-	if (read_expected(EVENT_OP, ":") < 0)
-		return;
-	if (read_expect_type(EVENT_ITEM, &token) < 0)
-		goto fail;
-	*size = atoi(token);
-	free_token(token);
-	if (read_expected(EVENT_OP, ";") < 0)
-		return;
-	type = read_token(&token);
-	if (type != EVENT_NEWLINE) {
-		/* newer versions of the kernel have a "signed" type */
-		if (type != EVENT_ITEM)
-			goto fail;
-
-		if (strcmp(token, "signed") != 0)
-			goto fail;
-
-		free_token(token);
-
-		if (read_expected(EVENT_OP, ":") < 0)
-			return;
-
-		if (read_expect_type(EVENT_ITEM, &token))
-			goto fail;
-
-		free_token(token);
-		if (read_expected(EVENT_OP, ";") < 0)
-			return;
-
-		if (read_expect_type(EVENT_NEWLINE, &token))
-			goto fail;
-	}
- fail:
-	free_token(token);
-}
-
-int parse_header_page(char *buf, unsigned long size)
-{
-	init_input_buf(buf, size);
-
-	parse_header_field("timestamp", &header_page_ts_offset,
-			   &header_page_ts_size, true);
-	parse_header_field("commit", &header_page_size_offset,
-			   &header_page_size_size, true);
-	parse_header_field("overwrite", &header_page_overwrite_offset,
-			   &header_page_overwrite_size, false);
-	parse_header_field("data", &header_page_data_offset,
-			   &header_page_data_size, true);
-
-	return 0;
-}
-
 int parse_ftrace_file(char *buf, unsigned long size)
 {
 	struct format_field *field;
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 44889c9..4606639 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -52,6 +52,12 @@ static unsigned long	page_size;
 
 static ssize_t calc_data_size;
 
+/* If it fails, the next read will report it */
+static void skip(int size)
+{
+	lseek(input_fd, size, SEEK_CUR);
+}
+
 static int do_read(int fd, void *buf, int size)
 {
 	int rsize = size;
@@ -169,7 +175,6 @@ static void read_ftrace_printk(void)
 static void read_header_files(void)
 {
 	unsigned long long size;
-	char *header_page;
 	char *header_event;
 	char buf[BUFSIZ];
 
@@ -179,10 +184,7 @@ static void read_header_files(void)
 		die("did not read header page");
 
 	size = read8();
-	header_page = malloc_or_die(size);
-	read_or_die(header_page, size);
-	parse_header_page(header_page, size);
-	free(header_page);
+	skip(size);
 
 	/*
 	 * The size field in the page is of type long,
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 1f45d46..4e1acc3 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -244,7 +244,6 @@ extern int header_page_data_size;
 
 extern bool latency_format;
 
-int parse_header_page(char *buf, unsigned long size);
 int trace_parse_common_type(void *data);
 int trace_parse_common_pid(void *data);
 int parse_common_pc(void *data);
-- 
1.6.2.3

