Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2AaN0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:26:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2AaN0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:26:07 -0500
Date: Tue, 31 Jan 2012 05:25:41 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-509605dbe9395ce1abbfac1dba375f074ff57a53@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120130105037.GA5160@quad>
References: <20120130105037.GA5160@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Fix number of samples displayed
Git-Commit-ID: 509605dbe9395ce1abbfac1dba375f074ff57a53
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jan 2012 05:25:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  509605dbe9395ce1abbfac1dba375f074ff57a53
Gitweb:     http://git.kernel.org/tip/509605dbe9395ce1abbfac1dba375f074ff57a53
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 30 Jan 2012 11:50:37 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 30 Jan 2012 22:29:49 -0200

perf top: Fix number of samples displayed

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
