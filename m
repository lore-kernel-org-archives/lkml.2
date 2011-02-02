Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1BBBJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:09:44 -0500
Received: from mga11.intel.com ([192.55.52.93]:1497 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab1BBAnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653504902"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: borislav.petkov@amd.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [18/139] EDAC: Fix workqueue-related crashes
Message-Id: <20110202004332.A483C3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Borislav Petkov <borislav.petkov@amd.com>

commit bb31b3122c0dd07d2d958da17a50ad771ce79e2b upstream.

00740c58541b6087d78418cebca1fcb86dc6077d changed edac_core to
un-/register a workqueue item only if a lowlevel driver supplies a
polling routine. Normally, when we remove a polling low-level driver, we
go and cancel all the queued work. However, the workqueue unreg happens
based on the ->op_state setting, and edac_mc_del_mc() sets this to
OP_OFFLINE _before_ we cancel the work item, leading to NULL ptr oops on
the workqueue list.

Fix it by putting the unreg stuff in proper order.

Reported-and-tested-by: Tobias Karnat <tobias.karnat@googlemail.com>
LKML-Reference: <1291201307.3029.21.camel@Tobias-Karnat>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/edac/edac_mc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/drivers/edac/edac_mc.c
===================================================================
--- linux-2.6.35.y.orig/drivers/edac/edac_mc.c
+++ linux-2.6.35.y/drivers/edac/edac_mc.c
@@ -575,14 +575,16 @@ struct mem_ctl_info *edac_mc_del_mc(stru
 		return NULL;
 	}
 
-	/* marking MCI offline */
-	mci->op_state = OP_OFFLINE;
-
 	del_mc_from_global_list(mci);
 	mutex_unlock(&mem_ctls_mutex);
 
-	/* flush workq processes and remove sysfs */
+	/* flush workq processes */
 	edac_mc_workq_teardown(mci);
+
+	/* marking MCI offline */
+	mci->op_state = OP_OFFLINE;
+
+	/* remove from sysfs */
 	edac_remove_sysfs_mci_device(mci);
 
 	edac_printk(KERN_INFO, EDAC_MC,
