Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410Ab2FVGar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 02:30:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:6744 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761382Ab2FVGao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 02:30:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="161108611"
Subject: [set5 PATCH 5/6] Revert "[SCSI] fix async probe regression"
To: linux-scsi@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: Meelis Roos <mroos@linux.ee>, linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 23:47:22 -0700
Message-ID: <20120622064722.21538.62310.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
References: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 43a8d39d0137612c336aa8bbb2cb886a79772ffb.

Commit 43a8d39d fixed the fact that wait_for_device_probe() was unable
to flush sd probe work.  Now that sd probe work is once again flushable
via wait_for_device_probe() this workaround is no longer needed.

Cc: Meelis Roos <mroos@linux.ee>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/scsi_scan.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2731c81..03ebb37 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -147,7 +147,7 @@ int scsi_complete_async_scans(void)
 
 	do {
 		if (list_empty(&scanning_hosts))
-			goto out;
+			return 0;
 		/* If we can't get memory immediately, that's OK.  Just
 		 * sleep a little.  Even if we never get memory, the async
 		 * scans will finish eventually.
@@ -179,11 +179,8 @@ int scsi_complete_async_scans(void)
 	}
  done:
 	spin_unlock(&async_scan_lock);
-	kfree(data);
-
- out:
-	async_synchronize_full_domain(&scsi_sd_probe_domain);
 
+	kfree(data);
 	return 0;
 }
 

