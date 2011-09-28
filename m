Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab1I1WkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:40:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab1I1WkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:40:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:29 2011
Message-Id: <20110928220128.938081511@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Alan Cox <alan@linux.intel.com>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: [035/244] pata_via: disable ATAPI DMA on AVERATEC 3200
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 6d0e194d2eefcaab6dbdca1f639748660144acb5 upstream.

On AVERATEC 3200, pata_via causes memory corruption with ATAPI DMA,
which often leads to random kernel oops.  The cause of the problem is
not well understood yet and only small subset of machines using the
controller seem affected.  Blacklist ATAPI DMA on the machine.

Signed-off-by: Tejun Heo <tj@kernel.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=11426
Reported-and-tested-by: Jim Bray <jimsantelmo@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_via.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -124,6 +124,17 @@ static const struct via_isa_bridge {
 	{ NULL }
 };
 
+static const struct dmi_system_id no_atapi_dma_dmi_table[] = {
+	{
+		.ident = "AVERATEC 3200",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AVERATEC"),
+			DMI_MATCH(DMI_BOARD_NAME, "3200"),
+		},
+	},
+	{ }
+};
+
 struct via_port {
 	u8 cached_device;
 };
@@ -355,6 +366,13 @@ static unsigned long via_mode_filter(str
 			mask &= ~ ATA_MASK_UDMA;
 		}
 	}
+
+	if (dev->class == ATA_DEV_ATAPI &&
+	    dmi_check_system(no_atapi_dma_dmi_table)) {
+		ata_dev_printk(dev, KERN_WARNING, "controller locks up on ATAPI DMA, forcing PIO\n");
+		mask &= ATA_MASK_PIO;
+	}
+
 	return mask;
 }
 


