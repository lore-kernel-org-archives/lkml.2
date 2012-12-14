Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2LNHG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 02:06:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab2LNHGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:06:25 -0500
Date: Fri, 14 Dec 2012 18:05:53 +1100
From: NeilBrown <neilb@suse.de>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Tony Lindgren <tony@atomide.com>, Benoit <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        linux-omap@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Jon Hunter <jon-hunter@ti.com>
Subject: Re: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
Message-ID: <20121214180553.5eb62c0c@notabene.brown>
In-Reply-To: <87ipblahho.fsf@deeprootsystems.com>
References: <20120825214459.7333a376@notabene.brown>
	<CAMQu2gz0-U4GxEpZFfmJec+0FRs7ugy8EYS3HyYhb1jwbMBjug@mail.gmail.com>
	<20120827085312.75957354@notabene.brown>
	<CAMQu2gwH0O+NHV7H2aF375qmv0=TKb6RweOLohTHtB4UhQ-1gQ@mail.gmail.com>
	<CAMQu2gw2b8HHDPuSRuHXVYn3sJ5BYi_PuOT=snpa3zD5ert=QQ@mail.gmail.com>
	<20120906130510.32b0b877@notabene.brown>
	<CAMQu2gxGNJ+NW_rcRiXNE=OMTq8Hb81_1hDZnNen6mjc2cf6BQ@mail.gmail.com>
	<20120906170245.10e97bdd@notabene.brown>
	<87627pldkj.fsf@deeprootsystems.com>
	<CAMQu2gwSCvw_4gVE-giD6MSzmRCNoNu4NoFBSao_dh9YnojfuA@mail.gmail.com>
	<87ipblahho.fsf@deeprootsystems.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/V=LemLG=vm.KbeFn6aKrMlQ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/V=LemLG=vm.KbeFn6aKrMlQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Sep 2012 10:57:07 -0700 Kevin Hilman <khilman@deeprootsystems.co=
m>
wrote:


> OK thanks, I'll queue this up for v3.6-rc as this should qualify as a
> regression.

I don't think this did actually get queued.  At least I'm still seeing the
bug in 3.7 and I cannot see a patch in the git history that looks right.
But then I don't remember what we ended up with - it was 3 months ago!!!

This is the last thing I can find in my email history - it still seems to
apply and still seems to work.

NeilBrown


From: NeilBrown <neilb@suse.de>
Date: Mon, 10 Sep 2012 14:09:06 +1000
Subject: [PATCH] OMAP GPIO - don't wake from suspend unless requested.

Current kernel will wake from suspend on an event an any active
GPIO event if enable_irq_wake() wasn't called.

There are two reasons that the hardware wake-enable bit should be set:

1/ while non-suspended the CPU might go into a deep sleep (off_mode)
  in which the wake-enable bit is needed for an interrupt to be
  recognised.
2/ while suspended the GPIO interrupt should wake from suspend if and
   only if irq_wake as been enabled.

The code currently doesn't keep these two reasons separate so they get
confused and sometimes the wakeup flags is set incorrectly.

This patch reverts:
 commit 9c4ed9e6c01e7a8bd9079da8267e1f03cb4761fc
    gpio/omap: remove suspend/resume callbacks
and
 commit 0aa2727399c0b78225021413022c164cb99fbc5e
    gpio/omap: remove suspend_wakeup field from struct gpio_bank

and makes some minor changes so that we have separate flags for "GPIO
should wake from deep idle" and "GPIO should wake from suspend".

With this patch, the GPIO from my touch screen doesn't wake my device
any more, which is what I want.

Cc: Kevin Hilman <khilman@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Govindraj.R <govindraj.raja@ti.com>

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 4fbc208..79e1340 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -57,6 +57,7 @@ struct gpio_bank {
 	u16 irq;
 	int irq_base;
 	struct irq_domain *domain;
+	u32 suspend_wakeup;
 	u32 non_wakeup_gpios;
 	u32 enabled_non_wakeup_gpios;
 	struct gpio_regs context;
@@ -522,11 +523,9 @@ static int _set_gpio_wakeup(struct gpio_bank *bank, in=
t gpio, int enable)
=20
 	spin_lock_irqsave(&bank->lock, flags);
 	if (enable)
-		bank->context.wake_en |=3D gpio_bit;
+		bank->suspend_wakeup |=3D gpio_bit;
 	else
-		bank->context.wake_en &=3D ~gpio_bit;
-
-	__raw_writel(bank->context.wake_en, bank->base + bank->regs->wkup_en);
+		bank->suspend_wakeup &=3D ~gpio_bit;
 	spin_unlock_irqrestore(&bank->lock, flags);
=20
 	return 0;
@@ -1157,6 +1156,49 @@ static int __devinit omap_gpio_probe(struct platform=
_device *pdev)
 #ifdef CONFIG_ARCH_OMAP2PLUS
=20
 #if defined(CONFIG_PM_RUNTIME)
+
+#if defined(CONFIG_PM_SLEEP)
+static int omap_gpio_suspend(struct device *dev)
+{
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct gpio_bank *bank =3D platform_get_drvdata(pdev);
+	void __iomem *base =3D bank->base;
+	unsigned long flags;
+
+	if (!bank->mod_usage ||
+	    !bank->regs->wkup_en ||
+	    !bank->context.wake_en)
+		return 0;
+
+	spin_lock_irqsave(&bank->lock, flags);
+	_gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
+	_gpio_rmw(base, bank->regs->wkup_en, bank->suspend_wakeup, 1);
+	spin_unlock_irqrestore(&bank->lock, flags);
+
+	return 0;
+}
+
+static int omap_gpio_resume(struct device *dev)
+{
+	struct platform_device *pdev =3D to_platform_device(dev);
+	struct gpio_bank *bank =3D platform_get_drvdata(pdev);
+	void __iomem *base =3D bank->base;
+	unsigned long flags;
+
+	if (!bank->mod_usage ||
+	    !bank->regs->wkup_en ||
+	    !bank->context.wake_en)
+		return 0;
+
+	spin_lock_irqsave(&bank->lock, flags);
+	_gpio_rmw(base, bank->regs->wkup_en, 0xffffffff, 0);
+	_gpio_rmw(base, bank->regs->wkup_en, bank->context.wake_en, 1);
+	spin_unlock_irqrestore(&bank->lock, flags);
+
+	return 0;
+}
+#endif /* CONFIG_PM_SLEEP */
+
 static void omap_gpio_restore_context(struct gpio_bank *bank);
=20
 static int omap_gpio_runtime_suspend(struct device *dev)
@@ -1386,11 +1428,14 @@ static void omap_gpio_restore_context(struct gpio_b=
ank *bank)
 }
 #endif /* CONFIG_PM_RUNTIME */
 #else
+#define omap_gpio_suspend NULL
+#define omap_gpio_resume NULL
 #define omap_gpio_runtime_suspend NULL
 #define omap_gpio_runtime_resume NULL
 #endif
=20
 static const struct dev_pm_ops gpio_pm_ops =3D {
+	SET_SYSTEM_SLEEP_PM_OPS(omap_gpio_suspend, omap_gpio_resume)
 	SET_RUNTIME_PM_OPS(omap_gpio_runtime_suspend, omap_gpio_runtime_resume,
 									NULL)
 };

[signature.asc  application/pgp-signature (828 bytes)]=20

--Sig_/V=LemLG=vm.KbeFn6aKrMlQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUMrP2Tnsnt1WYoG5AQK+Vw//X5j3Y/5tShAEe1PbpIdjDuwU4iQyqF29
c9aIxGjoAQn24uFhMz3xhllfLZbeojnyFNLhX3txLg2bbyHrevBFDaY1doE/MT77
ye4e1coS90LQguhWTBfwI/jDu4Df669U/95xvRR8/ysflMTENG0NIVQma8hgy2tY
isdni61MleCjHeRMqet04L2vVvfIHQdIzJDlprvdQGkAlk9Pp8RDPekT0xW8aSpG
JtN3OZdIziO7ped+5TEPx+bFjG/5GI5XjbBWhF39kQSXfYPW90Ym1ZXkaspuRs2A
FKqd4Td1RqtRATLM37pil83VGmwe9n2dQSBmIER5Ml8vM0GyDx2+4rcP9GM3RoA/
oeXfbdei4mlXq2fRXDn9uqiSWy5JRl73wEzxlXsjuztnYVxr8BlGgkyuiyfQmF35
92PDI8e5RF2nQLxjjdgMIXf+pawdiRftSztqTYDEKhJPi1xeUI6Ly3tP4cW+jjHr
ymRiMPTaTV5XU8RUSDs44cVj+1yBJmO6yKfD5h6FrIX/S2w3+NX8Wx06+j4m1OU+
EYb9gZy6pfoNY7/iMXgJOTtEzl+I3fx7z/S/VuztJ7+X1AP066aPQZ/Ogwp/RsHR
hGoy85D5SMsmgNacdokQsi+aFvv9nb4VK18Cyk7tfeczBWQFGWg4Ds2AMQNZiKCF
iv5e03LDQnA=
=Vqut
-----END PGP SIGNATURE-----

--Sig_/V=LemLG=vm.KbeFn6aKrMlQ--
