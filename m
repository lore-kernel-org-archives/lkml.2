Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0EMGEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:04:49 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50290 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab0EMGEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:04:47 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ian Munsie <imunsie@au1.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/7] perf trace: Rewind pointer in case field in header_page is missing
Date: Thu, 13 May 2010 16:03:49 +1000
Message-Id: <1273730632-21008-5-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
References: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch rewinds the input pointer in the event that parsing one of
the fields in the header_page fails (which can happen if a field is
missing, such as the overwrite field), allowing the next field to be
parsed.

This patch fixes an issue from e9e94e3bd862d31777335722e747e97d9821bc1d
"perf trace: Ignore "overwrite" field if present in /events/header_page"
which ignored the field mismatch warning, but left the pointer in at
invalid position, resulting in this warning when the next field was
processed:

    	Warning: Error: expected type 6 but read 4

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/util/trace-event-parse.c |   35 +++++++++++++++++++++++------------
 1 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 9717f7a..950c757 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -29,6 +29,7 @@
 #include <errno.h>
 
 #undef _GNU_SOURCE
+#include <linux/kernel.h>
 #include "../perf.h"
 #include "util.h"
 #include "trace-event.h"
@@ -37,6 +38,8 @@ int header_page_ts_offset;
 int header_page_ts_size;
 int header_page_size_offset;
 int header_page_size_size;
+/* NOTE: the overwrite field may not be present on all systems so, check if
+ * header_page_overwrite_size > 0 before use */
 int header_page_overwrite_offset;
 int header_page_overwrite_size;
 int header_page_data_offset;
@@ -3117,11 +3120,12 @@ static void parse_header_field(const char *field,
 {
 	char *token;
 	int type;
+	unsigned long long input_buf_ptr_sav = input_buf_ptr;
 
 	if (read_expected(EVENT_ITEM, "field") < 0)
-		return;
+		goto tokenlessfail;
 	if (read_expected(EVENT_OP, ":") < 0)
-		return;
+		goto tokenlessfail;
 
 	/* type */
 	if (read_expect_type(EVENT_ITEM, &token) < 0)
@@ -3129,29 +3133,29 @@ static void parse_header_field(const char *field,
 	free_token(token);
 
 	if (read_expected_warn(EVENT_ITEM, field, warn) < 0)
-		return;
+		goto tokenlessfail;
 	if (read_expected(EVENT_OP, ";") < 0)
-		return;
+		goto tokenlessfail;
 	if (read_expected(EVENT_ITEM, "offset") < 0)
-		return;
+		goto tokenlessfail;
 	if (read_expected(EVENT_OP, ":") < 0)
-		return;
+		goto tokenlessfail;
 	if (read_expect_type(EVENT_ITEM, &token) < 0)
 		goto fail;
 	*offset = atoi(token);
 	free_token(token);
 	if (read_expected(EVENT_OP, ";") < 0)
-		return;
+		goto tokenlessfail;
 	if (read_expected(EVENT_ITEM, "size") < 0)
-		return;
+		goto tokenlessfail;
 	if (read_expected(EVENT_OP, ":") < 0)
-		return;
+		goto tokenlessfail;
 	if (read_expect_type(EVENT_ITEM, &token) < 0)
 		goto fail;
 	*size = atoi(token);
 	free_token(token);
 	if (read_expected(EVENT_OP, ";") < 0)
-		return;
+		goto tokenlessfail;
 	type = read_token(&token);
 	if (type != EVENT_NEWLINE) {
 		/* newer versions of the kernel have a "signed" type */
@@ -3164,20 +3168,27 @@ static void parse_header_field(const char *field,
 		free_token(token);
 
 		if (read_expected(EVENT_OP, ":") < 0)
-			return;
+			goto tokenlessfail;
 
 		if (read_expect_type(EVENT_ITEM, &token))
 			goto fail;
 
 		free_token(token);
 		if (read_expected(EVENT_OP, ";") < 0)
-			return;
+			goto tokenlessfail;
 
 		if (read_expect_type(EVENT_NEWLINE, &token))
 			goto fail;
 	}
+	free_token(token);
+	return;
+
  fail:
 	free_token(token);
+ tokenlessfail:
+	input_buf_ptr = input_buf_ptr_sav;
+	if (warn)
+		pr_warning("Failed to parse %s field of header_page\n", field);
 }
 
 int parse_header_page(char *buf, unsigned long size)
-- 
1.7.1

