Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761911Ab0HFSoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:44:07 -0400
Received: from kroah.org ([198.145.64.141]:48544 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761662Ab0HFSfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:18 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:00 2010
Message-Id: <20100806183200.209512682@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Juergen Beisert <j.beisert@pengutronix.de>,
        Daniel Mack <daniel@caiaq.de>, Baruch Siach <baruch@tkos.co.il>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [02/38] arm/imx/gpio: add spinlock protection
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Baruch Siach <baruch@tkos.co.il>

commit 14cb0deb66fcfca8fdbef75da8c84b5405a8c767 upstream.

The GPIO registers need protection from concurrent access for operations that
are not atomic.

Cc: Juergen Beisert <j.beisert@pengutronix.de>
Cc: Daniel Mack <daniel@caiaq.de>
Reported-by: rpkamiak@rockwellcollins.com
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/plat-mxc/gpio.c              |    8 ++++++++
 arch/arm/plat-mxc/include/mach/gpio.h |    1 +
 2 files changed, 9 insertions(+)

--- a/arch/arm/plat-mxc/gpio.c
+++ b/arch/arm/plat-mxc/gpio.c
@@ -214,13 +214,16 @@ static void _set_gpio_direction(struct g
 	struct mxc_gpio_port *port =
 		container_of(chip, struct mxc_gpio_port, chip);
 	u32 l;
+	unsigned long flags;
 
+	spin_lock_irqsave(&port->lock, flags);
 	l = __raw_readl(port->base + GPIO_GDIR);
 	if (dir)
 		l |= 1 << offset;
 	else
 		l &= ~(1 << offset);
 	__raw_writel(l, port->base + GPIO_GDIR);
+	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static void mxc_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
@@ -229,9 +232,12 @@ static void mxc_gpio_set(struct gpio_chi
 		container_of(chip, struct mxc_gpio_port, chip);
 	void __iomem *reg = port->base + GPIO_DR;
 	u32 l;
+	unsigned long flags;
 
+	spin_lock_irqsave(&port->lock, flags);
 	l = (__raw_readl(reg) & (~(1 << offset))) | (value << offset);
 	__raw_writel(l, reg);
+	spin_unlock_irqrestore(&port->lock, flags);
 }
 
 static int mxc_gpio_get(struct gpio_chip *chip, unsigned offset)
@@ -285,6 +291,8 @@ int __init mxc_gpio_init(struct mxc_gpio
 		port[i].chip.base = i * 32;
 		port[i].chip.ngpio = 32;
 
+		spin_lock_init(&port[i].lock);
+
 		/* its a serious configuration bug when it fails */
 		BUG_ON( gpiochip_add(&port[i].chip) < 0 );
 
--- a/arch/arm/plat-mxc/include/mach/gpio.h
+++ b/arch/arm/plat-mxc/include/mach/gpio.h
@@ -36,6 +36,7 @@ struct mxc_gpio_port {
 	int virtual_irq_start;
 	struct gpio_chip chip;
 	u32 both_edges;
+	spinlock_t lock;
 };
 
 int mxc_gpio_init(struct mxc_gpio_port*, int);


