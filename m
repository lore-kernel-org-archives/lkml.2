Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab2EVObA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:31:00 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:36976 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab2EVOa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:30:58 -0400
From: fweisbec@gmail.com
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
        Frederic Weisbecker <fweisbec@redhat.com>
Subject: [PATCH 1/2] perf: Explicitly handle known default print arg type in perf scripting
Date: Tue, 22 May 2012 16:30:48 +0200
Message-Id: <1337697049-30251-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
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
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@redhat.com>
---
 .../perf/util/scripting-engines/trace-event-perl.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

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
1.7.5.4

