Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab2BUOwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:52:18 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51808 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab2BUOwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:52:16 -0500
Message-ID: <4F43AF71.4060207@ti.com>
Date: Tue, 21 Feb 2012 15:51:29 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 00/27] irq_domain generalization and rework
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca> <20120216145219.0f1c1b98.akpm@linux-foundation.org> <4F3E9187.9080308@ti.com> <20120217175550.GQ27825@n2100.arm.linux.org.uk>
In-Reply-To: <20120217175550.GQ27825@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/2012 6:55 PM, Russell King - ARM Linux wrote:
> On Fri, Feb 17, 2012 at 06:42:31PM +0100, Cousson, Benoit wrote:

[...]

>> @@ -1237,8 +1238,10 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
>>
>>   	pdata->irq_base = status;
>>   	pdata->irq_end = pdata->irq_base + nr_irqs;
>> +#ifdef IRQ_DOMAIN
>>   	irq_domain_add_legacy(node, nr_irqs, pdata->irq_base, 0,
>>   			&irq_domain_simple_ops, NULL);
>> +#endif
> 
> Do you really need this?  If you've tested this, then apparantly the answer
> is no, because it won't ever be built like that.  (You're missing a
> CONFIG_ prefix.)

Ooops, sorry about that.
It was indeed working fine in every cases except for the DT boot :-(

As explain before, for the moment the interrupt domain is used only for the DT boot. It is mandatory do get the interrupt binding to work properly for all the TWL sub modules (RTC...).

> Maybe the only solution to the x86 problem is to ensure that the driver
> includes linux/irq.h ?

Both will be needed to allow a DT boot with OMAP. Here is the updated version.

Regards,
Benoit

---
>From d844a8fc84d4514884356c935967f59d88a00124 Mon Sep 17 00:00:00 2001
From: Benoit Cousson <b-cousson@ti.com>
Date: Mon, 20 Feb 2012 10:58:34 +0100
Subject: [PATCH] mfd: twl-core: Fix IRQ_DOMAIN dependency

TWL chips might be potentially used on architecture that does not support
ird_domain yet.

Do not call ird_domain API in that case.

Include <linux/irq.h> directly since it will not be included anymore by
<linux/irqdomain.h> if !IRQ_DOMAIN.

Signed-off-by: Benoit Cousson <b-cousson@ti.com>
---
 drivers/mfd/twl-core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 66f9bff..18c4f93 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -38,6 +38,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/irq.h>
 #include <linux/irqdomain.h>
 
 #include <linux/regulator/machine.h>
@@ -1223,8 +1224,10 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	pdata->irq_base = status;
 	pdata->irq_end = pdata->irq_base + nr_irqs;
+#ifdef CONFIG_IRQ_DOMAIN
 	irq_domain_add_legacy(node, nr_irqs, pdata->irq_base, 0,
 			      &irq_domain_simple_ops, NULL);
+#endif
 
 	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
-- 
1.7.0.4


