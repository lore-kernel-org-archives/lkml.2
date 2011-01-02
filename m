Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1ABIDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:03:06 -0500
Received: from mail.windriver.com ([147.11.1.11]:34725 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab1ABHWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:25 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Tejun Heo <htejun@gmail.com>,
        Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 061/260] libata: skip EH autopsy and recovery during suspend
Date: Sun,  2 Jan 2011 02:15:57 -0500
Message-Id: <1293952756-15010-62-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:12.0257 (UTC) FILETIME=[A2505B10:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

commit e2f3d75fc0e4a0d03c61872bad39ffa2e74a04ff upstream.

For some mysterious reason, certain hardware reacts badly to usual EH
actions while the system is going for suspend.  As the devices won't
be needed until the system is resumed, ask EH to skip usual autopsy
and recovery and proceed directly to suspend.

Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/ata/libata-core.c |   14 +++++++++++++-
 drivers/ata/libata-eh.c   |    4 ++++
 include/linux/libata.h    |    1 +
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5abab5d..5405b36 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5526,6 +5526,7 @@ static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
  */
 int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 {
+	unsigned int ehi_flags = ATA_EHI_QUIET;
 	int rc;
 
 	/*
@@ -5534,7 +5535,18 @@ int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 	 */
 	ata_lpm_enable(host);
 
-	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
+	/*
+	 * On some hardware, device fails to respond after spun down
+	 * for suspend.  As the device won't be used before being
+	 * resumed, we don't need to touch the device.  Ask EH to skip
+	 * the usual stuff and proceed directly to suspend.
+	 *
+	 * http://thread.gmane.org/gmane.linux.ide/46764
+	 */
+	if (mesg.event == PM_EVENT_SUSPEND)
+		ehi_flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_NO_RECOVERY;
+
+	rc = ata_host_request_pm(host, mesg, 0, ehi_flags, 1);
 	if (rc == 0)
 		host->dev->power.power_state = mesg;
 	return rc;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 228740f..1cf0bff 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3234,6 +3234,10 @@ static int ata_eh_skip_recovery(struct ata_link *link)
 	if (link->flags & ATA_LFLAG_DISABLED)
 		return 1;
 
+	/* skip if explicitly requested */
+	if (ehc->i.flags & ATA_EHI_NO_RECOVERY)
+		return 1;
+
 	/* thaw frozen port and recover failed devices */
 	if ((ap->pflags & ATA_PFLAG_FROZEN) || ata_link_nr_enabled(link))
 		return 0;
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b2f2003..79878c2 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -340,6 +340,7 @@ enum {
 	ATA_EHI_HOTPLUGGED	= (1 << 0),  /* could have been hotplugged */
 	ATA_EHI_NO_AUTOPSY	= (1 << 2),  /* no autopsy */
 	ATA_EHI_QUIET		= (1 << 3),  /* be quiet */
+	ATA_EHI_NO_RECOVERY	= (1 << 4),  /* no recovery */
 
 	ATA_EHI_DID_SOFTRESET	= (1 << 16), /* already soft-reset this port */
 	ATA_EHI_DID_HARDRESET	= (1 << 17), /* already soft-reset this port */
-- 
1.7.3.3

