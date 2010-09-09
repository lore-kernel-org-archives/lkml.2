Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab0IIToZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:44:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:40527 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab0IIToY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:44:24 -0400
Date: Thu, 9 Sep 2010 19:43:59 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        fweisbec@gmail.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100827113859.22882.75598.stgit@ltc236.sdl.hitachi.co.jp>
References: <20100827113859.22882.75598.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix handling of arguments names
Message-ID: <tip-367e94c10092469c896a226a77ef13cf6da757e4@git.kernel.org>
Git-Commit-ID: 367e94c10092469c896a226a77ef13cf6da757e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:44:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  367e94c10092469c896a226a77ef13cf6da757e4
Gitweb:     http://git.kernel.org/tip/367e94c10092469c896a226a77ef13cf6da757e4
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Fri, 27 Aug 2010 20:38:59 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 8 Sep 2010 11:47:19 -0300

perf probe: Fix handling of arguments names

Don't make argument names from raw parameters (means the parameters are written
in kprobe-tracer syntax), because the argument syntax may include special
characters.  Just leave it, then kprobe-tracer gives a new name.

Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100827113859.22882.75598.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 9b0e1b1..32b81f7 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -686,6 +686,25 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 	char buf[32], *ptr;
 	int ret, nscopes;
 
+	if (!is_c_varname(pf->pvar->var)) {
+		/* Copy raw parameters */
+		pf->tvar->value = strdup(pf->pvar->var);
+		if (pf->tvar->value == NULL)
+			return -ENOMEM;
+		if (pf->pvar->type) {
+			pf->tvar->type = strdup(pf->pvar->type);
+			if (pf->tvar->type == NULL)
+				return -ENOMEM;
+		}
+		if (pf->pvar->name) {
+			pf->tvar->name = strdup(pf->pvar->name);
+			if (pf->tvar->name == NULL)
+				return -ENOMEM;
+		} else
+			pf->tvar->name = NULL;
+		return 0;
+	}
+
 	if (pf->pvar->name)
 		pf->tvar->name = strdup(pf->pvar->name);
 	else {
@@ -700,19 +719,6 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 	if (pf->tvar->name == NULL)
 		return -ENOMEM;
 
-	if (!is_c_varname(pf->pvar->var)) {
-		/* Copy raw parameters */
-		pf->tvar->value = strdup(pf->pvar->var);
-		if (pf->tvar->value == NULL)
-			return -ENOMEM;
-		if (pf->pvar->type) {
-			pf->tvar->type = strdup(pf->pvar->type);
-			if (pf->tvar->type == NULL)
-				return -ENOMEM;
-		}
-		return 0;
-	}
-
 	pr_debug("Searching '%s' variable in context.\n",
 		 pf->pvar->var);
 	/* Search child die for local variables and parameters. */
