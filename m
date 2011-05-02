Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab1EBNQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 09:16:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:24067 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606Ab1EBNQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 09:16:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,302,1301900400"; 
   d="scan'208";a="636711123"
Date: Mon, 2 May 2011 15:16:25 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Wei Ni <wni@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ccross@android.com" <ccross@android.com>,
        Varun Wadekar <vwadekar@nvidia.com>, Emily Jiang <ejiang@nvidia.com>
Subject: Re: [PATCH] mfd: call disable_irq()/enable_irq() in suspend/resume
Message-ID: <20110502131624.GB740@sortiz-mobl>
References: <1301379390-28063-1-git-send-email-wni@nvidia.com>
 <6B4D417B830BC44B8026029FD256F7F1C2CB3DD499@HKMAIL01.nvidia.com>
 <6B4D417B830BC44B8026029FD256F7F1C2CB3DD4C0@HKMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6B4D417B830BC44B8026029FD256F7F1C2CB3DD4C0@HKMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
