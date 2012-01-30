Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab2A3Kum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 05:50:42 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39065 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202Ab2A3Kul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 05:50:41 -0500
Date: Mon, 30 Jan 2012 11:50:37 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com
Subject: [PATCH] perf: fix perf top number of samples displayed
Message-ID: <20120130105037.GA5160@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In recent versions of perf top, pressing the 'e' key
to change the number of displayed samples had no effect.
The number of samples was still dictated by the size of
the terminal (stdio mode). That was quite annoying because
typically only the first dozen samples really matter.

This patch fixes this.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

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
