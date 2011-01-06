Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1AFA3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:12 -0500
Received: from kroah.org ([198.145.64.141]:35456 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab1AFA3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:06 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:22:58 2011
Message-Id: <20110106002258.858968802@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [023/152] EDAC: Fix workqueue-related crashes
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/edac/edac_mc.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -578,14 +578,16 @@ struct mem_ctl_info *edac_mc_del_mc(stru
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


