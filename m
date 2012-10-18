Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2JRJss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 05:48:48 -0400
Received: from mga03.intel.com ([143.182.124.21]:8465 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab2JRJsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 05:48:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,606,1344236400"; 
   d="scan'208";a="157600838"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] ptp_pch: release chip->mem_base and chip->regs on error
Date: Thu, 18 Oct 2012 17:48:52 +0800
Message-Id: <1350553732-17204-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix smatch warnings catched by Fengguang's 0-DAY system:
+ drivers/ptp/ptp_pch.c:641 pch_probe() warn: 'chip->mem_base' was not released on error
+ drivers/ptp/ptp_pch.c:641 pch_probe() warn: 'chip->regs' was not released on error

Cc: Richard Cochran <richardcochran@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/ptp/ptp_pch.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index e624e4d..daddd88 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -629,8 +629,10 @@ pch_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	chip->caps = ptp_pch_caps;
 	chip->ptp_clock = ptp_clock_register(&chip->caps, &pdev->dev);
 
-	if (IS_ERR(chip->ptp_clock))
-		return PTR_ERR(chip->ptp_clock);
+	if (IS_ERR(chip->ptp_clock)) {
+		ret = PTR_ERR(chip->ptp_clock);
+		goto err_ptp_clock;
+	}
 
 	spin_lock_init(&chip->register_lock);
 
@@ -669,6 +671,7 @@ pch_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 err_req_irq:
 	ptp_clock_unregister(chip->ptp_clock);
+err_ptp_clock:
 	iounmap(chip->regs);
 	chip->regs = 0;
 
-- 
1.7.7.6

