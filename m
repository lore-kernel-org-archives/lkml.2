Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab1LBFHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 00:07:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab1LBFHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 00:07:18 -0500
Date: Fri, 2 Dec 2011 16:06:48 +1100
From: NeilBrown <neilb@suse.de>
To: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add driver for TCA6507 LED controller.
Message-ID: <20111202160648.7ca96421@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bGd0jHBJN.nF1+njjgs1Ptd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bGd0jHBJN.nF1+njjgs1Ptd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Driver can drive each of 7 outputs as an LED or a GPIO output,
and provides hardware-assist blinking.

Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: NeilBrown <neilb@suse.de>
---

Hi,
 The TCA6507 is the LED driver in the GTA04.  The driver provides full supp=
ort
for brightness levels and hardware blinking.

"MAINTAINERS" says I should send this to Richard, but "git log" suggests
all drivers/leds/ patches are going through Andrew - so I'm sending this
to both :-)

Thanks,
NeilBrown


 drivers/leds/Kconfig         |    8 +
 drivers/leds/Makefile        |    1 +
 drivers/leds/leds-tca6507.c  |  678 ++++++++++++++++++++++++++++++++++++++=
++++
 include/linux/leds-tca6507.h |   33 ++
 4 files changed, 720 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-tca6507.c
 create mode 100644 include/linux/leds-tca6507.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index ff203a4..70f0667 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -387,6 +387,14 @@ config LEDS_RENESAS_TPU
 	  pin function. The latter to support brightness control.
 	  Brightness control is supported but hardware blinking is not.
=20
+config LEDS_TCA6507
+	tristate "LED Support for TCA6507 I2C chip"
+	depends on LEDS_CLASS && I2C
+	help
+	  This option enables support for LEDs connected to TC6507
+	  LED driver chips accessed via the I2C bus.
+	  Driver support brightness control and hardware-assisted blinking.
+
 config LEDS_TRIGGERS
 	bool "LED Trigger support"
 	depends on LEDS_CLASS
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index e4f6bf5..a0525f3 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_LEDS_NS2)			+=3D leds-ns2.o
 obj-$(CONFIG_LEDS_NETXBIG)		+=3D leds-netxbig.o
 obj-$(CONFIG_LEDS_ASIC3)		+=3D leds-asic3.o
 obj-$(CONFIG_LEDS_RENESAS_TPU)		+=3D leds-renesas-tpu.o
+obj-$(CONFIG_LEDS_TCA6507)		+=3D leds-tca6507.o
=20
 # LED SPI Drivers
 obj-$(CONFIG_LEDS_DAC124S085)		+=3D leds-dac124s085.o
diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
new file mode 100644
index 0000000..a7ea4cf
--- /dev/null
+++ b/drivers/leds/leds-tca6507.c
@@ -0,0 +1,678 @@
+/*
+ * leds-tca6507
+ *
+ * The TCA6507 is a programmable LED controller that can drive 7
+ * separate lines either by holding them low, or by pulsing them
+ * with modulated width.
+ * The modulation can be varied in a simple pattern to produce a blink or
+ * double-blink.
+ *
+ * This driver can configure each line either as a 'GPIO' which is out-only
+ * (no pull-up) or as an LED with variable brightness and hardware-assisted
+ * blinking.
+ *
+ * Apart from OFF and ON there are three programmable brightness levels wh=
ich
+ * can be programmed from 0 to 15 and indicate how many 500usec intervals =
in
+ * each 8msec that the led is 'on'.  The levels are named MASTER, BANK0 an=
d BANK1.
+ *
+ * There are two different blink rates that can be programmed, each with s=
eparate
+ * time for rise, on, fall, off and second-off.  Thus if 3 or more differe=
nt
+ * non-trivial rates are required, software must be used for the extra rat=
es.
+ * The two different blink rates must align with the two levels BANK0 and =
BANK1.
+ * This drivers does not support double-blink so 'second-off' always match=
es 'off'.
+ *
+ * Only 16 different times can be programmed is a roughly logarithmic scal=
e from
+ * 64ms to 16320ms.   Times that cannot be closely matched with these must=
 be
+ * handled in software.  This driver allows 12.5% error in matching.
+ *
+ * This driver does not allow rise/fall rates to be set explicitly.  When =
trying
+ * to match a given 'on' or 'off' period, an appropriate pair of 'change' =
and
+ * 'hold' times are chosen to get a close match, with the 'change' being t=
he
+ * smaller.
+ *
+ * Access to the 3 levels and 2 blinks are on a first-come, first-served b=
asis.
+ * Access can be shared by multiple leds if they have the same level and
+ * either same blink rates, or some don't blink.
+ * When a led changes, it relinquishes access and tries again, so it might
+ * lose access to hardware blink.
+ * If a blink engine cannot be allocated, software blink is used.
+ * If the desired brightness cannot be allocated, the closest available no=
n-zero
+ * brightness is used.  As 'full' is always available, the worst case woul=
d be to
+ * have two different blink rates at '1', with Max at '2', then other leds=
 will
+ * have to choose between '2' and '16'.  Hopefully this is not likely.
+ *
+ * Each bank (BANK0 and BANK1) have two usage counts - Leds using the brig=
htness and
+ * Leds using the blink.  It can only be reprogrammed when appropriate cou=
nter
+ * is zero.  The MASTER level has as single usage count.
+ *
+ * Each Led has programmable 'on' and 'off' time as milliseconds.  With ea=
ch
+ * there is a flag saying if it was explicitly requested or defaulted.  Si=
milarly
+ * the banks know if each time was explicit or a default.  Defaults are pe=
rmitted
+ * to be changed freely - they are not recognised when matching.
+ *
+ *
+ * An led-tca6507 device must be provided with platform data.  This data
+ * lists for each output: the name, default trigger, and whether the signal
+ * is being used as a GPiO rather than an led.  'struct led_plaform_data'
+ * is used for this.  If 'name' is NULL, the output isn't used.  If 'flags'
+ * is non-zero, the output is a GPO.  The 'flags' for the first GPIO should
+ * be the base gpio number, or -1.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/leds.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/workqueue.h>
+#include <linux/leds-tca6507.h>
+
+/* LED select registers determine the source that drives LED outputs */
+#define TCA6507_LS_LED_OFF	0x0	/* Output HI-Z (off) */
+#define TCA6507_LS_LED_PWM0	0x2	/* Output LOW with Bank0 rate */
+#define TCA6507_LS_LED_PWM1	0x3	/* Output LOW with Bank1 rate */
+#define TCA6507_LS_LED_ON	0x4	/* Output LOW (on) */
+#define TCA6507_LS_LED_MIR	0x5	/* Output LOW with Master Intensity */
+#define TCA6507_LS_BLINK0	0x6	/* Blink at Bank0 rate */
+#define TCA6507_LS_BLINK1	0x7	/* Blink at Bank1 rate */
+
+enum {
+	BANK0,
+	BANK1,
+	MASTER,
+};
+static int bank_source[3] =3D {
+	TCA6507_LS_LED_PWM0,
+	TCA6507_LS_LED_PWM1,
+	TCA6507_LS_LED_MIR,
+};
+static int blink_source[3] =3D {
+	TCA6507_LS_BLINK0,
+	TCA6507_LS_BLINK1,
+};
+
+/* PWM registers */
+#define	TCA6507_REG_CNT			11
+
+#define	TCA6507_FADE_ON			0x03
+#define	TCA6507_FULL_ON			0x04
+#define	TCA6507_FADE_OFF		0x05
+#define	TCA6507_FIRST_OFF		0x06
+#define	TCA6507_SECOND_OFF		0x07
+#define	TCA6507_MAX_INTENSITY		0x08
+#define	TCA6507_MASTER_INTENSITY	0x09
+#define	TCA6507_INITIALIZE		0x0A
+
+#define	INIT_CODE			0x8
+
+#define TIMECODES 16
+static int time_codes[TIMECODES] =3D {
+	0, 64, 128, 192, 256, 384, 512, 768,
+	1024, 1536, 2048, 3072, 4096, 5760, 8128, 16320
+};
+
+/* Convert an led.brightness level (0..255) to a TCA6507 level (0..15) */
+static inline int TO_LEVEL(int brightness) {
+	return brightness >> 4;
+}
+/* ...and convert back */
+static inline int TO_BRIGHT(int level) {
+	if (level)
+		return (level << 4) | 0xf;
+	return 0;
+}
+
+#define NUM_LEDS 7
+struct tca6507_chip {
+	int			reg_set;	/* a '1' means the register
+						 * should be written */
+	u8			reg_file[TCA6507_REG_CNT];
+	/* Bank 0 is Master Intensity */
+	struct bank {
+		int level;
+		int ontime, offtime;
+		int on_dflt, off_dflt;
+		int time_use, level_use;
+	} bank[3];
+	struct i2c_client	*client;
+	struct work_struct	work;
+	spinlock_t		lock;
+
+	struct tca6507_led {
+		struct tca6507_chip	*chip;
+		struct led_classdev	led_cdev;
+		int			num;
+		int			ontime, offtime;
+		int			on_dflt, off_dflt;
+		int			bank;	/* Bank used, or -1 */
+		int			blink;	/* 1 if we are hardware-blinking */
+	} leds[NUM_LEDS];
+	struct gpio_chip		gpio;
+	const char			*gpio_name[NUM_LEDS];
+	int				gpio_map[NUM_LEDS];
+};
+
+static const struct i2c_device_id tca6507_id[] =3D {
+	{ "tca6507" },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, tca6507);
+
+static int choose_times(int msec, int *c1p, int *c2p)
+{
+	/* Chose two timecodes which add to 'msec' as near as possible.
+	 * The first returned should be the larger.
+	 * If cannot get within 1/8, fail.
+	 * If two possibilities are equally good (e.g. 512+0, 256+256), choose
+	 * the first pair so there is more change-time visible (i.e. it is softer=
).
+	 */
+	int c1, c2;
+	int tmax =3D msec * 9 / 8;
+	int tmin =3D msec * 7 / 8;
+	int diff =3D 65536;
+
+	for (c1 =3D 1; c1 <=3D TIMECODES; c1++) {
+		int t =3D time_codes[c1];
+		if (t*2 < tmin)
+			continue;
+		if (t > tmax)
+			break;
+		for (c2 =3D 0; c2 <=3D c1; c2--) {
+			int tt =3D t + time_codes[c2];
+			int d;
+			if (tt < tmin)
+				continue;
+			if (tt > tmax)
+				break;
+			/* This works! */
+			d =3D abs(msec - tt);
+			if (d >=3D diff)
+				continue;
+			/* Best yet */
+			*c1p =3D c1;
+			*c2p =3D c2;
+			diff =3D d;
+			if (d =3D=3D 0)
+				return 0;
+		}
+	}
+	if (diff < 65536)
+		return 0;
+	/* No close match */
+	return -EINVAL;
+}
+
+/*
+ * Update the register file with the appropriate 3-bit state for
+ * the given led.
+ */
+static void set_select(struct tca6507_chip *tca, int led, int val)
+{
+	int mask =3D (1<<led);
+	int bit;
+
+	for (bit =3D 0; bit < 3; bit++) {
+		int n =3D tca->reg_file[bit] & ~mask;
+		if (val & (1<<bit))
+			n |=3D mask;
+		if (tca->reg_file[bit] !=3D n) {
+			tca->reg_file[bit] =3D n;
+			tca->reg_set |=3D (1<<bit);
+		}
+	}
+}
+
+/* Update the register file with the appropriate 4-bit code for
+ * one bank or other.  This can be used for timers, for levels, or
+ * for initialisation.
+ */
+static void set_code(struct tca6507_chip *tca, int reg, int bank, int new)
+{
+	int mask =3D (0xF << bank);
+	int n =3D tca->reg_file[reg] & ~mask;
+	if (bank)
+		new <<=3D 4;
+	n |=3D new;
+	if (tca->reg_file[reg] !=3D n) {
+		tca->reg_file[reg] =3D n;
+		tca->reg_set |=3D 1 << reg;
+	}
+}
+
+/* Update brightness level. */
+static void set_level(struct tca6507_chip *tca, int bank, int level)
+{
+	switch(bank) {
+	case BANK0:
+	case BANK1:
+		set_code(tca, TCA6507_MAX_INTENSITY, bank, level);
+		break;
+	case MASTER:
+		set_code(tca, TCA6507_MASTER_INTENSITY, 0, level);
+		break;
+	}
+	tca->bank[bank].level =3D level;
+}
+
+/* Record all relevant time code for a given bank */
+static void set_times(struct tca6507_chip *tca, int bank)
+{
+	int c1, c2;
+
+	choose_times(tca->bank[bank].ontime, &c1, &c2);
+	set_code(tca, TCA6507_FADE_ON, bank, c2);
+	set_code(tca, TCA6507_FULL_ON, bank, c1);
+	tca->bank[bank].ontime =3D time_codes[c1] + time_codes[c2];
+
+	choose_times(tca->bank[bank].offtime, &c1, &c2);
+	set_code(tca, TCA6507_FADE_OFF, bank, c2);
+	set_code(tca, TCA6507_FIRST_OFF, bank, c1);
+	set_code(tca, TCA6507_SECOND_OFF, bank, c1);
+	tca->bank[bank].offtime =3D time_codes[c1] + time_codes[c2];
+
+	set_code(tca, TCA6507_INITIALIZE, bank, INIT_CODE);
+}
+
+/* Write all needed register of tca6507 */
+
+static void tca6507_work(struct work_struct *work)
+{
+	struct tca6507_chip *tca =3D container_of(work, struct tca6507_chip,
+						work);
+	struct i2c_client *cl =3D tca->client;
+	int set;
+	u8 file[TCA6507_REG_CNT];
+	int r;
+
+	spin_lock(&tca->lock);
+	set =3D tca->reg_set;
+	memcpy(file, tca->reg_file, TCA6507_REG_CNT);
+	tca->reg_set =3D 0;
+	spin_unlock(&tca->lock);
+
+	for (r =3D 0; r < TCA6507_REG_CNT; r++)
+		if (set & (1<<r))
+			i2c_smbus_write_byte_data(cl, r, file[r]);
+}
+
+static void led_release(struct tca6507_led *led)
+{
+	/* If led owns any resource, release it. */
+	struct tca6507_chip *tca =3D led->chip;
+	if (led->bank >=3D 0) {
+		struct bank *b =3D tca->bank + led->bank;
+		if (led->blink)
+			b->time_use--;
+		b->level_use--;
+	}
+	led->blink =3D 0;
+	led->bank =3D -1;
+}
+
+static int led_prepare(struct tca6507_led *led)
+{
+	/* Assign this led to a bank. configuring that
+	 * bank if necessary.
+	 */
+	int level =3D TO_LEVEL(led->led_cdev.brightness);
+	struct tca6507_chip *tca =3D led->chip;
+	int c1, c2;
+	int i;
+	struct bank *b;
+	int need_init =3D 0;
+
+	led->led_cdev.brightness =3D TO_BRIGHT(level);
+	if (level =3D=3D 0) {
+		set_select(tca, led->num, TCA6507_LS_LED_OFF);
+		return 0;
+	}
+
+	if (led->ontime =3D=3D 0 || led->offtime =3D=3D 0) {
+		/* Just set the brightness, choosing first usable bank.
+		 * If none perfect, choose best.
+		 * Count backwards so we check MASTER bank first
+		 * to avoid wasting a timer.
+		 */
+		int best =3D -1;/* full-on */
+		int diff =3D 15-level;
+
+		if (level =3D=3D 15) {
+			set_select(tca, led->num, TCA6507_LS_LED_ON);
+			return 0;
+		}
+
+		for (i =3D MASTER; i >=3D BANK0; i++) {
+			int d;
+			if (tca->bank[i].level =3D=3D level ||
+			    tca->bank[i].level_use =3D=3D 0) {
+				best =3D i;
+				break;
+			}
+			d =3D abs(level - tca->bank[i].level);
+			if (d < diff) {
+				diff =3D d;
+				best =3D i;
+			}
+		}
+		if (best =3D=3D -1) {
+			/* Best brightness is full-on */
+			set_select(tca, led->num, TCA6507_LS_LED_ON);
+			led->led_cdev.brightness =3D LED_FULL;
+			return 0;
+		}
+
+		if (!tca->bank[best].level_use)
+			set_level(tca, best, level);
+
+		tca->bank[best].level_use++;
+		led->bank =3D best;
+		set_select(tca, led->num, bank_source[best]);
+		led->led_cdev.brightness =3D TO_BRIGHT(tca->bank[best].level);
+		return 0;
+	}
+
+	/* We have on/off time so we need to try to allocate a timing bank. */
+	if (choose_times(led->ontime, &c1, &c2) < 0)
+		return -EINVAL;
+	if (choose_times(led->offtime, &c1, &c2) < 0)
+		return -EINVAL;
+
+	for (i =3D BANK0; i <=3D BANK1; i++) {
+		if (tca->bank[i].level_use =3D=3D 0)
+			/* not in use - it is ours! */
+			break;
+		if (tca->bank[i].level !=3D level)
+			/* Incompatible level - skip */
+			/* FIX: if timer matches we maybe should consider
+			 * this anyway...
+			 */
+			continue;
+
+		if (tca->bank[i].time_use =3D=3D 0)
+			/* Timer not in use, and level matches - use it */
+			break;
+
+		if (!(tca->bank[i].on_dflt ||
+		      led->on_dflt ||
+		      tca->bank[i].ontime =3D=3D led->ontime))
+			/* on time is incompatible */
+			continue;
+
+		if (!(tca->bank[i].off_dflt ||
+		      led->off_dflt ||
+		      tca->bank[i].offtime =3D=3D led->offtime))
+			/* off time is incompatible */
+			continue;
+
+		/* looks like a suitable match */
+		break;
+	}
+
+	if (i > BANK1)
+		/* Nothing matches - how sad */
+		return -EINVAL;
+
+	b =3D &tca->bank[i];
+	if (b->level_use =3D=3D 0)
+		set_level(tca, i, level);
+	b->level_use++;
+	led->bank =3D i;
+
+	if (b->on_dflt ||
+	    !led->on_dflt ||
+	    b->time_use =3D=3D 0) {
+		b->ontime =3D led->ontime;
+		b->on_dflt =3D led->on_dflt;
+		need_init =3D 1;
+	}
+
+	if (b->off_dflt ||
+	    !led->off_dflt ||
+	    b->time_use =3D=3D 0) {
+		b->offtime =3D led->offtime;
+		b->off_dflt =3D led->off_dflt;
+		need_init =3D 1;
+	}
+
+	if (need_init)
+		set_times(tca, i);
+
+	led->ontime =3D b->ontime;
+	led->offtime =3D b->offtime;
+
+	b->time_use++;
+	led->blink =3D 1;
+	led->led_cdev.brightness =3D TO_BRIGHT(b->level);
+	set_select(tca, led->num, blink_source[i]);
+	return 0;
+}
+
+static int led_assign(struct tca6507_led *led)
+{
+	struct tca6507_chip *tca =3D led->chip;
+	int err;
+
+	spin_lock(&tca->lock);
+	led_release(led);
+	err =3D led_prepare(led);
+	if (err) {
+		/* Can only fail on timer setup.  In that
+		 * case need to re-establish as steady level.
+		 */
+		led->ontime =3D 0;
+		led->offtime =3D 0;
+		led_prepare(led);
+	}
+	spin_unlock(&tca->lock);
+
+	if (tca->reg_set)
+		schedule_work(&tca->work);
+	return err;
+}
+
+static void tca6507_brightness_set(struct led_classdev *led_cdev,
+				   enum led_brightness brightness)
+{
+	struct tca6507_led *led =3D container_of(led_cdev, struct tca6507_led,
+					       led_cdev);
+	led->led_cdev.brightness =3D brightness;
+	led->ontime =3D 0;
+	led->offtime =3D 0;
+	led_assign(led);
+}
+
+static int tca6507_blink_set(struct led_classdev *led_cdev,
+			     unsigned long *delay_on,
+			     unsigned long *delay_off)
+{
+	struct tca6507_led *led =3D container_of(led_cdev, struct tca6507_led,
+					       led_cdev);
+
+	if (*delay_on =3D=3D 0)
+		led->on_dflt =3D 1;
+	else if (delay_on !=3D &led_cdev->blink_delay_on)
+		led->on_dflt =3D 0;
+	led->ontime =3D *delay_on;
+
+	if (*delay_off =3D=3D 0)
+		led->off_dflt =3D 1;
+	else if (delay_off !=3D &led_cdev->blink_delay_off)
+		led->off_dflt =3D 0;
+	led->offtime =3D *delay_off;
+
+	if (led->ontime =3D=3D 0)
+		led->ontime =3D 512;
+	if (led->offtime =3D=3D 0)
+		led->offtime =3D 512;
+
+	if (led->led_cdev.brightness =3D=3D LED_OFF)
+		led->led_cdev.brightness =3D LED_FULL;
+	if (led_assign(led) < 0) {
+		led->ontime =3D 0;
+		led->offtime =3D 0;
+		led->led_cdev.brightness =3D LED_OFF;
+		return -EINVAL;
+	}
+	*delay_on =3D led->ontime;
+	*delay_off =3D led->offtime;
+	return 0;
+}
+
+static void tca6507_gpio_set_value(struct gpio_chip *gc,
+				   unsigned offset, int val)
+{
+	struct tca6507_chip *tca =3D container_of(gc, struct tca6507_chip, gpio);
+
+	spin_lock(&tca->lock);
+	/* 'OFF' is floating high, and 'ON' is pulled down, so it has
+	 * the inverse sense of 'val'.
+	 */
+	set_select(tca, tca->gpio_map[offset],
+		   val ? TCA6507_LS_LED_OFF : TCA6507_LS_LED_ON);
+	spin_unlock(&tca->lock);
+	if (tca->reg_set)
+		schedule_work(&tca->work);
+}
+
+static int tca6507_gpio_direction_output(struct gpio_chip *gc,
+					  unsigned offset, int val)
+{
+	tca6507_gpio_set_value(gc, offset, val);
+	return 0;
+}
+
+static int __devinit tca6507_probe(struct i2c_client *client,
+				   const struct i2c_device_id *id)
+{
+	struct tca6507_chip *tca;
+	struct i2c_adapter *adapter;
+	struct tca6507_platform_data *pdata;
+	int err;
+	int i =3D 0;
+	int gpios =3D 0;
+
+	adapter =3D to_i2c_adapter(client->dev.parent);
+	pdata =3D client->dev.platform_data;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C))
+		return -EIO;
+
+	if (!pdata || pdata->leds.num_leds !=3D NUM_LEDS) {
+		dev_err(&client->dev, "Need %d entries in platform-data list\n",
+			NUM_LEDS);
+		return -ENODEV;
+	}
+	err =3D -ENOMEM;
+	tca =3D kzalloc(sizeof(*tca), GFP_KERNEL);
+	if (!tca)
+		goto exit;
+
+	tca->client =3D client;
+	INIT_WORK(&tca->work, tca6507_work);
+	spin_lock_init(&tca->lock);
+
+	for (i =3D 0; i < NUM_LEDS; i++) {
+		struct tca6507_led *l =3D tca->leds + i;
+
+		l->chip =3D tca;
+		l->num =3D i;
+		if (pdata->leds.leds[i].name && !pdata->leds.leds[i].flags) {
+			l->led_cdev.name =3D pdata->leds.leds[i].name;
+			l->led_cdev.default_trigger
+				=3D pdata->leds.leds[i].default_trigger;
+			l->led_cdev.brightness_set =3D tca6507_brightness_set;
+			l->led_cdev.blink_set =3D tca6507_blink_set;
+			l->bank =3D -1;
+			err =3D led_classdev_register(&client->dev,
+						    &l->led_cdev);
+			if (err < 0)
+				goto exit;
+		}
+		if (pdata->leds.leds[i].name && pdata->leds.leds[i].flags) {
+			/* Configure as a gpio */
+			tca->gpio_name[gpios] =3D pdata->leds.leds[i].name;
+			tca->gpio_map[gpios] =3D i;
+			gpios++;
+		}
+	}
+	if (gpios) {
+		tca->gpio.label =3D "gpio-tca6507";
+		tca->gpio.names =3D tca->gpio_name;
+		tca->gpio.ngpio =3D gpios;
+		tca->gpio.base =3D pdata->gpio_base;
+		tca->gpio.owner =3D THIS_MODULE;
+		tca->gpio.direction_output =3D tca6507_gpio_direction_output;
+		tca->gpio.set =3D tca6507_gpio_set_value;
+		tca->gpio.dev =3D &client->dev;
+		err =3D gpiochip_add(&tca->gpio);
+		if (err) {
+			tca->gpio.ngpio =3D 0;
+			goto exit;
+		}
+		if (pdata->setup)
+			pdata->setup(tca->gpio.base, tca->gpio.ngpio);
+	}
+	i2c_set_clientdata(client, tca);
+	/* set all registers to known state - zero */
+	tca->reg_set =3D 0x7f;
+	schedule_work(&tca->work);
+
+	return 0;
+exit:
+	while (i--)
+		if (tca->leds[i].led_cdev.name)
+			led_classdev_unregister(&tca->leds[i].led_cdev);
+	kfree(tca);
+	return err;
+}
+
+static int __devexit tca6507_remove(struct i2c_client *client)
+{
+	int i;
+	struct tca6507_chip *tca =3D i2c_get_clientdata(client);
+	struct tca6507_led *tca_leds =3D tca->leds;
+
+	for (i =3D 0; i < NUM_LEDS; i++) {
+		if (tca_leds[i].led_cdev.name)
+			led_classdev_unregister(&tca_leds[i].led_cdev);
+	}
+	if (tca->gpio.ngpio) {
+		int err =3D gpiochip_remove(&tca->gpio);
+		dev_err(&tca->client->dev, "%s failed, %d\n",
+			"gpiochip_remove()", err);
+	}
+	cancel_work_sync(&tca->work);
+	kfree(tca);
+	i2c_set_clientdata(client, NULL);
+
+	return 0;
+}
+
+static struct i2c_driver tca6507_driver =3D {
+	.driver   =3D {
+		.name    =3D "leds-tca6507",
+		.owner   =3D THIS_MODULE,
+	},
+	.probe    =3D tca6507_probe,
+	.remove   =3D __devexit_p(tca6507_remove),
+	.id_table =3D tca6507_id,
+};
+
+static int __init tca6507_leds_init(void)
+{
+	return i2c_add_driver(&tca6507_driver);
+}
+
+static void __exit tca6507_leds_exit(void)
+{
+	i2c_del_driver(&tca6507_driver);
+}
+
+module_init(tca6507_leds_init);
+module_exit(tca6507_leds_exit);
+
+MODULE_AUTHOR("NeilBrown <neilb@suse.de>");
+MODULE_DESCRIPTION("TCA6507 LED/GPO driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/leds-tca6507.h b/include/linux/leds-tca6507.h
new file mode 100644
index 0000000..3b8ac62
--- /dev/null
+++ b/include/linux/leds-tca6507.h
@@ -0,0 +1,33 @@
+/*
+ * TCA6507 LED chip driver.
+ *
+ * Copyright (C) 2011 Neil Brown <neil@brown.name>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __LINUX_TCA6507_H
+#define __LINUX_TCA6507_H
+#include <linux/leds.h>
+
+struct tca6507_platform_data {
+	struct led_platform_data leds;
+	int gpio_base;
+	void (*setup)(unsigned gpio_base, unsigned ngpio);
+	void (*teardown)(unsigned gpio_base, unsigned ngpio);
+};
+
+#define	TCA6507_MAKE_GPIO 1
+#endif /* __LINUX_TCA6507_H*/
--=20
1.7.7.3


--Sig_/bGd0jHBJN.nF1+njjgs1Ptd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTthc9Dnsnt1WYoG5AQKvzQ//RGKjDxSXzvQ/gZSoAKQMytbiJPryo6qs
IW/56FVEfLgWqOOCi5bPIpTrAxON/2dKs9jlNjRXuy0QsWZo+nBHT0OgpIRUdqfN
QkTGDpbvW9txmjaf2ZYINXMZXhiGB9pav9bTYV8w8G5ZzVaJyGhaFc+jj69x2zbD
Gn9eCVRdVrk2VFwmC5kGqhE40MwB5xvXyAAVtrjgiosOCUPxufFKT/23VCsdsvY8
xkAUO2DUrNI7Xh2bZ919Pdm5tuxVz7WzvUEBu5sc2PthBzhfM0S95Xl1mZBrToZ2
LTUv792JF2x+qV1spiwX3Ct9mfleepjaA26aJZH9XyP+1Xmg3aDM+/qXHyX329pj
LmMuAjQvny8RZJP9q0+Frq5SBuV4C2rih44kTRmr1MjAJahDcWXKITWJRjSXY4Vv
5479+kK7JTY3IfRR2bLDCBPo9yu8x9LWyoUZ6pW3T7jaSQdSAKgpj3Jvxj0lvsDK
VJrfJsN3igJHVP+2XQPJVQ5BIwtqU/bqmN093lv154Ahp54u8avloiOAVsPxmHPb
wD+1hXbKpwYTHMB08KGzoqVksxzakaDUk50+g+EpaRplw8+JljAaLgikvqV8B5zd
K8827aWikZC8He1WSD+uwYV9MsNI8eoQsYTLlWGJiYNrX8lDlnvlv4+7A6YtF6QY
bwQI+hXztLA=
=kRDd
-----END PGP SIGNATURE-----

--Sig_/bGd0jHBJN.nF1+njjgs1Ptd--
