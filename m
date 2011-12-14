Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab1LNDSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 22:18:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:53347 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537Ab1LNDSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 22:18:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="86301865"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH 1/3] [SCSI] sd: fix runtime status check in sd_shutdown
Date: Wed, 14 Dec 2011 11:17:59 +0800
Message-Id: <1323832681-7177-2-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1323832681-7177-1-git-send-email-ming.m.lin@intel.com>
References: <1323832681-7177-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit af8db15 disabled device's runtime PM during shutdown.
So sd's runtime status can't be checked with pm_runtime_suspended(dev)
any more.

Fix it by checking runtime status with pm_runtime_status_suspended(dev).

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/sd.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7b3f807..284b087 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2742,7 +2742,12 @@ static void sd_shutdown(struct device *dev)
 	if (!sdkp)
 		return;         /* this can happen */
 
-	if (pm_runtime_suspended(dev))
+	/*
+	 * Check runtime status with pm_runtime_status_suspended(dev)
+	 * instead of pm_runtime_suspended(dev),
+	 * because device_shutdown() has disabled the device's runtime PM.
+	 */
+	if (pm_runtime_status_suspended(dev))
 		goto exit;
 
 	if (sdkp->WCE) {
-- 
1.7.2.5

