Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1L3AgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 19:36:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910Ab1L3AgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 19:36:15 -0500
Date: Fri, 30 Dec 2011 11:35:58 +1100
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] leds-tca6507: allow driver to compile when GPIOLIB
 is not available.
Message-ID: <20111230113558.4e04ea5d@notabene.brown>
In-Reply-To: <20111220142331.e81f7dfc.akpm@linux-foundation.org>
References: <20111220054233.7043.3561.stgit@notabene.brown>
	<20111220054441.7043.48656.stgit@notabene.brown>
	<4EF0ED15.5030906@xenotime.net>
	<4EF0EF8B.1030904@xenotime.net>
	<20111221080300.02cb8a45@notabene.brown>
	<20111220142331.e81f7dfc.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/b1pgdmIJJtTj01mq0DyhDVR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/b1pgdmIJJtTj01mq0DyhDVR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Dec 2011 14:23:31 -0800 Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Wed, 21 Dec 2011 08:03:00 +1100
> NeilBrown <neilb@suse.de> wrote:
>=20
> > I might just go an re-review all the code.  And repeat the tests.
>=20
> Here's the current patch as I see it:

Thanks.

Here is a patch against that which is the result of a review and more testi=
ng
*after* making the changes :-)

NeilBrown

=46rom a2081eb20047e9254137e37931e3b47193d8e363 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 29 Dec 2011 17:37:20 +1100
Subject: [PATCH] LEDS tca6507 fixes

- various improvements to comments.
- bug in choose_times() which was counting down instead of up
- Change choice algorithm to allow change-time to be longer
  if requested 'msec' is odd (i.e. use lsb of 'msec' as a flag).
- bug in set_code wasn't shifting mask properly.
- dev_dbg messages so we can monitor the choice funciton.
- make spinlock irq-safe so that gpio.set() and others can be
  called from interrupt handler.
- set client_data before ->setup call back as it could set the
  GPIO value immediately.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index b693de4..133f89f 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -24,29 +24,41 @@
  * This driver does not support double-blink so 'second-off' always matches
  * 'off'.
  *
- * Only 16 different times can be programmed is a roughly logarithmic scal=
e from
- * 64ms to 16320ms.   Times that cannot be closely matched with these must=
 be
+ * Only 16 different times can be programmed in a roughly logarithmic scal=
e from
+ * 64ms to 16320ms.  To be precise the possible times are:
+ *    0, 64, 128, 192, 256, 384, 512, 768,
+ *    1024, 1536, 2048, 3072, 4096, 5760, 8128, 16320
+ *
+ * Times that cannot be closely matched with these must be
  * handled in software.  This driver allows 12.5% error in matching.
  *
  * This driver does not allow rise/fall rates to be set explicitly.  When =
trying
  * to match a given 'on' or 'off' period, an appropriate pair of 'change' =
and
- * 'hold' times are chosen to get a close match, with the 'change' being t=
he
- * smaller.
+ * 'hold' times are chosen to get a close match.  If the target delay is e=
ven,
+ * the 'change' number will be the smaller; if odd, the 'hold' number will=
 be
+ * the smaller.
+
+ * Choosing pairs of delays with 12.5% errors allows us to match delays in=
 the
+ * ranges: 56-72, 112-144, 168-216, 224-27504, 28560-36720.
+ * 26% of the achievable sums can be matched by multiple pairings. For exa=
mple
+ * 1536 =3D=3D 1536+0, 1024+512, or 768+768.  This driver will always choo=
se the
+ * pairing with the least maximum - 768+768 in this case.  Other pairings =
are
+ * not available.
  *
  * Access to the 3 levels and 2 blinks are on a first-come, first-served b=
asis.
  * Access can be shared by multiple leds if they have the same level and
  * either same blink rates, or some don't blink.
  * When a led changes, it relinquishes access and tries again, so it might
  * lose access to hardware blink.
- * If a blink engine cannot be allocated, software blink is used.  If the
- * desired brightness cannot be allocated, the closest available non-zero
+ * If a blink engine cannot be allocated, software blink is used.
+ * If the desired brightness cannot be allocated, the closest available no=
n-zero
  * brightness is used.  As 'full' is always available, the worst case woul=
d be
  * to have two different blink rates at '1', with Max at '2', then other l=
eds
  * will have to choose between '2' and '16'.  Hopefully this is not likely.
  *
- * Each bank (BANK0 and BANK1) have two usage counts - Leds using the brig=
htness
- * and leds using the blink.  It can only be reprogrammed when appropriate
- * counter is zero.  The MASTER level has as single usage count.
+ * Each bank (BANK0 and BANK1) has two usage counts - LEDs using the brigh=
tness
+ * and LEDs using the blink.  It can only be reprogrammed when the appropr=
iate
+ * counter is zero.  The MASTER level has a single usage count.
  *
  * Each Led has programmable 'on' and 'off' time as milliseconds.  With ea=
ch
  * there is a flag saying if it was explicitly requested or defaulted.
@@ -58,8 +70,10 @@
  * lists for each output: the name, default trigger, and whether the signal
  * is being used as a GPiO rather than an led.  'struct led_plaform_data'
  * is used for this.  If 'name' is NULL, the output isn't used.  If 'flags'
- * is non-zero, the output is a GPO.  The 'flags' for the first GPIO should
- * be the base gpio number, or -1.
+ * is TCA6507_MAKE_CPIO, the output is a GPO.
+ * The "struct led_platform_data" can be embedded in a
+ * "struct tca6507_platform_data" which adds a 'gpio_base' for the GPiOs,
+ * and a 'setup' callback which is called once the GPiOs are available.
  *
  */
=20
@@ -74,6 +88,7 @@
=20
 /* LED select registers determine the source that drives LED outputs */
 #define TCA6507_LS_LED_OFF	0x0	/* Output HI-Z (off) */
+#define TCA6507_LS_LED_OFF1	0x1	/* Output HI-Z (off) - not used */
 #define TCA6507_LS_LED_PWM0	0x2	/* Output LOW with Bank0 rate */
 #define TCA6507_LS_LED_PWM1	0x3	/* Output LOW with Bank1 rate */
 #define TCA6507_LS_LED_ON	0x4	/* Output LOW (on) */
@@ -91,7 +106,7 @@ static int bank_source[3] =3D {
 	TCA6507_LS_LED_PWM1,
 	TCA6507_LS_LED_MIR,
 };
-static int blink_source[3] =3D {
+static int blink_source[2] =3D {
 	TCA6507_LS_BLINK0,
 	TCA6507_LS_BLINK1,
 };
@@ -99,6 +114,10 @@ static int blink_source[3] =3D {
 /* PWM registers */
 #define	TCA6507_REG_CNT			11
=20
+/*
+ * 0x00, 0x01, 0x02 encode the TCA6507_LS_* values, each output
+ * owns one bit in each register
+ */
 #define	TCA6507_FADE_ON			0x03
 #define	TCA6507_FULL_ON			0x04
 #define	TCA6507_FADE_OFF		0x05
@@ -132,10 +151,11 @@ static inline int TO_BRIGHT(int level)
=20
 #define NUM_LEDS 7
 struct tca6507_chip {
-	int			reg_set;	/* a '1' means the register
+	int			reg_set;	/* One bit per register where
+						 * a '1' means the register
 						 * should be written */
 	u8			reg_file[TCA6507_REG_CNT];
-	/* Bank 0 is Master Intensity */
+	/* Bank 2 is Master Intensity and doesn't use times */
 	struct bank {
 		int level;
 		int ontime, offtime;
@@ -153,7 +173,7 @@ struct tca6507_chip {
 		int			ontime, offtime;
 		int			on_dflt, off_dflt;
 		int			bank;	/* Bank used, or -1 */
-		int			blink;	/* 1 if we are hardware-blinking */
+		int			blink;	/* Set if hardware-blinking */
 	} leds[NUM_LEDS];
 #ifdef CONFIG_GPIOLIB
 	struct gpio_chip		gpio;
@@ -172,9 +192,13 @@ static int choose_times(int msec, int *c1p, int *c2p)
 {
 	/*
 	 * Choose two timecodes which add to 'msec' as near as possible.
-	 * The first returned should be the larger and is the 'on' of 'off'
-	 * time.  The second will be used as a 'fade-on' or 'fade-off' time.
-	 * If cannot get within 1/8, fail.
+	 * The first returned is the 'on' or 'off' time.  The second is to be
+	 * used as a 'fade-on' or 'fade-off' time.  If 'msec' is even,
+	 * the first will not be smaller than the second.  If 'msec' is odd,
+	 * the first will not be larger than the second.
+	 * If we cannot get a sum within 1/8 of 'msec' fail with -EINVAL,
+	 * otherwise return the sum that was achieved, plus 1 if the first is
+	 * smaller.
 	 * If two possibilities are equally good (e.g. 512+0, 256+256), choose
 	 * the first pair so there is more change-time visible (i.e. it is
 	 * softer).
@@ -193,7 +217,7 @@ static int choose_times(int msec, int *c1p, int *c2p)
 			continue;
 		if (t > tmax)
 			break;
-		for (c2 =3D 0; c2 <=3D c1; c2--) {
+		for (c2 =3D 0; c2 <=3D c1; c2++) {
 			int tt =3D t + time_codes[c2];
 			int d;
 			if (tt < tmin)
@@ -209,11 +233,22 @@ static int choose_times(int msec, int *c1p, int *c2p)
 			*c2p =3D c2;
 			diff =3D d;
 			if (d =3D=3D 0)
-				return 0;
+				return msec;
 		}
 	}
-	if (diff < 65536)
-		return 0;
+	if (diff < 65536) {
+		int actual;
+		if (msec & 1) {
+			c1 =3D *c2p;
+			*c2p =3D *c1p;
+			*c1p =3D c1;
+		}
+		actual =3D time_codes[*c1p] + time_codes[*c2p];
+		if (*c1p < *c2p)
+			return actual + 1;
+		else
+			return actual;
+	}
 	/* No close match */
 	return -EINVAL;
 }
@@ -244,10 +279,13 @@ static void set_select(struct tca6507_chip *tca, int =
led, int val)
  */
 static void set_code(struct tca6507_chip *tca, int reg, int bank, int new)
 {
-	int mask =3D (0xF << bank);
-	int n =3D tca->reg_file[reg] & ~mask;
-	if (bank)
+	int mask =3D 0xF;
+	int n;
+	if (bank) {
+		mask <<=3D 4;
 		new <<=3D 4;
+	}
+	n =3D tca->reg_file[reg] & ~mask;
 	n |=3D new;
 	if (tca->reg_file[reg] !=3D n) {
 		tca->reg_file[reg] =3D n;
@@ -274,17 +312,24 @@ static void set_level(struct tca6507_chip *tca, int b=
ank, int level)
 static void set_times(struct tca6507_chip *tca, int bank)
 {
 	int c1, c2;
+	int result;
=20
-	choose_times(tca->bank[bank].ontime, &c1, &c2);
+	result =3D choose_times(tca->bank[bank].ontime, &c1, &c2);
+	dev_dbg(&tca->client->dev,
+		"Chose on  times %d(%d) %d(%d) for %dms\n", c1, time_codes[c1],
+		c2, time_codes[c2], tca->bank[bank].ontime);
 	set_code(tca, TCA6507_FADE_ON, bank, c2);
 	set_code(tca, TCA6507_FULL_ON, bank, c1);
-	tca->bank[bank].ontime =3D time_codes[c1] + time_codes[c2];
+	tca->bank[bank].ontime =3D result;
=20
-	choose_times(tca->bank[bank].offtime, &c1, &c2);
+	result =3D choose_times(tca->bank[bank].offtime, &c1, &c2);
+	dev_dbg(&tca->client->dev,
+		"Chose off times %d(%d) %d(%d) for %dms\n", c1, time_codes[c1],
+		c2, time_codes[c2], tca->bank[bank].offtime);
 	set_code(tca, TCA6507_FADE_OFF, bank, c2);
 	set_code(tca, TCA6507_FIRST_OFF, bank, c1);
 	set_code(tca, TCA6507_SECOND_OFF, bank, c1);
-	tca->bank[bank].offtime =3D time_codes[c1] + time_codes[c2];
+	tca->bank[bank].offtime =3D result;
=20
 	set_code(tca, TCA6507_INITIALIZE, bank, INIT_CODE);
 }
@@ -300,11 +345,11 @@ static void tca6507_work(struct work_struct *work)
 	u8 file[TCA6507_REG_CNT];
 	int r;
=20
-	spin_lock(&tca->lock);
+	spin_lock_irq(&tca->lock);
 	set =3D tca->reg_set;
 	memcpy(file, tca->reg_file, TCA6507_REG_CNT);
 	tca->reg_set =3D 0;
-	spin_unlock(&tca->lock);
+	spin_unlock_irq(&tca->lock);
=20
 	for (r =3D 0; r < TCA6507_REG_CNT; r++)
 		if (set & (1<<r))
@@ -327,7 +372,7 @@ static void led_release(struct tca6507_led *led)
=20
 static int led_prepare(struct tca6507_led *led)
 {
-	/* Assign this led to a bank. configuring that bank if necessary */
+	/* Assign this led to a bank, configuring that bank if necessary. */
 	int level =3D TO_LEVEL(led->led_cdev.brightness);
 	struct tca6507_chip *tca =3D led->chip;
 	int c1, c2;
@@ -386,7 +431,11 @@ static int led_prepare(struct tca6507_led *led)
 		return 0;
 	}
=20
-	/* We have on/off time so we need to try to allocate a timing bank. */
+	/*
+	 * We have on/off time so we need to try to allocate a timing bank.
+	 * First check if times are compatible with hardware and give up if
+	 * not.
+	 */
 	if (choose_times(led->ontime, &c1, &c2) < 0)
 		return -EINVAL;
 	if (choose_times(led->offtime, &c1, &c2) < 0)
@@ -466,8 +515,9 @@ static int led_assign(struct tca6507_led *led)
 {
 	struct tca6507_chip *tca =3D led->chip;
 	int err;
+	unsigned long flags;
=20
-	spin_lock(&tca->lock);
+	spin_lock_irqsave(&tca->lock, flags);
 	led_release(led);
 	err =3D led_prepare(led);
 	if (err) {
@@ -479,7 +529,7 @@ static int led_assign(struct tca6507_led *led)
 		led->offtime =3D 0;
 		led_prepare(led);
 	}
-	spin_unlock(&tca->lock);
+	spin_unlock_irqrestore(&tca->lock, flags);
=20
 	if (tca->reg_set)
 		schedule_work(&tca->work);
@@ -539,15 +589,16 @@ static void tca6507_gpio_set_value(struct gpio_chip *=
gc,
 				   unsigned offset, int val)
 {
 	struct tca6507_chip *tca =3D container_of(gc, struct tca6507_chip, gpio);
+	unsigned long flags;
=20
-	spin_lock(&tca->lock);
+	spin_lock_irqsave(&tca->lock, flags);
 	/*
 	 * 'OFF' is floating high, and 'ON' is pulled down, so it has the
 	 * inverse sense of 'val'.
 	 */
 	set_select(tca, tca->gpio_map[offset],
 		   val ? TCA6507_LS_LED_OFF : TCA6507_LS_LED_ON);
-	spin_unlock(&tca->lock);
+	spin_unlock_irqrestore(&tca->lock, flags);
 	if (tca->reg_set)
 		schedule_work(&tca->work);
 }
@@ -558,6 +609,7 @@ static int tca6507_gpio_direction_output(struct gpio_ch=
ip *gc,
 	tca6507_gpio_set_value(gc, offset, val);
 	return 0;
 }
+
 static int tca6507_probe_gpios(struct i2c_client *client,
 			       struct tca6507_chip *tca,
 			       struct tca6507_platform_data *pdata)
@@ -643,6 +695,7 @@ static int __devinit tca6507_probe(struct i2c_client *c=
lient,
 	tca->client =3D client;
 	INIT_WORK(&tca->work, tca6507_work);
 	spin_lock_init(&tca->lock);
+	i2c_set_clientdata(client, tca);
=20
 	for (i =3D 0; i < NUM_LEDS; i++) {
 		struct tca6507_led *l =3D tca->leds + i;
@@ -665,7 +718,6 @@ static int __devinit tca6507_probe(struct i2c_client *c=
lient,
 	err =3D tca6507_probe_gpios(client, tca, pdata);
 	if (err)
 		goto exit;
-	i2c_set_clientdata(client, tca);
 	/* set all registers to known state - zero */
 	tca->reg_set =3D 0x7f;
 	schedule_work(&tca->work);
@@ -675,6 +727,8 @@ exit:
 	while (i--)
 		if (tca->leds[i].led_cdev.name)
 			led_classdev_unregister(&tca->leds[i].led_cdev);
+	cancel_work_sync(&tca->work);
+	i2c_set_clientdata(client, NULL);
 	kfree(tca);
 	return err;
 }
@@ -691,8 +745,8 @@ static int __devexit tca6507_remove(struct i2c_client *=
client)
 	}
 	tca6507_remove_gpio(tca);
 	cancel_work_sync(&tca->work);
-	kfree(tca);
 	i2c_set_clientdata(client, NULL);
+	kfree(tca);
=20
 	return 0;
 }

--Sig_/b1pgdmIJJtTj01mq0DyhDVR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTv0Hbjnsnt1WYoG5AQK2Vg//V1pfs0XXzrvc6wGIjNVCJOvXnxMPT676
Qhh+dk1dgs3rxpeRWWAPLjmZ8K8PpNyGQZSb0x49lMVDloO+GkyxdJmEmTEeIZzX
ptmGctow3dUNsnoFwxj+EtN2gcd5qc44kV90DlEAqTx6hR+7SCpFEemEPdm3UENJ
X1AWVC2h1Yaz6XMNak+6QmU3WDP1ES/KKibFd8THq4/nTyF6Rd1ZF/tzs1gaE4f1
jJ5WefvKDO9zDFtTjOAx41XrtVfBa5ks1TvzQZZ+4ruH4Gb0RxzxoRz8g74mLiev
GPf8rbiY5tVwplTQnSCIGd/QsqZZx7C+VuY+UAmmZqPoXppREILOiBllTNpYUs2X
XQ9aJXmv9zk9UOHBU0C/rUWqRiTdyuUFZNo1nUJsnx04s4NbW6/PJutActJudU94
kggGi2CQNDMicYasH9h4UdmCN8cieL6ixh9mkLykbNLpuTy72nr8bxlRbM7AIsya
xplzfr8FVZo6YHa+fGnr83nGKoZ0CxVXosgLaWdFwZy8xmSoBSA1P6f4N5BgqhSU
KKcyQ9Rv1NrSUsjJ1QxQ62F9LjKO134aL3rkVShkeUjnLQiEhrGR6zrnZdHXxDTB
WPSr+jXlsFjRiTM9Q6hBmaWOeNzUTBd6RPdk7wGppsC/Vo24z0d8qQVFo2sAnf4A
l5labBr78Zw=
=FAga
-----END PGP SIGNATURE-----

--Sig_/b1pgdmIJJtTj01mq0DyhDVR--
