Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab0EUD2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 23:28:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:39785 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753698Ab0EUD2J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 23:28:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,275,1272870000"; 
   d="scan'208";a="279709890"
Date: Fri, 21 May 2010 11:24:37 +0800
From: "Du, Alek" <alek.du@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Brownell <david-b@pacbell.net>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: add Penwell gpio support
Message-ID: <20100521112437.1efc88a2@dxy2>
In-Reply-To: <20100520142821.ed6efd58.akpm@linux-foundation.org>
References: <20100518154025.4aaff2ee@dxy2>
	<20100520142821.ed6efd58.akpm@linux-foundation.org>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 05:28:21 +0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 18 May 2010 15:40:25 +0800
> "Du, Alek" <alek.du@intel.com> wrote:
> 
> > >From 963f6e83843b0f94f8a5337def6e897ec5bb99bf Mon Sep 17 00:00:00 2001
> > From: Alek Du <alek.du@intel.com>
> > Date: Thu, 25 Feb 2010 14:32:46 +0800
> > Subject: [PATCH] gpio: add Penwell gpio support
> > 
> > Intel Penwell chip has two 96 pins GPIO blocks, which are very similiar as
> > Intel Langwell chip GPIO block, except for pin number difference. This
> > patch expends the original Langwell GPIO driver to support Penwell's.
> > 
> 
> Has the driver been retested on Moorestown?

Yes, retested with Moorestown platform.

> 
> > -static int lnw_gpio_get(struct gpio_chip *chip, unsigned offset)
> > +static inline void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
> > +			enum GPIO_REG reg_type)
> >  {
> >  	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
> > +	unsigned nreg = chip->ngpio / 32;
> >  	u8 reg = offset / 32;
> > -	void __iomem *gplr;
> > +	void __iomem *ptr;
> > +
> > +	ptr = (void __iomem *)(lnw->reg_base + reg_type * nreg * 4 + reg * 4);
> > +	return ptr;
> > +}
> 
> inlining this function was probably the wrong thing to do.  But modern
> gcc's often just ignore the `inline' and do the right thing anyway.
>

Yes, as I looked at the assembly code, the function is too big. I should remove "inline".

> 
> > -static struct pci_device_id lnw_gpio_ids[] = {
> > -	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f) },
> > +static struct pci_device_id lnw_gpio_ids[] = {      /* pin number */
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f), .driver_data = 64 },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081f), .driver_data = 96 },
> > +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081a), .driver_data = 96 },
> >  	{ 0, }
> 
> I suppose we should be using DEFINE_PCI_DEVICE_TABLE() here.
> 
>
Yes, here is the incremental patch against previous one (I got the mail said
the previous one is in mm tree now):

>From 47b561649890807a1a66fd8c4b07ded87df485c2 Mon Sep 17 00:00:00 2001
From: Alek Du <alek.du@intel.com>
Date: Fri, 21 May 2010 11:16:40 +0800
Subject: [PATCH] gpio: langwell/penwell gpio driver style fix

* remove gpio_reg inline, due to the fact the func is too big to inline
* use standard DEFINE_PCI_DEVICE_TABLE

Signed-off-by: Alek Du <alek.du@intel.com>
---
 drivers/gpio/langwell_gpio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 0693f71..8383a8d 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -63,7 +63,7 @@ struct lnw_gpio {
 	unsigned			irq_base;
 };
 
-static inline void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
+static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
 			enum GPIO_REG reg_type)
 {
 	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
@@ -175,7 +175,7 @@ static struct irq_chip lnw_irqchip = {
 	.set_type	= lnw_irq_type,
 };
 
-static struct pci_device_id lnw_gpio_ids[] = {      /* pin number */
+static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {   /* pin number */
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080f), .driver_data = 64 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081f), .driver_data = 96 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x081a), .driver_data = 96 },
-- 
1.7.0.4





 

