Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934623Ab2C3QKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:10:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:49283 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761037Ab2C3QJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:09:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/9] perf probe: Finder fails to resolve function name to address
Date: Fri, 30 Mar 2012 13:09:20 -0300
Message-Id: <1333123764-15662-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333123764-15662-1-git-send-email-acme@infradead.org>
References: <1333123764-15662-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>

If DIE entries corresponding to declarations appear before definition
entry, probe finder returns error instead of continuing to look further
for a definition entry.

This patch ensures we reach to the DIE entry corresponding to the
definition and get the function address.

V2: A simpler solution based on Masami's suggestion.

Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/4F703FB9.9020407@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 2cc162d..d448984 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -972,10 +972,12 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 	struct dwarf_callback_param *param = data;
 	struct probe_finder *pf = param->data;
 	struct perf_probe_point *pp = &pf->pev->point;
+	Dwarf_Attribute attr;
 
 	/* Check tag and diename */
 	if (dwarf_tag(sp_die) != DW_TAG_subprogram ||
-	    !die_compare_name(sp_die, pp->function))
+	    !die_compare_name(sp_die, pp->function) ||
+	    dwarf_attr(sp_die, DW_AT_declaration, &attr))
 		return DWARF_CB_OK;
 
 	/* Check declared file */
-- 
1.7.9.2.358.g22243

