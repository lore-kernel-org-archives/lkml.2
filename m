Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab1HHIv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 04:51:26 -0400
Received: from mail0.scram.de ([78.47.204.202]:56259 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab1HHIun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 04:50:43 -0400
Authentication-Results: localhost; dkim=pass (1024-bit key)
	header.i=@scram.de; dkim-asp=signed
X-Spam-Flag: NO
X-Spam-Score: -4.379
Authentication-Results: amavis.colab.de (amavisd-new); dkim=pass
	header.i=@scram.de
From: Jochen Friedrich <jochen@scram.de>
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        bryan.wu@canonical.com, kristoffer.ericson@gmail.com
Cc: linux-kernel@vger.kernel.org, Jochen Friedrich <jochen@scram.de>
Subject: [PATCH 3.2 2/4] ARM: simpad: Cleanup CS3 accessors.
Date: Mon,  8 Aug 2011 10:49:37 +0200
Message-Id: <1312793379-6020-3-git-send-email-jochen@scram.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1312793379-6020-1-git-send-email-jochen@scram.de>
References: <1312793379-6020-1-git-send-email-jochen@scram.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- prepend CS3 accessors by simpad_ to indicate they
  are specific to simpad devices.
- use spinlock to protect shadow register.
- implement 8 read-only pins.
- use readl/writel macros so barriers are used where
  necessary.
- register CS3 as GPIO controller with 24 pins
  (16 output only and 8 input only).
- fix PCMCIA driver to access the read-only pins
  rather than the shadow register for status bits.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/arm/mach-sa1100/include/mach/simpad.h |   81 ++++++++++++++------
 arch/arm/mach-sa1100/leds-simpad.c         |    7 +-
 arch/arm/mach-sa1100/simpad.c              |  117 ++++++++++++++++++++++------
 drivers/pcmcia/sa1100_simpad.c             |   35 ++++-----
 4 files changed, 169 insertions(+), 71 deletions(-)

diff --git a/arch/arm/mach-sa1100/include/mach/simpad.h b/arch/arm/mach-sa1100/include/mach/simpad.h
index 231550d..db28118 100644
--- a/arch/arm/mach-sa1100/include/mach/simpad.h
+++ b/arch/arm/mach-sa1100/include/mach/simpad.h
@@ -61,32 +61,67 @@
 #define SIMPAD_UCB1X00_GPIO_HEADSET	(SIMPAD_UCB1X00_GPIO_BASE + 8)
 #define SIMPAD_UCB1X00_GPIO_SPEAKER	(SIMPAD_UCB1X00_GPIO_BASE + 9)
 
-// CS3 Latch is write only, a shadow is necessary
+/*--- CS3 Latch ---*/
+#define SIMPAD_CS3_GPIO_BASE		(GPIO_MAX + 11)
+#define SIMPAD_CS3_VCC_5V_EN		(SIMPAD_CS3_GPIO_BASE)
+#define SIMPAD_CS3_VCC_3V_EN		(SIMPAD_CS3_GPIO_BASE + 1)
+#define SIMPAD_CS3_EN1			(SIMPAD_CS3_GPIO_BASE + 2)
+#define SIMPAD_CS3_EN0			(SIMPAD_CS3_GPIO_BASE + 3)
+#define SIMPAD_CS3_DISPLAY_ON		(SIMPAD_CS3_GPIO_BASE + 4)
+#define SIMPAD_CS3_PCMCIA_BUFF_DIS	(SIMPAD_CS3_GPIO_BASE + 5)
+#define SIMPAD_CS3_MQ_RESET		(SIMPAD_CS3_GPIO_BASE + 6)
+#define SIMPAD_CS3_PCMCIA_RESET		(SIMPAD_CS3_GPIO_BASE + 7)
+#define SIMPAD_CS3_DECT_POWER_ON	(SIMPAD_CS3_GPIO_BASE + 8)
+#define SIMPAD_CS3_IRDA_SD		(SIMPAD_CS3_GPIO_BASE + 9)
+#define SIMPAD_CS3_RS232_ON		(SIMPAD_CS3_GPIO_BASE + 10)
+#define SIMPAD_CS3_SD_MEDIAQ		(SIMPAD_CS3_GPIO_BASE + 11)
+#define SIMPAD_CS3_LED2_ON		(SIMPAD_CS3_GPIO_BASE + 12)
+#define SIMPAD_CS3_IRDA_MODE		(SIMPAD_CS3_GPIO_BASE + 13)
+#define SIMPAD_CS3_ENABLE_5V		(SIMPAD_CS3_GPIO_BASE + 14)
+#define SIMPAD_CS3_RESET_SIMCARD	(SIMPAD_CS3_GPIO_BASE + 15)
+
+#define SIMPAD_CS3_PCMCIA_BVD1		(SIMPAD_CS3_GPIO_BASE + 16)
+#define SIMPAD_CS3_PCMCIA_BVD2		(SIMPAD_CS3_GPIO_BASE + 17)
+#define SIMPAD_CS3_PCMCIA_VS1		(SIMPAD_CS3_GPIO_BASE + 18)
+#define SIMPAD_CS3_PCMCIA_VS2		(SIMPAD_CS3_GPIO_BASE + 19)
+#define SIMPAD_CS3_LOCK_IND		(SIMPAD_CS3_GPIO_BASE + 20)
+#define SIMPAD_CS3_CHARGING_STATE	(SIMPAD_CS3_GPIO_BASE + 21)
+#define SIMPAD_CS3_PCMCIA_SHORT		(SIMPAD_CS3_GPIO_BASE + 22)
+#define SIMPAD_CS3_GPIO_23		(SIMPAD_CS3_GPIO_BASE + 23)
 
-#define CS3BUSTYPE unsigned volatile long
 #define CS3_BASE        0xf1000000
 
-#define VCC_5V_EN       0x0001 // For 5V PCMCIA
-#define VCC_3V_EN       0x0002 // FOR 3.3V PCMCIA
-#define EN1             0x0004 // This is only for EPROM's
-#define EN0             0x0008 // Both should be enable for 3.3V or 5V
-#define DISPLAY_ON      0x0010
-#define PCMCIA_BUFF_DIS 0x0020
-#define MQ_RESET        0x0040
-#define PCMCIA_RESET    0x0080
-#define DECT_POWER_ON   0x0100
-#define IRDA_SD         0x0200 // Shutdown for powersave
-#define RS232_ON        0x0400
-#define SD_MEDIAQ       0x0800 // Shutdown for powersave
-#define LED2_ON         0x1000
-#define IRDA_MODE       0x2000 // Fast/Slow IrDA mode
-#define ENABLE_5V       0x4000 // Enable 5V circuit
-#define RESET_SIMCARD   0x8000
-
-#define RS232_ENABLE    0x0440
-#define PCMCIAMASK      0x402f
-
-
+long simpad_get_cs3_ro(void);
+long simpad_get_cs3_shadow(void);
+void simpad_set_cs3_bit(int value);
+void simpad_clear_cs3_bit(int value);
+
+#define VCC_5V_EN	0x0001 /* For 5V PCMCIA */
+#define VCC_3V_EN	0x0002 /* FOR 3.3V PCMCIA */
+#define EN1		0x0004 /* This is only for EPROM's */
+#define EN0		0x0008 /* Both should be enable for 3.3V or 5V */
+#define DISPLAY_ON	0x0010
+#define PCMCIA_BUFF_DIS	0x0020
+#define MQ_RESET	0x0040
+#define PCMCIA_RESET	0x0080
+#define DECT_POWER_ON	0x0100
+#define IRDA_SD		0x0200 /* Shutdown for powersave */
+#define RS232_ON	0x0400
+#define SD_MEDIAQ	0x0800 /* Shutdown for powersave */
+#define LED2_ON		0x1000
+#define IRDA_MODE	0x2000 /* Fast/Slow IrDA mode */
+#define ENABLE_5V	0x4000 /* Enable 5V circuit */
+#define RESET_SIMCARD	0x8000
+
+#define PCMCIA_BVD1	0x01
+#define PCMCIA_BVD2	0x02
+#define PCMCIA_VS1	0x04
+#define PCMCIA_VS2	0x08
+#define LOCK_IND	0x10
+#define CHARGING_STATE	0x20
+#define PCMCIA_SHORT	0x40
+
+/*--- Battery ---*/
 struct simpad_battery {
 	unsigned char ac_status;	/* line connected yes/no */
 	unsigned char status;		/* battery loading yes/no */
diff --git a/arch/arm/mach-sa1100/leds-simpad.c b/arch/arm/mach-sa1100/leds-simpad.c
index d50f4ee..d25784c 100644
--- a/arch/arm/mach-sa1100/leds-simpad.c
+++ b/arch/arm/mach-sa1100/leds-simpad.c
@@ -22,9 +22,6 @@ static unsigned int hw_led_state;
 #define	LED_GREEN	(1)
 #define	LED_MASK	(1)
 
-extern void set_cs3_bit(int value);
-extern void clear_cs3_bit(int value);     
-
 void simpad_leds_event(led_event_t evt)
 {
 	switch (evt)
@@ -93,8 +90,8 @@ void simpad_leds_event(led_event_t evt)
 	}
 
 	if  (led_state & LED_STATE_ENABLED)
-		set_cs3_bit(LED2_ON);
+		simpad_set_cs3_bit(LED2_ON);
 	else 
-	        clear_cs3_bit(LED2_ON);
+		simpad_clear_cs3_bit(LED2_ON);
 }
 
diff --git a/arch/arm/mach-sa1100/simpad.c b/arch/arm/mach-sa1100/simpad.c
index 718b802..c3c66b0 100644
--- a/arch/arm/mach-sa1100/simpad.c
+++ b/arch/arm/mach-sa1100/simpad.c
@@ -13,6 +13,7 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/io.h>
+#include <linux/gpio.h>
 
 #include <asm/irq.h>
 #include <mach/hardware.h>
@@ -31,32 +32,85 @@
 
 #include "generic.h"
 
-long cs3_shadow;
+/*
+ * CS3 support
+ */
+
+static long cs3_shadow;
+static spinlock_t cs3_lock;
+static struct gpio_chip cs3_gpio;
+
+long simpad_get_cs3_ro(void)
+{
+	return readl(CS3_BASE);
+}
+EXPORT_SYMBOL(simpad_get_cs3_ro);
 
-long get_cs3_shadow(void)
+long simpad_get_cs3_shadow(void)
 {
 	return cs3_shadow;
 }
+EXPORT_SYMBOL(simpad_get_cs3_shadow);
 
-void set_cs3(long value)
+static void __simpad_write_cs3(void)
 {
-	*(CS3BUSTYPE *)(CS3_BASE) = cs3_shadow = value;
+	writel(cs3_shadow, CS3_BASE);
 }
 
-void set_cs3_bit(int value)
+void simpad_set_cs3_bit(int value)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&cs3_lock, flags);
 	cs3_shadow |= value;
-	*(CS3BUSTYPE *)(CS3_BASE) = cs3_shadow;
+	__simpad_write_cs3();
+	spin_unlock_irqrestore(&cs3_lock, flags);
 }
+EXPORT_SYMBOL(simpad_set_cs3_bit);
 
-void clear_cs3_bit(int value)
+void simpad_clear_cs3_bit(int value)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&cs3_lock, flags);
 	cs3_shadow &= ~value;
-	*(CS3BUSTYPE *)(CS3_BASE) = cs3_shadow;
+	__simpad_write_cs3();
+	spin_unlock_irqrestore(&cs3_lock, flags);
 }
+EXPORT_SYMBOL(simpad_clear_cs3_bit);
+
+static void cs3_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	if (offset > 15)
+		return;
+	if (value)
+		simpad_set_cs3_bit(1 << offset);
+	else
+		simpad_clear_cs3_bit(1 << offset);
+};
 
-EXPORT_SYMBOL(set_cs3_bit);
-EXPORT_SYMBOL(clear_cs3_bit);
+static int cs3_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	if (offset > 15)
+		return simpad_get_cs3_ro() & (1 << (offset - 16));
+	return simpad_get_cs3_shadow() & (1 << offset);
+};
+
+static int cs3_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	if (offset > 15)
+		return 0;
+	return -EINVAL;
+};
+
+static int cs3_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
+	int value)
+{
+	if (offset > 15)
+		return -EINVAL;
+	cs3_gpio_set(chip, offset, value);
+	return 0;
+};
 
 static struct map_desc simpad_io_desc[] __initdata = {
 	{	/* MQ200 */
@@ -64,9 +118,9 @@ static struct map_desc simpad_io_desc[] __initdata = {
 		.pfn		= __phys_to_pfn(0x4b800000),
 		.length		= 0x00800000,
 		.type		= MT_DEVICE
-	}, {	/* Paules CS3, write only */
-		.virtual	=  0xf1000000,
-		.pfn		= __phys_to_pfn(0x18000000),
+	}, {	/* Simpad CS3 */
+		.virtual	= CS3_BASE,
+		.pfn		= __phys_to_pfn(SA1100_CS3_PHYS),
 		.length		= 0x00100000,
 		.type		= MT_DEVICE
 	},
@@ -78,12 +132,12 @@ static void simpad_uart_pm(struct uart_port *port, u_int state, u_int oldstate)
 	if (port->mapbase == (u_int)&Ser1UTCR0) {
 		if (state)
 		{
-			clear_cs3_bit(RS232_ON);
-			clear_cs3_bit(DECT_POWER_ON);
+			simpad_clear_cs3_bit(RS232_ON);
+			simpad_clear_cs3_bit(DECT_POWER_ON);
 		}else
 		{
-			set_cs3_bit(RS232_ON);
-			set_cs3_bit(DECT_POWER_ON);
+			simpad_set_cs3_bit(RS232_ON);
+			simpad_set_cs3_bit(DECT_POWER_ON);
 		}
 	}
 }
@@ -143,9 +197,10 @@ static void __init simpad_map_io(void)
 
 	iotable_init(simpad_io_desc, ARRAY_SIZE(simpad_io_desc));
 
-	set_cs3_bit (EN1 | EN0 | LED2_ON | DISPLAY_ON | RS232_ON |
-		      ENABLE_5V | RESET_SIMCARD | DECT_POWER_ON);
-
+	/* Initialize CS3 */
+	cs3_shadow = (EN1 | EN0 | LED2_ON | DISPLAY_ON |
+		RS232_ON | ENABLE_5V | RESET_SIMCARD | DECT_POWER_ON);
+	__simpad_write_cs3(); /* Spinlocks not yet initialized */
 
         sa1100_register_uart_fns(&simpad_port_fns);
 	sa1100_register_uart(0, 3);  /* serial interface */
@@ -171,13 +226,14 @@ static void __init simpad_map_io(void)
 
 static void simpad_power_off(void)
 {
-	local_irq_disable(); // was cli
-	set_cs3(0x800);        /* only SD_MEDIAQ */
+	local_irq_disable();
+	cs3_shadow = SD_MEDIAQ;
+	__simpad_write_cs3(); /* Bypass spinlock here */
 
 	/* disable internal oscillator, float CS lines */
 	PCFR = (PCFR_OPDE | PCFR_FP | PCFR_FS);
-	/* enable wake-up on GPIO0 (Assabet...) */
-	PWER = GFER = GRER = 1;
+	/* enable wake-up on GPIO0 */
+	PWER = GFER = GRER = PWER_GPIO0;
 	/*
 	 * set scratchpad to zero, just in case it is used as a
 	 * restart address by the bootloader.
@@ -212,6 +268,19 @@ static int __init simpad_init(void)
 {
 	int ret;
 
+	spin_lock_init(&cs3_lock);
+
+	cs3_gpio.label = "simpad_cs3";
+	cs3_gpio.base = SIMPAD_CS3_GPIO_BASE;
+	cs3_gpio.ngpio = 24;
+	cs3_gpio.set = cs3_gpio_set;
+	cs3_gpio.get = cs3_gpio_get;
+	cs3_gpio.direction_input = cs3_gpio_direction_input;
+	cs3_gpio.direction_output = cs3_gpio_direction_output;
+	ret = gpiochip_add(&cs3_gpio);
+	if (ret)
+		printk(KERN_WARNING "simpad: Unable to register cs3 GPIO device");
+
 	pm_power_off = simpad_power_off;
 
 	sa11x0_register_mtd(&simpad_flash_data, simpad_flash_resources,
diff --git a/drivers/pcmcia/sa1100_simpad.c b/drivers/pcmcia/sa1100_simpad.c
index c998f7a..0fac965 100644
--- a/drivers/pcmcia/sa1100_simpad.c
+++ b/drivers/pcmcia/sa1100_simpad.c
@@ -15,10 +15,6 @@
 #include <mach/simpad.h>
 #include "sa1100_generic.h"
  
-extern long get_cs3_shadow(void);
-extern void set_cs3_bit(int value); 
-extern void clear_cs3_bit(int value);
-
 static struct pcmcia_irqs irqs[] = {
 	{ 1, IRQ_GPIO_CF_CD, "CF_CD" },
 };
@@ -26,7 +22,7 @@ static struct pcmcia_irqs irqs[] = {
 static int simpad_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 {
 
-	clear_cs3_bit(VCC_3V_EN|VCC_5V_EN|EN0|EN1);
+	simpad_clear_cs3_bit(VCC_3V_EN|VCC_5V_EN|EN0|EN1);
 
 	skt->socket.pci_irq = IRQ_GPIO_CF_IRQ;
 
@@ -38,8 +34,8 @@ static void simpad_pcmcia_hw_shutdown(struct soc_pcmcia_socket *skt)
 	soc_pcmcia_free_irqs(skt, irqs, ARRAY_SIZE(irqs));
 
 	/* Disable CF bus: */
-	//set_cs3_bit(PCMCIA_BUFF_DIS);
-	clear_cs3_bit(PCMCIA_RESET);       
+	/*simpad_set_cs3_bit(PCMCIA_BUFF_DIS);*/
+	simpad_clear_cs3_bit(PCMCIA_RESET);
 }
 
 static void
@@ -47,15 +43,16 @@ simpad_pcmcia_socket_state(struct soc_pcmcia_socket *skt,
 			   struct pcmcia_state *state)
 {
 	unsigned long levels = GPLR;
-	long cs3reg = get_cs3_shadow();
+	long cs3reg = simpad_get_cs3_ro();
 
 	state->detect=((levels & GPIO_CF_CD)==0)?1:0;
 	state->ready=(levels & GPIO_CF_IRQ)?1:0;
-	state->bvd1=1; /* Not available on Simpad. */
-	state->bvd2=1; /* Not available on Simpad. */
+	state->bvd1 = 1; /* Might be cs3reg & PCMCIA_BVD1 */
+	state->bvd2 = 1; /* Might be cs3reg & PCMCIA_BVD2 */
 	state->wrprot=0; /* Not available on Simpad. */
-  
-	if((cs3reg & 0x0c) == 0x0c) {
+
+	if ((cs3reg & (PCMCIA_VS1|PCMCIA_VS2)) ==
+			(PCMCIA_VS1|PCMCIA_VS2)) {
 		state->vs_3v=0;
 		state->vs_Xv=0;
 	} else {
@@ -75,23 +72,23 @@ simpad_pcmcia_configure_socket(struct soc_pcmcia_socket *skt,
 	/* Murphy: see table of MIC2562a-1 */
 	switch (state->Vcc) {
 	case 0:
-		clear_cs3_bit(VCC_3V_EN|VCC_5V_EN|EN0|EN1);
+		simpad_clear_cs3_bit(VCC_3V_EN|VCC_5V_EN|EN0|EN1);
 		break;
 
 	case 33:  
-		clear_cs3_bit(VCC_3V_EN|EN1);
-		set_cs3_bit(VCC_5V_EN|EN0);
+		simpad_clear_cs3_bit(VCC_3V_EN|EN1);
+		simpad_set_cs3_bit(VCC_5V_EN|EN0);
 		break;
 
 	case 50:
-		clear_cs3_bit(VCC_5V_EN|EN1);
-		set_cs3_bit(VCC_3V_EN|EN0);
+		simpad_clear_cs3_bit(VCC_5V_EN|EN1);
+		simpad_set_cs3_bit(VCC_3V_EN|EN0);
 		break;
 
 	default:
 		printk(KERN_ERR "%s(): unrecognized Vcc %u\n",
 			__func__, state->Vcc);
-		clear_cs3_bit(VCC_3V_EN|VCC_5V_EN|EN0|EN1);
+		simpad_clear_cs3_bit(VCC_3V_EN|VCC_5V_EN|EN0|EN1);
 		local_irq_restore(flags);
 		return -1;
 	}
@@ -110,7 +107,7 @@ static void simpad_pcmcia_socket_init(struct soc_pcmcia_socket *skt)
 static void simpad_pcmcia_socket_suspend(struct soc_pcmcia_socket *skt)
 {
 	soc_pcmcia_disable_irqs(skt, irqs, ARRAY_SIZE(irqs));
-	set_cs3_bit(PCMCIA_RESET);
+	simpad_set_cs3_bit(PCMCIA_RESET);
 }
 
 static struct pcmcia_low_level simpad_pcmcia_ops = { 
-- 
1.7.5.4

