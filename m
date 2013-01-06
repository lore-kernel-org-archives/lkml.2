Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab3AFVMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 16:12:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab3AFVMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 16:12:39 -0500
Date: Mon, 7 Jan 2013 08:12:20 +1100
From: NeilBrown <neilb@suse.de>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Erickson <marathon96@gmail.com>, <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: add pwm driver using dmtimers.
Message-ID: <20130107081220.3c39617b@notabene.brown>
In-Reply-To: <50CA0B4D.2000302@ti.com>
References: <20121212192430.50cea126@notabene.brown>
	<50C8ABFC.3080309@ti.com>
	<20121213140635.4eda5858@notabene.brown>
	<50CA0B4D.2000302@ti.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jPMJkBpUO_mukbphZx5us6Y"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jPMJkBpUO_mukbphZx5us6Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Dec 2012 11:07:25 -0600 Jon Hunter <jon-hunter@ti.com> wrote:

>=20
> On 12/12/2012 09:06 PM, NeilBrown wrote:
> >=20

> >>> +
> >>> +#if CONFIG_PM
> >>> +static int omap_pwm_suspend(struct platform_device *pdev, pm_message=
_t state)
> >>> +{
> >>> +	struct omap_chip *omap =3D platform_get_drvdata(pdev);
> >>> +	/* No one preserve these values during suspend so reset them
> >>> +	 * Otherwise driver leaves PWM unconfigured if same values
> >>> +	 * passed to pwm_config
> >>> +	 */
> >>> +	omap->period_ns =3D 0;
> >>> +	omap->duty_ns =3D 0;
> >>
> >>
> >> Hmmm, looks like you are trying to force a reconfiguration after suspe=
nd
> >> if the same values are used. Is there an underlying problem here that
> >> you are trying to workaround?
> >=20
> > I copied that from pwm-samsung.c.
> >=20
> > The key question is: does a dmtimer preserve all register values over s=
uspend.
> > If so, then I guess we don't need this.
> > If not, we do (because omap_pwm_config short circuits if it thinks the =
config
> > hasn't changed).
>=20
> I gave it a quick test on omap3/4 when just operating the timer as a
> counter (not driving a pwm output) and suspend/resume works fine.
> However, it does not work if I enable off mode (via the debugfs). This
> is not enabled by default and may be I should put that on my to-do list
> as well.

I've been playing with off-mode and discovered that the first attempt to set
the PWM after resume didn't work, but subsequent ones did.
I did some digging and came up with the following patch. =20
With this in place, the omap_pwm_suspend() above is definitely pointless (w=
as
wasn't really useful even without it).

NeilBrown


From: NeilBrown <neilb@suse.de>
Date: Mon, 7 Jan 2013 07:53:03 +1100
Subject: [PATCH] OMAP dmtimer - simplify context-loss handling.

The context loss handling in dmtimer appears to assume that
   omap_dm_timer_set_load_start() or omap_dm_timer_start()
and
   omap_dm_timer_stop()

bracket all interactions.  Only the first two restore the context and
the last updates the context loss counter.
However omap_dm_timer_set_load() or omap_dm_timer_set_match() can
reasonably be called outside this bracketing, and the fact that they
call omap_dm_timer_enable() / omap_dm_timer_disable() suggest that
is expected.

So if, after a transition into and out of off-mode which would cause
the dm timer to loose all state, omap_dm_timer_set_match() is called
before omap_dm_timer_start(), the value read from OMAP_TIMER_CTRL_REG
will be 'wrong' and this wrong value will be stored context.tclr so
a subsequent omap_dm_timer_start() can fail (As the control register
is wrong).

Simplify this be doing the restore-from-context in
omap_dm_timer_enable() so that whenever the timer is enabled, the
context is correct.
Also update the ctx_loss_count at the same time as we notice it is
wrong - these is no value in delaying this until the
omap_dm_timer_disable() as it cannot change while the timer is
enabled.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 938b50a..c216696 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -253,6 +253,15 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_free);
 void omap_dm_timer_enable(struct omap_dm_timer *timer)
 {
 	pm_runtime_get_sync(&timer->pdev->dev);
+
+	if (!(timer->capability & OMAP_TIMER_ALWON)) {
+		int loss_count =3D
+			omap_pm_get_dev_context_loss_count(&timer->pdev->dev);
+		if (loss_count !=3D timer->ctx_loss_count) {
+			omap_timer_restore_context(timer);
+			timer->ctx_loss_count =3D loss_count;
+		}
+	}
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_enable);
=20
@@ -347,12 +356,6 @@ int omap_dm_timer_start(struct omap_dm_timer *timer)
=20
 	omap_dm_timer_enable(timer);
=20
-	if (!(timer->capability & OMAP_TIMER_ALWON)) {
-		if (omap_pm_get_dev_context_loss_count(&timer->pdev->dev) !=3D
-				timer->ctx_loss_count)
-			omap_timer_restore_context(timer);
-	}
-
 	l =3D omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
 	if (!(l & OMAP_TIMER_CTRL_ST)) {
 		l |=3D OMAP_TIMER_CTRL_ST;
@@ -377,10 +380,6 @@ int omap_dm_timer_stop(struct omap_dm_timer *timer)
=20
 	__omap_dm_timer_stop(timer, timer->posted, rate);
=20
-	if (!(timer->capability & OMAP_TIMER_ALWON))
-		timer->ctx_loss_count =3D
-			omap_pm_get_dev_context_loss_count(&timer->pdev->dev);
-
 	/*
 	 * Since the register values are computed and written within
 	 * __omap_dm_timer_stop, we need to use read to retrieve the
@@ -494,12 +493,6 @@ int omap_dm_timer_set_load_start(struct omap_dm_timer =
*timer, int autoreload,
=20
 	omap_dm_timer_enable(timer);
=20
-	if (!(timer->capability & OMAP_TIMER_ALWON)) {
-		if (omap_pm_get_dev_context_loss_count(&timer->pdev->dev) !=3D
-				timer->ctx_loss_count)
-			omap_timer_restore_context(timer);
-	}
-
 	l =3D omap_dm_timer_read_reg(timer, OMAP_TIMER_CTRL_REG);
 	if (autoreload) {
 		l |=3D OMAP_TIMER_CTRL_AR;

--Sig_/jPMJkBpUO_mukbphZx5us6Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUOnotDnsnt1WYoG5AQJ+BA//Vgzcy0IF30TpG7FqArw2aGXkAFvhiFB1
B72T47gM0i88N4ySPQnqJJcZwzTvk9G3SrWlrR/tHRzbZXJIaYWzTBk7U1VZ2Bwv
9CK7DVdPwrvTsALNX+l7xeHayC9zL4Eot/VJTLm3/LVLChwyeZdpZ7ltUSG9Tq55
3imBnNfUeHk6z5AbyT/WU/BRquB/Hm0SslmHQGgXOHgwbj3FmrcL1HHLAQcOmtdx
vfFSByAVBMkt6GmPIuiJMFxsjqi/QpEneZi1Bb47o09pR4h11MuEvoeitkqpuFzL
4EsXeazJHrlAivs4MZ3iuX4uFGZRkczB11SR3j94oEoLZjS0p4r1oCTzaZ3MBQtF
VHhcvd1fvn2c7jsdtqqPdVX67wzurLnyVNu6rlOqOExpq+XD3lLzaE6EGXxUFco9
MGgi+jXGVfPGZDJq9+YIm4ld85f3v708NnCdPhIwMf75PRgYs2zkO4AWtuhsJOHu
v7sPZ7anLoESSGOef907n10ko814m8xiNzuh9HpSqqAzzUfdNtxzI5kOnqWv94Z9
mlHaud2htGg7actqsyyghZYNsfnThOfwIyBdPXGTmLTAwuT3knedzSC+t4optc4G
Lh5yY8WdibsvQkaAHquNt+2MIZDmBEQBmLFn6jrVMhz4XtqOY/KLuQqBmehDVWx8
bWJU0yEUFtU=
=7y+B
-----END PGP SIGNATURE-----

--Sig_/jPMJkBpUO_mukbphZx5us6Y--
