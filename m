Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2DNPxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 11:53:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab2DNPxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 11:53:19 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Mike Sterling <Mike.Sterling@microsoft.com>
Subject: [PATCH 1/2] libata: add a host flag to ignore detected ATA devices
Date: Sat, 14 Apr 2012 16:53:15 +0100
Message-Id: <1334418796-11473-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1334418796-11473-1-git-send-email-apw@canonical.com>
References: <4F87351E.9040905@pobox.com>
 <1334418796-11473-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where devices are visible via more than one host we sometimes wish to
indicate that cirtain devices should be ignored on a specific host.  Add a
host flag indicating that this host wishes to ignore ATA specific devices.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/ata/libata-core.c |    7 +++++++
 include/linux/libata.h    |    1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index e0bda9f..a85e338 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1973,6 +1973,13 @@ retry:
 	if (class == ATA_DEV_ATA) {
 		if (!ata_id_is_ata(id) && !ata_id_is_cfa(id))
 			goto err_out;
+		if (ap->host->flags & ATA_HOST_IGNORE_ATA &&
+							ata_id_is_ata(id)) {
+			ata_dev_dbg(dev,
+				"host indicates ignore ATA devices, ignored\n");
+			return -ENOENT;
+		}
+
 	} else {
 		if (ata_id_is_ata(id))
 			goto err_out;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 42378d6..198c8f1 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -247,6 +247,7 @@ enum {
 	ATA_HOST_SIMPLEX	= (1 << 0),	/* Host is simplex, one DMA channel per host only */
 	ATA_HOST_STARTED	= (1 << 1),	/* Host started */
 	ATA_HOST_PARALLEL_SCAN	= (1 << 2),	/* Ports on this host can be scanned in parallel */
+	ATA_HOST_IGNORE_ATA	= (1 << 3),	/* Ignore ATA devices on this host. */
 
 	/* bits 24:31 of host->flags are reserved for LLD specific flags */
 
-- 
1.7.9.5

