Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab1LELGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:06:19 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46428 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab1LELGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:06:18 -0500
Message-ID: <1323083166.6763.3.camel@phoenix>
Subject: [PATCH v2] pcmcia: pxa: replace IRQ_GPIO() with gpio_to_irq()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Ian Molton <spyro@f2s.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-pcmcia@lists.infradead.org
Date: Mon, 05 Dec 2011 19:06:06 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 6384fd "ARM: pxa: rename IRQ_GPIO to PXA_GPIO_TO_IRQ",
I got buid errors due to implicit declaration of function 'IRQ_GPIO'.

Use common gpio_to_irq() to replace machine dependant macro IRQ_GPIO().

Cc: Marek Vasut <marek.vasut@gmail.com>
Cc: Ian Molton <spyro@f2s.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Zhuang <haojian.zhuang@marvell.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
v2: 
I just found pxa2xx_trizeps4.c also needs to be converted to gpio_to_irq.
Thus include the fix for pxa2xx_trizeps4.c in v2.

 drivers/pcmcia/pxa2xx_e740.c      |   11 +++++++----
 drivers/pcmcia/pxa2xx_palmld.c    |    2 +-
 drivers/pcmcia/pxa2xx_palmtc.c    |    2 +-
 drivers/pcmcia/pxa2xx_stargate2.c |    6 ++++--
 drivers/pcmcia/pxa2xx_trizeps4.c  |    5 +++--
 drivers/pcmcia/pxa2xx_vpac270.c   |    4 ++--
 6 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/pcmcia/pxa2xx_e740.c b/drivers/pcmcia/pxa2xx_e740.c
index 8bfbd4d..17cd2ce 100644
--- a/drivers/pcmcia/pxa2xx_e740.c
+++ b/drivers/pcmcia/pxa2xx_e740.c
@@ -26,20 +26,23 @@
 static struct pcmcia_irqs cd_irqs[] = {
 	{
 		.sock = 0,
-		.irq  = IRQ_GPIO(GPIO_E740_PCMCIA_CD0),
 		.str  = "CF card detect"
 	},
 	{
 		.sock = 1,
-		.irq  = IRQ_GPIO(GPIO_E740_PCMCIA_CD1),
 		.str  = "Wifi switch"
 	},
 };
 
 static int e740_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 {
-	skt->socket.pci_irq = skt->nr == 0 ? IRQ_GPIO(GPIO_E740_PCMCIA_RDY0) :
-				IRQ_GPIO(GPIO_E740_PCMCIA_RDY1);
+	if (skt->nr == 0)
+		skt->socket.pci_irq = gpio_to_irq(GPIO_E740_PCMCIA_RDY0);
+	else
+		skt->socket.pci_irq = gpio_to_irq(GPIO_E740_PCMCIA_RDY1);
+
+	cd_irqs[0].irq = gpio_to_irq(GPIO_E740_PCMCIA_CD0);
+	cd_irqs[1].irq = gpio_to_irq(GPIO_E740_PCMCIA_CD1);
 
 	return soc_pcmcia_request_irqs(skt, &cd_irqs[skt->nr], 1);
 }
diff --git a/drivers/pcmcia/pxa2xx_palmld.c b/drivers/pcmcia/pxa2xx_palmld.c
index d589ad1..6a8e011 100644
--- a/drivers/pcmcia/pxa2xx_palmld.c
+++ b/drivers/pcmcia/pxa2xx_palmld.c
@@ -33,7 +33,7 @@ static int palmld_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 	ret = gpio_request_array(palmld_pcmcia_gpios,
 				ARRAY_SIZE(palmld_pcmcia_gpios));
 
-	skt->socket.pci_irq = IRQ_GPIO(GPIO_NR_PALMLD_PCMCIA_READY);
+	skt->socket.pci_irq = gpio_to_irq(GPIO_NR_PALMLD_PCMCIA_READY);
 
 	return ret;
 }
diff --git a/drivers/pcmcia/pxa2xx_palmtc.c b/drivers/pcmcia/pxa2xx_palmtc.c
index 9c6a04b..9e38de7 100644
--- a/drivers/pcmcia/pxa2xx_palmtc.c
+++ b/drivers/pcmcia/pxa2xx_palmtc.c
@@ -37,7 +37,7 @@ static int palmtc_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 	ret = gpio_request_array(palmtc_pcmcia_gpios,
 				ARRAY_SIZE(palmtc_pcmcia_gpios));
 
-	skt->socket.pci_irq = IRQ_GPIO(GPIO_NR_PALMTC_PCMCIA_READY);
+	skt->socket.pci_irq = gpio_to_irq(GPIO_NR_PALMTC_PCMCIA_READY);
 
 	return ret;
 }
diff --git a/drivers/pcmcia/pxa2xx_stargate2.c b/drivers/pcmcia/pxa2xx_stargate2.c
index 9396222..6c2366b 100644
--- a/drivers/pcmcia/pxa2xx_stargate2.c
+++ b/drivers/pcmcia/pxa2xx_stargate2.c
@@ -34,7 +34,7 @@
 #define SG2_S0_GPIO_READY	81
 
 static struct pcmcia_irqs irqs[] = {
-	{ 0, IRQ_GPIO(SG2_S0_GPIO_DETECT), "PCMCIA0 CD" },
+	{.sock = 0, .str = "PCMCIA0 CD" },
 };
 
 static struct gpio sg2_pcmcia_gpios[] = {
@@ -44,7 +44,9 @@ static struct gpio sg2_pcmcia_gpios[] = {
 
 static int sg2_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 {
-	skt->socket.pci_irq = IRQ_GPIO(SG2_S0_GPIO_READY);
+	skt->socket.pci_irq = gpio_to_irq(SG2_S0_GPIO_READY);
+	irqs[0].irq = gpio_to_irq(SG2_S0_GPIO_DETECT);
+
 	return soc_pcmcia_request_irqs(skt, irqs, ARRAY_SIZE(irqs));
 }
 
diff --git a/drivers/pcmcia/pxa2xx_trizeps4.c b/drivers/pcmcia/pxa2xx_trizeps4.c
index 57ddb969..7c33f89 100644
--- a/drivers/pcmcia/pxa2xx_trizeps4.c
+++ b/drivers/pcmcia/pxa2xx_trizeps4.c
@@ -30,7 +30,7 @@
 extern void board_pcmcia_power(int power);
 
 static struct pcmcia_irqs irqs[] = {
-	{ 0, IRQ_GPIO(GPIO_PCD), "cs0_cd" }
+	{ .sock = 0, .str = "cs0_cd" }
 	/* on other baseboards we can have more inputs */
 };
 
@@ -53,7 +53,8 @@ static int trizeps_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 			gpio_free(GPIO_PRDY);
 			return -EINVAL;
 		}
-		skt->socket.pci_irq = IRQ_GPIO(GPIO_PRDY);
+		skt->socket.pci_irq = gpio_to_irq(GPIO_PRDY);
+		irqs[0].irq = gpio_to_irq(GPIO_PCD);
 		break;
 	default:
 		break;
diff --git a/drivers/pcmcia/pxa2xx_vpac270.c b/drivers/pcmcia/pxa2xx_vpac270.c
index 66ab92c..61b17d2 100644
--- a/drivers/pcmcia/pxa2xx_vpac270.c
+++ b/drivers/pcmcia/pxa2xx_vpac270.c
@@ -38,12 +38,10 @@ static struct gpio vpac270_cf_gpios[] = {
 static struct pcmcia_irqs cd_irqs[] = {
 	{
 		.sock = 0,
-		.irq  = IRQ_GPIO(GPIO84_VPAC270_PCMCIA_CD),
 		.str  = "PCMCIA CD"
 	},
 	{
 		.sock = 1,
-		.irq  = IRQ_GPIO(GPIO17_VPAC270_CF_CD),
 		.str  = "CF CD"
 	},
 };
@@ -57,6 +55,7 @@ static int vpac270_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 				ARRAY_SIZE(vpac270_pcmcia_gpios));
 
 		skt->socket.pci_irq = gpio_to_irq(GPIO35_VPAC270_PCMCIA_RDY);
+		cd_irqs[0].irq = gpio_to_irq(GPIO84_VPAC270_PCMCIA_CD);
 
 		if (!ret)
 			ret = soc_pcmcia_request_irqs(skt, &cd_irqs[0], 1);
@@ -65,6 +64,7 @@ static int vpac270_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 				ARRAY_SIZE(vpac270_cf_gpios));
 
 		skt->socket.pci_irq = gpio_to_irq(GPIO12_VPAC270_CF_RDY);
+		cd_irqs[1].irq = gpio_to_irq(GPIO17_VPAC270_CF_CD);
 
 		if (!ret)
 			ret = soc_pcmcia_request_irqs(skt, &cd_irqs[1], 1);
-- 
1.7.5.4



