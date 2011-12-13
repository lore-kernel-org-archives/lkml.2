Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1LMOSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:18:13 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:58855 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754295Ab1LMOSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:18:11 -0500
Date: Tue, 13 Dec 2011 16:18:04 +0200
From: Felipe Balbi <balbi@ti.com>
To: Eric =?iso-8859-1?Q?B=E9nard?= <eric@eukrea.com>
Cc: linux-arm-kernel@lists.infradead.org, Sascha Hauer <kernel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Li Yang <leoli@freescale.com>,
        Felipe Balbi <balbi@ti.com>,
        "open list:FREESCALE USB PER..." <linux-usb@vger.kernel.org>,
        "open list:FREESCALE USB PER..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/19] mxc_udc: add workaround for ENGcm09152 for
 i.MX25
Message-ID: <20111213141803.GO3133@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111213101846.GC2619@pengutronix.de>
 <1323785377-22463-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bJ3jXuwtxrXxD2iT"
Content-Disposition: inline
In-Reply-To: <1323785377-22463-1-git-send-email-eric@eukrea.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bJ3jXuwtxrXxD2iT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 13, 2011 at 03:09:37PM +0100, Eric B=E9nard wrote:
> this patch gives the possibility to workaround bug ENGcm09152
> on i.MX25 when the hardware workaround is also implemented on
> the board.
> It covers the workaround described on page 42 of the following Errata,
> titled "USB: UTMI_USBPHY VBUS input impedance implementation error" :
> http://cache.freescale.com/files/dsp/doc/errata/IMX25CE.pdf
>=20
> Signed-off-by: Eric B=E9nard <eric@eukrea.com>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Li Yang <leoli@freescale.com>

Sascha, are you taking this one or should I take it ? One comment below
though.

> ---
>  drivers/usb/gadget/fsl_mxc_udc.c |   22 +++++++++++++---------
>  1 files changed, 13 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/fsl_mxc_udc.c b/drivers/usb/gadget/fsl_mx=
c_udc.c
> index dcbc0a2..4aff05d 100644
> --- a/drivers/usb/gadget/fsl_mxc_udc.c
> +++ b/drivers/usb/gadget/fsl_mxc_udc.c
> @@ -23,7 +23,7 @@
>  static struct clk *mxc_ahb_clk;
>  static struct clk *mxc_usb_clk;
> =20
> -/* workaround ENGcm09152 for i.MX35 */
> +/* workaround ENGcm09152 for i.MX25/35 */
>  #define USBPHYCTRL_OTGBASE_OFFSET	0x608
>  #define USBPHYCTRL_EVDO			(1 << 23)
> =20
> @@ -89,16 +89,20 @@ eenahb:
>  void fsl_udc_clk_finalize(struct platform_device *pdev)
>  {
>  	struct fsl_usb2_platform_data *pdata =3D pdev->dev.platform_data;
> -	if (cpu_is_mx35()) {
> +	if (cpu_is_mx25() || cpu_is_mx35()) {
>  		unsigned int v;
> -
> -		/* workaround ENGcm09152 for i.MX35 */
> +		void __iomem *otgbase;
> +		if (cpu_is_mx25())
> +			otgbase =3D MX25_IO_ADDRESS(MX25_USB_BASE_ADDR +
> +					USBPHYCTRL_OTGBASE_OFFSET);
> +		else if (cpu_is_mx35())
> +			otgbase =3D MX35_IO_ADDRESS(MX35_USB_BASE_ADDR +
> +					USBPHYCTRL_OTGBASE_OFFSET);

I don't want to see cpu_is_* or machine_is_* or <plat/*> or <mach/*>
anywhere on drivers, please make sure to remove them for 3.4 merge
window the latest. You should also make sure that this driver has no
static globals. IOW, I would like to be able to have multiple instances
of this driver working fine.

Granted, you have no boards with such setup, but we made that mistake on
musb driver and now we have a bunch of other stuff to rework in order to
get our dual-MUSB board to work ;-)

I also see that fsl_udc_core.c is still not using dev_pm_ops, please fix
that too.

--=20
balbi

--bJ3jXuwtxrXxD2iT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO516bAAoJEIaOsuA1yqRE19oP/iu4VtYk+Wc5HUUyzpPDnEBP
IcXWhAFfqGkwfu1EIqsBzDX4hChT0hEuP7V/TNx9b2BF07SJnuFkn4KJlSRmBarn
UaxABnS7Ne862GCc2fQHZYaNJ5PcMIiUmCB89YSeqmjVOa4E9S7MV6PVC7QlLmD2
QrBmBP9ifIJXFTlbGutyZYHQeOXzc6Ln2/HIt4k149ngsI+g9vwFhkvqc/WMyhxq
G00QFH/yjK94HyXGSTWBxU5M+ORyp+UjWn+pGXL2kyih/wmgY0DGeY8ZmoJzIiZ9
OluE5h5dShvdrw6qSHA45Uef+J6uAOnX9zWsIuUfqCzgQCDbGU2/eN7QLwMRhu63
lSnfkWFRL1phSgyq5rjjk5EtrZj9lti/6jjX4wq/jo1o7TjQi+TD+ijkB5D+oR+U
WyA9WeqLCCwfji6DrRJ/sxan1W5XBw13W24AK2oMlEyLqK4yslssCIpGIPLavnhw
mRoOdvDK2n8eOTCTFBcwpHEhc3BrcCiLDzFosKSOG8fHcS8iqvlefbYQtTB522iK
JyPKipfk1L8u4yvQSGCxMyclfyox7GNYw6TgnpudY31+M6B+NX+JlJlAjQEAqSIh
6dVl9kGD/olq+xULbspHU+p2MCkZd6IqfSkcn0g3bbZzvSgCt8OkM8QGPkz8Nyxl
8kW++t4asuqSdd0WBTN5
=4Uqw
-----END PGP SIGNATURE-----

--bJ3jXuwtxrXxD2iT--
