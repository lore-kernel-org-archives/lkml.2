Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1GJKl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 06:41:59 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56940 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab1GJKlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 06:41:55 -0400
X-AuditID: b753bd60-a28c6ba000003bac-4a-4e1981f08255
X-AuditID: b753bd60-a28c6ba000003bac-4a-4e1981f08255
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 1/5] [BUGFIX] perf-probe: Fix a memory leak for scopes
 array
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Sun, 10 Jul 2011 19:00:12 +0900
Message-ID: <20110710100012.2550.4040.stgit@fedora15>
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

Fix a memory leak for scopes array when it finds a
variable in the global scope.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---

 tools/perf/util/probe-finder.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3b9d0b8..1a35637 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1177,6 +1177,7 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 	else {
 		/* Search upper class */
 		nscopes = dwarf_getscopes_die(sp_die, &scopes);
+		ret = -ENOENT;
 		while (nscopes-- > 1) {
 			pr_debug("Searching variables in %s\n",
 				 dwarf_diename(&scopes[nscopes]));
@@ -1185,14 +1186,12 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 						 pf->pvar->var, 0,
 						 &vr_die)) {
 				ret = convert_variable(&vr_die, pf);
-				goto found;
+				break;
 			}
 		}
 		if (scopes)
 			free(scopes);
-		ret = -ENOENT;
 	}
-found:
 	if (ret < 0)
 		pr_warning("Failed to find '%s' in this function.\n",
 			   pf->pvar->var);

