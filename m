Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0IRTPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:34 -0400
Received: from kroah.org ([198.145.64.141]:43571 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756923Ab0IRTPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:32 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:03 2010
Message-Id: <20100918191303.349633894@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [070/129] libata: skip EH autopsy and recovery during suspend
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <htejun@gmail.com>

commit e2f3d75fc0e4a0d03c61872bad39ffa2e74a04ff upstream.

For some mysterious reason, certain hardware reacts badly to usual EH
actions while the system is going for suspend.  As the devices won't
be needed until the system is resumed, ask EH to skip usual autopsy
and recovery and proceed directly to suspend.

Signed-off-by: Tejun Heo <tj@kernel.org>
Tested-by: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |   14 +++++++++++++-
 drivers/ata/libata-eh.c   |    4 ++++
 include/linux/libata.h    |    1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5434,6 +5434,7 @@ static int ata_host_request_pm(struct at
  */
 int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 {
+	unsigned int ehi_flags = ATA_EHI_QUIET;
 	int rc;
 
 	/*
@@ -5442,7 +5443,18 @@ int ata_host_suspend(struct ata_host *ho
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
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3234,6 +3234,10 @@ static int ata_eh_skip_recovery(struct a
 	if (link->flags & ATA_LFLAG_DISABLED)
 		return 1;
 
+	/* skip if explicitly requested */
+	if (ehc->i.flags & ATA_EHI_NO_RECOVERY)
+		return 1;
+
 	/* thaw frozen port and recover failed devices */
 	if ((ap->pflags & ATA_PFLAG_FROZEN) || ata_link_nr_enabled(link))
 		return 0;
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -335,6 +335,7 @@ enum {
 	ATA_EHI_HOTPLUGGED	= (1 << 0),  /* could have been hotplugged */
 	ATA_EHI_NO_AUTOPSY	= (1 << 2),  /* no autopsy */
 	ATA_EHI_QUIET		= (1 << 3),  /* be quiet */
+	ATA_EHI_NO_RECOVERY	= (1 << 4),  /* no recovery */
 
 	ATA_EHI_DID_SOFTRESET	= (1 << 16), /* already soft-reset this port */
 	ATA_EHI_DID_HARDRESET	= (1 << 17), /* already soft-reset this port */


