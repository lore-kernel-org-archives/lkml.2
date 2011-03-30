Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1C3GT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 02:19:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8218 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab1C3GTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 02:19:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 29 Mar 2011 23:19:53 -0700
From: Wei Ni <wni@nvidia.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "ccross@android.com" <ccross@android.com>,
        Varun Wadekar <vwadekar@nvidia.com>, Wei Ni <wni@nvidia.com>,
        Emily Jiang <ejiang@nvidia.com>
Date: Wed, 30 Mar 2011 14:19:30 +0800
Subject: RE: [PATCH] mfd: call disable_irq()/enable_irq() in suspend/resume
Thread-Topic: [PATCH] mfd: call disable_irq()/enable_irq() in suspend/resume
Thread-Index: Acvt2Otvgx632cJjTHeElwCvRXpn6wAyVQ/g
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C2CB3DD499@HKMAIL01.nvidia.com>
References: <1301379390-28063-1-git-send-email-wni@nvidia.com>
In-Reply-To: <1301379390-28063-1-git-send-email-wni@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all
Could anyone review this patch?

Thanks
Wei.

-----Original Message-----
From: Wei Ni 
Sent: Tuesday, March 29, 2011 2:17 PM
To: sameo@linux.intel.com; linux-kernel@vger.kernel.org
Cc: ccross@android.com; Varun Wadekar; Wei Ni
Subject: [PATCH] mfd: call disable_irq()/enable_irq() in suspend/resume

From: Wei Ni <wni@nvidia.com>

When use rtc tps6586x wakealarm to suspend/resume system,
it will show a lot error messages:
"tps6586x 4-0034: failed to read interrupt status
tps6586x 4-0034: failed reading from 0xb5"
After resume, the system will call the mfd tps6586x driver's interrupt handle
tps6586x_irq(). This handle will read tps6586x interrupt status (0xb5), but at
that time the i2c driver didn't resume yet, so the reading will be failed.
I call the disble_irq in the suspend, and enable_irq in the resume, which will
delay the delivery of the irq until the i2c driver has been resumed.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 drivers/mfd/tps6586x.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index b600808..c7bd96b 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -569,6 +569,22 @@ static const struct i2c_device_id tps6586x_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, tps6586x_id_table);
 
+#ifdef CONFIG_PM
+static int tps6586x_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+	if (client->irq)
+		disable_irq(client->irq);
+	return 0;
+}
+
+static int tps6586x_resume(struct i2c_client *client)
+{
+	if (client->irq)
+		enable_irq(client->irq);
+	return 0;
+}
+#endif
+
 static struct i2c_driver tps6586x_driver = {
 	.driver	= {
 		.name	= "tps6586x",
@@ -577,6 +593,10 @@ static struct i2c_driver tps6586x_driver = {
 	.probe		= tps6586x_i2c_probe,
 	.remove		= __devexit_p(tps6586x_i2c_remove),
 	.id_table	= tps6586x_id_table,
+#ifdef CONFIG_PM
+	.suspend	= tps6586x_suspend,
+	.resume		= tps6586x_resume,
+#endif
 };
 
 static int __init tps6586x_init(void)
-- 
1.7.0

