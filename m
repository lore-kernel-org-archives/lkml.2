Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab2BDQIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 11:08:13 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:58526 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069Ab2BDQIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 11:08:12 -0500
Date: Sat, 4 Feb 2012 18:08:04 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: balbi@ti.com, "Cousson, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Charulatha V <charu@ti.com>
Subject: Re: [PATCH v9 01/25] gpio/omap: remove dependency on gpio_bank_count
Message-ID: <20120204160802.GA10818@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1328203851-20435-2-git-send-email-tarun.kanti@ti.com>
 <20120202184106.GC29215@legolas.emea.dhcp.ti.com>
 <20120202191630.GT15343@ponder.secretlab.ca>
 <20120202194545.GA29351@legolas.emea.dhcp.ti.com>
 <4F2AF68D.1000505@ti.com>
 <20120202214907.GA22888@legolas.emea.dhcp.ti.com>
 <20120202215350.GB22888@legolas.emea.dhcp.ti.com>
 <4F2B078B.1040709@ti.com>
 <20120202220744.GA23092@legolas.emea.dhcp.ti.com>
 <87liojajs4.fsf@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <87liojajs4.fsf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 03, 2012 at 09:50:19AM -0800, Kevin Hilman wrote:
> Felipe Balbi <balbi@ti.com> writes:
>=20
> [...]
>=20
> >> >This question remains. Why do we need those funtions ?
> >>=20
> >> These functions are called from the CPUIdle path so outside the scope
> >> of the GPIO driver. These are part of a bunch of nasty PM hacks we
> >> are doing in the CPU idle loop. We are in the process of getting rid
> >> of most of them, but it looks like some are still needed.
> >
> > Too bad. I can see that the gpio pm implementation seems a bit
> > "peculiar". I mean, pm does reference counting and yet the driver has
> > checks to prevent multiple gets and puts on a single bank (meaning that
> > pm counter will be either 0 or 1 at any point in time).
> >
> > To me it looks like those functions are there in order to forcefully put
> > PER power domain in OFF because drivers are always holding a reference
> > to their gpios (drivers generally gpio_request() on probe() and
> > gpio_free() on remove()).
> >
> > Looks like the entire pm implementation on OMAP gpio driver has always
> > considered only the fact that gpios can be requested and freed, but
> > never that we want the system to go to OFF even while gpios are
> > requested, because we have I/O PAD wakeups. At some point that has to be
> > sorted out because that HACK is quite ugly :-)
> >
> > I'll see if I find some time to go over the interactions between
> > gpio-omap.c and pm24x.c and pm34xx.c any of these days, but I can't
> > promise anything ;-)
>=20
> If you look at the state of these prepare/resume hacks at the end of
> this series, you'll see that they are significantly cleaner and do
> nothing but call the runtime PM hooks.

sure, definitely.

> We have explored several ways to get rid of them completely in the idle
> path but have not yet come up with a clean way, but this series gets us
> a long ways towards that goal.

have you thought about being a bit more aggressive at when to
runtime_get and runtime_put ?

I didn't test below (will do probably on monday), but I think this will
help keeping GPIO block always suspended, and only wake it up when truly
needed. That way, you could, at some point, remove that list_head
because by the time you reach CPUIdle path, GPIO module is already
suspended. That's the theory at least, gotta run it first on silicon to
be sure

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 4273401..2dd9ced 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -537,12 +537,7 @@ static int omap_gpio_request(struct gpio_chip *chip, u=
nsigned offset)
 	struct gpio_bank *bank =3D container_of(chip, struct gpio_bank, chip);
 	unsigned long flags;
=20
-	/*
-	 * If this is the first gpio_request for the bank,
-	 * enable the bank module.
-	 */
-	if (!bank->mod_usage)
-		pm_runtime_get_sync(bank->dev);
+	pm_runtime_get_sync(bank->dev);
=20
 	spin_lock_irqsave(&bank->lock, flags);
 	/* Set trigger to none. You need to enable the desired trigger with
@@ -572,6 +567,8 @@ static int omap_gpio_request(struct gpio_chip *chip, un=
signed offset)
=20
 	spin_unlock_irqrestore(&bank->lock, flags);
=20
+	pm_runtime_put(bank->dev);
+
 	return 0;
 }
=20
@@ -581,6 +578,8 @@ static void omap_gpio_free(struct gpio_chip *chip, unsi=
gned offset)
 	void __iomem *base =3D bank->base;
 	unsigned long flags;
=20
+	pm_runtime_get_sync(bank->dev);
+
 	spin_lock_irqsave(&bank->lock, flags);
=20
 	if (bank->regs->wkup_en) {
@@ -606,12 +605,7 @@ static void omap_gpio_free(struct gpio_chip *chip, uns=
igned offset)
 	_reset_gpio(bank, bank->chip.base + offset);
 	spin_unlock_irqrestore(&bank->lock, flags);
=20
-	/*
-	 * If this is the last gpio to be freed in the bank,
-	 * disable the bank module.
-	 */
-	if (!bank->mod_usage)
-		pm_runtime_put(bank->dev);
+	pm_runtime_put(bank->dev);
 }
=20
 /*
@@ -707,9 +701,11 @@ static void gpio_irq_shutdown(struct irq_data *d)
 	struct gpio_bank *bank =3D irq_data_get_irq_chip_data(d);
 	unsigned long flags;
=20
+	pm_runtime_get_sync(bank->dev);
 	spin_lock_irqsave(&bank->lock, flags);
 	_reset_gpio(bank, gpio);
 	spin_unlock_irqrestore(&bank->lock, flags);
+	pm_runtime_put(bank->dev);
 }
=20
 static void gpio_ack_irq(struct irq_data *d)
@@ -717,7 +713,9 @@ static void gpio_ack_irq(struct irq_data *d)
 	unsigned int gpio =3D d->irq - IH_GPIO_BASE;
 	struct gpio_bank *bank =3D irq_data_get_irq_chip_data(d);
=20
+	pm_runtime_get_sync(bank->dev);
 	_clear_gpio_irqstatus(bank, gpio);
+	pm_runtime_put(bank->dev);
 }
=20
 static void gpio_mask_irq(struct irq_data *d)
@@ -726,10 +724,12 @@ static void gpio_mask_irq(struct irq_data *d)
 	struct gpio_bank *bank =3D irq_data_get_irq_chip_data(d);
 	unsigned long flags;
=20
+	pm_runtime_get_sync(bank->dev);
 	spin_lock_irqsave(&bank->lock, flags);
 	_set_gpio_irqenable(bank, gpio, 0);
 	_set_gpio_triggering(bank, GPIO_INDEX(bank, gpio), IRQ_TYPE_NONE);
 	spin_unlock_irqrestore(&bank->lock, flags);
+	pm_runtime_put(bank->dev);
 }
=20
 static void gpio_unmask_irq(struct irq_data *d)
@@ -740,6 +740,7 @@ static void gpio_unmask_irq(struct irq_data *d)
 	u32 trigger =3D irqd_get_trigger_type(d);
 	unsigned long flags;
=20
+	pm_runtime_get_sync(bank->dev);
 	spin_lock_irqsave(&bank->lock, flags);
 	if (trigger)
 		_set_gpio_triggering(bank, GPIO_INDEX(bank, gpio), trigger);
@@ -753,6 +754,7 @@ static void gpio_unmask_irq(struct irq_data *d)
=20
 	_set_gpio_irqenable(bank, gpio, 1);
 	spin_unlock_irqrestore(&bank->lock, flags);
+	pm_runtime_put(bank->dev);
 }
=20
 static struct irq_chip gpio_irq_chip =3D {
@@ -836,17 +838,26 @@ static int gpio_input(struct gpio_chip *chip, unsigne=
d offset)
 	unsigned long flags;
=20
 	bank =3D container_of(chip, struct gpio_bank, chip);
+	pm_runtime_get_sync(bank->dev);
+
 	spin_lock_irqsave(&bank->lock, flags);
 	_set_gpio_direction(bank, offset, 1);
 	spin_unlock_irqrestore(&bank->lock, flags);
+	pm_runtime_put(bank->dev);
+
 	return 0;
 }
=20
 static int gpio_is_input(struct gpio_bank *bank, int mask)
 {
 	void __iomem *reg =3D bank->base + bank->regs->direction;
+	u32 val;
=20
-	return __raw_readl(reg) & mask;
+	pm_runtime_get_sync(bank->dev);
+	val =3D __raw_readl(reg) & mask;
+	pm_runtime_put(bank->dev);
+
+	return val;
 }
=20
 static int gpio_get(struct gpio_chip *chip, unsigned offset)
@@ -856,15 +867,20 @@ static int gpio_get(struct gpio_chip *chip, unsigned =
offset)
 	int gpio;
 	u32 mask;
=20
+	int val;
 	gpio =3D chip->base + offset;
 	bank =3D container_of(chip, struct gpio_bank, chip);
 	reg =3D bank->base;
 	mask =3D GPIO_BIT(bank, gpio);
=20
+	pm_runtime_get_sync(bank->dev);
 	if (gpio_is_input(bank, mask))
-		return _get_gpio_datain(bank, gpio);
+		val =3D _get_gpio_datain(bank, gpio);
 	else
-		return _get_gpio_dataout(bank, gpio);
+		val =3D _get_gpio_dataout(bank, gpio);
+	pm_runtime_put(bank->dev);
+
+	return val;
 }
=20
 static int gpio_output(struct gpio_chip *chip, unsigned offset, int value)
@@ -873,10 +889,14 @@ static int gpio_output(struct gpio_chip *chip, unsign=
ed offset, int value)
 	unsigned long flags;
=20
 	bank =3D container_of(chip, struct gpio_bank, chip);
+
+	pm_runtime_get_sync(bank->dev);
 	spin_lock_irqsave(&bank->lock, flags);
 	bank->set_dataout(bank, offset, value);
 	_set_gpio_direction(bank, offset, 0);
 	spin_unlock_irqrestore(&bank->lock, flags);
+	pm_runtime_put(bank->dev);
+
 	return 0;
 }
=20
@@ -894,9 +914,11 @@ static int gpio_debounce(struct gpio_chip *chip, unsig=
ned offset,
 			dev_err(bank->dev, "Could not get gpio dbck\n");
 	}
=20
+	pm_runtime_get_sync(bank->dev);
 	spin_lock_irqsave(&bank->lock, flags);
 	_set_gpio_debounce(bank, offset, debounce);
 	spin_unlock_irqrestore(&bank->lock, flags);
+	pm_runtime_put(bank->dev);
=20
 	return 0;
 }
@@ -907,9 +929,12 @@ static void gpio_set(struct gpio_chip *chip, unsigned =
offset, int value)
 	unsigned long flags;
=20
 	bank =3D container_of(chip, struct gpio_bank, chip);
+
+	pm_runtime_get_sync(bank->dev);
 	spin_lock_irqsave(&bank->lock, flags);
 	bank->set_dataout(bank, offset, value);
 	spin_unlock_irqrestore(&bank->lock, flags);
+	pm_runtime_put(bank->dev);
 }
=20
 static int gpio_2irq(struct gpio_chip *chip, unsigned offset)
@@ -1330,7 +1355,8 @@ void omap2_gpio_prepare_for_idle(int pwr_mode)
=20
 		bank->power_mode =3D pwr_mode;
=20
-		pm_runtime_put_sync_suspend(bank->dev);
+		if (!pm_runtime_suspended(bank->dev))
+			pm_runtime_suspend(bank->dev);
 	}
 }
=20
@@ -1342,7 +1368,8 @@ void omap2_gpio_resume_after_idle(void)
 		if (!bank->mod_usage || !bank->loses_context)
 			continue;
=20
-		pm_runtime_get_sync(bank->dev);
+		if (pm_runtime_suspended(bank->dev))
+			pm_runtime_resume(bank->dev);
 	}
 }
=20

--=20
balbi

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPLVfiAAoJEIaOsuA1yqREHKcP/2DUMfd3yJcFkETOUAan9G63
EI/q51HqrLX+2frxMAfsbFWJoghAcXeUCnl/4Wfx2wuTCM54HnFPsfmo6OzQGSux
LtU9z7Zvl1HkIb3kKZeebZl+gTkFrcP6FqsSEK1D7rXGhu2oYM1nldaqYH7ISIQ0
6fXo3Djr0B/sVl814S4JVrBzniocecvKtHCAsbOLPv90aMnCK70bhP7vOzvbPFnT
MGbpTwaJ2zsg/QaY3hhwWzQStCvpdRkEBU6PLby8hzyYq/yioFfz45m0qgg1BN8/
nXl9ALcLf8k+uIBj5I703zAjaBBX4tMB74ix0YPr3CFD+/5O2UrytveOI0+erZdz
Q3FXe89qPhAKm/Vapr0CkkBpy5OhffWBG1WITjkkiGBKPbm9oAtqWdNK+WMNSu3a
oX4S03+zdS4PasYOi98DVPNyRwP31lhB97PIjL3pzODLLa56WrkeCPcw6UTSyky9
9iwdlGEGRPmE5HctKkf1lH9qfOGIvLhar7z3YJ7AczE1Aqh64tT57YjpPei4a4ML
oIiYOPKWPFbO7ZC9dZ1VTCwAFVnT7Sacg4YWo9eL60lw401jBNDTiJQ1CuP/RCuK
q89gMHW7Sh0W52byqufHB8lHwQSCGaxNsDwHkbTpKfIyz87lqNKpLNyOjhSJ+hnq
rD+rQa2SXct9uZrQPfBW
=gemU
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
