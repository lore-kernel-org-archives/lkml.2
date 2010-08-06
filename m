Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965721Ab0HFT3h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:29:37 -0400
Received: from kroah.org ([198.145.64.141]:47529 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965620Ab0HFT2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:28:24 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 12:21:17 2010
Message-Id: <20100806192117.771064392@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 12:20:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [36/36] ssb: Handle alternate SSPROM location
In-Reply-To: <20100806192649.GA1614@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 9d1ac34ec3a67713308ae0883c3359c557f14d17 upstream.

In kernel Bugzilla #15825 (2 users), in a wireless mailing list thread
(http://lists.infradead.org/pipermail/b43-dev/2010-May/000124.html), and on a
netbook owned by John Linville
(http://marc.info/?l=linux-wireless&m=127230751408818&w=4), there are reports
of ssb failing to detect an SPROM at the normal location. After studying the
MMIO trace dump for the Broadcom wl driver, it was determined that the affected
boxes had a relocated SPROM.

This patch fixes all systems that have reported this problem.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ssb/driver_chipcommon.c |    1 +
 drivers/ssb/pci.c               |   15 +++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -235,6 +235,7 @@ void ssb_chipcommon_init(struct ssb_chip
 		return; /* We don't have a ChipCommon */
 	if (cc->dev->id.revision >= 11)
 		cc->status = chipco_read32(cc, SSB_CHIPCO_CHIPSTAT);
+	ssb_dprintk(KERN_INFO PFX "chipcommon status is 0x%x\n", cc->status);
 	ssb_pmu_init(cc);
 	chipco_powercontrol_init(cc);
 	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_FAST);
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -626,11 +626,22 @@ static int ssb_pci_sprom_get(struct ssb_
 		return -ENODEV;
 	}
 	if (bus->chipco.dev) {	/* can be unavailible! */
-		bus->sprom_offset = (bus->chipco.dev->id.revision < 31) ?
-			SSB_SPROM_BASE1 : SSB_SPROM_BASE31;
+		/*
+		 * get SPROM offset: SSB_SPROM_BASE1 except for
+		 * chipcommon rev >= 31 or chip ID is 0x4312 and
+		 * chipcommon status & 3 == 2
+		 */
+		if (bus->chipco.dev->id.revision >= 31)
+			bus->sprom_offset = SSB_SPROM_BASE31;
+		else if (bus->chip_id == 0x4312 &&
+			 (bus->chipco.status & 0x03) == 2)
+			bus->sprom_offset = SSB_SPROM_BASE31;
+		else
+			bus->sprom_offset = SSB_SPROM_BASE1;
 	} else {
 		bus->sprom_offset = SSB_SPROM_BASE1;
 	}
+	ssb_dprintk(KERN_INFO PFX "SPROM offset is 0x%x\n", bus->sprom_offset);
 
 	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
 	if (!buf)


