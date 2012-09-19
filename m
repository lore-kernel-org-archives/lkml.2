Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab2ISL6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:58:01 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:40736 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756142Ab2ISL54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:57:56 -0400
Date: Wed, 19 Sep 2012 14:53:10 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Moiz Sonasath <m-sonasath@ti.com>
Subject: Re: [PATCH 2/4] usb: dwc3: Fix gadget pullup in SS mode
Message-ID: <20120919115306.GG3772@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
 <1348054229-27362-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Enx9fNJ0XV5HaWRu"
Content-Disposition: inline
In-Reply-To: <1348054229-27362-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Enx9fNJ0XV5HaWRu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 19, 2012 at 05:00:27PM +0530, Kishon Vijay Abraham I wrote:
> From: Moiz Sonasath <m-sonasath@ti.com>
>=20
> For the gadget pullup functionality to work in
> SS mode it requires a particular sequence of
> toggling the run-stop bit. Here is the required
> sequence:
>=20
> - Set DCTL[31]
> - Clear DCTL[31]
> - Clear OMAP5430_CONTROL_CORE__PHY_POWER_USB[14]
> - Clear DCTL[8:5] =3D 0x00
> - Set DCTL[8:5] =3D 0x05
> - Wait 25 Ms
> - Set DCTL[31]
> - Set OMAP5430_CONTROL_CORE__PHY_POWER_USB[14]
>=20
> Tested rigourously the gadget pull-up functionality
> in bot HS and SS modes.
>=20
> Signed-off-by: Moiz Sonasath <m-sonasath@ti.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

this needs to split into three patches:

add new poweron field, implement it on omap-usb3, use it on
dwc3/gadget.c

btw, I don't think the changes to run_stop bit are necessary and if they
are, that'd either be a silicon errata or it would've been mentioned on
the databook. I don't remember seeing that on the databook so I'm
assuming that this is caused by a bad use of the PHY.

Why that mdelay(25) ? why 25 ms ? That's quite a long time, actually.

> ---
>  drivers/usb/dwc3/gadget.c   |   21 +++++++++++++++------
>  drivers/usb/phy/omap-usb3.c |   16 ++++++++++++++++
>  include/linux/usb/phy.h     |   10 +++++++++-
>  3 files changed, 40 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> index 58fdfad..bcc0102 100644
> --- a/drivers/usb/dwc3/gadget.c
> +++ b/drivers/usb/dwc3/gadget.c
> @@ -49,6 +49,7 @@
> =20
>  #include <linux/usb/ch9.h>
>  #include <linux/usb/gadget.h>
> +#include <linux/usb/otg.h>
> =20
>  #include "core.h"
>  #include "gadget.h"
> @@ -1417,19 +1418,27 @@ static int dwc3_gadget_run_stop(struct dwc3 *dwc,=
 int is_on)
>  	reg =3D dwc3_readl(dwc->regs, DWC3_DCTL);
>  	if (is_on) {
>  		if (dwc->revision <=3D DWC3_REVISION_187A) {
> -			reg &=3D ~DWC3_DCTL_TRGTULST_MASK;
> -			reg |=3D DWC3_DCTL_TRGTULST_RX_DET;
> +			reg &=3D ~DWC3_DCTL_ULSTCHNGREQ_MASK;
> +			dwc3_writel(dwc->regs, DWC3_DCTL, reg);
> +			reg |=3D DWC3_DCTL_ULSTCHNG_RX_DETECT;
> +			dwc3_writel(dwc->regs, DWC3_DCTL, reg);
> +			mdelay(25);
> +			reg |=3D DWC3_DCTL_RUN_STOP;
> +			dwc3_writel(dwc->regs, DWC3_DCTL, reg);
> +			usb_phy_poweron(dwc->usb3_phy);
>  		}
> =20
> -		if (dwc->revision >=3D DWC3_REVISION_194A)
> +		if (dwc->revision >=3D DWC3_REVISION_194A) {
>  			reg &=3D ~DWC3_DCTL_KEEP_CONNECT;
> -		reg |=3D DWC3_DCTL_RUN_STOP;
> +			reg |=3D DWC3_DCTL_RUN_STOP;
> +			dwc3_writel(dwc->regs, DWC3_DCTL, reg);
> +		}
>  	} else {
>  		reg &=3D ~DWC3_DCTL_RUN_STOP;
> +		dwc3_writel(dwc->regs, DWC3_DCTL, reg);
> +		usb_phy_shutdown(dwc->usb3_phy);
>  	}
> =20
> -	dwc3_writel(dwc->regs, DWC3_DCTL, reg);

I'd prefer to hold all values on the variable and write only one.

--=20
balbi

--Enx9fNJ0XV5HaWRu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQWbIiAAoJEIaOsuA1yqREADEP/jVLnZElEph4rnD1fK54nz9B
8aKEy9MmBIyN5FrqktmeWKzVU5kmMDZ3rCaDcq0hkepUlBCIZYzrj2671IZfG4UK
bCLztVZnyhY9rfH/51GGjhaMrog44A8iDUpENV8FS6iBHt00EjVAE2Vh2rtXHDy+
LJxjkCL73IPaCyfcLXjffmPrJRt+5NyfL0UrhvPSwuREnLreOJ/nIKLxERkRv7xA
SJqtDXuE73Xq78JqRwqCXU97Ax8/Zn458fFeS2l12Sz16S8L4RaE+rq4TmNvRGK4
mTZ3OoRniFewc0Z6OW0AfXcz5NVJlhs0+3XUblDVqF7m6gL1CiRPHOBBFD4MlpQT
6bD21ZxyOJn32NKkVFYmZOt/li49ZI/l0h9O9Nu3A783HPryBCRjKbS84KTwvGXk
ARcc1N/kZlsj1JfVqYTgeAkdqGDjscvxOCPOhhNhuxDv3PzK2dJNp42Mr9vbuCHl
PlMmPNRFEPL7YkjGbr74Fu0DxTuTsWmuKAVkwF+wrjpBdmwGr3K9IA3bsIJKEYrW
osVdexoI8Q0ztLC33vZk+85PvjG1u/Gui7nqO7PHaHMG2TXvqWfRwZOJOdGG2orw
/ikoueXv1hJzXvpuMTq42ez0FRHWF7MEvf3LLdKf1XshcVEI0YZjbfWHmINAkpNm
XHe8gqNZKE+kvEZzU2hY
=zgsO
-----END PGP SIGNATURE-----

--Enx9fNJ0XV5HaWRu--
