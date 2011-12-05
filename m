Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab1LEGqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 01:46:32 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:21377
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287Ab1LEGqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 01:46:31 -0500
X-SpamScore: -11
X-BigFish: VPS-11(zz9371K542M1432N98dKzz1202h10d2nzz8275dhz2dh2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:Outbound.kpitcummins.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
Subject: Re: [PATCH 01/11] MFD: DA9052/53 MFD core module v8
From: ashishj3 <ashish.jangam@kpitcummins.com>
Reply-To: <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <sameo@openedhand.com>, <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>, <linaro-dev@lists.linaro.org>,
        <arnd@arndb.de>, <eric.miao@linaro.org>, <sameo@linux.intel.com>
In-Reply-To: <1320152142.4892.4.camel@L-0761.kpit.com>
References: <1320152142.4892.4.camel@L-0761.kpit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 5 Dec 2011 12:16:24 +0530
Message-ID: <1323067584.1652.10.camel@L-0761.kpit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.22]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Mark Brown [mailto:broonie"@opensource.wolfsonmicro.com]
> Sent: Sunday, December 04, Dec 04, 
	"2011 9:29 PM
> To: Ashish Jangam
> Cc: arnd"@arndb.de; sameo@openedhand.com; linux-kernel@vger.kernel.org;
> Dajun; linaro-dev@lists.linaro.org
> Subject: Re: [PATCH 01/11] MFD: DA9052 MFD core module v8
> 
> On Sun, Dec 04, 2011 at 11:50:02AM +0000, Ashish Jangam wrote:
> You should fix your mailer to word wrap at less than 80 columns, I've
> reflowed your text for legibility.
> 
> > > > regmap-irq has a opaque struct regmap_irq_chip_data which has a
> member
> > > > irq_base and this is required for non-primary irqs registration
> > > > and also the clean-up function regmap_del_irq_chip() requires it.
> > > > So as of now I will keep the current irq implementation as it is.
> 
> > > I'm not sure how this is relevant to my above comment? The struct is
> of
> > > course opaque since it is only used by the implementation.
> 
> > No issues on that but it has got irq_base as its member which gets
> > initialize in the function regmap_add_irq_chip() and since this member
> > value is not available to the user how can the mfd dependent modules
> > like touch, battery etc can register for interrupt because during irq
> > registration we add irq_base to the irq nmber for e.g. irq_base +
> > battery_irq
> 
> There's several straightforward solutions to that - for example, we can
> add an accessor to retrieve the information, we can use resources to
> pass the interrupt ranges to the MFD children or we can have the core
> remember the interrupt base it's passing on to the children.
> 
> Whichever one we choose we can certainly solve the problem without
> replicating the entire interrupt controller implementation.

Adding an accessor looks good since the existing mainlined MFD children
will not require any or less modification in their code. Below is the quick
patch for your review. Let me know your views on it since if its ok I will
go ahead and make appropriate modification in the DA9052 MFD code.
----
 drivers/base/regmap/regmap-irq.c |   18 ++++++++----------
 include/linux/regmap.h           |    3 +--
 2 files changed, 9 insertions(+), 12 deletions(-)
diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 6b8a74c..e386b20 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -164,7 +164,6 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
  * irq:       The IRQ the device uses to signal interrupts
  * irq_flags: The IRQF_ flags to use for the primary interrupt.
  * chip:      Configuration for the interrupt controller.
- * data:      Runtime data structure for the controller, allocated on success
  *
  * Returns 0 on success or an errno on failure.
  *
@@ -173,18 +172,17 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
  * register values used by the IRQ controller over suspend and resume.
  */
 int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
-			int irq_base, struct regmap_irq_chip *chip,
-			struct regmap_irq_chip_data **data)
+			int *irq_base, struct regmap_irq_chip *chip)
 {
 	struct regmap_irq_chip_data *d;
 	int cur_irq, i;
 	int ret = -ENOMEM;
 
-	irq_base = irq_alloc_descs(irq_base, 0, chip->num_irqs, 0);
-	if (irq_base < 0) {
+	*irq_base = irq_alloc_descs(*irq_base, 0, chip->num_irqs, 0);
+	if (*irq_base < 0) {
 		dev_warn(map->dev, "Failed to allocate IRQs: %d\n",
-			 irq_base);
-		return irq_base;
+			 *irq_base);
+		return *irq_base;
 	}
 
 	d = kzalloc(sizeof(*d), GFP_KERNEL);
@@ -213,7 +211,7 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 
 	d->map = map;
 	d->chip = chip;
-	d->irq_base = irq_base;
+	d->irq_base = *irq_base;
 	mutex_init(&d->lock);
 
 	for (i = 0; i < chip->num_irqs; i++)
@@ -232,8 +230,8 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
 	}
 
 	/* Register them with genirq */
-	for (cur_irq = irq_base;
-	     cur_irq < chip->num_irqs + irq_base;
+	for (cur_irq = d->irq_base;
+	     cur_irq < chip->num_irqs + d->irq_base;
 	     cur_irq++) {
 		irq_set_chip_data(cur_irq, d);
 		irq_set_chip_and_handler(cur_irq, &regmap_irq_chip,
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a83e4a0..21920b2 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -190,8 +190,7 @@ struct regmap_irq_chip {
 struct regmap_irq_chip_data;
 
 int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
-			int irq_base, struct regmap_irq_chip *chip,
-			struct regmap_irq_chip_data **data);
+			int *irq_base, struct regmap_irq_chip *chip);
 void regmap_del_irq_chip(int irq, struct regmap_irq_chip_data *data);
 
 #endif


