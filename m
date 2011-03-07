Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab1CGPzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:55:53 -0500
Received: from dakia2.marvell.com ([65.219.4.35]:33393 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab1CGPzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:55:20 -0500
X-ASG-Debug-ID: 1299512691-082e751d0001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: johnpol@2ka.mipt.ru, sameo@linux.intel.com, a.zummo@towertech.it,
        lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
        dmitry.torokhov@gmail.com, dtor@mail.ru, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH] mfd: add workqueue thread into 88pm860x
Subject: [PATCH] mfd: add workqueue thread into 88pm860x
Date: Mon,  7 Mar 2011 23:43:13 +0800
X-ASG-Orig-Subj: [PATCH] mfd: add workqueue thread into 88pm860x
Message-Id: <1299512600-29047-5-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
References: <1299512600-29047-1-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-2-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-3-git-send-email-haojian.zhuang@marvell.com>
 <1299512600-29047-4-git-send-email-haojian.zhuang@marvell.com>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1299512691
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create workqueue thread in 88pm860x driver since 88pm860x driver
needs to handle event in workqueue.

Avoid to use system workqueue since i2c operation cost a lot of
time. It would impact system performance.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
---
 drivers/mfd/88pm860x-core.c  |   12 ++++++++++++
 include/linux/mfd/88pm860x.h |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
index 9c511c1..42c4fa2 100644
--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -766,11 +766,21 @@ static void __devinit device_8607_init(struct pm860x_chip *chip,
 	if (ret < 0)
 		goto out;
 
+	chip->monitor_wqueue = create_singlethread_workqueue("88pm860x");
+	if (!chip->monitor_wqueue) {
+		ret = -ESRCH;
+		goto out_work;
+	}
+
 	device_regulator_init(chip, i2c, pdata);
 	device_onkey_init(chip, i2c, pdata);
 	device_touch_init(chip, i2c, pdata);
 	device_power_init(chip, i2c, pdata);
 	device_codec_init(chip, i2c, pdata);
+	return;
+
+out_work:
+	device_irq_exit(chip);
 out:
 	return;
 }
@@ -807,6 +817,8 @@ int __devinit pm860x_device_init(struct pm860x_chip *chip,
 
 void __devexit pm860x_device_exit(struct pm860x_chip *chip)
 {
+	flush_workqueue(chip->monitor_wqueue);
+	destroy_workqueue(chip->monitor_wqueue);
 	device_irq_exit(chip);
 	mfd_remove_devices(chip->dev);
 }
diff --git a/include/linux/mfd/88pm860x.h b/include/linux/mfd/88pm860x.h
index a6f6f81..87df510 100644
--- a/include/linux/mfd/88pm860x.h
+++ b/include/linux/mfd/88pm860x.h
@@ -301,6 +301,7 @@ struct pm860x_chip {
 	struct mutex		irq_lock;
 	struct i2c_client	*client;
 	struct i2c_client	*companion;	/* companion chip client */
+	struct workqueue_struct	*monitor_wqueue;
 
 	int			buck3_double;	/* DVC ramp slope double */
 	unsigned short		companion_addr;
-- 
1.5.6.5

