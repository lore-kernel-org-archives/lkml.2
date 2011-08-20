Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab1HTF5A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 01:57:00 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45549 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1HTF44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 01:56:56 -0400
X-AuditID: b753bd60-a28adba0000019f4-d1-4e4f4ca56483
X-AuditID: b753bd60-a28adba0000019f4-d1-4e4f4ca56483
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip ] [BUGFIX] perf probe: Fix regression of variable finder
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Sat, 20 Aug 2011 14:39:23 +0900
Message-ID: <20110820053922.3286.65805.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to call convert_variable() if previous call does not fail.

To call convert_variable, it ensures "ret" is 0. However, since
"ret" has the return value of synthesize_perf_probe_arg() which
always returns positive value if it succeeded, perf probe doesn't
call convert_variable(). This will cause a SEGV when we add an
event with arguments.

This has to be fixed as it ensures "ret" is greater than 0
(or not negative).

This regression has been introduced by my previous patch, f182e3e1.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
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

