Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab2CYVMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 17:12:34 -0400
Received: from uucp.gnuu.de ([83.246.114.63]:2801 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab2CYVMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 17:12:32 -0400
From: =?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@alea.gnuu.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?J=C3=B6rg=20Sommer?= <joerg@alea.gnuu.de>
Subject: [PATCH 2/2] perf tools: Fix parsing of unary operator in ?: expression
Date: Sun, 25 Mar 2012 23:11:32 +0200
Message-Id: <bc768c12ba3df410cb3a049ea6d88d39a993768d.1332709498.git.joerg@alea.gnuu.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <05a6b9ad17375452aedc994c4553137750db0a13.1332709498.git.joerg@alea.gnuu.de>
References: <05a6b9ad17375452aedc994c4553137750db0a13.1332709498.git.joerg@alea.gnuu.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parsing an expression like

print fmt: "reason %s (%d)", …, REC->errno < 0 ? -REC->errno : REC->reason

in kvm_space_exit fails with

Fatal unknown op ':'

The colon after a simple operator signals the end of this expression. The
token should not be advanced, because the colon is handled in
process_cond(). Hence, it's enough to signal there's an operation
heading.

Signed-off-by: Jörg Sommer <joerg@alea.gnuu.de>
---
An alternative could be:

 --- a/tools/perf/util/trace-event-parse.c
 +++ b/tools/perf/util/trace-event-parse.c
 @@ -1287,7 +1287,7 @@ process_op(struct event *event, struct print_arg *arg, char **tok)
                return EVENT_NONE;
        }
 
-       if (type == EVENT_OP) {
+       if (type == EVENT_OP && strcmp(*tok, ":") != 0) {
                int prio;
 
                /* higher prios need to be closer to the root */


 tools/perf/util/trace-event-parse.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 185e284..d7b5880 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1125,6 +1125,7 @@ static int get_op_prio(char *op)
 		case '|':
 			return 13;
 		case '?':
+		case ':':
 			return 16;
 		default:
 			die("unknown op '%c'", op[0]);
@@ -1202,6 +1203,8 @@ process_op(struct event *event, struct print_arg *arg, char **tok)
 
 		type = process_arg(event, right, tok);
 
+	} else if (strcmp(token, ":") == 0) {
+		return EVENT_OP;
 	} else if (strcmp(token, "?") == 0) {
 
 		left = malloc_or_die(sizeof(*left));
-- 
1.7.9.1

