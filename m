Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369Ab3AIUip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:38:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:42154 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933110Ab3AIUi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dimitris Damigos <damigos@freemail.gr>, Aaron Lu <aaron.lu@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 037/123] libata: restore acpi disable functionality
Date: Wed,  9 Jan 2013 12:34:36 -0800
Message-Id: <20130109201503.331272600@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit 0d0cdb028f9d9771e2b346038707734121f906e3 upstream.

Commit 66fa7f215 "libata-acpi: improve ACPI disabling" introdcued the
behaviour of disabling ATA ACPI if ata_acpi_on_devcfg failed the 2nd
time, but commit 30dcf76ac dropped this behaviour and this caused
problem for Dimitris Damigos, where his laptop can not resume correctly.

The bugzilla page for it is:
https://bugzilla.kernel.org/show_bug.cgi?id=49331

The problem is, ata_dev_push_id will fail the 2nd time it is invoked,
and due to disabling ACPI code is dropped, ata_acpi_on_devcfg which
calls ata_dev_push_id will keep failing and eventually made the device
disabled.

This patch restores the original behaviour, if acpi failed the 2nd time,
disable acpi functionality for the device(and we do not event need to
add a debug message for this as it is still there ;-).

Reported-by: Dimitris Damigos <damigos@freemail.gr>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-acpi.c |    4 ++++
 include/linux/libata.h    |    1 +
 2 files changed, 5 insertions(+)

--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -76,6 +76,9 @@ acpi_handle ata_dev_acpi_handle(struct a
 	acpi_integer adr;
 	struct ata_port *ap = dev->link->ap;
 
+	if (dev->flags & ATA_DFLAG_ACPI_DISABLED)
+		return NULL;
+
 	if (ap->flags & ATA_FLAG_ACPI_SATA) {
 		if (!sata_pmp_attached(ap))
 			adr = SATA_ADR(ap->port_no, NO_PORT_MULT);
@@ -945,6 +948,7 @@ int ata_acpi_on_devcfg(struct ata_device
 		return rc;
 	}
 
+	dev->flags |= ATA_DFLAG_ACPI_DISABLED;
 	ata_dev_warn(dev, "ACPI: failed the second time, disabled\n");
 
 	/* We can safely continue if no _GTF command has been executed
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -163,6 +163,7 @@ enum {
 
 	ATA_DFLAG_DA		= (1 << 26), /* device supports Device Attention */
 	ATA_DFLAG_DEVSLP	= (1 << 27), /* device supports Device Sleep */
+	ATA_DFLAG_ACPI_DISABLED = (1 << 28), /* ACPI for the device is disabled */
 
 	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
 	ATA_DEV_ATA		= 1,	/* ATA device */


