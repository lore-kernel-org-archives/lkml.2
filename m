Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1LBX5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:57:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:46810 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab1LBX5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:57:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,286,1320652800"; 
   d="scan'208";a="91762461"
Subject: [PATCH 3/3] scsi: use drain_workqueue
To: tj@kernel.org, JBottomley@parallels.com
From: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>,
        Robert Love <robert.w.love@intel.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Date: Fri, 02 Dec 2011 15:57:01 -0800
Message-ID: <20111202235700.24470.23826.stgit@localhost6.localdomain6>
In-Reply-To: <20111202235319.24470.65483.stgit@localhost6.localdomain6>
References: <20111202235319.24470.65483.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15-7-g9bfb-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use 'drain' versus 'flush' as the former additionally flushes chained
operations.  libsas uses chained operations when it posts discovery work
in response to a port event.

As a result the hardcoded double-flush can be removed from the isci
driver.

Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Robert Love <robert.w.love@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/hosts.c     |    8 ++++----
 drivers/scsi/isci/host.c |    3 ---
 include/scsi/scsi_host.h |    2 +-
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 351dc0b..37155d1 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -564,19 +564,19 @@ int scsi_queue_work(struct Scsi_Host *shost, struct work_struct *work)
 EXPORT_SYMBOL_GPL(scsi_queue_work);
 
 /**
- * scsi_flush_work - Flush a Scsi_Host's workqueue.
+ * scsi_flush_work - Drain a Scsi_Host's workqueue.
  * @shost:	Pointer to Scsi_Host.
  **/
-void scsi_flush_work(struct Scsi_Host *shost)
+int scsi_flush_work(struct Scsi_Host *shost)
 {
 	if (!shost->work_q) {
 		printk(KERN_ERR
 			"ERROR: Scsi host '%s' attempted to flush scsi-work, "
 			"when no workqueue created.\n", shost->hostt->name);
 		dump_stack();
-		return;
+		return 0;
 	}
 
-	flush_workqueue(shost->work_q);
+	return drain_workqueue(shost->work_q);
 }
 EXPORT_SYMBOL_GPL(scsi_flush_work);
diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index e7fe9c4..240779a 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -655,9 +655,6 @@ int isci_host_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	if (test_bit(IHOST_START_PENDING, &ihost->flags))
 		return 0;
 
-	/* todo: use sas_flush_discovery once it is upstream */
-	scsi_flush_work(shost);
-
 	scsi_flush_work(shost);
 
 	dev_dbg(&ihost->pdev->dev,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 50266c9..505bc34 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -770,7 +770,7 @@ static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
 }
 
 extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
-extern void scsi_flush_work(struct Scsi_Host *);
+extern int scsi_flush_work(struct Scsi_Host *);
 
 extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
 extern int __must_check scsi_add_host_with_dma(struct Scsi_Host *,

