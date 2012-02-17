Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab2BQRnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:43:45 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55020 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab2BQRnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:43:11 -0500
Message-ID: <4F3E9187.9080308@ti.com>
Date: Fri, 17 Feb 2012 18:42:31 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Milton Miller <miltonm@bga.com>, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 00/27] irq_domain generalization and rework
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca> <20120216145219.0f1c1b98.akpm@linux-foundation.org>
In-Reply-To: <20120216145219.0f1c1b98.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 2/16/2012 11:52 PM, Andrew Morton wrote:
> On Thu, 16 Feb 2012 02:09:01 -0700
> Grant Likely<grant.likely@secretlab.ca>  wrote:
> 
>>
>> This series generalizes the "irq_host" infrastructure from powerpc
>> so that it can be used by all architectures and renames it to "irq_domain".
> 
> drivers/mfd/twl-core.c is fairly horked on i386 allmodconfig:
> 
> drivers/mfd/twl-core.c: In function 'twl_probe':
> drivers/mfd/twl-core.c:1218: error: implicit declaration of function 'irq_alloc_descs'
> drivers/mfd/twl-core.c:1226: error: implicit declaration of function 'irq_domain_add_legacy'
> drivers/mfd/twl-core.c:1227: error: 'irq_domain_simple_ops' undeclared (first use in this function)
> drivers/mfd/twl-core.c:1227: error: (Each undeclared identifier is reported only once
> drivers/mfd/twl-core.c:1227: error: for each function it appears in.)
> 
> 
> This is today's linux-next so it has rmk's "ARM: omap: fix broken
> twl-core dependencies and ifdefs" in there, which looks like it
> attempts to repair this stuff.

If we cannot assume this driver will be used only on architecture that does support IRQ_DOMAIN, we have to keep the #ifdef and then add the missing linux/irq.h.

Since this driver is using IRQ_DOMAIN only for Device Tree support, we can still avoid using irq_domain_add_legacy for the legacy non-DT case.
That's too bad because I was expecting to use irq_domain to clean the cascading IRQ scheme used in that driver, but that can wait.

The fix is trivial, but here it is just in case.

Regards,
Benoit


---
>From 0faf51f8475025260d5db808b1651a38b409803d Mon Sep 17 00:00:00 2001
From: Benoit Cousson <b-cousson@ti.com>
Date: Fri, 17 Feb 2012 18:13:31 +0100
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
index 59888f5..61441e2 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -38,6 +38,7 @@
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/irq.h>
 #include <linux/irqdomain.h>
 
 #include <linux/regulator/machine.h>
@@ -1237,8 +1238,10 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	pdata->irq_base = status;
 	pdata->irq_end = pdata->irq_base + nr_irqs;
+#ifdef IRQ_DOMAIN
 	irq_domain_add_legacy(node, nr_irqs, pdata->irq_base, 0,
 			      &irq_domain_simple_ops, NULL);
+#endif
 
 	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
-- 
1.7.5.4



