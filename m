Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2AaBVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 20:21:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54020 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab2AaBVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 20:21:38 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf top: Fix number of samples displayed
Date: Mon, 30 Jan 2012 23:21:19 -0200
Message-Id: <1327972879-29214-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327972879-29214-1-git-send-email-acme@infradead.org>
References: <1327972879-29214-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
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
index 8f80df8..dd162aa 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -89,8 +89,6 @@ void get_term_dimensions(struct winsize *ws)
 
 static void perf_top__update_print_entries(struct perf_top *top)
 {
-	top->print_entries = top->winsize.ws_row;
-
 	if (top->print_entries > 9)
 		top->print_entries -= 9;
 }
@@ -100,6 +98,13 @@ static void perf_top__sig_winch(int sig __used, siginfo_t *info __used, void *ar
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
 
@@ -453,8 +458,10 @@ static void perf_top__handle_keypress(struct perf_top *top, int c)
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
1.7.4.4

