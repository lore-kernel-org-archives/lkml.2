Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab1BJXzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 18:55:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757240Ab1BJXze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 18:55:34 -0500
Date: Thu, 10 Feb 2011 15:55:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, LKML <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>, Alan Cox <alan@linux.intel.com>,
        Alek Du <alek.du@intel.com>
Subject: Re: [patch 0/3] platform-drivers: x86: Cleanup pmic gpio interrupt
Message-Id: <20110210155506.126c870f.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1102072120240.31804@localhost6.localdomain6>
References: <20110205104025.559237313@linutronix.de>
	<20110207201730.GA21520@srcf.ucam.org>
	<alpine.LFD.2.00.1102072120240.31804@localhost6.localdomain6>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011 21:41:30 +0100 (CET)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 7 Feb 2011, Matthew Garrett wrote:
> 
> > Applied, thanks.
> 
> Btw, there is no real reason to have this as a chained handler. I
> guess I need to find some time for educational documentation :)
> 
> See below.
> 
> Thanks,
> 
> 	tglx
> 
> ------->
> Subject: platform-drivers: x86: pmic: Use request_irq instead of chained handler
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Mon, 07 Feb 2011 21:24:29 +0100
> 
> There is no need to install a chained handler for this hardware. This
> is a plain x86 IOAPIC interrupt which is handled by the core code
> perfectly fine. There is nothing special about demultiplexing these
> gpio interrupts which justifies a custom hack. Replace it by a plain
> old interrupt handler installed with request_irq. That makes the code
> agnostic about the underlying primary interrupt hardware. The overhead
> for this is minimal, but it gives us the advantage of accounting,
> balancing and to detect interrupt storms. gpio interrupts are not
> really that performance critical.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/platform/x86/intel_pmic_gpio.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/drivers/platform/x86/intel_pmic_gpio.c
> ===================================================================
> --- linux-2.6.orig/drivers/platform/x86/intel_pmic_gpio.c
> +++ linux-2.6/drivers/platform/x86/intel_pmic_gpio.c
> @@ -211,9 +211,9 @@ static struct irq_chip pmic_irqchip = {
>  	.irq_set_type	= pmic_irq_type,
>  };
>  
> -static void pmic_irq_handler(unsigned irq, struct irq_desc *desc)
> +static irqreturn_t pmic_irq_handler(unsigned int irq, void *data)
>  {
> -	struct pmic_gpio *pg = (struct pmic_gpio *)get_irq_data(irq);
> +	struct pmic_gpio *pg = data;
>  	u8 intsts = *((u8 *)pg->gpiointr + 4);
>  	int gpio;
>  
> @@ -223,7 +223,6 @@ static void pmic_irq_handler(unsigned ir
>  			generic_handle_irq(pg->irq_base + gpio);
>  		}
>  	}
> -	desc->chip->irq_eoi(get_irq_desc_chip_data(desc));
>  }
>  
>  static int __devinit platform_pmic_gpio_probe(struct platform_device *pdev)
> @@ -280,8 +279,13 @@ static int __devinit platform_pmic_gpio_
>  		printk(KERN_ERR "%s: Can not add pmic gpio chip.\n", __func__);
>  		goto err;
>  	}
> -	set_irq_data(pg->irq, pg);
> -	set_irq_chained_handler(pg->irq, pmic_irq_handler);
> +
> +	retval = request_irq(pg->irq, pmic_irq_handler, 0, "pmic", pg);
> +	if (retval) {
> +		printk(KERN_WARN "pmic: Interrupt request failed\n");
> +		goto err;
> +	}
> +
>  	for (i = 0; i < 8; i++) {
>  		set_irq_chip_and_handler_name(i + pg->irq_base, &pmic_irqchip,
>  					handle_simple_irq, "demux");

That didn't work out too well.


Subject: drivers/platform/x86/intel_pmic_gpio.c: fix big mess with i386 allmodconfig
From: Andrew Morton <akpm@linux-foundation.org>

Fix build error:

drivers/platform/x86/intel_pmic_gpio.c:285: error: 'KERN_WARN' undeclared (first use in this function)

And a bunch of warnings:

drivers/platform/x86/intel_pmic_gpio.c: In function 'pmic_irq_handler':
drivers/platform/x86/intel_pmic_gpio.c:226: warning: no return statement in function returning non-void
drivers/platform/x86/intel_pmic_gpio.c: In function 'platform_pmic_gpio_probe':
drivers/platform/x86/intel_pmic_gpio.c:283: warning: passing argument 2 of 'request_irq' from incompatible pointer type
drivers/platform/x86/intel_pmic_gpio.c: At top level:
drivers/platform/x86/intel_pmic_gpio.c:183: warning: 'pmic_bus_lock' defined but not used
drivers/platform/x86/intel_pmic_gpio.c:190: warning: 'pmic_bus_sync_unlock' defined but not used

This repairs linux-next's "platform-drivers: x86: pmic: Use request_irq
instead of chained handler".  Please don't introduce bisection holes into
mainline!

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/intel_pmic_gpio.c |   40 ++---------------------
 1 file changed, 5 insertions(+), 35 deletions(-)

diff -puN drivers/platform/x86/intel_pmic_gpio.c~drivers-platform-x86-intel_pmic_gpioc-fix-big-mess-with-i386-allmodconfig drivers/platform/x86/intel_pmic_gpio.c
--- a/drivers/platform/x86/intel_pmic_gpio.c~drivers-platform-x86-intel_pmic_gpioc-fix-big-mess-with-i386-allmodconfig
+++ a/drivers/platform/x86/intel_pmic_gpio.c
@@ -74,19 +74,6 @@ struct pmic_gpio {
 	u32			trigger_type;
 };
 
-static void pmic_program_irqtype(int gpio, int type)
-{
-	if (type & IRQ_TYPE_EDGE_RISING)
-		intel_scu_ipc_update_register(GPIO0 + gpio, 0x20, 0x20);
-	else
-		intel_scu_ipc_update_register(GPIO0 + gpio, 0x00, 0x20);
-
-	if (type & IRQ_TYPE_EDGE_FALLING)
-		intel_scu_ipc_update_register(GPIO0 + gpio, 0x10, 0x10);
-	else
-		intel_scu_ipc_update_register(GPIO0 + gpio, 0x00, 0x10);
-};
-
 static int pmic_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
 {
 	if (offset > 8) {
@@ -179,26 +166,6 @@ static int pmic_gpio_to_irq(struct gpio_
 	return pg->irq_base + offset;
 }
 
-static void pmic_bus_lock(struct irq_data *data)
-{
-	struct pmic_gpio *pg = irq_data_get_irq_chip_data(data);
-
-	mutex_lock(&pg->buslock);
-}
-
-static void pmic_bus_sync_unlock(struct irq_data *data)
-{
-	struct pmic_gpio *pg = irq_data_get_irq_chip_data(data);
-
-	if (pg->update_type) {
-		unsigned int gpio = pg->update_type & ~GPIO_UPDATE_TYPE;
-
-		pmic_program_irqtype(gpio, pg->trigger_type);
-		pg->update_type = 0;
-	}
-	mutex_unlock(&pg->buslock);
-}
-
 /* the gpiointr register is read-clear, so just do nothing. */
 static void pmic_irq_unmask(struct irq_data *data) { }
 
@@ -211,18 +178,21 @@ static struct irq_chip pmic_irqchip = {
 	.irq_set_type	= pmic_irq_type,
 };
 
-static irqreturn_t pmic_irq_handler(unsigned int irq, void *data)
+static irqreturn_t pmic_irq_handler(int irq, void *data)
 {
 	struct pmic_gpio *pg = data;
 	u8 intsts = *((u8 *)pg->gpiointr + 4);
 	int gpio;
+	irqreturn_t ret = IRQ_NONE;
 
 	for (gpio = 0; gpio < 8; gpio++) {
 		if (intsts & (1 << gpio)) {
 			pr_debug("pmic pin %d triggered\n", gpio);
 			generic_handle_irq(pg->irq_base + gpio);
+			ret = IRQ_HANDLED;
 		}
 	}
+	return ret;
 }
 
 static int __devinit platform_pmic_gpio_probe(struct platform_device *pdev)
@@ -282,7 +252,7 @@ static int __devinit platform_pmic_gpio_
 
 	retval = request_irq(pg->irq, pmic_irq_handler, 0, "pmic", pg);
 	if (retval) {
-		printk(KERN_WARN "pmic: Interrupt request failed\n");
+		printk(KERN_WARNING "pmic: Interrupt request failed\n");
 		goto err;
 	}
 
_

