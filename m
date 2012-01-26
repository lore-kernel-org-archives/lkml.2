Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab2AZJDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:03:05 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:46585 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415Ab2AZJCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:02:53 -0500
Date: Thu, 26 Jan 2012 11:02:47 +0200
From: Felipe Balbi <balbi@ti.com>
To: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Pasupathy, Visuvanadan" <vichu@ti.com>,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: RFC: usb: musb: Changes proposed for adding CPPI4.1 DMA
Message-ID: <20120126090245.GF15110@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <47CEF8C4B26E8C44B22B028A650E0EA9317C5B92@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/QKKmeG/X/bPShih"
Content-Disposition: inline
In-Reply-To: <47CEF8C4B26E8C44B22B028A650E0EA9317C5B92@DBDE01.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/QKKmeG/X/bPShih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(please format your emails better next time)

On Wed, Jan 25, 2012 at 03:22:32PM +0000, Gupta, Ajay Kumar wrote:
> As a next step to dma-engine based cppi4.1 driver implementation
> this RFC has the overview of changes in the musb driver.=20
> RFC on CPPI slave driver changes will follow next.
>=20
> Overview of changes in the musb driver
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> 1)Add a dma-engine.c file in the drivers/usb/musb folder
> 2)This file will host the current musb dma APIs and translates them to
>   dmaengine APIs.
> 3)This will help to keep the changes in drivers/usb/musb/musb* files=20
>   minimal and also to retain compatibility other DMA (Mentor etc.)=20
>   drivers which are yet to be moved to drivers/dma=20
> 4)drivers/usb/musb/dma-engine.c, will wrap the dmaengine APIs to=20
>   make existing musb APIs compatible.
> 5)drivers/usb/musb/dma-engine.c file will implement the filter=20
>   functions and also implement .dma_controller_create (allocates=20
>   & provides "dma_controller" object) and .dma_controller_delete
> 6)CPPI4.1 DMA specific queue and buffer management will be internal=20
>   to slave CPPI DMA driver implementation.

looks good.

> Brief on each DMA related API used in /drivers/usb/musb*
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=20
> 1)
> MUSB DMA API currently used: dma_controller_create()         =20
> MUSB DMA API parameters currently used:=20
> 		struct musb  *musb,=20
> 		void __iomem *mregs
>=20
> Proposal: This API will be implemented in the dma-engine.c and will
> allocate and populate dma_controller object.

k

> 2)
> MUSB DMA API currently used: dma_controller_delete()=20
> MUSB DMA API parameters currently used:=20
> 		struct dma_controller *controller
>=20
> Proposal: This API will be implemented in the dma-engine.c and frees
>          the dma_controller object

k

> 3)
> MUSB DMA API currently used: dma_controller.start()
> MUSB DMA API parameters currently used:=20
> 		struct dma_controller *controller
>=20
> Proposal: This will be an empty function. The current actions intended
>           for start of HW DMA (as whole engine - not the specific channel)
>	    will be implemented in cppi41 slave driver.

why don' you make this one actually enable the hw ? Maybe call
pm_runtime_get_sync(), enable the DMA, increase a usecount on the
controller and stuff like that ?

> 4)
> MUSB DMA API currently used: dma_controller.stop()
> MUSB DMA API parameters currently used:=20
> 		struct dma_controller *controller
>=20
> Proposal: This will be an empty function. The current actions intended
>           for stop of HW DMA (as whole engine - not the specific channel)
>	    will be implemented in cppi41 slave driver.

likewise, but reversing start ?

> 5)
> MUSB DMA API currently used: dma_controller.chan_alloc()      =20
> MUSB DMA API parameters currently used:=20
> 				struct dma_controller *,=09
> 				struct musb_hw_ep *,		 =20
> 				u8 is_tx               =20
> Proposal
> * This function translates to the dma_request_channel API of dma-engine.
> * The filter function that helps to acquire the channel is also part of
>   this implementation.
> * The dma_chan structure returned by dma-engine API is going to be=20
>   different from "dma_channel" structure. As the channel structure=20
>   does not carry any important information except status and
>   associating DMA-HW channel structure, dma engine.c could still
>   translate/emulate the similar (almost same) structure to musb* files.
> * The endpoint and direction information is used in filter function.
> * A challenge here is to implement a filter function that scales up=20
>   for more number of channels (64 channels at this point)

to start, make it as simple as necessary. Implement other trickery
later.

> * Another challenge is the maintain the platform data on endpoints vs=20
>   channels (which change between SoCs)

We need to move out of platform_data. While doing that, make it match on
DT attributes.

> 6)	=09
> MUSB DMA API currently used: dma_controller.chan_program()=20
> MUSB DMA API parameters currently used:=20
> 				struct dma_channel *=20
> 				u16 maxpacket
> 				u8 mode,=20
> 				dma_addr_t dma_addr,
> 				u32 length =20
>=20
> Proposal:
> * All the parameters except the maxpacket directly applies in dma-engine =
API
> * Max packet is used for Transparent (mode0) mode of DMA where, each
>   burst of DMA programming will be of maxpacket size.
> * For all generic DMA requests - SG structure of DMA engine API will=20
>   have only one entry
> * DMA driver would require the "maxpacket" size, for deciding type of=20
>   DMA transfer. As the current API does not provide option, it can be=20
>   part of a private data to slave DMA driver through dma_chan structure.
>   Alternatively, dmaengine's "DMA_SLAVE_CONFIG" control command also
>   can be used for this purpose
> * For ISO requests, each frame buffer is treated as an entry of SG struct=
ure.
>   ISO programming will require some changes in musb_host.c as it currentl=
y=20
>   programs each frame buffer as a separate DMA request.

k

> 7)
> MUSB DMA API currently used: dma_controller.chan_release()
> MUSB DMA API parameters currently used:=20
> 		struct dma_channel	*channel
>=20
> Proposal: Releases the channel - typically happens only during the rmmod=
=20
>         of the driver

k

> 8)
> MUSB DMA API currently used: dma_controller.chan_abort()
> MUSB DMA API parameters currently used:=20
> 		struct dma_channel	*channel
>=20
> Proposal: This translates into the control commands of DMA engine. We can=
 use=20
>           "DMA_TERMINATE_ALL" control command for this purpose.

k

--=20
balbi

--/QKKmeG/X/bPShih
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPIRa1AAoJEIaOsuA1yqREv/sP/3NYLanZW878rwcMdYR7dAxP
qKzp8CyoRCkNG6s8SI0WQbsTo3qJTs0NxdZeIy5S+S/ugExxgrkUijCrq1t0zeH0
qz9wnzrXVoY9lH5kMK4dunmiiyar8XnRr1GKtpvCIsKGE5CstW+SO80NZOTelvhP
UtNWRfm9pIR6zK6GSz9OllaicVc84ln00KzW39o0p3FmuGp/EwjtXCocLZB6AlTn
UWj0ou05tX6B82zj69hflDnP1S5aAi+UEqOuSJKa8z8+lm7M+GM4aT0UDxcpsKSI
LvDQ83AuIjKmthr020ijnmR1E6nhe/a1lnMX67pA7fljvTkADg6Ppz18emo8EmhN
j6m/IDvO/gTRhsFNTw24TRnrNUI2I4lcj6ZJ4mKGHxXSBdVF3emdrZfRBrzJJwLb
NVY7mr98/q+cd4xmTIV9rP/I5sQwR67RQ1+O28Xq7hgXesd3jNFuCvjtnffynt5h
OibnZFkt4bXQy6eETbsuABulCh93/G0ZSL6tD3aozHrrPEEAlAfbRmJ8rCE6l62M
5jBV/ADJjqYP6Lya+PjnCAGtuch9rSHEeXGnf1WfGWzv9N7y7rzAnsxgq3LgQllq
FisFVt+QDY6j15lOnxQ86N4wq0ah5tKrr65axKKqDp7AK8HwcbPO+y5EnS2kQ5XA
NpIM8N9lTNZqQqqLg3MJ
=jp7J
-----END PGP SIGNATURE-----

--/QKKmeG/X/bPShih--
