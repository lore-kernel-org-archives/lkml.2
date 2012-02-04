Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2BDWbr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 17:31:47 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38760 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab2BDWbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 17:31:45 -0500
Date: Sat, 4 Feb 2012 22:31:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Milton Miller <miltonm@bga.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 00/25] irq_domain generalization and refinement
Message-ID: <20120204223125.GO14129@n2100.arm.linux.org.uk>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca> <20120204221748.GN14129@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120204221748.GN14129@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 10:17:48PM +0000, Russell King - ARM Linux wrote:
> On Fri, Jan 27, 2012 at 02:35:54PM -0700, Grant Likely wrote:
> > Hey everyone,
> > 
> > This patch series is ready for much wider consumption now.  I'd like
> > to get it into linux-next ASAP because there will be ARM board support
> > depending on it.  I'll wait a few days before I ask Stephen to pull
> > this in.
> 
> Grant,
> 
> Can you answer me this: does this irqdomain support require DT?
> 
> The question comes up because OMAP has converted some of their support
> to require irq domain support for their PMICs, and it seems irq domain
> support requires DT.  This seems to have made the whole of OMAP
> essentially become a DT-only platform.
> 
> Removing the dependency on IRQ_DOMAIN brings up these build errors
> in the twl-core code (that being the PMIC for OMAP CPUs):
> 
> drivers/mfd/twl-core.c: In function 'twl_probe':
> drivers/mfd/twl-core.c:1229: error: invalid use of undefined type 'struct irq_domain'
> drivers/mfd/twl-core.c:1230: error: invalid use of undefined type 'struct irq_domain'
> drivers/mfd/twl-core.c:1235: error: implicit declaration of function 'irq_domain_add'
> 
> That's a bit of a problem, because afaik there aren't the DT descriptions
> for the boards I have yet, so it's causing me to see regressions when
> building and booting kernels with CONFIG_OF=n.
> 
> The more core-code we end up with which requires DT, the worse this
> problem is going to become - and obviously saying "everyone must now
> convert to DT" is, even today, a mammoth task.
> 
> Now, here's the thing: I believe that IRQ domains - at least as far as
> the hwirq stuff - should be available irrespective of whether we have
> the rest of the IRQ domain support code in place, so that IRQ support
> code doesn't have to keep playing games to decode from the global
> space to the per-controller number space.
> 
> I believe that would certainly help the current OMAP problems, where
> the current lack of CONFIG_IRQ_DOMAIN basically makes the kernel oops
> on boot.
> 
> How we fix this regression for 3.4 I've no idea at present, I'm trying
> to work out what the real dependencies are for OMAP on this stuff.

Actually, it turns out to be not that hard, because twl doesn't actually
make use of the IRQ domain stuff:

commit aeb5032b3f8b9ab69daa545777433fa94b3494c4
Author:     Benoit Cousson <b-cousson@ti.com>
AuthorDate: Mon Aug 29 16:20:23 2011 +0200
Commit:     Samuel Ortiz <sameo@linux.intel.com>
CommitDate: Mon Jan 9 00:37:40 2012 +0100

    mfd: twl-core: Add initial DT support for twl4030/twl6030

    [grant.likely@secretlab.ca: Fix IRQ_DOMAIN dependency in kconfig]

Adding any dependency - especially one which wouldn't be enabled - for
a new feature which wasn't required before is going to break existing
users, so this shouldn't have been done in the first place.

A better fix to preserve existing users would've been as below - yes
it means more ifdefs, but if irq domain is to remain a DT only thing
then we're going to end up with _lots_ of this stuff.

I'd much prefer to see irq domain become more widely available so it
doesn't require these ifdefs everywhere.

 drivers/mfd/Kconfig    |    2 +-
 drivers/mfd/twl-core.c |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 28a301b..bd60ce0 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -200,7 +200,7 @@ config MENELAUS
 
 config TWL4030_CORE
 	bool "Texas Instruments TWL4030/TWL5030/TWL6030/TPS659x0 Support"
-	depends on I2C=y && GENERIC_HARDIRQS && IRQ_DOMAIN
+	depends on I2C=y && GENERIC_HARDIRQS
 	help
 	  Say yes here if you have TWL4030 / TWL6030 family chip on your board.
 	  This core driver provides register access and IRQ handling
diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index e04e04d..5913aaa 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -263,7 +263,9 @@ struct twl_client {
 
 static struct twl_client twl_modules[TWL_NUM_SLAVES];
 
+#ifdef CONFIG_IRQ_DOMAIN
 static struct irq_domain domain;
+#endif
 
 /* mapping the module id to slave id and base address */
 struct twl_mapping {
@@ -1226,6 +1228,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	pdata->irq_base = status;
 	pdata->irq_end = pdata->irq_base + nr_irqs;
 
+#ifdef CONFIG_IRQ_DOMAIN
 	domain.irq_base = pdata->irq_base;
 	domain.nr_irq = nr_irqs;
 #ifdef CONFIG_OF_IRQ
@@ -1233,6 +1236,7 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	domain.ops = &irq_domain_simple_ops;
 #endif
 	irq_domain_add(&domain);
+#endif
 
 	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C) == 0) {
 		dev_dbg(&client->dev, "can't talk I2C?\n");
