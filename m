Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab2LUEle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 23:41:34 -0500
Received: from mail-la0-f74.google.com ([209.85.215.74]:55820 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2LUEl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 23:41:28 -0500
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 23:41:28 EST
From: Derek Basehore <dbasehore@chromium.org>
To: JBottomley@parallels.com
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH 2/2] ata: don't wait on resume
Date: Thu, 20 Dec 2012 20:35:40 -0800
Message-Id: <1356064540-17414-2-git-send-email-dbasehore@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1356064540-17414-1-git-send-email-dbasehore@chromium.org>
References: <1356064540-17414-1-git-send-email-dbasehore@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When resuming an ata port, do not wait for the function ata_port_request_pm to
return. The reasoning behing this is that we can resume the device much faster
if we do not wait for ata ports connected to spinning disks to resume.

A small change is made in ata_port_request_pm to make it return 0 when we do not
wait. Previously, the function just returned an uninitialized variable if it did
not wait.

The pm runtime status of the ata port is set to active (even though is has not
fully resumed yet).

Signed-off-by: Derek Basehore <dbasehore@chromium.org>

Conflicts:

	drivers/ata/libata-core.c

---
 drivers/ata/libata-core.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9e8b99a..c700b79 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5279,7 +5279,7 @@ bool ata_link_offline(struct ata_link *link)
 #ifdef CONFIG_PM
 static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 			       unsigned int action, unsigned int ehi_flags,
-			       int *async)
+			       int *async, int wait)
 {
 	struct ata_link *link;
 	unsigned long flags;
@@ -5289,9 +5289,12 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 	 * progress.  Wait for PM_PENDING to clear.
 	 */
 	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
-		if (async) {
-			*async = -EAGAIN;
-			return 0;
+		if (!wait) {
+			if (async) {
+				*async = -EAGAIN;
+				return 0;
+			}
+			return -EAGAIN;
 		}
 		ata_port_wait_eh(ap);
 		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
@@ -5303,7 +5306,7 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 	ap->pm_mesg = mesg;
 	if (async)
 		ap->pm_result = async;
-	else
+	else if (wait)
 		ap->pm_result = &rc;
 
 	ap->pflags |= ATA_PFLAG_PM_PENDING;
@@ -5317,7 +5320,7 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	/* wait and check result */
-	if (!async) {
+	if (wait) {
 		ata_port_wait_eh(ap);
 		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
 	}
@@ -5341,7 +5344,8 @@ static int __ata_port_suspend_common(struct ata_port *ap, pm_message_t mesg, int
 	if (mesg.event == PM_EVENT_SUSPEND)
 		ehi_flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_NO_RECOVERY;
 
-	rc = ata_port_request_pm(ap, mesg, 0, ehi_flags, async);
+	rc = ata_port_request_pm(ap, mesg, 0, ehi_flags, async,
+			async == NULL ? 1 : 0);
 	return rc;
 }
 
@@ -5381,7 +5385,8 @@ static int __ata_port_resume_common(struct ata_port *ap, int *async)
 	int rc;
 
 	rc = ata_port_request_pm(ap, PMSG_ON, ATA_EH_RESET,
-		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, async);
+		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, async,
+		async == NULL ? 1 : 0);
 	return rc;
 }
 
@@ -5394,9 +5399,11 @@ static int ata_port_resume_common(struct device *dev)
 
 static int ata_port_resume(struct device *dev)
 {
+	struct ata_port *ap = to_ata_port(dev);
 	int rc;
 
-	rc = ata_port_resume_common(dev);
+	rc = ata_port_request_pm(ap, PMSG_ON, ATA_EH_RESET,
+		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, NULL, 0);
 	if (!rc) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
-- 
1.7.7.3

