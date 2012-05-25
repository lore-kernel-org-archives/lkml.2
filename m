Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2EYRjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:39:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:28009 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab2EYRjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:39:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="171360179"
Subject: [PATCH v2] scsi: fix async probe regression
To: JBottomley@parallels.com
From: Dan Williams <dan.j.williams@intel.com>
Cc: Meelis Roos <mroos@linux.ee>, Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        David Miller <davem@davemloft.net>
Date: Fri, 25 May 2012 10:55:07 -0700
Message-ID: <20120525175140.22423.21697.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a7a20d1 "[SCSI] sd: limit the scope of the async probe domain"
moved sd probe work out of reach of wait_for_device_probe().  Allow it
to be synced via scsi_complete_async_scans().

Cc: David Miller <davem@davemloft.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 v2: James: don't wrapper scsi_complete_async_scans()

 Kept the Tested-by tag since this is equivalent to v1.

 --
 Dan

 drivers/scsi/scsi_scan.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 01b0374..2e5fe58 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -147,7 +147,7 @@ int scsi_complete_async_scans(void)
 
 	do {
 		if (list_empty(&scanning_hosts))
-			return 0;
+			goto out;
 		/* If we can't get memory immediately, that's OK.  Just
 		 * sleep a little.  Even if we never get memory, the async
 		 * scans will finish eventually.
@@ -179,8 +179,11 @@ int scsi_complete_async_scans(void)
 	}
  done:
 	spin_unlock(&async_scan_lock);
-
 	kfree(data);
+
+ out:
+	async_synchronize_full_domain(&scsi_sd_probe_domain);
+
 	return 0;
 }
 

