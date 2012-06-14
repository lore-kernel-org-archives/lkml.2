Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab2FOAAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:00:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45611 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab2FOAAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:00:08 -0400
Message-Id: <20120614235626.117961775@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arend van Spriel <arend@broadcom.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Seth Forshee <seth.forshee@canonical.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 25/42] bcma: add ext PA workaround for BCM4331 and BCM43431
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Forshee <seth.forshee@canonical.com>

commit 69aaedd3cfd23b2c732e3cf1227370a35f5c89d4 upstream.

MacBook Pro models with BCM4331 wireless have been found to have the ext
PA lines disabled after resuming from S3 without external power attach.
This causes them to be unable to transmit. Add a workaround to ensure
that the ext PA lines are enabled on BCM4331. Also extend all handling
of ext PA line muxing to BCM43431 as is done in the Broadcom SDK.

BugLink: http://bugs.launchpad.net/bugs/925577
Cc: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bcma/driver_chipcommon_pmu.c |    4 +++-
 drivers/bcma/sprom.c                 |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -139,7 +139,9 @@ void bcma_pmu_workarounds(struct bcma_dr
 		bcma_chipco_chipctl_maskset(cc, 0, ~0, 0x7);
 		break;
 	case 0x4331:
-		/* BCM4331 workaround is SPROM-related, we put it in sprom.c */
+	case 43431:
+		/* Ext PA lines must be enabled for tx on BCM4331 */
+		bcma_chipco_bcm4331_ext_pa_lines_ctl(cc, true);
 		break;
 	case 43224:
 		if (bus->chipinfo.rev == 0) {
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -432,13 +432,13 @@ int bcma_sprom_get(struct bcma_bus *bus)
 	if (!sprom)
 		return -ENOMEM;
 
-	if (bus->chipinfo.id == 0x4331)
+	if (bus->chipinfo.id == 0x4331 || bus->chipinfo.id == 43431)
 		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, false);
 
 	pr_debug("SPROM offset 0x%x\n", offset);
 	bcma_sprom_read(bus, offset, sprom);
 
-	if (bus->chipinfo.id == 0x4331)
+	if (bus->chipinfo.id == 0x4331 || bus->chipinfo.id == 43431)
 		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, true);
 
 	err = bcma_sprom_valid(sprom);


