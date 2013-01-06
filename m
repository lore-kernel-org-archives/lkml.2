Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab3AFInP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 03:43:15 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:43057
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456Ab3AFInN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 03:43:13 -0500
X-IronPort-AV: E=Sophos;i="4.84,419,1355094000"; 
   d="scan'208";a="167531338"
Date: Sun, 6 Jan 2013 09:43:10 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Anton Vorontsov <anton@enomsg.org>
cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/power/88pm860x_battery.c: eliminate possible references
 to released resources
In-Reply-To: <20130106050953.GH6919@lizard.sbx05280.losalca.wayport.net>
Message-ID: <alpine.DEB.2.02.1301060941400.2070@localhost6.localdomain6>
References: <1354986995-2324-1-git-send-email-Julia.Lawall@lip6.fr> <20130106050953.GH6919@lizard.sbx05280.losalca.wayport.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

devm_kzalloc should not be followed by kfree, as this results in a double
free.  The problem was found using the following semantic match
(http://coccinelle.lip6.fr/):

// <smpl>
@@
expression x,e;
@@
x = devm_kzalloc(...)
... when != x = e
?-kfree(x,...);
// </smpl>

Furthermore, in the remove function, the calls to free_irq are moved up to
prevent a possible reference in the interrupt handler to resources freed by
power_supply_unregister.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
V2, moving up the calls to free_irq, instead of removing them and using
devm_request_threaded_irq.

  drivers/power/88pm860x_battery.c |   13 ++++---------
  1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/power/88pm860x_battery.c b/drivers/power/88pm860x_battery.c
index 8bc80b0..d338c1c 100644
--- a/drivers/power/88pm860x_battery.c
+++ b/drivers/power/88pm860x_battery.c
@@ -915,15 +915,13 @@ static int pm860x_battery_probe(struct platform_device *pdev)
  	info->irq_cc = platform_get_irq(pdev, 0);
  	if (info->irq_cc <= 0) {
  		dev_err(&pdev->dev, "No IRQ resource!\n");
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
  	}

  	info->irq_batt = platform_get_irq(pdev, 1);
  	if (info->irq_batt <= 0) {
  		dev_err(&pdev->dev, "No IRQ resource!\n");
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
  	}

  	info->chip = chip;
@@ -957,7 +955,7 @@ static int pm860x_battery_probe(struct platform_device *pdev)

  	ret = power_supply_register(&pdev->dev, &info->battery);
  	if (ret)
-		goto out;
+		return ret;
  	info->battery.dev->parent = &pdev->dev;

  	ret = request_threaded_irq(info->irq_cc, NULL,
@@ -984,8 +982,6 @@ out_coulomb:
  	free_irq(info->irq_cc, info);
  out_reg:
  	power_supply_unregister(&info->battery);
-out:
-	kfree(info);
  	return ret;
  }

@@ -993,10 +989,9 @@ static int pm860x_battery_remove(struct platform_device *pdev)
  {
  	struct pm860x_battery_info *info = platform_get_drvdata(pdev);

-	power_supply_unregister(&info->battery);
  	free_irq(info->irq_batt, info);
  	free_irq(info->irq_cc, info);
-	kfree(info);
+	power_supply_unregister(&info->battery);
  	platform_set_drvdata(pdev, NULL);
  	return 0;
  }

