Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab0L1RgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:36:09 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:56585 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753447Ab0L1RgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:36:08 -0500
Date: Tue, 28 Dec 2010 19:36:04 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC/PATCH 0/3] TWL4030 IRQ Changes
Message-ID: <20101228173604.GH2239@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20101228161657.GF2239@legolas.emea.dhcp.ti.com>
 <1293556459-28613-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1293556459-28613-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 28, 2010 at 07:14:16PM +0200, Felipe Balbi wrote:
>I dropped the twl6030-irq.c changes because that
>thing is a bit messy. I hope the original author
>will feel inspired and fix that one up.
>
>Anyway, twl4030-irq.c seems to be going to the
>right direction now. Thanks to Mark Brown for
>pointing out the need to drop the locking and
>implement bus_lock/bus_sync_unlock methods.
>
>Compile tested only with omap2plus_defconfig.
>
>I'll test after merge window to be sure I have
>all the newest code.

when we finally move to struct irq_data, the below could
be used. BTW, Thomas do you have any plans for exposing
irq_data_to_desc() ?

8<------------------------------ cut here --------------------------------------

 From 6069e3ddb34608fef0cb3dca3e544fca8deb3840 Mon Sep 17 00:00:00 2001
From: Felipe Balbi <balbi@ti.com>
Date: Tue, 28 Dec 2010 19:33:22 +0200
Subject: [PATCH] mfd: twl4030-irq: switch to new methods
Organization: Texas Instruments\n

Move everybody to struct irq_data-based
methods.

NYET-Signed-off-by: Felipe Balbi <balbi@ti.com>
---
  drivers/mfd/twl4030-irq.c |   86 ++++++++++++++++++++++++++++++++-------------
  1 files changed, 61 insertions(+), 25 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index ff7bb93..ad6197c 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -447,10 +447,14 @@ struct sih_agent {
  
  /*----------------------------------------------------------------------*/
  
-static void twl4030_sih_mask(unsigned irq)
+/* REVISIT define it here until IRQ Subsystem exports its implementation */
+#define irq_data_to_desc(data)	container_of(data, struct irq_desc, irq_data)
+
+static void twl4030_sih_mask(struct irq_data *data)
  {
-	struct sih_agent	*agent = get_irq_chip_data(irq);
-	const struct sih	*sih = agent->sih;
+	struct irq_desc		*d = irq_data_to_desc(data);
+	struct sih_agent	*agent;
+	const struct sih	*sih;
  
  	union {
  		u8	bytes[4];
@@ -458,7 +462,13 @@ static void twl4030_sih_mask(unsigned irq)
  	}			imr;
  
  	int			status;
+	int			irq = data->irq;
  
+	if (!d)
+		return;
+
+	agent = d->chip_data;
+	sih = agent->sih;
  	agent->imr |= BIT(irq - agent->irq_base);
  
  	/* byte[0] gets overwritten as we write ... */
@@ -472,10 +482,11 @@ static void twl4030_sih_mask(unsigned irq)
  				"write", status);
  }
  
-static void twl4030_sih_unmask(unsigned irq)
+static void twl4030_sih_unmask(struct irq_data *data)
  {
-	struct sih_agent	*agent = get_irq_chip_data(irq);
-	const struct sih	*sih = agent->sih;
+	struct irq_desc		*d = irq_data_to_desc(data);
+	struct sih_agent	*agent;
+	const struct sih	*sih;
  
  	union {
  		u8	bytes[4];
@@ -483,7 +494,13 @@ static void twl4030_sih_unmask(unsigned irq)
  	}			imr;
  
  	int			status;
+	int			irq = data->irq;
+
+	if (!d)
+		return;
  
+	agent = d->chip_data;
+	sih = agent->sih;
  	agent->imr &= ~BIT(irq - agent->irq_base);
  
  	/* byte[0] gets overwritten as we write ... */
@@ -497,14 +514,15 @@ static void twl4030_sih_unmask(unsigned irq)
  				"write", status);
  }
  
-static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
+static int twl4030_sih_set_type(struct irq_data *data, unsigned trigger)
  {
-	struct sih_agent	*agent = get_irq_chip_data(irq);
-	const struct sih	*sih = agent->sih;
-	struct irq_desc		*desc = irq_to_desc(irq);
+	struct irq_desc		*d = irq_data_to_desc(data);
+	struct sih_agent	*agent;
+	const struct sih	*sih;
  	int			status = 0;
+	int			irq = data->irq;
  
-	if (!desc) {
+	if (!d) {
  		pr_err("twl4030: Invalid IRQ: %d\n", irq);
  		return -EINVAL;
  	}
@@ -512,12 +530,15 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
  	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
  		return -EINVAL;
  
-	if ((desc->status & IRQ_TYPE_SENSE_MASK) != trigger) {
+	agent = d->chip_data;
+	sih = agent->sih;
+
+	if ((d->status & IRQ_TYPE_SENSE_MASK) != trigger) {
  		u8			bytes[6];
  		u32			edge_change;
  
-		desc->status &= ~IRQ_TYPE_SENSE_MASK;
-		desc->status |= trigger;
+		d->status &= ~IRQ_TYPE_SENSE_MASK;
+		d->status |= trigger;
  		agent->edge_change |= BIT(irq - agent->irq_base);
  		edge_change = agent->edge_change;
  
@@ -537,7 +558,6 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
  		/* Modify only the bits we know must change */
  		while (edge_change) {
  			int		i = fls(edge_change) - 1;
-			struct irq_desc	*d = irq_to_desc(i + agent->irq_base);
  			int		byte = 1 + (i >> 2);
  			int		off = (i & 0x3) * 2;
  
@@ -570,27 +590,43 @@ static int twl4030_sih_set_type(unsigned irq, unsigned trigger)
  	return status;
  }
  
-static void twl4030_sih_bus_lock(unsigned int irq)
+static void twl4030_sih_bus_lock(struct irq_data *data)
  {
-	struct sih_agent	*agent = get_irq_chip_data(irq);
+	struct irq_desc		*d = irq_data_to_desc(data);
+	struct sih_agent	*agent;
+	int			irq = data->irq;
+
+	if (!d) {
+		pr_err("twl4030: Invalid IRQ: %d\n", irq);
+		return;
+	}
  
+	agent = d->chip_data;
  	mutex_lock(&agent->irq_lock);
  }
  
-static void twl4030_sih_bus_sync_unlock(unsigned int irq)
+static void twl4030_sih_bus_sync_unlock(struct irq_data *data)
  {
-	struct sih_agent	*agent = get_irq_chip_data(irq);
+	struct irq_desc		*d = irq_data_to_desc(data);
+	struct sih_agent	*agent;
+	int			irq = data->irq;
+
+	if (!d) {
+		pr_err("twl4030: Invalid IRQ: %d\n", irq);
+		return;
+	}
  
+	agent = d->chip_data;
  	mutex_unlock(&agent->irq_lock);
  }
  
  static struct irq_chip twl4030_sih_irq_chip = {
-	.name		= "twl4030",
-	.mask		= twl4030_sih_mask,
-	.unmask		= twl4030_sih_unmask,
-	.set_type	= twl4030_sih_set_type,
-	.bus_lock	= twl4030_sih_bus_lock,
-	.bus_sync_unlock = twl4030_sih_bus_sync_unlock,
+	.name			= "twl4030",
+	.irq_mask		= twl4030_sih_mask,
+	.irq_unmask		= twl4030_sih_unmask,
+	.irq_set_type		= twl4030_sih_set_type,
+	.irq_bus_lock		= twl4030_sih_bus_lock,
+	.irq_bus_sync_unlock	= twl4030_sih_bus_sync_unlock,
  };
  
  /*----------------------------------------------------------------------*/
-- 
1.7.3.4.598.g85356

-- 
balbi
