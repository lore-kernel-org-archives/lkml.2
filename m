Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab2E3HvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:51:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35394 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2E3Hu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:50:59 -0400
Date: Wed, 30 May 2012 00:50:42 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-o1szpyjh3z87yi0n6x0cr8uu@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf annotate browser:
  The idx_asm field should be used in asm only view
Git-Commit-ID: a44b45f236dd1c1a8caccf9a078adf2941a20267
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 00:50:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a44b45f236dd1c1a8caccf9a078adf2941a20267
Gitweb:     http://git.kernel.org/tip/a44b45f236dd1c1a8caccf9a078adf2941a20267
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 29 May 2012 20:49:14 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 29 May 2012 20:52:38 -0300

perf annotate browser: The idx_asm field should be used in asm only view

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
 1 files changed, 5 insertions(+), 1 deletions(-)

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
 
