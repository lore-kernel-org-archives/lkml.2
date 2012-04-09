Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab2DIMSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 08:18:34 -0400
Received: from nm18-vm0.bullet.mail.ird.yahoo.com ([77.238.189.215]:33589 "HELO
	nm18-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751292Ab2DIMSd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 08:18:33 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 816440.17564.bm@omp1006.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=f6er9jEOYz0hvcnTgSVYw5UFYgNlF2+7oUTGCDZxxiQbHlIWuPrh2U/tf9zZ7suy5eivlNPUYPWgTFiEdpuOqHrC/+8Yp6XEIHlfkJ8KbiEx0J3+Ik/PzKe9kD4L1IvTSBtYTgZU9nbsH246T0gSs9yKfXFCBYWDpP9e4y87UFI=;
X-YMail-OSG: wEPalnMVM1kgTtCydXmA3qto5KO5Hig.G0QixGAYKOKMxOs
 dfeyi_cKc9Yk2.Guwh3CNAH5mUH_7VUn.1OXuqc.NXT4UwgFqvb_JubBHF9L
 L8tfYLX8qMTSyBFDoaiYS2ZZa4PKUVzNeokDZKFPMFDNlabiIlCjITZaxrqF
 0lN9ijgzk9eQG93fmxMT7hmxcUuVC7efY5XtXX1Y.SY9_eyW1IdFNaof53YA
 b9Gj6UtuT4o7PFbPKZqZnJ30zP2iUcZS5Zgg00pCBFUBT3Q5ac_9pvn3VioN
 MViOcLI4zWcWqOUux75WJPwUuLoXLpyuSgwHO5MhaL_h2ct7EdqdpuPlRm_u
 PKdFGTsF_tX66hHiq9sl1ndMUFLq.DlU5qyWkh825J4vjLPzfFpOzn4vMP9P
 Cib_991q7eStucNVpCj1E3Z6eQNH7Y5rqc5lcrcEXJQ--
X-Mailer: YahooMailClassic/15.0.5 YahooMailWebService/0.8.117.340979
Message-ID: <1333973911.59189.YahooMailClassic@web29014.mail.ird.yahoo.com>
Date: Mon, 9 Apr 2012 13:18:31 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: [PATCH v2] mfd: asic3: Set DS1WM clock_rate
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, philipp.zabel@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mfd/asic3 driver does not set the ds1wm_driver_data clock_rate field
before passing the structure to the DS1WM w1 busmaster driver.
This was not noticed before commit 26a6afb, because ds1wm_find_divisor()
unintentionally returned the correct divisor when a zero clock_rate was
passed in. However after that commit DS1WM fails a zero clock_rate:

ds1wm ds1wm: no suitable divisor for 0Hz clock

This patch sets the ds1wm_driver_data clock_rate field.

Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
---

V2:
Separated arch/arm/mach-pxa/hx4700.c changes into a separate patch,
to avoid crossing maintainer boundaries.
This patch now submitted to linux-kernel instead of linux-arm-kernel.
Rebased from linux-3.0.1 to linux-3.4-rc2.

 drivers/mfd/asic3.c       |    9 ++++++---
 include/linux/mfd/asic3.h |    2 ++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 0c083e7..4bf02a8 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -892,10 +892,13 @@ static int __init asic3_mfd_probe(struct platform_device *pdev,
 	asic3_mmc_resources[0].start >>= asic->bus_shift;
 	asic3_mmc_resources[0].end   >>= asic->bus_shift;
 
-	ret = mfd_add_devices(&pdev->dev, pdev->id,
+	if (pdata->clock_rate) {
+		ds1wm_pdata.clock_rate = pdata->clock_rate;
+		ret = mfd_add_devices(&pdev->dev, pdev->id,
 			&asic3_cell_ds1wm, 1, mem, asic->irq_base);
-	if (ret < 0)
-		goto out;
+		if (ret < 0)
+			goto out;
+	}
 
 	if (mem_sdio && (irq >= 0)) {
 		ret = mfd_add_devices(&pdev->dev, pdev->id,
diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
index ef6faa5..e1148d0 100644
--- a/include/linux/mfd/asic3.h
+++ b/include/linux/mfd/asic3.h
@@ -31,6 +31,8 @@ struct asic3_platform_data {
 
 	unsigned int gpio_base;
 
+	unsigned int clock_rate;
+
 	struct asic3_led *leds;
 };
 
-- 
1.7.3.4

