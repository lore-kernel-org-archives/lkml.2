Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab1GFRyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:54:23 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:40448 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754626Ab1GFRyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:54:21 -0400
Date: Wed, 6 Jul 2011 20:54:14 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Partha Basak <p-basak2@ti.com>,
        Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Anand Gadiyar <gadiyar@ti.com>,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        Benoit Cousson <b-cousson@ti.com>, paul@pwsan.com, johnstul@us.ibm.com,
        Vishwanath Sripathy <vishwanath.bs@ti.com>
Subject: Re: [PATCH 6/6 v2] arm: omap: usb: global Suspend and resume support
 of ehci and ohci
Message-ID: <20110706175412.GH10729@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <Pine.LNX.4.44L0.1107051018580.2060-100000@iolanthe.rowland.org>
 <8762ngtyqj.fsf@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MFZs98Tklfu0WsCO"
Content-Disposition: inline
In-Reply-To: <8762ngtyqj.fsf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MFZs98Tklfu0WsCO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 05, 2011 at 10:37:40AM -0700, Kevin Hilman wrote:
> While I did design the OMAP PM core to be runtime PM centric, and we
> implemented several drivers based on runtime PM alone, after some long
> discussions on linux-pm[1] with Alan and Rafael (PM maintainer) over the
> last couple weeks, I'm now convinced I had the wrong design/approach.
>=20
> Rafael and Alan have been patient with my stubborness, but now I've been
> pursuaded.  Rafael has detailed on linux-pm the various
> problems/limitations/races between runtime PM and system PM[2], so I
> don't plan debating them again here.
>=20
> That being said, today we have several drivers that use runtime PM calls
> in their suspend/resume path and our PM domain implementation (inside
> omap_device) deals with most of the limitations fine.  However, there
> are 2 main problems/limitation with this that we've chosen to live with
> (for now):
>        =20
> 1) synchronous calls must be used in the suspend/resume path (because
>    PM workqueue is frozen during suspend/resumea)
> 2) disabling runtime PM from userspace will prevent that device
>    from hitting its low-power state during suspend.
>=20
> For v3.1 (and before), we've lived with these limitations, and I'm OK
> with merging other drivers for v3.1 with these limitations.  After 3.1,
> this will be changing (more on this below.) =20
>=20
> So, while I've been OK with merging drivers with the above limitations
> for one more merge window, $SUBJECT patch adds a new twist by forcibly
> managing the parent device from the child device.  Personally, I really
> don't like that approach and it serves as a good illustration of yet
> another reason why system PM and runtime PM need understood as
> conceptually very different.
>=20
> For v3.2, the PM core will change[2] to futher limit/protect
> interactions between runtime PM and system PM, and I will be reworking
> our PM domain (omap_device) implementation accordingly. =20
>=20
> Basically, what that will mean is that our PM domain layer (omap_device)
> will also call omap_device_idle() in the suspend path, but only if the
> device is *not* already idle (from previous runtime suspend.)  The PM
> domain layer will then omap_device_enable() the device in the system
> resume path if it was suspended in the system suspend path.  A minimally
> tested patch to do this is below.
>=20
> So, the driver still does not have to care about it's specific clocks
> etc. (which should address Felipe's concern), clocks and other
> IP-specific PM details will all continue to be handled by omap_device,
> just like it is with runtime PM.
>=20
> The primary change to the driver, is that whatever needs to be done to
> prepare for both runtime PM and system PM (including context
> save/restore etc.) will have to be done in a common function(s) that
> will be called by *both* of its ->runtime_suspend() and ->suspend()
> callbacks, and similar for ->runtime_resume() and ->resume(). =20
>=20
> Some drivers will have additional work to do for system PM though.  This
> is mainly because system PM can happen at *any* time, including in the
> middle of ongoing activity, whereas runtime PM transitions happen when
> the device is known to be idle.  What that means is that for example, a
> drivers ->suspend() method might need to wait for (or forcibly stop) any
> ongoing activity in order to be sure the device is ready to be suspended.
>=20
> Frankly, this is not a very big change for the drivers, as the
> device-specific idle work will still be handled by the PM domain layer.
>=20
> Hope that helps clarify the background.
>=20
> As for this particular patch, since it is rather late in the development
> cycle for v3.1, I would recommend that it wait until the omap_device
> changes, and then let the PM core (for system PM and runtime PM) handle
> the parent/child relationships as they are designed to.   But that is up
> to Felipe and USB maintainers to decide.
>=20
> Kevin
>=20
> [1] https://lists.linux-foundation.org/pipermail/linux-pm/2011-June/03155=
9.html
> [2] https://lists.linux-foundation.org/pipermail/linux-pm/2011-June/03197=
7.html
>=20
>=20
> From 6696e9a2b106ca9c9936e5c2ad89650010120e10 Mon Sep 17 00:00:00 2001
> From: Kevin Hilman <khilman@ti.com>
> Date: Tue, 7 Jun 2011 16:07:28 -0700
> Subject: [PATCH] OMAP: PM: omap_device: add system PM methods for PM doma=
in handling
>=20
> Using PM domain callbacks, use omap_device idle/enable to
> automatically suspend/resume devices.  Also use pm_generic_* routines
> to ensure driver's callbacks are correctly called.
>=20
> Driver ->suspend callback is needed to ensure the driver is in a state
> that it can be suspended.
>=20
> If device is already idle (typically because of previous runtime PM
> activity), there's nothing extra to do.
>=20
> KJH: The omap_device_* calls should probably actually be done in the
>      _noirq() methods.
>=20
> Not-yet-Signed-off-by: Kevin Hilman <khilman@ti.com>
> ---
>  arch/arm/plat-omap/include/plat/omap_device.h |    4 +++
>  arch/arm/plat-omap/omap_device.c              |   32 +++++++++++++++++++=
++++++
>  2 files changed, 36 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/arm/plat-omap/include/plat/omap_device.h b/arch/arm/pla=
t-omap/include/plat/omap_device.h
> index e4c349f..bc36d05 100644
> --- a/arch/arm/plat-omap/include/plat/omap_device.h
> +++ b/arch/arm/plat-omap/include/plat/omap_device.h
> @@ -44,6 +44,9 @@ extern struct device omap_device_parent;
>  #define OMAP_DEVICE_STATE_IDLE		2
>  #define OMAP_DEVICE_STATE_SHUTDOWN	3
> =20
> +/* omap_device.flags values */
> +#define OMAP_DEVICE_SUSPENDED BIT(0)
> +
>  /**
>   * struct omap_device - omap_device wrapper for platform_devices
>   * @pdev: platform_device
> @@ -73,6 +76,7 @@ struct omap_device {
>  	s8				pm_lat_level;
>  	u8				hwmods_cnt;
>  	u8				_state;
> +	u8                              flags;
>  };
> =20
>  /* Device driver interface (call via platform_data fn ptrs) */
> diff --git a/arch/arm/plat-omap/omap_device.c b/arch/arm/plat-omap/omap_d=
evice.c
> index 49fc0df..f2711c3 100644
> --- a/arch/arm/plat-omap/omap_device.c
> +++ b/arch/arm/plat-omap/omap_device.c
> @@ -564,12 +564,44 @@ static int _od_runtime_resume(struct device *dev)
>  	return pm_generic_runtime_resume(dev);
>  }
> =20
> +static int _od_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +	struct omap_device *od =3D to_omap_device(pdev);
> +	int ret;
> +
> +	ret =3D pm_generic_suspend(dev);
> +
> +	od->flags &=3D ~OMAP_DEVICE_SUSPENDED;
> +
> +	if (od->_state =3D=3D OMAP_DEVICE_STATE_ENABLED) {
> +		omap_device_idle(pdev);
> +		od->flags |=3D OMAP_DEVICE_SUSPENDED;
> +	}
> +
> +	return ret;
> +}
> +
> +static int _od_resume(struct device *dev)
> +{
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +	struct omap_device *od =3D to_omap_device(pdev);

seems like you guys have duplicated helpers for this. There's
_find_by_pdev() and to_omap_device and both do the exact same thing:

static inline struct omap_device *_find_by_pdev(struct platform_device *pde=
v)
{
	return container_of(pdev, struct omap_device, pdev);
}

#define to_omap_device(x) container_of((x), struct omap_device, pdev)

> +
> +	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
> +	    (od->_state =3D=3D OMAP_DEVICE_STATE_IDLE))
> +		omap_device_enable(pdev);
> +=09
> +	return pm_generic_resume(dev);
> +}
> +
>  static struct dev_power_domain omap_device_power_domain =3D {
>  	.ops =3D {
>  		.runtime_suspend =3D _od_runtime_suspend,
>  		.runtime_idle =3D _od_runtime_idle,
>  		.runtime_resume =3D _od_runtime_resume,
>  		USE_PLATFORM_PM_SLEEP_OPS
> +		.suspend =3D _od_suspend,
> +		.resume =3D _od_resume,
>  	}
>  };

it all depends on when are you planning to get this patch upstream. I'm
considering getting some PM working on USB host and remove the
pm_runtime calls from system suspend/resume either during -rc or next
merge window.

--=20
balbi

--MFZs98Tklfu0WsCO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOFKFEAAoJEAv8Txj19kN1eEcH/1F1czdWiMEQ8qXBDW6qbYME
g7MYjcTWPWge5uFFK6zfpPVfPunli31Yd4UK2AD38PxX/yEwBOoWVswGeLf1YjA9
6BPTenvkfs78o5uqY6V3Pqe4+QOnW7J782VTwOEnegyLMfcahfwTtY1HmnNcDhFx
QYfbk3bOketZUJahLznUXX+2ffD4/rcLjc3Pi4vcqPAV/DJmV4orgKLiIVnYSGZ+
HDIPc1XGO6oWd7ZzZk28eCK5WJyyUK85IRTxpDCOocDcUo1kX6aZ6+42R71v8yyb
WjDDAbpzR8A1d234oJktqGfAjFKZUV2dVjW+yfr4NSI++AU2Cw8t+pbNnasHtU4=
=oy9T
-----END PGP SIGNATURE-----

--MFZs98Tklfu0WsCO--
