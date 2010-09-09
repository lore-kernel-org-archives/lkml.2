Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0IIRHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:07:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36348 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab0IIRHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 13:07:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/5] perf probe: Fix handling of arguments names
Date: Thu,  9 Sep 2010 14:06:43 -0300
Message-Id: <1284052005-25658-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1284052005-25658-1-git-send-email-acme@infradead.org>
References: <1284052005-25658-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

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
-- 
1.6.2.5

