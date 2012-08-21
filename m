Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2HUPLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:11:11 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:56067 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632Ab2HUPLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:11:04 -0400
Date: Tue, 21 Aug 2012 18:07:04 +0300
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: alan@linux.intel.com, Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Subject: Re: [PATCH v2 00/13] OMAP Serial patches
Message-ID: <20120821150702.GN10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
 <1345551371-18862-1-git-send-email-balbi@ti.com>
 <20120821130134.GH10347@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z7bbLlDR+qKEHzO8"
Content-Disposition: inline
In-Reply-To: <20120821130134.GH10347@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z7bbLlDR+qKEHzO8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 21, 2012 at 04:01:36PM +0300, Felipe Balbi wrote:
> Hi,
>=20
> On Tue, Aug 21, 2012 at 03:15:58PM +0300, Felipe Balbi wrote:
> > Hi guys,
> >=20
> > here's a series of cleanup patches to the OMAP serial
> > driver. A later series could be made re-implementing
> > DMA using the DMA Engine API. Note that for RX DMA
> > we could be using RX Timeout IRQ as a hint that we better
> > use PIO instead ;-)
> >=20
> > All patches were tested on my pandaboard, but I'd really
> > like to receive Tested-by on other platforms.
> >=20
> > After this goes in, I'll probably try to get UART wakeup
> > working again and only after that look at DMA.
> >=20
> > Changes since v1:
> >=20
> > 	. improved commit log on patch 9/13 (formerly 10/13)
> > 	. removed patch 2/13
> > 	. added a new patch switching from spin_lock_irqsave() to spin_lock and
> > 		spin_unlock_irqrestore to spin_unlock
> >=20
> > Retested with my pandaboard, UART continues to work:
> >=20
> >  # grep -i uart /proc/interrupts
> >  106:        124          0       GIC  OMAP UART2
> >  #  grep -i uart /proc/interrupts
> >  106:        189          0       GIC  OMAP UART2
> >  #  grep -i uart /proc/interrupts
> >  106:        255          0       GIC  OMAP UART2
> >  #  grep -i uart /proc/interrupts
> >  106:        321          0       GIC  OMAP UART2
> >  #  grep -i uart /proc/interrupts
> >  106:        387          0       GIC  OMAP UART2
> >  #  grep -i uart /proc/interrupts
> >  106:        453          0       GIC  OMAP UART2
> >  #  grep -i uart /proc/interrupts
> >  106:        519          0       GIC  OMAP UART2
> >=20
> > cheers
> >=20
> > ps: if anyone knows a better test for UART, let me know.
> >=20
> > for convenience of anyone testing, patches are available on my git tree=
 [1] on
> > branch uart
> >=20
> > [1] git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git uart
>=20
> I have added one extra patch to this series:
>=20
> From 6921efdb13dda7af216b331bb35535d4b53f004a Mon Sep 17 00:00:00 2001
> From: Felipe Balbi <balbi@ti.com>
> Date: Tue, 21 Aug 2012 15:48:35 +0300
> Subject: [PATCH] serial: omap: drop pm_runtime_irq_safe() usage
>=20
> pm_runtime_irq_safe() will essentially do an
> unbalanced pm_runtime_get_sync() on our parent
> device, which might cause problems when trying
> to suspend.
>=20
> In order to prevent that we drop pm_runtime_irq_safe
> usage in exchange for a little performance hit
> when we enter our IRQ handler while still suspended.
>=20
> If that happens, what we will do is set the irq_pending
> flag, do an asynchronous pm_runtime_get() call and
> return IRQ_HANDLED. When our runtime_resume() callback
> is executed, we check for that flag, and run our
> IRQ handler so that we receive/transmit the pending
> characters.
>=20
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>=20
> One extra patch to OMAP UART driver. This seems to be working
> pretty well even after echo mem > /sys/power/state. I can
> see that I can even wake my pandaboard up by sending a character
> through serial:
>=20
>  #  echo mem > /sys/power/state
>  [ 1335.679260] PM: Syncing filesystems ... done.
>  [ 1335.684387] Freezing user space processes ... (elapsed 0.00 seconds) =
done.
>  [ 1335.691741] Freezing remaining freezable tasks ... (elapsed 0.02 seco=
nds) done.
>  [ 1335.720886] Suspending console(s) (use no_console_suspend to debug)
> =20
>  [ 1335.734405] PM: suspend of devices complete after 5.492 msecs
>  [ 1335.735534] PM: late suspend of devices complete after 1.128 msecs
>  [ 1335.737518] PM: noirq suspend of devices complete after 1.952 msecs
>  [ 1335.737518] Disabling non-boot CPUs ...
>  [ 1335.738525] CPU1: shutdown
>  [ 1338.543762] Successfully put all powerdomains to target state
>  [ 1338.543853] Enabling non-boot CPUs ...
>  [ 1338.545654] CPU1: Booted secondary processor
>  [ 1338.546020] CPU1 is up
>  [ 1338.547027] PM: noirq resume of devices complete after 0.976 msecs
>  [ 1338.548400] PM: early resume of devices complete after 0.762 msecs
>  [ 1339.827087] PM: resume of devices complete after 1278.686 msecs
>  [ 1339.890960] Restarting tasks ... done.
>  # # grep -i uart /proc/interrupts
>  106:       3385          0       GIC  OMAP UART2
>  # echo mem > /sys/power/state
>  [ 1358.015624] PM: Syncing filesystems ... done.
>  [ 1358.020812] Freezing user space processes ... (elapsed 0.00 seconds) =
done.
>  [ 1358.028167] Freezing remaining freezable tasks ... (elapsed 0.01 seco=
nds) done.
>  [ 1358.055084] Suspending console(s) (use no_console_suspend to debug)
> =20
>  [ 1358.068847] PM: suspend of devices complete after 5.633 msecs
>  [ 1358.070007] PM: late suspend of devices complete after 1.126 msecs
>  [ 1358.072051] PM: noirq suspend of devices complete after 2.040 msecs
>  [ 1358.072051] Disabling non-boot CPUs ...
>  [ 1358.073211] CPU1: shutdown
>  [ 1359.104156] Successfully put all powerdomains to target state
>  [ 1359.104278] Enabling non-boot CPUs ...
>  [ 1359.106079] CPU1: Booted secondary processor
>  [ 1359.106475] CPU1 is up
>  [ 1359.107482] PM: noirq resume of devices complete after 1.004 msecs
>  [ 1359.108886] PM: early resume of devices complete after 0.761 msecs
>  [ 1360.414794] PM: resume of devices complete after 1305.836 msecs
>  [ 1360.478668] Restarting tasks ... done.
>  # # grep -i uart /proc/interrupts
>  106:       3511          0       GIC  OMAP UART2
>=20
>  arch/arm/plat-omap/include/plat/omap-serial.h |  1 +
>  drivers/tty/serial/omap-serial.c              | 16 +++++++++++++---
>  2 files changed, 14 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/arm/plat-omap/include/plat/omap-serial.h b/arch/arm/pla=
t-omap/include/plat/omap-serial.h
> index 743ac80..52328ca 100644
> --- a/arch/arm/plat-omap/include/plat/omap-serial.h
> +++ b/arch/arm/plat-omap/include/plat/omap-serial.h
> @@ -130,6 +130,7 @@ struct uart_omap_port {
>  	u32			context_loss_cnt;
>  	u32			errata;
>  	u8			wakeups_enabled;
> +	unsigned int		irq_pending:1;
> =20
>  	struct pm_qos_request	pm_qos_request;
>  	u32			latency;
> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-s=
erial.c
> index a79658d..7e237f3 100644
> --- a/drivers/tty/serial/omap-serial.c
> +++ b/drivers/tty/serial/omap-serial.c
> @@ -353,9 +353,13 @@ static inline irqreturn_t serial_omap_irq(int irq, v=
oid *dev_id)
>  	irqreturn_t ret =3D IRQ_HANDLED;
>  	int max_count =3D 256;
> =20
> -	spin_lock(&up->port.lock);
> -	pm_runtime_get_sync(up->dev);
> +	if (pm_runtime_suspended(up->dev)) {
> +		up->irq_pending =3D true;
> +		pm_runtime_get(up->dev);
> +		return IRQ_HANDLED;
> +	}
> =20
> +	spin_lock(&up->port.lock);
>  	do {
>  		iir =3D serial_in(up, UART_IIR);
>  		if (iir & UART_IIR_NO_INT) {
> @@ -400,6 +404,7 @@ static inline irqreturn_t serial_omap_irq(int irq, vo=
id *dev_id)
>  	pm_runtime_mark_last_busy(up->dev);
>  	pm_runtime_put_autosuspend(up->dev);
>  	up->port_activity =3D jiffies;
> +	up->irq_pending =3D false;
> =20
>  	return ret;
>  }
> @@ -1305,7 +1310,6 @@ static int serial_omap_probe(struct platform_device=
 *pdev)
>  	pm_runtime_set_autosuspend_delay(&pdev->dev,
>  			omap_up_info->autosuspend_timeout);
> =20
> -	pm_runtime_irq_safe(&pdev->dev);
>  	pm_runtime_enable(&pdev->dev);
>  	pm_runtime_get_sync(&pdev->dev);
> =20
> @@ -1416,6 +1420,9 @@ static int serial_omap_runtime_suspend(struct devic=
e *dev)
>  	if (!up)
>  		return -EINVAL;
> =20
> +	if (up->irq_pending)
> +		return -EBUSY;
> +
>  	if (!pdata)
>  		return 0;
> =20
> @@ -1452,6 +1459,9 @@ static int serial_omap_runtime_resume(struct device=
 *dev)
> =20
>  		up->latency =3D up->calc_latency;
>  		schedule_work(&up->qos_work);
> +
> +		if (up->irq_pending)
> +			serial_omap_irq(up->port.irq, up);
>  	}
> =20
>  	return 0;

let's not apply this extra patch. It actually caused a regression which
was pretty difficult to trigger. I have now dropped it from my series.
Sorry for the noise.

--=20
balbi

--z7bbLlDR+qKEHzO8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM6QWAAoJEIaOsuA1yqREcGsP/3/LnqPIezpnAX6p6mIkuykZ
udnyaZUubsDjQXVMHD6KWPFYeDzHqPNzgL0eQqrzmg8OeUK8XtRXXalpiGCIWsic
Ym4EDZUmJlDSNFRJsccHvxiErtRG8rHLOld+ux8pSJDsuUSyB0c+DSEfAPMnLI3Z
GdxW+TDIF6dQrdzjDsLtrWtVxLUFL34qIMj29C1+sj9lSqs1fcHD8SZOR5TYINRm
Nhrh6giPPzVqVQI4NZDJIItnPRoFFRfYOyhV6VSELaZp+tDUITA29OX5viHGCyGJ
ENkILq2wrwlVm5LQlAg+vi2z6ixOGSdtumZ+/93q5TVSceAj5mDaA2om8++A5eto
wX0nWvbH/CmhpzU5XI55IZz2r46O0srPbsmmNiT9GIfkIqCEuGgATbLyOr4VhLaB
JLVB8EL0wx/uj+7u56b/4KW9xDZyOfI4b4J0cMXGxPFlFUDn1a22xFYLQD8ZopDE
0LEyTvMVt1bpe7rKaI/FP2osemvR9Kr1llxYP84M+b47JidA15VQeGBZj/hXHVAU
KBUrkfR/hpCP5if54sGR/+p9JMgE8Xht/od9ohMczSoVrpR0tDUc1xJjbECf/DXZ
utmfb05obdIrWgYX3BlOYhvNZtZApXF54lvZAte0KjNkjn/zWukDgLYTx2KAvzwE
3YusHn1QugUAd0GHyOcF
=IDF6
-----END PGP SIGNATURE-----

--z7bbLlDR+qKEHzO8--
