Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab2BOKTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 05:19:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:37218 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2BOKTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 05:19:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="107904456"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [RESEND PATCH v2 3/3] ata: runtime suspend port if no device attached
Date: Wed, 15 Feb 2012 18:18:52 +0800
Message-Id: <1329301132-3687-4-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1329301132-3687-1-git-send-email-ming.m.lin@intel.com>
References: <1329301132-3687-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function ata_device_probed(...) to check if device was probed.
Runtime suspend scsi_host--->ata port if no device was probed.

Controller will be runtime suspended if all port were suspended already.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/libata-core.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c04ad68..1ff921b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5906,6 +5906,21 @@ int ata_port_probe(struct ata_port *ap)
 	return rc;
 }
 
+/**
+ *	ata_device_probed - Check if device is probed
+ *	@ap:	port to check
+ */
+static bool ata_device_probed(struct ata_port *ap)
+{
+	struct ata_link *link;
+	struct ata_device *dev;
+
+	ata_for_each_link(link, ap, EDGE)
+		ata_for_each_dev(dev, link, ENABLED)
+			return true;
+
+	return false;
+}
 
 static void async_port_probe(void *data, async_cookie_t cookie)
 {
@@ -5926,7 +5941,11 @@ static void async_port_probe(void *data, async_cookie_t cookie)
 	/* in order to keep device order, we need to synchronize at this point */
 	async_synchronize_cookie(cookie);
 
-	ata_scsi_scan_host(ap, 1);
+	if (ata_device_probed(ap))
+		ata_scsi_scan_host(ap, 1);
+	else
+		/* Runtime suspend it if no device is attached */
+		pm_runtime_idle(&ap->scsi_host->shost_gendev);
 }
 
 /**
-- 
1.7.2.5

