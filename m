Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879Ab2D0Ink (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:43:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34486 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759838Ab2D0Inh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:43:37 -0400
Date: Fri, 27 Apr 2012 01:43:15 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-inzjrzyqhkzyv78met2vula6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, hagen@jauu.net, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, hagen@jauu.net,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Handle NULL jump targets
Git-Commit-ID: 9481ede909e08418c9379665ee9f25335d20dd06
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:43:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9481ede909e08418c9379665ee9f25335d20dd06
Gitweb:     http://git.kernel.org/tip/9481ede909e08418c9379665ee9f25335d20dd06
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 25 Apr 2012 07:48:42 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Apr 2012 07:48:42 -0300

perf annotate browser: Handle NULL jump targets

In annotate_browser__mark_jump_targets

702                     dlt = browser->offsets[dl->ops.target];
703                     bdlt = disasm_line__browser(dlt);
704                     bdlt->jump_target = true;
705             }
706
707     }

(gdb) p size
$5 = 2415
(gdb) p offset
$6 = 140
(gdb) p dl->ops.target
$7 = 143
(gdb) p browser->offsets[143]
$8 = (struct disasm_line *) 0x0
(gdb) p dl->name
$9 = 0x2363bd0 "je"
(gdb)

Really strange, the code assumed that at the jump target we would have
an assembly line, but only in the previous instruction offset we have a
'lock':

(gdb) p browser->offsets[144]
$10 = (struct disasm_line *) 0x0
(gdb) p browser->offsets[142]
$11 = (struct disasm_line *) 0x27bd620
(gdb) p browser->offsets[142]->name
$12 = 0x237a8a0 "lock"
(gdb)

I'll study this more, but for now I'll just check if there is a
disasm_line at dl->ops.target, i.e. a valid jump target.

Reported-by: Hagen Paul Pfeifer <hagen@jauu.net>
Reported-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-inzjrzyqhkzyv78met2vula6@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 9e3310c..4c83fe3 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -700,6 +700,13 @@ static void annotate_browser__mark_jump_targets(struct annotate_browser *browser
 		}
 
 		dlt = browser->offsets[dl->ops.target];
+		/*
+ 		 * FIXME: Oops, no jump target? Buggy disassembler? Or do we
+ 		 * have to adjust to the previous offset?
+ 		 */
+		if (dlt == NULL)
+			continue;
+
 		bdlt = disasm_line__browser(dlt);
 		bdlt->jump_target = true;
 	}
