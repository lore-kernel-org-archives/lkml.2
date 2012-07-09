Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2GINcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:32:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52112 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab2GINcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:32:04 -0400
Date: Mon, 9 Jul 2012 15:31:54 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "Yanmin Zhang <yanmin_zhang@linux.intel.com>
	(yanmin_zhang@linux.intel.com)" <yanmin_zhang@linux.intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>
Subject: Re: [PATCH] i2c_dw: deadlock happening when system is trying to
 suspend
Message-ID: <20120709133154.GK1296@pengutronix.de>
References: <27240C0AC20F114CBF8149A2696CBE4A0EE76A@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCF9ydJxlAJsfRTu"
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A0EE76A@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCF9ydJxlAJsfRTu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 26, 2012 at 02:29:13PM +0000, Liu, Chuansheng wrote:
> From: liu chuansheng <chuansheng.liu@intel.com>
> Subject: [PATCH] i2c_dw: deadlock happening when system is trying to susp=
end
>=20
> In i2c_dw code, there is a race condition that causes pm suspend
> thread blocking there always. The scenerio is as below:
>=20
> PM thread:
> suspend -->
> pm_suspend -->
> enter_state -->
> dpm_suspend_start(will call i2c_dw_pci_suspend(),
> and the dw_i2c_dev->lock is hold)
> ...
> suspend_enter -->
> dpm_suspend_noirq -->
> suspend_device_irqs -->
> synchronize_irq()
>=20
> synchronize_irq will wait for any pending irq is handled, and
> the correpsonding irq thread is finished.
>=20
> In this case, there is a i2c device interrupt is pending, the irq
> thread do the below things:
> IRQ thread:
> i2c_smbus_read_byte_data -->
> i2c_smbus_xfer -->
> i2c_transfer -->
> i2c_dw_xfer -->
> down()
>=20
> The irq thread blocked at down dw_i2c_dev->lock, because in PM thread,
> it has been hold after calling i2c_dw_pci_suspend(), but PM thread is
> waiting for IRQ thread, then deadlock happened.
>=20
> The solution is moving the down() action after pm_runtime_get_sync().
>=20
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  drivers/i2c/busses/i2c-designware-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busse=
s/i2c-designware-core.c
> index 1e48bec..748ecb1 100644
> --- a/drivers/i2c/busses/i2c-designware-core.c
> +++ b/drivers/i2c/busses/i2c-designware-core.c
> @@ -512,8 +512,8 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg =
msgs[], int num)
> =20
>         dev_dbg(dev->dev, "%s: msgs: %d\n", __func__, num);
> =20
> -       mutex_lock(&dev->lock);
>         pm_runtime_get_sync(dev->dev);
> +       mutex_lock(&dev->lock);
> =20
>         INIT_COMPLETION(dev->cmd_complete);
>         dev->msgs =3D msgs;

Don't you need to place the mutex_unlock() before pm_runtime_put then?

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--FCF9ydJxlAJsfRTu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/63UoACgkQD27XaX1/VRt5YACfUi4fIDUIsZv9+1XWZR6g1G1/
AZoAn1uNdEfBvgVb+KAK58uaTAOFEio9
=GIAz
-----END PGP SIGNATURE-----

--FCF9ydJxlAJsfRTu--
