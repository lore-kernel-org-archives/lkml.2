Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab2IEMfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 08:35:05 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47412 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2IEMfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 08:35:03 -0400
Date: Wed, 5 Sep 2012 15:34:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] da9052-battery: don't free IRQ that wasn't requested
Message-ID: <20120905123440.GF6128@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should decrement "i" before doing the free_irq().  If we call this
because request_threaded_irq() failed then we don't want to free the
thing which failed.  Or in the case where we get here because
power_supply_register() failed then the original codes does a read past
the end of the array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
index 20b86ed..d9d034d 100644
--- a/drivers/power/da9052-battery.c
+++ b/drivers/power/da9052-battery.c
@@ -623,7 +623,7 @@ static s32 __devinit da9052_bat_probe(struct platform_device *pdev)
 	return 0;
 
 err:
-	for (; i >= 0; i--) {
+	while (--i >= 0) {
 		irq = platform_get_irq_byname(pdev, da9052_bat_irqs[i]);
 		free_irq(bat->da9052->irq_base + irq, bat);
 	}
