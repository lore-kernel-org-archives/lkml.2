Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1LTKvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:51:23 -0500
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:50055 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422Ab1LTKvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:51:15 -0500
Date: Tue, 20 Dec 2011 12:51:08 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        "open list:DESIGNWARE USB3 D..." <linux-omap@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:AMD GEODE CS5536..." <linux-geode@lists.infradead.org>
Subject: Re: [PATCH 4/9] usb: renesas: gadget: use generic map/unmap routines
Message-ID: <20111220105105.GB31842@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1324290632-23758-1-git-send-email-balbi@ti.com>
 <1324290632-23758-5-git-send-email-balbi@ti.com>
 <87d3bkrp4n.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
In-Reply-To: <87d3bkrp4n.wl%kuninori.morimoto.gx@renesas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 19, 2011 at 05:46:56PM -0800, Kuninori Morimoto wrote:
> I tried this patch, but renesas_usbhs didn't work.
> It seems have some bugs.
>=20
> 1. renesas_usbhs dma needs pkt->dma, but this patch didn't care it.
> 2. dma direction seems wrong
>    ("dir" needs 0/1, not DMA_xxx_DEVICE for usb_gadget_xx_request())
>=20
> And, renesas_usbhs can not use scatter/gather type dma
>=20
> #
> # this is not super important, but
> #
> # int usb_gadget_map_request(struct usb_gadget *gadget,
> #		struct usb_request *req, int direction)
> #
> # this "direction =3D 0/1" is a little bit un-understandable for me.
> # it is difficult to understand "which direction ?" from code.
> # if "direction =3D DMA_TO_DEVICE/DMA_FROM_DEVICE, it is understandable ;P

I see. The thing is that we want usb_gadget_map/unmap_request() to
handle that. In the long run, we might want to have a direction flag on
the public struct usb_request and remove this extra parameter, but I'm
still considering that :-)

> Can you please add below fix patch ?

thanks, will do as soon as you fix below :-)

> ------------------------------------------------
> diff --git a/drivers/usb/renesas_usbhs/mod_gadget.c b/drivers/usb/renesas=
_usbhs/mod_gadget.c
> index cb92a1d..c467067 100644
> --- a/drivers/usb/renesas_usbhs/mod_gadget.c
> +++ b/drivers/usb/renesas_usbhs/mod_gadget.c
> @@ -173,15 +173,32 @@ static int usbhsg_dma_map_ctrl(struct usbhs_pkt *pk=
t, int map)
>  	struct usbhsg_uep *uep =3D usbhsg_pipe_to_uep(pipe);
>  	struct usbhsg_gpriv *gpriv =3D usbhsg_uep_to_gpriv(uep);
>  	enum dma_data_direction dir;
> +	int ret;
> =20
> -	dir =3D usbhs_pipe_is_dir_in(pipe) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +	dir =3D !usbhs_pipe_is_dir_in(pipe);
> =20
>  	if (map) {
> -		return usb_gadget_map_request(&gpriv->gadget, req, dir);
> +		if (req->num_sgs) /* it can not use scatter/gather */
> +			return -EIO;

it would be better to through a big fat WARN() in this case. Gadget
drivers are supposed to check whether you support SGs (by looking into
gadget->sg_suported) before giving you a request with SGs.

> +		if (pkt->dma !=3D DMA_ADDR_INVALID)
> +			return -EIO;

no no, we want to remove the whole DMA_ADDR_INVALID thing. What we're
doing now is that UDC is required to map the request buffer. So gadget
drivers must not do it. We shouldn't have this DMA_ADDR_INVALID macro
anymore :-)

--=20
balbi

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO8GiZAAoJEIaOsuA1yqREf1cP/iDKK6Cqqjfn+J5391b9D2E4
06ZDFQxMgDHQDS6c+fVO/7/DFgG5udBZSuQzDmivn1ERioYMubXXTwCn1DUbQ/2l
4mgz8DUGkPMPiHga6acsQv3lEz3UK8Mj3bPXWxDDa4WYQwGJHchv6f97zChOhjtH
5l4cvftQK89ut1objiFRIwyjRXpIl1VOZG0tLoPcHtzdwFc7ywcyc35qeCR3mljp
rqTXddfEKMp4feMMW0+HGXXIDySUQz64dMWIr/iLxQIik+khScDWgvOEZ3LBTex/
1Pn5oKmpBLPbqblLJUSTUU4HHO+XzV+U4nUgAx+Ka8nZ4b6J5Y/wtxwwvqGjIrTp
OPBnNr2nkbUVfvxZnLm9/umdxC3Bu6FDVOxqE8O5otpyO/rJIIpIvbQ8pl19Lktk
hLAckwpKE5GWv/wDHdQyaVO4j+Jg48j3npS/lwAGUv7CZltid9+lzBob4GgDruda
TLwOYaLBOfRZ3WtvcKYIIhf+e+dfKOVdCnJM3Vg9Hom6w3Ke2JIyhpF3lLg8/FSm
UYVRjN6c4Brw++cOzaK0HgtzWhc+8PDIUi0f7FtBJW5FIL/njn97VmQs6kFZXeHI
VKEspkHMFsBYyEbMEdV7IIxlBqGPPVgCGZqm9xN0Xbvwor1lFZyzLoHqfeiyYsRd
AuznmBNAkr6nZnjauemd
=sEAS
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
