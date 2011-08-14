Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab1HNPjz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:39:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:60921 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab1HNPjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:39:52 -0400
Date: Sun, 14 Aug 2011 15:39:31 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-8afa2a707d3d1320df5d35966729ac5262da737d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        penberg@kernel.org, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, penberg@kernel.org,
        peterz@infradead.org, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110811110229.19900.63019.stgit@fedora15>
References: <20110811110229.19900.63019.stgit@fedora15>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix a memory leak for scopes array
Git-Commit-ID: 8afa2a707d3d1320df5d35966729ac5262da737d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 15:39:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8afa2a707d3d1320df5d35966729ac5262da737d
Gitweb:     http://git.kernel.org/tip/8afa2a707d3d1320df5d35966729ac5262da737d
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 11 Aug 2011 20:02:29 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Aug 2011 09:21:15 -0300

perf probe: Fix a memory leak for scopes array

Fix a memory leak for scopes array when it finds a variable in the
global scope.

Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20110811110229.19900.63019.stgit@fedora15
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3e44a3e..573c723 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -660,6 +660,7 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 	else {
 		/* Search upper class */
 		nscopes = dwarf_getscopes_die(sp_die, &scopes);
+		ret = -ENOENT;
 		while (nscopes-- > 1) {
 			pr_debug("Searching variables in %s\n",
 				 dwarf_diename(&scopes[nscopes]));
@@ -668,14 +669,12 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
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
