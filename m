Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab0L2M2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 07:28:17 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:45023 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096Ab0L2M2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 07:28:14 -0500
Date: Wed, 29 Dec 2010 14:28:08 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC/PATCH 3/3] mfd: twl4030-irq: implement bus_*lock
Message-ID: <20101229122808.GC2222@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20101228161657.GF2239@legolas.emea.dhcp.ti.com>
 <1293556459-28613-1-git-send-email-balbi@ti.com>
 <1293556459-28613-4-git-send-email-balbi@ti.com>
 <20101228235836.GA2609@opensource.wolfsonmicro.com>
 <1293583108.1822.3.camel@eowin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1293583108.1822.3.camel@eowin>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 29, 2010 at 02:38:28AM +0200, Felipe Balbi wrote:
>On Tue, 2010-12-28 at 23:58 +0000, Mark Brown wrote:
>> On Tue, Dec 28, 2010 at 07:14:19PM +0200, Felipe Balbi wrote:
>>
>> > +static void twl4030_sih_bus_sync_unlock(unsigned int irq)
>> > +{
>> > +       struct sih_agent        *agent = get_irq_chip_data(irq);
>> > +
>> > +       mutex_unlock(&agent->irq_lock);
>> > +}
>>
>> I suspect you need to do some sort of sync with the hardware here - the
>> _sync bit of the name comes from the fact that the mask and unmask stuff
>> is still called with IRQs disabled and so can't touch and I2C chip, this
>> is called after reenabling them give a chance for the updates done to
>> be reflected in the hardware.  The implementation everyone else has done
>> is to update a register cache in the other functions then write that
>> out here before dropping the mutex.
>
>now that I look at some gpio chips I see what you're saying, will update
>that tomorrow. Thanks

I believe you meant something like below, I'll get back to this in a
little while. Have lots to test:

 From f15801a5d57041b7669222bdb7cccf8b592c2f63 Mon Sep 17 00:00:00 2001
From: Felipe Balbi <balbi@ti.com>
Date: Tue, 28 Dec 2010 19:07:33 +0200
Subject: [PATCH 1/2] mfd: twl4030-irq: implement bus_*lock
Organization: Texas Instruments\n

drop all the locking around mask/unmask and
implement bus_lock and bus_sync_unlock methods.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
  drivers/mfd/twl4030-irq.c |  101 ++++++++++++++++++++++-----------------------
  1 files changed, 50 insertions(+), 51 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 298956d..84f6066 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -440,6 +440,7 @@ struct sih_agent {
  	const struct sih	*sih;
  
  	u32			imr;
+	bool			imr_change_pending;
  	u32			edge_change;
  
  	struct mutex		irq_lock;
@@ -450,64 +451,23 @@ struct sih_agent {
  static void twl4030_sih_mask(unsigned irq)
  {
  	struct sih_agent	*agent = get_irq_chip_data(irq);
-	const struct sih	*sih = agent->sih;
-
-	union {
-		u8	bytes[4];
-		u32	word;
-	}			imr;
-
-	int			status;
  
  	agent->imr |= BIT(irq - agent->irq_base);
-
-	mutex_lock(&agent->irq_lock);
-
-	/* byte[0] gets overwritten as we write ... */
-	imr.word = cpu_to_le32(agent->imr << 8);
-
-	/* write the whole mask ... simpler than subsetting it */
-	status = twl_i2c_write(sih->module, imr.bytes,
-			sih->mask[irq_line].imr_offset, sih->bytes_ixr);
-	if (status)
-		pr_err("twl4030: %s, %s --> %d\n", __func__,
-				"write", status);
-	mutex_unlock(&agent->irq_lock);
+	agent->imr_change_pending = true;
  }
  
  static void twl4030_sih_unmask(unsigned irq)
  {
  	struct sih_agent	*agent = get_irq_chip_data(irq);
-	const struct sih	*sih = agent->sih;
  
-	union {
-		u8	bytes[4];
-		u32	word;
-	}			imr;
-
-	int			status;
-
-	mutex_lock(&agent->irq_lock);
  	agent->imr &= ~BIT(irq - agent->irq_base);
-
-	/* byte[0] gets overwritten as we write ... */
-	imr.word = cpu_to_le32(agent->imr << 8);
-
-	/* write the whole mask ... simpler than subsetting it */
-	status = twl_i2c_write(sih->module, imr.bytes,
-			sih->mask[irq_line].imr_offset, sih->bytes_ixr);
-	if (status)
-		pr_err("twl4030: %s, %s --> %d\n", __func__,
-				"write", status);
-	mutex_unlock(&agent->irq_lock);
+	agent->imr_change_pending = true;
  }
  
  static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
  {
  	struct sih_agent	*agent = get_irq_chip_data(irq);
-	const struct sih	*sih = agent->sih;
  	struct irq_desc		*desc = irq_to_desc(irq);
-	int			status = 0;
  
  	if (!desc) {
  		pr_err("twl4030: Invalid IRQ: %d\n", irq);
@@ -517,17 +477,57 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
  	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
  		return -EINVAL;
  
-	mutex_lock(&agent->irq_lock);
  	if ((desc->status & IRQ_TYPE_SENSE_MASK) != trigger) {
-		u8			bytes[6];
-		u32			edge_change;
+		agent->edge_change |= BIT(irq - agent->irq_base);
  
  		desc->status &= ~IRQ_TYPE_SENSE_MASK;
  		desc->status |= trigger;
-		agent->edge_change |= BIT(irq - agent->irq_base);
+	}
+
+	return 0;
+}
+
+static void twl4030_sih_bus_lock(unsigned int irq)
+{
+	struct sih_agent	*agent = get_irq_chip_data(irq);
+
+	mutex_lock(&agent->irq_lock);
+}
+
+static void twl4030_sih_bus_sync_unlock(unsigned int irq)
+{
+	struct sih_agent	*agent = get_irq_chip_data(irq);
+	const struct sih	*sih = agent->sih;
+
+	int			status;
+
+	union {
+		u8	bytes[4];
+		u32	word;
+	}			imr;
+
+	if (agent->imr_change_pending) {
+		/* byte[0] gets overwritten as we write ... */
+		imr.word = cpu_to_le32(agent->imr << 8);
+
+		/* write the whole mask ... simpler than subsetting it */
+		status = twl_i2c_write(sih->module, imr.bytes,
+				sih->mask[irq_line].imr_offset, sih->bytes_ixr);
+		if (status)
+			pr_err("twl4030: %s, %s --> %d\n", __func__,
+					"write", status);
+		agent->imr_change_pending = false;
+	}
+
+	if (agent->edge_change) {
+		u32			edge_change;
+		u8			bytes[6];
+
  		edge_change = agent->edge_change;
+		agent->edge_change = 0;
  
-		/* Read, reserving first byte for write scratch.  Yes, this
+		/*
+		 * Read, reserving first byte for write scratch.  Yes, this
  		 * could be cached for some speedup ... but be careful about
  		 * any processor on the other IRQ line, EDR registers are
  		 * shared.
@@ -550,7 +550,6 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
  			if (!d) {
  				pr_err("twl4030: Invalid IRQ: %d\n",
  						i + agent->irq_base);
-				status = -ENODEV;
  				goto out;
  			}
  
@@ -576,8 +575,6 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
  
  out:
  	mutex_unlock(&agent->irq_lock);
-
-	return status;
  }
  
  static struct irq_chip twl4030_sih_irq_chip = {
@@ -585,6 +582,8 @@ static struct irq_chip twl4030_sih_irq_chip = {
  	.mask		= twl4030_sih_mask,
  	.unmask		= twl4030_sih_unmask,
  	.set_type	= twl4030_sih_set_type,
+	.bus_lock	= twl4030_sih_bus_lock,
+	.bus_sync_unlock = twl4030_sih_bus_sync_unlock,
  };
  
  /*----------------------------------------------------------------------*/
-- 
1.7.3.4.598.g85356

-- 
balbi
