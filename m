Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2E3ALk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 20:11:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:36110 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab2E3ALj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 20:11:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/4] perf annotate browser: The idx_asm field should be used in asm only view
Date: Tue, 29 May 2012 21:11:28 -0300
Message-Id: <1338336688-25616-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1338336688-25616-1-git-send-email-acme@infradead.org>
References: <1338336688-25616-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When hide_src_view is true we can't use browser_disasm_line->idx, that
takes into account also non asm lines, we must use browser_disasm_line->idx_asm
instead, otherwise we may end up with an index after the number of
entries, oops, fix it.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-o1szpyjh3z87yi0n6x0cr8uu@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 6e0ef79..aaf36ce 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -300,10 +300,14 @@ static void annotate_browser__set_rb_top(struct annotate_browser *browser,
 {
 	struct browser_disasm_line *bpos;
 	struct disasm_line *pos;
+	u32 idx;
 
 	bpos = rb_entry(nd, struct browser_disasm_line, rb_node);
 	pos = ((struct disasm_line *)bpos) - 1;
-	annotate_browser__set_top(browser, pos, bpos->idx);
+	idx = bpos->idx;
+	if (browser->hide_src_code)
+		idx = bpos->idx_asm;
+	annotate_browser__set_top(browser, pos, idx);
 	browser->curr_hot = nd;
 }
 
-- 
1.7.9.2.358.g22243

