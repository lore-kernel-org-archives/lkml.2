Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760017Ab2EVRkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:40:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:60447 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab2EVRkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:40:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/19] perf script: Explicitly handle known default print arg type
Date: Tue, 22 May 2012 14:40:04 -0300
Message-Id: <1337708407-24522-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1337708407-24522-1-git-send-email-acme@infradead.org>
References: <1337708407-24522-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

Handle the print argument types brought by the new libparsevent in perl
scripting engine.

PRINT_BSTRING and PRINT_DYNAMIC_ARRAY are treated just like strings
and thus don't require specific processing.

But PRINT_FUNC need specific plugins which are not yet handled, lets
warn if we meet this case.

This fixes:

     util/scripting-engines/trace-event-perl.c: In function define_event_symbol:
     util/scripting-engines/trace-event-perl.c:188: error: enumeration value PRINT_BSTRING not handled in switch
     util/scripting-engines/trace-event-perl.c:188: error: enumeration value PRINT_DYNAMIC_ARRAY not handled in switch
     util/scripting-engines/trace-event-perl.c:188: error: enumeration value PRINT_FUNC not handled in switch

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Link: http://lkml.kernel.org/r/1337697049-30251-1-git-send-email-fweisbec@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../perf/util/scripting-engines/trace-event-perl.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index e30749e..d50658b 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -209,6 +209,8 @@ static void define_event_symbols(struct event *event,
 		define_symbolic_values(args->symbol.symbols, ev_name,
 				       cur_field_name);
 		break;
+	case PRINT_BSTRING:
+	case PRINT_DYNAMIC_ARRAY:
 	case PRINT_STRING:
 		break;
 	case PRINT_TYPE:
@@ -220,7 +222,9 @@ static void define_event_symbols(struct event *event,
 		define_event_symbols(event, ev_name, args->op.left);
 		define_event_symbols(event, ev_name, args->op.right);
 		break;
+	case PRINT_FUNC:
 	default:
+		pr_err("Unsupported print arg type\n");
 		/* we should warn... */
 		return;
 	}
-- 
1.7.9.2.358.g22243

