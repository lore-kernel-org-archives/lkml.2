Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1GJKmK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 06:42:10 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58463 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab1GJKmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 06:42:02 -0400
X-AuditID: b753bd60-a14c4ba000003bac-50-4e1981f7efcc
X-AuditID: b753bd60-a14c4ba000003bac-50-4e1981f7efcc
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 2/5] [BUGFIX] perf probe: Fix line walker to check CU
 correctly
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Sun, 10 Jul 2011 19:00:21 +0900
Message-ID: <20110710100021.2550.85858.stgit@fedora15>
In-Reply-To: <20110710100005.2550.83138.stgit@fedora15>
References: <20110710100005.2550.83138.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix line walker to check whether a given DIE is CU or not.
Actually this function accepts CU, subprogram and
inlined_subroutine DIEs.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---

 tools/perf/util/probe-finder.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 1a35637..52b87f3 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -599,8 +599,9 @@ static int __die_walk_culines_cb(Dwarf_Die *sp_die, void *data)
 }
 
 /*
- * Walk on lines inside given PDIE. If the PDIE is subprogram, walk only on
- * the lines inside the subprogram, otherwise PDIE must be a CU DIE.
+ * Walk on lines inside given PDIE. If the PDIE is subprogram or
+ * inlined_subprogram, walk only on the lines inside the DIE,
+ * otherwise PDIE must be a CU DIE.
  */
 static int die_walk_lines(Dwarf_Die *pdie, line_walk_handler_t handler,
 			  void *data)
@@ -614,12 +615,12 @@ static int die_walk_lines(Dwarf_Die *pdie, line_walk_handler_t handler,
 	size_t nlines, i;
 
 	/* Get the CU die */
-	if (dwarf_tag(pdie) == DW_TAG_subprogram)
+	if (dwarf_tag(pdie) != DW_TAG_compile_unit)
 		cu_die = dwarf_diecu(pdie, &die_mem, NULL, NULL);
 	else
 		cu_die = pdie;
 	if (!cu_die) {
-		pr_debug2("Failed to get CU from subprogram\n");
+		pr_debug2("Failed to get CU from given DIE\n");
 		return -EINVAL;
 	}
 

