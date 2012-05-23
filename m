Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965233Ab2EWPWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:22:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40831 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965221Ab2EWPWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:22:01 -0400
Date: Wed, 23 May 2012 08:21:28 -0700
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Message-ID: <tip-e326e7524531c5c6de4a8cf8eeed60b4a9f47637@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, tzanussi@gmail.com, peterz@infradead.org,
        namhyung.kim@lge.com, fweisbec@gmail.com, rostedt@goodmis.org,
        fweisbec@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, peterz@infradead.org,
        namhyung.kim@lge.com, fweisbec@gmail.com, rostedt@goodmis.org,
        fweisbec@redhat.com, tglx@linutronix.de
In-Reply-To: <1337697049-30251-1-git-send-email-fweisbec@gmail.com>
References: <1337697049-30251-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Explicitly handle known default print arg type
Git-Commit-ID: e326e7524531c5c6de4a8cf8eeed60b4a9f47637
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 23 May 2012 08:21:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e326e7524531c5c6de4a8cf8eeed60b4a9f47637
Gitweb:     http://git.kernel.org/tip/e326e7524531c5c6de4a8cf8eeed60b4a9f47637
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 22 May 2012 16:30:48 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 22 May 2012 12:31:26 -0300

perf script: Explicitly handle known default print arg type

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
