Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2CaHot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 03:44:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54801 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2CaHor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 03:44:47 -0400
Date: Sat, 31 Mar 2012 00:44:17 -0700
From: tip-bot for Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Message-ID: <tip-ba28c59bc9ed8fb7b9a753cd88ee54a2c4f6265b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, prashanth@linux.vnet.ibm.com, ananth@in.ibm.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: ananth@in.ibm.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        prashanth@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <4F703FB9.9020407@linux.vnet.ibm.com>
References: <4F703FB9.9020407@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe:
  Finder fails to resolve function name to address
Git-Commit-ID: ba28c59bc9ed8fb7b9a753cd88ee54a2c4f6265b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 31 Mar 2012 00:44:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba28c59bc9ed8fb7b9a753cd88ee54a2c4f6265b
Gitweb:     http://git.kernel.org/tip/ba28c59bc9ed8fb7b9a753cd88ee54a2c4f6265b
Author:     Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
AuthorDate: Mon, 26 Mar 2012 15:36:49 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 28 Mar 2012 11:56:49 -0300

perf probe: Finder fails to resolve function name to address

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
 1 files changed, 3 insertions(+), 1 deletions(-)

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
