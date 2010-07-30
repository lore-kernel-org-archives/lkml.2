Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab0G3Sjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:39:39 -0400
Received: from kroah.org ([198.145.64.141]:57886 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759745Ab0G3RyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:24 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:35 2010
Message-Id: <20100730175135.306422763@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [019/205] hwmon: (k10temp) Do not blacklist known working CPU models
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit eefc2d9e3d4f8820f2c128a0e44a23de28b1ed64 upstream.

When detecting AM2+ or AM3 socket with DDR2, only blacklist cores
which are known to exist in AM2+ format.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/k10temp.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -112,11 +112,21 @@ static bool __devinit has_erratum_319(st
 	if (pkg_type != CPUID_PKGTYPE_AM2R2_AM3)
 		return false;
 
-	/* Differentiate between AM2+ (bad) and AM3 (good) */
+	/* DDR3 memory implies socket AM3, which is good */
 	pci_bus_read_config_dword(pdev->bus,
 				  PCI_DEVFN(PCI_SLOT(pdev->devfn), 2),
 				  REG_DCT0_CONFIG_HIGH, &reg_dram_cfg);
-	return !(reg_dram_cfg & DDR3_MODE);
+	if (reg_dram_cfg & DDR3_MODE)
+		return false;
+
+	/*
+	 * Unfortunately it is possible to run a socket AM3 CPU with DDR2
+	 * memory. We blacklist all the cores which do exist in socket AM2+
+	 * format. It still isn't perfect, as RB-C2 cores exist in both AM2+
+	 * and AM3 formats, but that's the best we can do.
+	 */
+	return boot_cpu_data.x86_model < 4 ||
+	       (boot_cpu_data.x86_model == 4 && boot_cpu_data.x86_mask <= 2);
 }
 
 static int __devinit k10temp_probe(struct pci_dev *pdev,


