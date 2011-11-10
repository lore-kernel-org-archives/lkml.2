Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab1KJGYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 01:24:06 -0500
Received: from mga03.intel.com ([143.182.124.21]:30670 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab1KJGXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 01:23:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,487,1315206000"; 
   d="scan'208";a="72745967"
From: Lin Ming <ming.m.lin@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH v2 1/4] ata: make ata port as parent device of scsi host
Date: Thu, 10 Nov 2011 14:22:43 +0800
Message-Id: <1320906166-15459-2-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
References: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the device tree of ata port and scsi host looks as below,

        /sys/devices/pci0000:00/0000:00:1f.2    (ahci controller)
        |-- ata1                                (ata port)
        |-- host0                               (scsi host)
           |-- target0:0:0                      (scsi target)
               |-- 0:0:0:0                      (disk)

This patch makes ata port as parent device of scsi host, then it becomes

        /sys/devices/pci0000:00/0000:00:1f.2    (ahci controller)
        |-- ata1                                (ata port)
            |-- host0                           (scsi host)
                |-- target0:0:0                 (scsi target)
                    |-- 0:0:0:0                 (disk)

With this change, the ata port runtime PM is easier.
For example, the ata port runtime suspend will happen as,

disk suspend --> scsi target suspend --> scsi host suspend --> ata port
suspend.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 72a9770..4c2a524 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3394,7 +3394,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		 */
 		shost->max_host_blocked = 1;
 
-		rc = scsi_add_host(ap->scsi_host, ap->host->dev);
+		rc = scsi_add_host(ap->scsi_host, &ap->tdev);
 		if (rc)
 			goto err_add;
 	}
-- 
1.7.2.5

