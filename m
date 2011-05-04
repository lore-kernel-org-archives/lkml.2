Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1EDGtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 02:49:25 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6248 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab1EDGtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 02:49:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 03 May 2011 23:49:23 -0700
From: Wei Ni <wni@nvidia.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>,
        Varun Wadekar <vwadekar@nvidia.com>
Date: Wed, 4 May 2011 14:49:19 +0800
Subject: RE: [PATCH] mfd: call disable_irq()/enable_irq() in suspend/resume
Thread-Topic: [PATCH] mfd: call disable_irq()/enable_irq() in suspend/resume
Thread-Index: AcwIyyeEyMZLLvX9Sl6gNP+PD4wgyQBWxSVg
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C2CB3DD4E8@HKMAIL01.nvidia.com>
References: <1301379390-28063-1-git-send-email-wni@nvidia.com>
 <6B4D417B830BC44B8026029FD256F7F1C2CB3DD499@HKMAIL01.nvidia.com>
 <6B4D417B830BC44B8026029FD256F7F1C2CB3DD4C0@HKMAIL01.nvidia.com>
 <20110502131624.GB740@sortiz-mobl>
In-Reply-To: <20110502131624.GB740@sortiz-mobl>
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

Hi, Samuel
I tried your codes, it looks ok, the error messages disappeared.
Could you submit your patch?

BTW, what kernel version do you use?
In my 2.6.39, the SIMPLE_DEV_PM_OPS only have 3 arguments,
and it should be" .pm     = &tps6586x_pm_ops,"

Thanks
Wei.

-----Original Message-----
From: Samuel Ortiz [mailto:sameo@linux.intel.com] 
Sent: Monday, May 02, 2011 9:16 PM
To: Wei Ni
Cc: linux-kernel@vger.kernel.org; ccross@android.com; Varun Wadekar; Emily Jiang
Subject: Re: [PATCH] mfd: call disable_irq()/enable_irq() in suspend/resume

Hi Wei,

> When use rtc tps6586x wakealarm to suspend/resume system,
> it will show a lot error messages:
> "tps6586x 4-0034: failed to read interrupt status
> tps6586x 4-0034: failed reading from 0xb5"
> After resume, the system will call the mfd tps6586x driver's interrupt handle
> tps6586x_irq(). This handle will read tps6586x interrupt status (0xb5), but at
> that time the i2c driver didn't resume yet, so the reading will be failed.
> I call the disble_irq in the suspend, and enable_irq in the resume, which will
> delay the delivery of the irq until the i2c driver has been resumed.
I think something like this would make more sense:

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index bba26d9..a5feeb5 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -569,10 +569,36 @@ static const struct i2c_device_id tps6586x_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, tps6586x_id_table);
 
+#ifdef CONFIG_PM
+static int tps6586x_suspend(struct device *dev)
+{
+	struct i2c_client *i2c = to_i2c_client(dev);
+
+	if (device_may_wakeup(&i2c->dev) && i2c->irq)
+		enable_irq_wake(i2c->irq);
+
+	return 0;
+}
+
+static int tps6586x_resume(struct device *dev)
+{
+	struct i2c_client *i2c = to_i2c_client(dev);
+
+	if (device_may_wakeup(&i2c->dev) && i2c->irq)
+		disable_irq_wake(i2c->irq);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(tps6586x_pm_ops, tps6586x_suspend, tps6586x_resume,
+			    NULL);
+
 static struct i2c_driver tps6586x_driver = {
 	.driver	= {
 		.name	= "tps6586x",
 		.owner	= THIS_MODULE,
+		.pm     = tps6586x_pm_ops,
 	},
 	.probe		= tps6586x_i2c_probe,
 	.remove		= __devexit_p(tps6586x_i2c_remove),

Could you please try ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
