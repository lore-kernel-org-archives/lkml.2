Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761958Ab0HGHBX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 03:01:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:50715 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab0HGHBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 03:01:20 -0400
Date: Sat, 7 Aug 2010 07:00:42 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4C577AD8.50808@hitachi.com>
References: <4C577AD8.50808@hitachi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix to copy the type for raw parameters
Message-ID: <tip-58432e1f3625ef22b347ec8f9487e1852aa9ad67@git.kernel.org>
Git-Commit-ID: 58432e1f3625ef22b347ec8f9487e1852aa9ad67
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 07 Aug 2010 07:00:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58432e1f3625ef22b347ec8f9487e1852aa9ad67
Gitweb:     http://git.kernel.org/tip/58432e1f3625ef22b347ec8f9487e1852aa9ad67
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Tue, 3 Aug 2010 11:11:36 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 6 Aug 2010 16:25:56 -0300

perf probe: Fix to copy the type for raw parameters

Copy type field if it is for raw parameters.
Without this fix, perf probe drops the type if user passes it
for raw parameters (e.g. %ax:u32 will be converted to %ax).

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <4C577AD8.50808@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 6c7750d..5251366 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -705,8 +705,12 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 		pf->tvar->value = strdup(pf->pvar->var);
 		if (pf->tvar->value == NULL)
 			return -ENOMEM;
-		else
-			return 0;
+		if (pf->pvar->type) {
+			pf->tvar->type = strdup(pf->pvar->type);
+			if (pf->tvar->type == NULL)
+				return -ENOMEM;
+		}
+		return 0;
 	}
 
 	pr_debug("Searching '%s' variable in context.\n",
