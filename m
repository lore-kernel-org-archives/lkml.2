Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0IGMFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:05:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49971 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab0IGMFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=SVuHUtvcDssClv/Pu+AJErMzgLNFFnVCVhJFjS3VTKwYQWONQDx0tYCO+XQk+e5DDr
         pGn6/ZaTSAUDY9I96h5q4hzwIHqr0cvnkqB7VRkBPYFXmdm+fAHAmlkvBTTaNwzpQ/mh
         uAr3+6nwrsNHt7yVl21bpeiUI8ahn+Bt2OJIs=
Message-ID: <4C862A8B.3000506@gmail.com>
Date: Tue, 07 Sep 2010 14:05:31 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>,
        stable@kernel.org
Subject: [PATCH #upstream-fixes] libata: skip EH autopsy and recovery during
 suspend
References: <201007091750.05020.stephan.diestelhorst@amd.com> <4C7376BE.5040006@gmail.com> <201008242239.43249.rjw@sisk.pl> <201008270109.36687.rjw@sisk.pl> <4C7F6931.4050707@gmail.com>
In-Reply-To: <4C7F6931.4050707@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some mysterious reason, certain hardware reacts badly to usual EH
actions while the system is going for suspend.  As the devices won't
be needed until the system is resumed, ask EH to skip usual autopsy
and recovery and proceed directly to suspend.

Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Cc: stable@kernel.org
---
 drivers/ata/libata-core.c |   14 +++++++++++++-
 drivers/ata/libata-eh.c   |    4 ++++
 include/linux/libata.h    |    1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9ceb493..92cd5f3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5427,6 +5427,7 @@ static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
  */
 int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 {
+	unsigned int ehi_flags = ATA_EHI_QUIET;
 	int rc;

 	/*
@@ -5435,7 +5436,18 @@ int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
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
index 0108731..95838b3 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3242,6 +3242,10 @@ static int ata_eh_skip_recovery(struct ata_link *link)
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
index 89115f8..d1ef41b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -335,6 +335,7 @@ enum {
 	ATA_EHI_HOTPLUGGED	= (1 << 0),  /* could have been hotplugged */
 	ATA_EHI_NO_AUTOPSY	= (1 << 2),  /* no autopsy */
 	ATA_EHI_QUIET		= (1 << 3),  /* be quiet */
+	ATA_EHI_NO_RECOVERY	= (1 << 4),  /* no recovery */

 	ATA_EHI_DID_SOFTRESET	= (1 << 16), /* already soft-reset this port */
 	ATA_EHI_DID_HARDRESET	= (1 << 17), /* already soft-reset this port */
