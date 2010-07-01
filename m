Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab0GAVNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:13:25 -0400
Received: from kroah.org ([198.145.64.141]:33713 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758820Ab0GAVMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:12:49 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:47 2010
Message-Id: <20100701174247.281384439@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:41:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Nick Bowler <nbowler@elliptictech.com>, David Zeuthen <david@fubar.dk>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [010/200] libata: disable ATAPI AN by default
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit e7ecd435692ca9bde9d124be30b3a26e672ea6c2 upstream.

There are ATAPI devices which raise AN when hit by commands issued by
open().  This leads to infinite loop of AN -> MEDIA_CHANGE uevent ->
udev open() to check media -> AN.

Both ACS and SerialATA standards don't define in which case ATAPI
devices are supposed to raise or not raise AN.  They both list media
insertion event as a possible use case for ATAPI ANs but there is no
clear description of what constitutes such events.  As such, it seems
a bit too naive to export ANs directly to userland as MEDIA_CHANGE
events without further verification (which should behave similarly to
windows as it apparently is the only thing that some hardware vendors
are testing against).

This patch adds libata.atapi_an module parameter and disables ATAPI AN
by default for now.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Nick Bowler <nbowler@elliptictech.com>
Cc: David Zeuthen <david@fubar.dk>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -160,6 +160,10 @@ int libata_allow_tpm = 0;
 module_param_named(allow_tpm, libata_allow_tpm, int, 0444);
 MODULE_PARM_DESC(allow_tpm, "Permit the use of TPM commands (0=off [default], 1=on)");
 
+static int atapi_an;
+module_param(atapi_an, int, 0444);
+MODULE_PARM_DESC(atapi_an, "Enable ATAPI AN media presence notification (0=0ff [default], 1=on)");
+
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Library module for ATA devices");
 MODULE_LICENSE("GPL");
@@ -2572,7 +2576,8 @@ int ata_dev_configure(struct ata_device
 		 * to enable ATAPI AN to discern between PHY status
 		 * changed notifications and ATAPI ANs.
 		 */
-		if ((ap->flags & ATA_FLAG_AN) && ata_id_has_atapi_AN(id) &&
+		if (atapi_an &&
+		    (ap->flags & ATA_FLAG_AN) && ata_id_has_atapi_AN(id) &&
 		    (!sata_pmp_attached(ap) ||
 		     sata_scr_read(&ap->link, SCR_NOTIFICATION, &sntf) == 0)) {
 			unsigned int err_mask;


