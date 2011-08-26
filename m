Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab1HZPiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 11:38:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:58650 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab1HZPh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 11:37:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/6] perf probe: Fix regression of variable finder
Date: Fri, 26 Aug 2011 12:37:06 -0300
Message-Id: <1314373031-6687-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1314373031-6687-1-git-send-email-acme@infradead.org>
References: <1314373031-6687-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix to call convert_variable() if previous call does not fail.

To call convert_variable, it ensures "ret" is 0. However, since
"ret" has the return value of synthesize_perf_probe_arg() which
always returns positive value if it succeeded, perf probe doesn't
call convert_variable(). This will cause a SEGV when we add an
event with arguments.

This has to be fixed as it ensures "ret" is greater than 0
(or not negative).

This regression has been introduced by my previous patch, f182e3e1.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20110820053922.3286.65805.stgit@fedora15
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 555fc38..5d73262 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -659,7 +659,7 @@ static int find_variable(Dwarf_Die *sc_die, struct probe_finder *pf)
 		if (!die_find_variable_at(&pf->cu_die, pf->pvar->var, 0, &vr_die))
 			ret = -ENOENT;
 	}
-	if (ret == 0)
+	if (ret >= 0)
 		ret = convert_variable(&vr_die, pf);
 
 	if (ret < 0)
-- 
1.6.2.5

