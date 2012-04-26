Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab2DZPGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:06:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:53715 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2DZPGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:06:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/4] perf annotate browser: Handle NULL jump targets
Date: Thu, 26 Apr 2012 12:06:14 -0300
Message-Id: <1335452777-27326-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335452777-27326-1-git-send-email-acme@infradead.org>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 1 file changed, 7 insertions(+)

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
-- 
1.7.9.2.358.g22243

