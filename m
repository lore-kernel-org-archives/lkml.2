Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809Ab2D0IlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:41:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34445 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759201Ab2D0IlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:41:10 -0400
Date: Fri, 27 Apr 2012 01:40:46 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-x1dlc4d5aukj72g45o15s75k@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Handle retq instructions
Git-Commit-ID: c4cceae3ba786c136b0cf568359863d74897a48a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:40:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4cceae3ba786c136b0cf568359863d74897a48a
Gitweb:     http://git.kernel.org/tip/c4cceae3ba786c136b0cf568359863d74897a48a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 20 Apr 2012 15:57:15 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 20 Apr 2012 15:57:15 -0300

perf annotate browser: Handle retq instructions

By just returning to the previous function being annotated or to the top
main screen when popping out the base of the annotation stack.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-x1dlc4d5aukj72g45o15s75k@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index d0c606e..38f4c6f 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -599,10 +599,15 @@ show_help:
 				ui_helpline__puts("Huh? No selection. Report to linux-kernel@vger.kernel.org");
 			else if (self->selection->offset == -1)
 				ui_helpline__puts("Actions are only available for assembly lines.");
-			else if (!self->selection->ins ||
-				 !(annotate_browser__jump(self) ||
-				   annotate_browser__callq(self, evidx, timer, arg, delay_secs)))
-				ui_helpline__puts("Actions are only available for the 'callq' and jump instructions.");
+			else if (!self->selection->ins) {
+				if (strcmp(self->selection->name, "retq"))
+					goto show_sup_ins;
+				goto out;
+			} else if (!(annotate_browser__jump(self) ||
+				     annotate_browser__callq(self, evidx, timer, arg, delay_secs))) {
+show_sup_ins:
+				ui_helpline__puts("Actions are only available for 'callq', 'retq' & jump instructions.");
+			}
 			continue;
 		case K_LEFT:
 		case K_ESC:
