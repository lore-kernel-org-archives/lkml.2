Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab2BEOyL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 09:54:11 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:56727 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182Ab2BEOyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 09:54:07 -0500
Date: Sun, 5 Feb 2012 16:54:00 +0200
From: Felipe Balbi <balbi@ti.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH/RFC] usb: fix renesas_usbhs to not schedule in atomic
 context
Message-ID: <20120205145358.GA13762@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
 <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de>
 <4F22624E.2090201@renesas.com>
 <Pine.LNX.4.64.1201270946150.32661@axis700.grange>
 <4F27CA7D.601@renesas.com>
 <Pine.LNX.4.64.1202022317560.13860@axis700.grange>
 <4F2B9F34.60308@renesas.com>
 <Pine.LNX.4.64.1202031623000.6211@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1202031623000.6211@axis700.grange>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 03, 2012 at 04:43:20PM +0100, Guennadi Liakhovetski wrote:
> The current renesas_usbhs driver triggers
>=20
> BUG: scheduling while atomic: ksoftirqd/0/3/0x00000102
>=20
> with enabled CONFIG_DEBUG_ATOMIC_SLEEP, by submitting DMA transfers from=
=20
> an atomic (tasklet) context, which is not supported by the shdma dmaengin=
e=20
> driver. Fix it by switching to a work. Also simplify some list=20
> manipulations.

you are doing much more than what you say. Also, instead of using a
workqueue, have you considered using threaded_irqs ?

(I didn't go over the driver again to see if it makes sense to use
threaded_irqs in this case, but doesn't hurt asking)

> Shimoda-san, this is the problem, that you were observing. However, it=20
> exists with the present version of shdma just as well as with the new one=
=20
> - on top of the simple DMA library. I marked it an RFC because (1) I only=
=20
> lightly tested it with the gadget device on mackerel with the mass storag=
e=20
> gadget, and (2) I am somewhat concerned about races. Currently the work=
=20
> function runs with no locking and there are no usual cancel_work_sync()=
=20
> points in the patch. However, it has also been like this before with the=
=20
> tasklet implementation, which is not much better, and it looks like there=
=20
> are no asynchronous operations on the same packets like timeouts. Only=20
> asynchronous events, that I can think about are things like unloading the=
=20
> driver or unplugging the cable, but these have been there before too. It=
=20
> would become worse on SMP, I think. Comments welcome.
>=20
> diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs=
/fifo.c
> index 72339bd..4d739ec 100644
> --- a/drivers/usb/renesas_usbhs/fifo.c
> +++ b/drivers/usb/renesas_usbhs/fifo.c
> @@ -75,8 +75,7 @@ void usbhs_pkt_push(struct usbhs_pipe *pipe, struct usb=
hs_pkt *pkt,
>  		pipe->handler =3D &usbhsf_null_handler;
>  	}
> =20
> -	list_del_init(&pkt->node);
> -	list_add_tail(&pkt->node, &pipe->list);
> +	list_move_tail(&pkt->node, &pipe->list);
> =20
>  	/*
>  	 * each pkt must hold own handler.
> @@ -106,7 +105,7 @@ static struct usbhs_pkt *__usbhsf_pkt_get(struct usbh=
s_pipe *pipe)
>  	if (list_empty(&pipe->list))
>  		return NULL;
> =20
> -	return list_entry(pipe->list.next, struct usbhs_pkt, node);
> +	return list_first_entry(&pipe->list, struct usbhs_pkt, node);

these two hunks are not part of $SUBJECT

--=20
balbi

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPLpgGAAoJEIaOsuA1yqREgUsQAKftHUUHLtmaN3Da2aZaMfKh
q38adVUYSnu0K0Ubr8MfGtBpJW+Z9lnDPiIES+YLPpZY7AMvdXEgTwj0R3wsMCul
Z5IcpiVyoMnQGVoRGMCH99w4gxRNj9iLiFJFtts5v6jqplrnWzMxHVyEocOc3blW
t3hZrj2ABEkgyKQ80nDiZJ2sXJ7b5F4wvotuC4Ip0W77rVUffBrN6IdDr38ZcR20
IO2lj8uLhKIuf5B05Z5wAM2lGLw+HXcJpMJNUSud4NIAhuUdqAQkEU+CUpHzZ4DZ
FoN8DfWMcoyUu/iqeOZ8OojZzVa3GgwoyG+sxnF+GvUfyDvCoqLhdLoIm0kzeuO8
kHRYxtNdFRDindDrTLyjfhaW1epT7HwY4LNmfOFfQb0GjaE00jPQ9Qva3XOzm/Wy
+ILnmgmpPFczBKfItGD9ySqt8lvICl6rWCDtze3DEw9NYI4Apl+nz0oWq6u6Ro0O
nWKvIKJTIhjtx07VF/XKGXQfxt84r8VRfz/dVZz+OmmHJV347RTKZ1XI+bTHATVO
jMBMJ+Dbu4PcPAncff4ntalKfMjpUiBm3JUsbgBtWxAowDQ42KalXhYI7ef1Kod8
khissC3+sq4xE5Hd0o6muy8IVm80DBongcP4Yl6wXo+WJNll19SGu+0aaEjY8quk
yMQD9C88flraWq+1vB6p
=f+lE
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
