Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab2HSErH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 00:47:07 -0400
Received: from mail.digium.com ([216.207.245.2]:37494 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab2HSErC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 00:47:02 -0400
From: Shaun Ruffell <sruffell@digium.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Subject: [PATCH 2/3] edac: edac_mc_free() cannot assume mem_ctl_info is registered in sysfs.
Date: Sat, 18 Aug 2012 23:11:23 -0500
Message-Id: <1345349484-31552-3-git-send-email-sruffell@digium.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1345349484-31552-1-git-send-email-sruffell@digium.com>
References: <20120810092223.GA27375@localhost>
 <1345349484-31552-1-git-send-email-sruffell@digium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

edac_mc_free() may need to deallocate any memory associated with struct
mem_ctl_info directly if the structure was never registered with sysfs in
edac_mc_add_mc(). This moves the error handling code from edac_mc_alloc() into a
dedicated function to be called by edac_mc_free() as well if necessary.

This resolves a NULL pointer dereference from the following code path first
introduced in 3.6-rc1:

  EDAC MC: Ver: 3.0.0
  EDAC DEBUG: edac_mc_sysfs_init: device mc created
  EDAC DEBUG: e7xxx_init_one:
  EDAC DEBUG: e7xxx_probe1: mci
  EDAC DEBUG: edac_mc_alloc: errcount layer 0 size 8
  EDAC DEBUG: edac_mc_alloc: errcount layer 1 size 16
  EDAC DEBUG: edac_mc_alloc: allocating 48 error counters
  EDAC DEBUG: edac_mc_alloc: allocating 1068 bytes for mci data (16 ranks, 16 csrows/channels)
  EDAC DEBUG: e7xxx_probe1: init mci
  EDAC DEBUG: e7xxx_probe1: init pvt
  EDAC e7xxx: error reporting device not found:vendor 8086 device 0x2541 (broken BIOS?)
  EDAC DEBUG: edac_mc_free:
  Floppy drive(s): fd0 is 1.44M
  EDAC DEBUG: edac_unregister_sysfs: Unregistering device (null)

Signed-off-by: Shaun Ruffell <sruffell@digium.com>
---
 drivers/edac/edac_mc.c | 59 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 20 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 9037ffa..a58facc 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -199,6 +199,36 @@ void *edac_align_ptr(void **p, unsigned size, int n_elems)
 	return (void *)(((unsigned long)ptr) + align - r);
 }
 
+static void _edac_mc_free(struct mem_ctl_info *mci)
+{
+	int i, chn, row;
+	struct csrow_info *csr;
+	const unsigned int tot_dimms = mci->tot_dimms;
+	const unsigned int tot_channels = mci->num_cschannel;
+	const unsigned int tot_csrows = mci->nr_csrows;
+
+	if (mci->dimms) {
+		for (i = 0; i < tot_dimms; i++)
+			kfree(mci->dimms[i]);
+		kfree(mci->dimms);
+	}
+	if (mci->csrows) {
+		for (row = 0; row < tot_csrows; row++) {
+			csr = mci->csrows[row];
+			if (csr) {
+				if (csr->channels) {
+					for (chn = 0; chn < tot_channels; chn++)
+						kfree(csr->channels[chn]);
+					kfree(csr->channels);
+				}
+				kfree(csr);
+			}
+		}
+		kfree(mci->csrows);
+	}
+	kfree(mci);
+}
+
 /**
  * edac_mc_alloc: Allocate and partially fill a struct mem_ctl_info structure
  * @mc_num:		Memory controller number
@@ -413,26 +443,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	return mci;
 
 error:
-	if (mci->dimms) {
-		for (i = 0; i < tot_dimms; i++)
-			kfree(mci->dimms[i]);
-		kfree(mci->dimms);
-	}
-	if (mci->csrows) {
-		for (row = 0; row < tot_csrows; row++) {
-			csr = mci->csrows[row];
-			if (csr) {
-				if (csr->channels) {
-					for (chn = 0; chn < tot_channels; chn++)
-						kfree(csr->channels[chn]);
-					kfree(csr->channels);
-				}
-				kfree(csr);
-			}
-		}
-		kfree(mci->csrows);
-	}
-	kfree(mci);
+	_edac_mc_free(mci);
 
 	return NULL;
 }
@@ -447,6 +458,14 @@ void edac_mc_free(struct mem_ctl_info *mci)
 {
 	edac_dbg(1, "\n");
 
+	/* If we're not yet registered with sysfs free only what was allocated
+	 * in edac_mc_alloc().
+	 */
+	if (!mci->bus.name) {
+		_edac_mc_free(mci);
+		return;
+	}
+
 	/* the mci instance is freed here, when the sysfs object is dropped */
 	edac_unregister_sysfs(mci);
 }
-- 
1.7.11.2

