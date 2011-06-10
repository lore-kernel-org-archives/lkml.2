Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab1FJH4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 03:56:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:42604 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab1FJH4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 03:56:44 -0400
Date: Fri, 10 Jun 2011 09:56:40 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Headphone output doesn't work with 3.0.0-rc* anymore
Message-ID: <20110610075640.GA4832@tiehlicka.suse.cz>
References: <s5hy61cxqcz.wl%tiwai@suse.de>
 <20110608174855.GA4138@tiehlicka.suse.cz>
 <s5hr573y1rl.wl%tiwai@suse.de>
 <20110609085616.GA4207@tiehlicka.suse.cz>
 <20110609090607.GB4207@tiehlicka.suse.cz>
 <s5hei33xsxn.wl%tiwai@suse.de>
 <20110609092826.GC4207@tiehlicka.suse.cz>
 <s5haadrxrsm.wl%tiwai@suse.de>
 <20110609111401.GA3994@tiehlicka.suse.cz>
 <s5htybyw52q.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5htybyw52q.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 10-06-11 08:53:01, Takashi Iwai wrote:
> At Thu, 9 Jun 2011 13:14:01 +0200,
> Michal Hocko wrote:
> > 
> > On Thu 09-06-11 11:44:41, Takashi Iwai wrote:
> > > At Thu, 9 Jun 2011 11:28:26 +0200,
[...]
> > > BTW, does my patch fix the problem when you load without model=auto?
> > 
> > I have just booted to the rc2 with the patch (https://lkml.org/lkml/2011/6/9/25)
> > and it looks it didn't solve the problem. Playback works only from
> > speakers when headphones are not plugged in - no sound if plugged in.
> 
> So, the auto-mute now works but now the headphone doesn't work.
> Weird...  Maybe the same reason the speaker doesn't work with
> auto-mode.  I saw that the only one converter keeps the stream in your
> alsa-info.sh output although multiple converters (0x02, 0x03, 0x06)
> should be used simultaneously.
> 
> > See alsa-info.txt-fresh-boot. Same thing happens if I 
> > modprobe -r snd-hda-intel and then load it again (without any parameters).
> > 
> > > If yes, does the problem appear with it?  I.e. is the silence problem
> > > specific to model=auto or not?
> > 
> > If I try to modproble with model=auto I get headphones working but not
> > output from speakers. Have a look at alsa-info.txt-modprobe_auto.
> 
> For testing, just copy 2.6.39/sound/pci/*.[ch] into 3.0 tree and
> rebuild.  

OK, I git checkout v2.6.39 -- sound/pci/*.[ch] (see the patch bellow for
reference). I have kept the earlier patch.

> Does it work as expected?  

No. There is no sound at all with or without headphones plugged in. See
attached alsa-info output (alsa-info.txt-fresh_boot_*) while mplayer was
running.
After I unloaded the module and loaded it back with model=auto
headphones started working while speakers are still silent as grave (see
alsa-info.txt-modprobe_auto_* taken while playing music).

> If you have a good-working reference, please take alsa-info.sh output
> while playing back a stream.
> 
> Note that the one-minute thing happens only when you unplug AC cable,
> supposedly.  

Hmmm, I was plugged during testing all the time. OK, this looks like a
separate issue. I will repost it as a separate thread once we are done
with this. Any idea who to CC?

> Or, simply write some value (in seconds) to
> /sys/modules/snd_hda_intel/parameters/powersave and access the device
> once (either mixer or PCM) to activate the power-saving mode.

---
>From 60d192d6cda43c358765c801dbabb94f3741a50b Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 10 Jun 2011 09:14:27 +0200
Subject: [PATCH] Revert sound/pci/*.[ch] to 2.6.39

Takashi has suggested to revert these files to 2.6.39 to test
auto mute breakage in 3.0.0-rc[12]
---
 sound/pci/es1968.c    |   78 ----------
 sound/pci/fm801.c     |  378 +++++++++++++++++++++++++++++++++++++-----------
 sound/pci/intel8x0m.c |    4 +-
 3 files changed, 293 insertions(+), 167 deletions(-)

diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index ab0a615..7c17f45 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -112,10 +112,6 @@
 #include <sound/ac97_codec.h>
 #include <sound/initval.h>
 
-#ifdef CONFIG_SND_ES1968_RADIO
-#include <sound/tea575x-tuner.h>
-#endif
-
 #define CARD_NAME "ESS Maestro1/2"
 #define DRIVER_NAME "ES1968"
 
@@ -557,10 +553,6 @@ struct es1968 {
 	spinlock_t ac97_lock;
 	struct tasklet_struct hwvol_tq;
 #endif
-
-#ifdef CONFIG_SND_ES1968_RADIO
-	struct snd_tea575x tea;
-#endif
 };
 
 static irqreturn_t snd_es1968_interrupt(int irq, void *dev_id);
@@ -2579,63 +2571,6 @@ static int __devinit snd_es1968_input_register(struct es1968 *chip)
 }
 #endif /* CONFIG_SND_ES1968_INPUT */
 
-#ifdef CONFIG_SND_ES1968_RADIO
-#define GPIO_DATA	0x60
-#define IO_MASK		4      /* mask      register offset from GPIO_DATA
-				bits 1=unmask write to given bit */
-#define IO_DIR		8      /* direction register offset from GPIO_DATA
-				bits 0/1=read/write direction */
-/* mask bits for GPIO lines */
-#define STR_DATA	0x0040 /* GPIO6 */
-#define STR_CLK		0x0080 /* GPIO7 */
-#define STR_WREN	0x0100 /* GPIO8 */
-#define STR_MOST	0x0200 /* GPIO9 */
-
-static void snd_es1968_tea575x_set_pins(struct snd_tea575x *tea, u8 pins)
-{
-	struct es1968 *chip = tea->private_data;
-	unsigned long io = chip->io_port + GPIO_DATA;
-	u16 val = 0;
-
-	val |= (pins & TEA575X_DATA) ? STR_DATA : 0;
-	val |= (pins & TEA575X_CLK)  ? STR_CLK  : 0;
-	val |= (pins & TEA575X_WREN) ? STR_WREN : 0;
-
-	outw(val, io);
-}
-
-static u8 snd_es1968_tea575x_get_pins(struct snd_tea575x *tea)
-{
-	struct es1968 *chip = tea->private_data;
-	unsigned long io = chip->io_port + GPIO_DATA;
-	u16 val = inw(io);
-
-	return  (val & STR_DATA) ? TEA575X_DATA : 0 |
-		(val & STR_MOST) ? TEA575X_MOST : 0;
-}
-
-static void snd_es1968_tea575x_set_direction(struct snd_tea575x *tea, bool output)
-{
-	struct es1968 *chip = tea->private_data;
-	unsigned long io = chip->io_port + GPIO_DATA;
-	u16 odir = inw(io + IO_DIR);
-
-	if (output) {
-		outw(~(STR_DATA | STR_CLK | STR_WREN), io + IO_MASK);
-		outw(odir | STR_DATA | STR_CLK | STR_WREN, io + IO_DIR);
-	} else {
-		outw(~(STR_CLK | STR_WREN | STR_DATA | STR_MOST), io + IO_MASK);
-		outw((odir & ~(STR_DATA | STR_MOST)) | STR_CLK | STR_WREN, io + IO_DIR);
-	}
-}
-
-static struct snd_tea575x_ops snd_es1968_tea_ops = {
-	.set_pins = snd_es1968_tea575x_set_pins,
-	.get_pins = snd_es1968_tea575x_get_pins,
-	.set_direction = snd_es1968_tea575x_set_direction,
-};
-#endif
-
 static int snd_es1968_free(struct es1968 *chip)
 {
 #ifdef CONFIG_SND_ES1968_INPUT
@@ -2650,10 +2585,6 @@ static int snd_es1968_free(struct es1968 *chip)
 		outw(0, chip->io_port + ESM_PORT_HOST_IRQ); /* disable IRQ */
 	}
 
-#ifdef CONFIG_SND_ES1968_RADIO
-	snd_tea575x_exit(&chip->tea);
-#endif
-
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
 	snd_es1968_free_gameport(chip);
@@ -2792,15 +2723,6 @@ static int __devinit snd_es1968_create(struct snd_card *card,
 
 	snd_card_set_dev(card, &pci->dev);
 
-#ifdef CONFIG_SND_ES1968_RADIO
-	chip->tea.private_data = chip;
-	chip->tea.ops = &snd_es1968_tea_ops;
-	strlcpy(chip->tea.card, "SF64-PCE2", sizeof(chip->tea.card));
-	sprintf(chip->tea.bus_info, "PCI:%s", pci_name(pci));
-	if (!snd_tea575x_init(&chip->tea))
-		printk(KERN_INFO "es1968: detected TEA575x radio\n");
-#endif
-
 	*chip_ret = chip;
 
 	return 0;
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index a7ec703..e1baad7 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -38,6 +38,7 @@
 
 #ifdef CONFIG_SND_FM801_TEA575X_BOOL
 #include <sound/tea575x-tuner.h>
+#define TEA575X_RADIO 1
 #endif
 
 MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
@@ -52,7 +53,7 @@ static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card *
 /*
  *  Enable TEA575x tuner
  *    1 = MediaForte 256-PCS
- *    2 = MediaForte 256-PCP
+ *    2 = MediaForte 256-PCPR
  *    3 = MediaForte 64-PCR
  *   16 = setup tuner only (this is additional bit), i.e. SF64-PCR FM card
  *  High 16-bits are video (radio) device number + 1
@@ -66,7 +67,7 @@ MODULE_PARM_DESC(id, "ID string for the FM801 soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable FM801 soundcard.");
 module_param_array(tea575x_tuner, int, NULL, 0444);
-MODULE_PARM_DESC(tea575x_tuner, "TEA575x tuner access method (0 = auto, 1 = SF256-PCS, 2=SF256-PCP, 3=SF64-PCR, 8=disable, +16=tuner-only).");
+MODULE_PARM_DESC(tea575x_tuner, "TEA575x tuner access method (1 = SF256-PCS, 2=SF256-PCPR, 3=SF64-PCR, +16=tuner-only).");
 
 #define TUNER_ONLY		(1<<4)
 #define TUNER_TYPE_MASK		(~TUNER_ONLY & 0xFFFF)
@@ -195,7 +196,7 @@ struct fm801 {
 	spinlock_t reg_lock;
 	struct snd_info_entry *proc_entry;
 
-#ifdef CONFIG_SND_FM801_TEA575X_BOOL
+#ifdef TEA575X_RADIO
 	struct snd_tea575x tea;
 #endif
 
@@ -714,89 +715,310 @@ static int __devinit snd_fm801_pcm(struct fm801 *chip, int device, struct snd_pc
  *  TEA5757 radio
  */
 
-#ifdef CONFIG_SND_FM801_TEA575X_BOOL
+#ifdef TEA575X_RADIO
 
-/* GPIO to TEA575x maps */
-struct snd_fm801_tea575x_gpio {
-	u8 data, clk, wren, most;
-	char *name;
-};
+/* 256PCS GPIO numbers */
+#define TEA_256PCS_DATA			1
+#define TEA_256PCS_WRITE_ENABLE		2	/* inverted */
+#define TEA_256PCS_BUS_CLOCK		3
 
-static struct snd_fm801_tea575x_gpio snd_fm801_tea575x_gpios[] = {
-	{ .data = 1, .clk = 3, .wren = 2, .most = 0, .name = "SF256-PCS" },
-	{ .data = 1, .clk = 0, .wren = 2, .most = 3, .name = "SF256-PCP" },
-	{ .data = 2, .clk = 0, .wren = 1, .most = 3, .name = "SF64-PCR" },
-};
+static void snd_fm801_tea575x_256pcs_write(struct snd_tea575x *tea, unsigned int val)
+{
+	struct fm801 *chip = tea->private_data;
+	unsigned short reg;
+	int i = 25;
 
-static void snd_fm801_tea575x_set_pins(struct snd_tea575x *tea, u8 pins)
+	spin_lock_irq(&chip->reg_lock);
+	reg = inw(FM801_REG(chip, GPIO_CTRL));
+	/* use GPIO lines and set write enable bit */
+	reg |= FM801_GPIO_GS(TEA_256PCS_DATA) |
+	       FM801_GPIO_GS(TEA_256PCS_WRITE_ENABLE) |
+	       FM801_GPIO_GS(TEA_256PCS_BUS_CLOCK);
+	/* all of lines are in the write direction */
+	/* clear data and clock lines */
+	reg &= ~(FM801_GPIO_GD(TEA_256PCS_DATA) |
+	         FM801_GPIO_GD(TEA_256PCS_WRITE_ENABLE) |
+	         FM801_GPIO_GD(TEA_256PCS_BUS_CLOCK) |
+	         FM801_GPIO_GP(TEA_256PCS_DATA) |
+	         FM801_GPIO_GP(TEA_256PCS_BUS_CLOCK) |
+		 FM801_GPIO_GP(TEA_256PCS_WRITE_ENABLE));
+	outw(reg, FM801_REG(chip, GPIO_CTRL));
+	udelay(1);
+
+	while (i--) {
+		if (val & (1 << i))
+			reg |= FM801_GPIO_GP(TEA_256PCS_DATA);
+		else
+			reg &= ~FM801_GPIO_GP(TEA_256PCS_DATA);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		udelay(1);
+		reg |= FM801_GPIO_GP(TEA_256PCS_BUS_CLOCK);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		reg &= ~FM801_GPIO_GP(TEA_256PCS_BUS_CLOCK);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		udelay(1);
+	}
+
+	/* and reset the write enable bit */
+	reg |= FM801_GPIO_GP(TEA_256PCS_WRITE_ENABLE) |
+	       FM801_GPIO_GP(TEA_256PCS_DATA);
+	outw(reg, FM801_REG(chip, GPIO_CTRL));
+	spin_unlock_irq(&chip->reg_lock);
+}
+
+static unsigned int snd_fm801_tea575x_256pcs_read(struct snd_tea575x *tea)
 {
 	struct fm801 *chip = tea->private_data;
-	unsigned short reg = inw(FM801_REG(chip, GPIO_CTRL));
-	struct snd_fm801_tea575x_gpio gpio = snd_fm801_tea575x_gpios[(chip->tea575x_tuner & TUNER_TYPE_MASK) - 1];
+	unsigned short reg;
+	unsigned int val = 0;
+	int i;
+	
+	spin_lock_irq(&chip->reg_lock);
+	reg = inw(FM801_REG(chip, GPIO_CTRL));
+	/* use GPIO lines, set data direction to input */
+	reg |= FM801_GPIO_GS(TEA_256PCS_DATA) |
+	       FM801_GPIO_GS(TEA_256PCS_WRITE_ENABLE) |
+	       FM801_GPIO_GS(TEA_256PCS_BUS_CLOCK) |
+	       FM801_GPIO_GD(TEA_256PCS_DATA) |
+	       FM801_GPIO_GP(TEA_256PCS_DATA) |
+	       FM801_GPIO_GP(TEA_256PCS_WRITE_ENABLE);
+	/* all of lines are in the write direction, except data */
+	/* clear data, write enable and clock lines */
+	reg &= ~(FM801_GPIO_GD(TEA_256PCS_WRITE_ENABLE) |
+	         FM801_GPIO_GD(TEA_256PCS_BUS_CLOCK) |
+	         FM801_GPIO_GP(TEA_256PCS_BUS_CLOCK));
+
+	for (i = 0; i < 24; i++) {
+		reg &= ~FM801_GPIO_GP(TEA_256PCS_BUS_CLOCK);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		udelay(1);
+		reg |= FM801_GPIO_GP(TEA_256PCS_BUS_CLOCK);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		udelay(1);
+		val <<= 1;
+		if (inw(FM801_REG(chip, GPIO_CTRL)) & FM801_GPIO_GP(TEA_256PCS_DATA))
+			val |= 1;
+	}
 
-	reg &= ~(FM801_GPIO_GP(gpio.data) |
-		 FM801_GPIO_GP(gpio.clk) |
-		 FM801_GPIO_GP(gpio.wren));
+	spin_unlock_irq(&chip->reg_lock);
+
+	return val;
+}
 
-	reg |= (pins & TEA575X_DATA) ? FM801_GPIO_GP(gpio.data) : 0;
-	reg |= (pins & TEA575X_CLK)  ? FM801_GPIO_GP(gpio.clk) : 0;
-	/* WRITE_ENABLE is inverted */
-	reg |= (pins & TEA575X_WREN) ? 0 : FM801_GPIO_GP(gpio.wren);
+/* 256PCPR GPIO numbers */
+#define TEA_256PCPR_BUS_CLOCK		0
+#define TEA_256PCPR_DATA		1
+#define TEA_256PCPR_WRITE_ENABLE	2	/* inverted */
+
+static void snd_fm801_tea575x_256pcpr_write(struct snd_tea575x *tea, unsigned int val)
+{
+	struct fm801 *chip = tea->private_data;
+	unsigned short reg;
+	int i = 25;
+
+	spin_lock_irq(&chip->reg_lock);
+	reg = inw(FM801_REG(chip, GPIO_CTRL));
+	/* use GPIO lines and set write enable bit */
+	reg |= FM801_GPIO_GS(TEA_256PCPR_DATA) |
+	       FM801_GPIO_GS(TEA_256PCPR_WRITE_ENABLE) |
+	       FM801_GPIO_GS(TEA_256PCPR_BUS_CLOCK);
+	/* all of lines are in the write direction */
+	/* clear data and clock lines */
+	reg &= ~(FM801_GPIO_GD(TEA_256PCPR_DATA) |
+	         FM801_GPIO_GD(TEA_256PCPR_WRITE_ENABLE) |
+	         FM801_GPIO_GD(TEA_256PCPR_BUS_CLOCK) |
+	         FM801_GPIO_GP(TEA_256PCPR_DATA) |
+	         FM801_GPIO_GP(TEA_256PCPR_BUS_CLOCK) |
+		 FM801_GPIO_GP(TEA_256PCPR_WRITE_ENABLE));
+	outw(reg, FM801_REG(chip, GPIO_CTRL));
+	udelay(1);
+
+	while (i--) {
+		if (val & (1 << i))
+			reg |= FM801_GPIO_GP(TEA_256PCPR_DATA);
+		else
+			reg &= ~FM801_GPIO_GP(TEA_256PCPR_DATA);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		udelay(1);
+		reg |= FM801_GPIO_GP(TEA_256PCPR_BUS_CLOCK);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		reg &= ~FM801_GPIO_GP(TEA_256PCPR_BUS_CLOCK);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		udelay(1);
+	}
 
+	/* and reset the write enable bit */
+	reg |= FM801_GPIO_GP(TEA_256PCPR_WRITE_ENABLE) |
+	       FM801_GPIO_GP(TEA_256PCPR_DATA);
 	outw(reg, FM801_REG(chip, GPIO_CTRL));
+	spin_unlock_irq(&chip->reg_lock);
 }
 
-static u8 snd_fm801_tea575x_get_pins(struct snd_tea575x *tea)
+static unsigned int snd_fm801_tea575x_256pcpr_read(struct snd_tea575x *tea)
 {
 	struct fm801 *chip = tea->private_data;
-	unsigned short reg = inw(FM801_REG(chip, GPIO_CTRL));
-	struct snd_fm801_tea575x_gpio gpio = snd_fm801_tea575x_gpios[(chip->tea575x_tuner & TUNER_TYPE_MASK) - 1];
+	unsigned short reg;
+	unsigned int val = 0;
+	int i;
+	
+	spin_lock_irq(&chip->reg_lock);
+	reg = inw(FM801_REG(chip, GPIO_CTRL));
+	/* use GPIO lines, set data direction to input */
+	reg |= FM801_GPIO_GS(TEA_256PCPR_DATA) |
+	       FM801_GPIO_GS(TEA_256PCPR_WRITE_ENABLE) |
+	       FM801_GPIO_GS(TEA_256PCPR_BUS_CLOCK) |
+	       FM801_GPIO_GD(TEA_256PCPR_DATA) |
+	       FM801_GPIO_GP(TEA_256PCPR_DATA) |
+	       FM801_GPIO_GP(TEA_256PCPR_WRITE_ENABLE);
+	/* all of lines are in the write direction, except data */
+	/* clear data, write enable and clock lines */
+	reg &= ~(FM801_GPIO_GD(TEA_256PCPR_WRITE_ENABLE) |
+	         FM801_GPIO_GD(TEA_256PCPR_BUS_CLOCK) |
+	         FM801_GPIO_GP(TEA_256PCPR_BUS_CLOCK));
+
+	for (i = 0; i < 24; i++) {
+		reg &= ~FM801_GPIO_GP(TEA_256PCPR_BUS_CLOCK);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		udelay(1);
+		reg |= FM801_GPIO_GP(TEA_256PCPR_BUS_CLOCK);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		udelay(1);
+		val <<= 1;
+		if (inw(FM801_REG(chip, GPIO_CTRL)) & FM801_GPIO_GP(TEA_256PCPR_DATA))
+			val |= 1;
+	}
+
+	spin_unlock_irq(&chip->reg_lock);
 
-	return  (reg & FM801_GPIO_GP(gpio.data)) ? TEA575X_DATA : 0 |
-		(reg & FM801_GPIO_GP(gpio.most)) ? TEA575X_MOST : 0;
+	return val;
 }
 
-static void snd_fm801_tea575x_set_direction(struct snd_tea575x *tea, bool output)
+/* 64PCR GPIO numbers */
+#define TEA_64PCR_BUS_CLOCK		0
+#define TEA_64PCR_WRITE_ENABLE		1	/* inverted */
+#define TEA_64PCR_DATA			2
+
+static void snd_fm801_tea575x_64pcr_write(struct snd_tea575x *tea, unsigned int val)
 {
 	struct fm801 *chip = tea->private_data;
-	unsigned short reg = inw(FM801_REG(chip, GPIO_CTRL));
-	struct snd_fm801_tea575x_gpio gpio = snd_fm801_tea575x_gpios[(chip->tea575x_tuner & TUNER_TYPE_MASK) - 1];
+	unsigned short reg;
+	int i = 25;
 
+	spin_lock_irq(&chip->reg_lock);
+	reg = inw(FM801_REG(chip, GPIO_CTRL));
 	/* use GPIO lines and set write enable bit */
-	reg |= FM801_GPIO_GS(gpio.data) |
-	       FM801_GPIO_GS(gpio.wren) |
-	       FM801_GPIO_GS(gpio.clk) |
-	       FM801_GPIO_GS(gpio.most);
-	if (output) {
-		/* all of lines are in the write direction */
-		/* clear data and clock lines */
-		reg &= ~(FM801_GPIO_GD(gpio.data) |
-			 FM801_GPIO_GD(gpio.wren) |
-			 FM801_GPIO_GD(gpio.clk) |
-			 FM801_GPIO_GP(gpio.data) |
-			 FM801_GPIO_GP(gpio.clk) |
-			 FM801_GPIO_GP(gpio.wren));
-	} else {
-		/* use GPIO lines, set data direction to input */
-		reg |= FM801_GPIO_GD(gpio.data) |
-		       FM801_GPIO_GD(gpio.most) |
-		       FM801_GPIO_GP(gpio.data) |
-		       FM801_GPIO_GP(gpio.most) |
-		       FM801_GPIO_GP(gpio.wren);
-		/* all of lines are in the write direction, except data */
-		/* clear data, write enable and clock lines */
-		reg &= ~(FM801_GPIO_GD(gpio.wren) |
-			 FM801_GPIO_GD(gpio.clk) |
-			 FM801_GPIO_GP(gpio.clk));
+	reg |= FM801_GPIO_GS(TEA_64PCR_DATA) |
+	       FM801_GPIO_GS(TEA_64PCR_WRITE_ENABLE) |
+	       FM801_GPIO_GS(TEA_64PCR_BUS_CLOCK);
+	/* all of lines are in the write direction */
+	/* clear data and clock lines */
+	reg &= ~(FM801_GPIO_GD(TEA_64PCR_DATA) |
+	         FM801_GPIO_GD(TEA_64PCR_WRITE_ENABLE) |
+	         FM801_GPIO_GD(TEA_64PCR_BUS_CLOCK) |
+	         FM801_GPIO_GP(TEA_64PCR_DATA) |
+	         FM801_GPIO_GP(TEA_64PCR_BUS_CLOCK) |
+		 FM801_GPIO_GP(TEA_64PCR_WRITE_ENABLE));
+	outw(reg, FM801_REG(chip, GPIO_CTRL));
+	udelay(1);
+
+	while (i--) {
+		if (val & (1 << i))
+			reg |= FM801_GPIO_GP(TEA_64PCR_DATA);
+		else
+			reg &= ~FM801_GPIO_GP(TEA_64PCR_DATA);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		udelay(1);
+		reg |= FM801_GPIO_GP(TEA_64PCR_BUS_CLOCK);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		reg &= ~FM801_GPIO_GP(TEA_64PCR_BUS_CLOCK);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		udelay(1);
+	}
+
+	/* and reset the write enable bit */
+	reg |= FM801_GPIO_GP(TEA_64PCR_WRITE_ENABLE) |
+	       FM801_GPIO_GP(TEA_64PCR_DATA);
+	outw(reg, FM801_REG(chip, GPIO_CTRL));
+	spin_unlock_irq(&chip->reg_lock);
+}
+
+static unsigned int snd_fm801_tea575x_64pcr_read(struct snd_tea575x *tea)
+{
+	struct fm801 *chip = tea->private_data;
+	unsigned short reg;
+	unsigned int val = 0;
+	int i;
+	
+	spin_lock_irq(&chip->reg_lock);
+	reg = inw(FM801_REG(chip, GPIO_CTRL));
+	/* use GPIO lines, set data direction to input */
+	reg |= FM801_GPIO_GS(TEA_64PCR_DATA) |
+	       FM801_GPIO_GS(TEA_64PCR_WRITE_ENABLE) |
+	       FM801_GPIO_GS(TEA_64PCR_BUS_CLOCK) |
+	       FM801_GPIO_GD(TEA_64PCR_DATA) |
+	       FM801_GPIO_GP(TEA_64PCR_DATA) |
+	       FM801_GPIO_GP(TEA_64PCR_WRITE_ENABLE);
+	/* all of lines are in the write direction, except data */
+	/* clear data, write enable and clock lines */
+	reg &= ~(FM801_GPIO_GD(TEA_64PCR_WRITE_ENABLE) |
+	         FM801_GPIO_GD(TEA_64PCR_BUS_CLOCK) |
+	         FM801_GPIO_GP(TEA_64PCR_BUS_CLOCK));
+
+	for (i = 0; i < 24; i++) {
+		reg &= ~FM801_GPIO_GP(TEA_64PCR_BUS_CLOCK);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		udelay(1);
+		reg |= FM801_GPIO_GP(TEA_64PCR_BUS_CLOCK);
+		outw(reg, FM801_REG(chip, GPIO_CTRL));
+		udelay(1);
+		val <<= 1;
+		if (inw(FM801_REG(chip, GPIO_CTRL)) & FM801_GPIO_GP(TEA_64PCR_DATA))
+			val |= 1;
 	}
 
+	spin_unlock_irq(&chip->reg_lock);
+
+	return val;
+}
+
+static void snd_fm801_tea575x_64pcr_mute(struct snd_tea575x *tea,
+					  unsigned int mute)
+{
+	struct fm801 *chip = tea->private_data;
+	unsigned short reg;
+
+	spin_lock_irq(&chip->reg_lock);
+
+	reg = inw(FM801_REG(chip, GPIO_CTRL));
+	if (mute)
+		/* 0xf800 (mute) */
+		reg &= ~FM801_GPIO_GP(TEA_64PCR_WRITE_ENABLE);
+	else
+		/* 0xf802 (unmute) */
+		reg |= FM801_GPIO_GP(TEA_64PCR_WRITE_ENABLE);
 	outw(reg, FM801_REG(chip, GPIO_CTRL));
+	udelay(1);
+
+	spin_unlock_irq(&chip->reg_lock);
 }
 
-static struct snd_tea575x_ops snd_fm801_tea_ops = {
-	.set_pins = snd_fm801_tea575x_set_pins,
-	.get_pins = snd_fm801_tea575x_get_pins,
-	.set_direction = snd_fm801_tea575x_set_direction,
+static struct snd_tea575x_ops snd_fm801_tea_ops[3] = {
+	{
+		/* 1 = MediaForte 256-PCS */
+		.write = snd_fm801_tea575x_256pcs_write,
+		.read = snd_fm801_tea575x_256pcs_read,
+	},
+	{
+		/* 2 = MediaForte 256-PCPR */
+		.write = snd_fm801_tea575x_256pcpr_write,
+		.read = snd_fm801_tea575x_256pcpr_read,
+	},
+	{
+		/* 3 = MediaForte 64-PCR */
+		.write = snd_fm801_tea575x_64pcr_write,
+		.read = snd_fm801_tea575x_64pcr_read,
+		.mute = snd_fm801_tea575x_64pcr_mute,
+	}
 };
 #endif
 
@@ -1149,7 +1371,7 @@ static int snd_fm801_free(struct fm801 *chip)
 	outw(cmdw, FM801_REG(chip, IRQ_MASK));
 
       __end_hw:
-#ifdef CONFIG_SND_FM801_TEA575X_BOOL
+#ifdef TEA575X_RADIO
 	snd_tea575x_exit(&chip->tea);
 #endif
 	if (chip->irq >= 0)
@@ -1228,34 +1450,16 @@ static int __devinit snd_fm801_create(struct snd_card *card,
 
 	snd_card_set_dev(card, &pci->dev);
 
-#ifdef CONFIG_SND_FM801_TEA575X_BOOL
-	chip->tea.private_data = chip;
-	chip->tea.ops = &snd_fm801_tea_ops;
-	sprintf(chip->tea.bus_info, "PCI:%s", pci_name(pci));
+#ifdef TEA575X_RADIO
 	if ((tea575x_tuner & TUNER_TYPE_MASK) > 0 &&
 	    (tea575x_tuner & TUNER_TYPE_MASK) < 4) {
-		if (snd_tea575x_init(&chip->tea)) {
-			snd_printk(KERN_ERR "TEA575x radio not found\n");
-			snd_fm801_free(chip);
-			return -ENODEV;
-		}
-	} else if ((tea575x_tuner & TUNER_TYPE_MASK) == 0) {
-		/* autodetect tuner connection */
-		for (tea575x_tuner = 1; tea575x_tuner <= 3; tea575x_tuner++) {
-			chip->tea575x_tuner = tea575x_tuner;
-			if (!snd_tea575x_init(&chip->tea)) {
-				snd_printk(KERN_INFO "detected TEA575x radio type %s\n",
-					snd_fm801_tea575x_gpios[tea575x_tuner - 1].name);
-				break;
-			}
-		}
-		if (tea575x_tuner == 4) {
-			snd_printk(KERN_ERR "TEA575x radio not found\n");
-			snd_fm801_free(chip);
-			return -ENODEV;
-		}
+		chip->tea.dev_nr = tea575x_tuner >> 16;
+		chip->tea.card = card;
+		chip->tea.freq_fixup = 10700;
+		chip->tea.private_data = chip;
+		chip->tea.ops = &snd_fm801_tea_ops[(tea575x_tuner & TUNER_TYPE_MASK) - 1];
+		snd_tea575x_init(&chip->tea);
 	}
-	strlcpy(chip->tea.card, snd_fm801_tea575x_gpios[(tea575x_tuner & TUNER_TYPE_MASK) - 1].name, sizeof(chip->tea.card));
 #endif
 
 	*rchip = chip;
diff --git a/sound/pci/intel8x0m.c b/sound/pci/intel8x0m.c
index f3353b4..27709f0 100644
--- a/sound/pci/intel8x0m.c
+++ b/sound/pci/intel8x0m.c
@@ -235,8 +235,8 @@ static DEFINE_PCI_DEVICE_TABLE(snd_intel8x0m_ids) = {
 	{ PCI_VDEVICE(NVIDIA, 0x0069), DEVICE_NFORCE }, /* NFORCE2 */
 	{ PCI_VDEVICE(NVIDIA, 0x0089), DEVICE_NFORCE }, /* NFORCE2s */
 	{ PCI_VDEVICE(NVIDIA, 0x00d9), DEVICE_NFORCE }, /* NFORCE3 */
-	{ PCI_VDEVICE(AMD, 0x746e), DEVICE_INTEL },	/* AMD8111 */
 #if 0
+	{ PCI_VDEVICE(AMD, 0x746d), DEVICE_INTEL },	/* AMD8111 */
 	{ PCI_VDEVICE(AL, 0x5455), DEVICE_ALI },   /* Ali5455 */
 #endif
 	{ 0, }
@@ -1261,9 +1261,9 @@ static struct shortname_table {
 	{ PCI_DEVICE_ID_NVIDIA_MCP2_MODEM, "NVidia nForce2" },
 	{ PCI_DEVICE_ID_NVIDIA_MCP2S_MODEM, "NVidia nForce2s" },
 	{ PCI_DEVICE_ID_NVIDIA_MCP3_MODEM, "NVidia nForce3" },
-	{ 0x746e, "AMD AMD8111" },
 #if 0
 	{ 0x5455, "ALi M5455" },
+	{ 0x746d, "AMD AMD8111" },
 #endif
 	{ 0 },
 };
-- 
1.7.5.3

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
