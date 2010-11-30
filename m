Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab0K3UL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 15:11:27 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44618 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab0K3ULY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 15:11:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/11] perf debug: Simplify trace_event
Date: Tue, 30 Nov 2010 18:10:56 -0200
Message-Id: <1291147856-17459-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291147856-17459-1-git-send-email-acme@infradead.org>
References: <1291147856-17459-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

No need to check that many times if debug_trace is on.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/debug.c |   41 +++++++++++++----------------------------
 1 files changed, 13 insertions(+), 28 deletions(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index e5161e8..01bbe8e 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -57,21 +57,6 @@ void ui__warning(const char *format, ...)
 }
 #endif
 
-static int dump_printf_color(const char *fmt, const char *color, ...)
-{
-	va_list args;
-	int ret = 0;
-
-	if (dump_trace) {
-		va_start(args, color);
-		ret = color_vfprintf(stdout, color, fmt, args);
-		va_end(args);
-	}
-
-	return ret;
-}
-
-
 void trace_event(event_t *event)
 {
 	unsigned char *raw_event = (void *)event;
@@ -81,29 +66,29 @@ void trace_event(event_t *event)
 	if (!dump_trace)
 		return;
 
-	dump_printf(".");
-	dump_printf_color("\n. ... raw event: size %d bytes\n", color,
-			  event->header.size);
+	printf(".");
+	color_fprintf(stdout, color, "\n. ... raw event: size %d bytes\n",
+		      event->header.size);
 
 	for (i = 0; i < event->header.size; i++) {
 		if ((i & 15) == 0) {
-			dump_printf(".");
-			dump_printf_color("  %04x: ", color, i);
+			printf(".");
+			color_fprintf(stdout, color, "  %04x: ", i);
 		}
 
-		dump_printf_color(" %02x", color, raw_event[i]);
+		color_fprintf(stdout, color, " %02x", raw_event[i]);
 
 		if (((i & 15) == 15) || i == event->header.size-1) {
-			dump_printf_color("  ", color);
+			color_fprintf(stdout, color, "  ");
 			for (j = 0; j < 15-(i & 15); j++)
-				dump_printf_color("   ", color);
+				color_fprintf(stdout, color, "   ");
 			for (j = i & ~15; j <= i; j++) {
-				dump_printf_color("%c", color,
-						isprint(raw_event[j]) ?
-						raw_event[j] : '.');
+				color_fprintf(stdout, color, "%c",
+					      isprint(raw_event[j]) ?
+					      raw_event[j] : '.');
 			}
-			dump_printf_color("\n", color);
+			color_fprintf(stdout, color, "\n");
 		}
 	}
-	dump_printf(".\n");
+	printf(".\n");
 }
-- 
1.6.2.5

