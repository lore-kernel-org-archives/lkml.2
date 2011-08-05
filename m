Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab1HEVOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:14:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33514 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1HEVNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:13:06 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=IumN79PWgNoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=zS5G-fdaeMUawApd05EA:9 a=nskj4mkD7Lfv2UUgehwA:7 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110805211302.399663250@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 05 Aug 2011 16:59:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [RFC][PATCH 7/8] perf/events: Add flag/symbol format_flags
References: <20110805205921.909038487@goodmis.org>
Content-Disposition: inline; filename=0007-perf-events-Add-flag-symbol-format_flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

This is a port of commit eb9a42caa7a92
 perf trace: Add flag/symbolic format_flags
of the old trace-event-parse.c to the new event-parse.c that
was written by Tom Zanussi and forward ported by Steven Rostedt.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/events/event-parse.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/tools/lib/events/event-parse.c b/tools/lib/events/event-parse.c
index dff66ad..3e9af2c 100644
--- a/tools/lib/events/event-parse.c
+++ b/tools/lib/events/event-parse.c
@@ -39,6 +39,9 @@ static const char *input_buf;
 static unsigned long long input_buf_ptr;
 static unsigned long long input_buf_siz;
 
+static int is_flag_field;
+static int is_symbolic_field;
+
 static int show_warning = 1;
 
 #define do_warning(fmt, ...)				\
@@ -1789,6 +1792,16 @@ process_entry(struct event_format *event __unused, struct print_arg *arg,
 	arg->type = PRINT_FIELD;
 	arg->field.name = field;
 
+	if (is_flag_field) {
+		arg->field.field = pevent_find_any_field(event, arg->field.name);
+		arg->field.field->flags |= FIELD_IS_FLAG;
+		is_flag_field = 0;
+	} else if (is_symbolic_field) {
+		arg->field.field = pevent_find_any_field(event, arg->field.name);
+		arg->field.field->flags |= FIELD_IS_SYMBOLIC;
+		is_symbolic_field = 0;
+	}
+
 	type = read_token(&token);
 	*tok = token;
 
@@ -2393,10 +2406,12 @@ process_function(struct event_format *event, struct print_arg *arg,
 
 	if (strcmp(token, "__print_flags") == 0) {
 		free_token(token);
+		is_flag_field = 1;
 		return process_flags(event, arg, tok);
 	}
 	if (strcmp(token, "__print_symbolic") == 0) {
 		free_token(token);
+		is_symbolic_field = 1;
 		return process_symbols(event, arg, tok);
 	}
 	if (strcmp(token, "__get_str") == 0) {
-- 
1.7.5.4


