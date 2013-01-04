Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab3ADAIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:08:07 -0500
Received: from mail4.aviatnet.com ([192.147.115.31]:56656 "EHLO
	mail4.aviatnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab3ADAHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:07:41 -0500
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2013 19:07:41 EST
Message-ID: <1357257748.31023.12.camel@pc786-ubu.GNET.GLOBAL.VPN>
Subject: [PATCH] mtd: m25p80: Flash protection support for STmicro chips
From: Austin Boyle <Austin.Boyle@aviatnet.com>
To: David Woodhouse <dwmw2@infradead.org>, <linux-mtd@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Fri, 4 Jan 2013 13:02:28 +1300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.16.1.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds generic support for flash protection on STmicro chips.
On chips with less than 3 protection bits, the unused bits are don't cares
and so can be written anyway. The lock function will only change the
protection bits if it would not unlock other areas. Similarly, the unlock
function will not lock currently unlocked areas. Tested on the m25p64.

From: Austin Boyle <Austin.Boyle@aviatnet.com>
Signed-off-by: Austin Boyle <Austin.Boyle@aviatnet.com>
---
diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 4eeeb2d..069e34f 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -565,6 +565,96 @@ time_out:
 	return ret;
 }
 
+static int m25p80_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
+{
+	struct m25p *flash = mtd_to_m25p(mtd);
+	uint32_t offset = ofs;
+	uint8_t status_old, status_new;
+	int res = 0;
+
+	mutex_lock(&flash->lock);
+	/* Wait until finished previous command */
+	if (wait_till_ready(flash)) {
+		res = 1;
+		goto err;
+	}
+
+	status_old = read_sr(flash);
+
+	if (offset < flash->mtd.size-(flash->mtd.size/2))
+		status_new = status_old | SR_BP2 | SR_BP1 | SR_BP0;
+	else if (offset < flash->mtd.size-(flash->mtd.size/4))
+		status_new = (status_old & ~SR_BP0) | SR_BP2 | SR_BP1;
+	else if (offset < flash->mtd.size-(flash->mtd.size/8))
+		status_new = (status_old & ~SR_BP1) | SR_BP2 | SR_BP0;
+	else if (offset < flash->mtd.size-(flash->mtd.size/16))
+		status_new = (status_old & ~(SR_BP0|SR_BP1)) | SR_BP2;
+	else if (offset < flash->mtd.size-(flash->mtd.size/32))
+		status_new = (status_old & ~SR_BP2) | SR_BP1 | SR_BP0;
+	else if (offset < flash->mtd.size-(flash->mtd.size/64))
+		status_new = (status_old & ~(SR_BP2|SR_BP0)) | SR_BP1;
+	else
+		status_new = (status_old & ~(SR_BP2|SR_BP1)) | SR_BP0;
+
+	/* Only modify protection if it will not unlock other areas */
+	if ((status_new&(SR_BP2|SR_BP1|SR_BP0)) >
+					(status_old&(SR_BP2|SR_BP1|SR_BP0))) {
+		write_enable(flash);
+		if (write_sr(flash, status_new) < 0) {
+			res = 1;
+			goto err;
+		}
+	}
+
+err:	mutex_unlock(&flash->lock);
+	return res;
+}
+
+static int m25p80_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
+{
+	struct m25p *flash = mtd_to_m25p(mtd);
+	uint32_t offset = ofs;
+	uint8_t status_old, status_new;
+	int res = 0;
+
+	mutex_lock(&flash->lock);
+	/* Wait until finished previous command */
+	if (wait_till_ready(flash)) {
+		res = 1;
+		goto err;
+	}
+
+	status_old = read_sr(flash);
+
+	if (offset+len > flash->mtd.size-(flash->mtd.size/64))
+		status_new = status_old & ~(SR_BP2|SR_BP1|SR_BP0);
+	else if (offset+len > flash->mtd.size-(flash->mtd.size/32))
+		status_new = (status_old & ~(SR_BP2|SR_BP1)) | SR_BP0;
+	else if (offset+len > flash->mtd.size-(flash->mtd.size/16))
+		status_new = (status_old & ~(SR_BP2|SR_BP0)) | SR_BP1;
+	else if (offset+len > flash->mtd.size-(flash->mtd.size/8))
+		status_new = (status_old & ~SR_BP2) | SR_BP1 | SR_BP0;
+	else if (offset+len > flash->mtd.size-(flash->mtd.size/4))
+		status_new = (status_old & ~(SR_BP0|SR_BP1)) | SR_BP2;
+	else if (offset+len > flash->mtd.size-(flash->mtd.size/2))
+		status_new = (status_old & ~SR_BP1) | SR_BP2 | SR_BP0;
+	else
+		status_new = (status_old & ~SR_BP0) | SR_BP2 | SR_BP1;
+
+	/* Only modify protection if it will not lock other areas */
+	if ((status_new&(SR_BP2|SR_BP1|SR_BP0)) <
+					(status_old&(SR_BP2|SR_BP1|SR_BP0))) {
+		write_enable(flash);
+		if (write_sr(flash, status_new) < 0) {
+			res = 1;
+			goto err;
+		}
+	}
+
+err:	mutex_unlock(&flash->lock);
+	return res;
+}
+
 /****************************************************************************/
 
 /*
@@ -899,6 +989,12 @@ static int m25p_probe(struct spi_device *spi)
 	flash->mtd._erase = m25p80_erase;
 	flash->mtd._read = m25p80_read;
 
+	/* flash protection support for STmicro chips */
+	if (JEDEC_MFR(info->jedec_id) == CFI_MFR_ST) {
+		flash->mtd._lock = m25p80_lock;
+		flash->mtd._unlock = m25p80_unlock;
+	}
+
 	/* sst flash chips use AAI word program */
 	if (JEDEC_MFR(info->jedec_id) == CFI_MFR_SST)
 		flash->mtd._write = sst_write;

