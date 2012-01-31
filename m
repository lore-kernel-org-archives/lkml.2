Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab2AaBYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:24:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:44346 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab2AaBYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:24:49 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/9] perf top: Fix number of samples displayed
Date: Mon, 30 Jan 2012 23:24:36 -0200
Message-Id: <1327973079-29426-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327973079-29426-1-git-send-email-acme@infradead.org>
References: <1327973079-29426-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

In recent versions of perf top, pressing the 'e' key to change the
number of displayed samples had no effect.

The number of samples was still dictated by the size of the terminal
(stdio mode). That was quite annoying because typically only the first
dozen samples really matter.

This patch fixes this.

Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120130105037.GA5160@quad
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e8b033c..d869b21 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -88,8 +88,6 @@ void get_term_dimensions(struct winsize *ws)
 
 static void perf_top__update_print_entries(struct perf_top *top)
 {
-	top->print_entries = top->winsize.ws_row;
-
 	if (top->print_entries > 9)
 		top->print_entries -= 9;
 }
@@ -99,6 +97,13 @@ static void perf_top__sig_winch(int sig __used, siginfo_t *info __used, void *ar
 	struct perf_top *top = arg;
 
 	get_term_dimensions(&top->winsize);
+	if (!top->print_entries
+	    || (top->print_entries+4) > top->winsize.ws_row) {
+		top->print_entries = top->winsize.ws_row;
+	} else {
+		top->print_entries += 4;
+		top->winsize.ws_row = top->print_entries;
+	}
 	perf_top__update_print_entries(top);
 }
 
@@ -452,8 +457,10 @@ static void perf_top__handle_keypress(struct perf_top *top, int c)
 				};
 				perf_top__sig_winch(SIGWINCH, NULL, top);
 				sigaction(SIGWINCH, &act, NULL);
-			} else
+			} else {
+				perf_top__sig_winch(SIGWINCH, NULL, top);
 				signal(SIGWINCH, SIG_DFL);
+			}
 			break;
 		case 'E':
 			if (top->evlist->nr_entries > 1) {
-- 
1.7.9.rc2.1.g69204

