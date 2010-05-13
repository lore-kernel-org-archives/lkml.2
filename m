Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0EMGFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:05:48 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53909 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab0EMGEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:04:48 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ian Munsie <imunsie@au1.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 3/7] Revert "perf: Fix warning while reading ring buffer headers"
Date: Thu, 13 May 2010 16:03:48 +1000
Message-Id: <1273730632-21008-4-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
References: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This reverts commit d00a47cce569a3e660a8c9de5d57af28d6a9f0f7.
    "perf: Fix warning while reading ring buffer headers"

The reverted patch removed the processing of the header_page, skipping
over it instead on the assumption that perf was not using any of the
data from that header. The patch neglected to remove the header_page_
variables which were initialised in the removed code, nor did it fix any
code that was using those variables.

In particular, long_size was set based on one of those variables
(header_page_size_size) to learn the size of a long from the kernel,
which is necessary to correctly print out some of the trace information
in some circumstances. For instance, the size of a long in a 64 bit
kernel would differ from the size of a long in perf if it was compiled
for a 32 bit userspace. Perf trace needs to know the size of a long in
the kernel so that it can print out the correct value without
truncation.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/util/trace-event-parse.c |   89 +++++++++++++++++++++++++++++++++++
 tools/perf/util/trace-event-read.c  |   12 ++---
 tools/perf/util/trace-event.h       |    1 +
 3 files changed, 95 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index f360f75..9717f7a 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -691,6 +691,11 @@ static int __read_expected(enum event_type expect, const char *str,
 	return ret;
 }
 
+static int read_expected_warn(enum event_type expect, const char *str, bool warn)
+{
+	return __read_expected(expect, str, 1, warn);
+}
+
 static int read_expected(enum event_type expect, const char *str)
 {
 	return __read_expected(expect, str, 1, true);
@@ -3107,6 +3112,90 @@ static void print_args(struct print_arg *args)
 	}
 }
 
+static void parse_header_field(const char *field,
+			       int *offset, int *size, bool warn)
+{
+	char *token;
+	int type;
+
+	if (read_expected(EVENT_ITEM, "field") < 0)
+		return;
+	if (read_expected(EVENT_OP, ":") < 0)
+		return;
+
+	/* type */
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto fail;
+	free_token(token);
+
+	if (read_expected_warn(EVENT_ITEM, field, warn) < 0)
+		return;
+	if (read_expected(EVENT_OP, ";") < 0)
+		return;
+	if (read_expected(EVENT_ITEM, "offset") < 0)
+		return;
+	if (read_expected(EVENT_OP, ":") < 0)
+		return;
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto fail;
+	*offset = atoi(token);
+	free_token(token);
+	if (read_expected(EVENT_OP, ";") < 0)
+		return;
+	if (read_expected(EVENT_ITEM, "size") < 0)
+		return;
+	if (read_expected(EVENT_OP, ":") < 0)
+		return;
+	if (read_expect_type(EVENT_ITEM, &token) < 0)
+		goto fail;
+	*size = atoi(token);
+	free_token(token);
+	if (read_expected(EVENT_OP, ";") < 0)
+		return;
+	type = read_token(&token);
+	if (type != EVENT_NEWLINE) {
+		/* newer versions of the kernel have a "signed" type */
+		if (type != EVENT_ITEM)
+			goto fail;
+
+		if (strcmp(token, "signed") != 0)
+			goto fail;
+
+		free_token(token);
+
+		if (read_expected(EVENT_OP, ":") < 0)
+			return;
+
+		if (read_expect_type(EVENT_ITEM, &token))
+			goto fail;
+
+		free_token(token);
+		if (read_expected(EVENT_OP, ";") < 0)
+			return;
+
+		if (read_expect_type(EVENT_NEWLINE, &token))
+			goto fail;
+	}
+ fail:
+	free_token(token);
+}
+
+int parse_header_page(char *buf, unsigned long size)
+{
+	init_input_buf(buf, size);
+
+	parse_header_field("timestamp", &header_page_ts_offset,
+			   &header_page_ts_size, true);
+	parse_header_field("commit", &header_page_size_offset,
+			   &header_page_size_size, true);
+	parse_header_field("overwrite", &header_page_overwrite_offset,
+			   &header_page_overwrite_size, false);
+	parse_header_field("data", &header_page_data_offset,
+			   &header_page_data_size, true);
+
+	return 0;
+}
+
 int parse_ftrace_file(char *buf, unsigned long size)
 {
 	struct format_field *field;
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index cb54cd0..43f19c1 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -53,12 +53,6 @@ static unsigned long	page_size;
 static ssize_t calc_data_size;
 static bool repipe;
 
-/* If it fails, the next read will report it */
-static void skip(int size)
-{
-	lseek(input_fd, size, SEEK_CUR);
-}
-
 static int do_read(int fd, void *buf, int size)
 {
 	int rsize = size;
@@ -190,6 +184,7 @@ static void read_ftrace_printk(void)
 static void read_header_files(void)
 {
 	unsigned long long size;
+	char *header_page;
 	char *header_event;
 	char buf[BUFSIZ];
 
@@ -199,7 +194,10 @@ static void read_header_files(void)
 		die("did not read header page");
 
 	size = read8();
-	skip(size);
+	header_page = malloc_or_die(size);
+	read_or_die(header_page, size);
+	parse_header_page(header_page, size);
+	free(header_page);
 
 	/*
 	 * The size field in the page is of type long,
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index cc58a19..5fa3c5a 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -246,6 +246,7 @@ extern int header_page_data_size;
 
 extern bool latency_format;
 
+int parse_header_page(char *buf, unsigned long size);
 int trace_parse_common_type(void *data);
 int trace_parse_common_pid(void *data);
 int parse_common_pc(void *data);
-- 
1.7.1

