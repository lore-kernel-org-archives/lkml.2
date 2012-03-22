Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2CVKYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:24:11 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:46861 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab2CVKYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:24:10 -0400
Message-ID: <4F6AFD92.4030603@linux.vnet.ibm.com>
Date: Thu, 22 Mar 2012 15:53:14 +0530
From: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: masami.hiramatsu.pt@hitachi.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, acme@infradead.org
CC: ananth@in.ibm.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        rostedt@goodmis.org
Subject: [PATCH] perf - probe finder fails to resolve function name to address
References: <4F6AF410.1010400@linux.vnet.ibm.com>
In-Reply-To: <4F6AF410.1010400@linux.vnet.ibm.com>
X-Forwarded-Message-Id: <4F6AF410.1010400@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032210-6148-0000-0000-000004740589
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

probe finder fails to resolve valid function names into addresses for
functions which have more than one die entries in DWARF info.

It is valid for DWARF info to contain more than 1 entries for a given
function name, where one entry corresponds to definition which has code
address/range attributes and remaining entries (which are only
declarations) does not have code address/range attributes.
(example: do_fork, sys_write, sys_wait4, sys_sync etc)

If die entries corresponding to declarations appear before definition
entry, probe finder returns error instead of continuing to look further
for a definition entry.

This patch ensures we reach to the die entry corresponding to the
definition and get the function address. I have also removed the
warning as this is a valid thing to happen.

Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
---

 tools/perf/util/probe-finder.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5d73262..5e1e6f7 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -984,10 +984,7 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 			param->retval = find_probe_point_lazy(sp_die, pf);
 		else {
 			if (dwarf_entrypc(sp_die, &pf->addr) != 0) {
-				pr_warning("Failed to get entry address of "
-					   "%s.\n", dwarf_diename(sp_die));
-				param->retval = -ENOENT;
-				return DWARF_CB_ABORT;
+				return DWARF_CB_OK;
 			}
 			pf->addr += pp->offset;
 			/* TODO: Check the address in this function */

