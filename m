Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2H1HnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 03:43:21 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:42382 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503Ab2H1HnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 03:43:19 -0400
Date: Tue, 28 Aug 2012 10:39:01 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 1/2] dw_dmac: make driver endianness configurable
Message-ID: <20120828073858.GK27166@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <503A8CAE.6050606@yahoo.es>
 <20120827070323.GC28721@samfundet.no>
 <503B342C.9060300@yahoo.es>
 <20120827111431.GA27868@samfundet.no>
 <503B8B26.3050205@yahoo.es>
 <CAKohpo=ALUNOnQdQjNd1Y2jtocxjixKCiBrRZp8qGErqg1LSKw@mail.gmail.com>
 <503C6B67.2010903@yahoo.es>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="00hq2S6J2Jlg6EbK"
Content-Disposition: inline
In-Reply-To: <503C6B67.2010903@yahoo.es>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--00hq2S6J2Jlg6EbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 28, 2012 at 02:55:35PM +0800, Hein Tibosch wrote:
> On 8/28/2012 11:23 AM, Viresh Kumar wrote:
> > On 27 August 2012 20:28, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> >>>> +config DW_DMAC_MEM_64_BIT
> >>>> +    bool "Allow 64-bit memory transfers"
> >>>> +    default y if !AVR32
> >>>> +    depends on DW_DMAC
> >>>> +    help
> >>>> +      Say yes if the DMA controller may do 64-bit memory transfers
> >>>> +      For AVR32, say no because only up to 32-bit transfers are
> >>>> +      defined
> >>> Is this sane to add? Could some non-AVR32 platforms use 64-bit and 32=
-bit
> >>> depending on runtime configuration? E.g. if you build a kernel with s=
upport
> >>> for multiple boards/processors, and there is a mix of 32-bit and 64-b=
it wide
> >>> DMA support.
> >>>
> >>> I think it is better to select 32/64-bit at runtime.
> >> I did that in the first patch, adding a new property to the dw_dma_sla=
ve
> >> structure. It had the small disadvantage that some arch code had to be
> >> adapted (at32ap700x.c).
> >>
> >> Viresh, what do you think? Add a property called "mem_64_bit_access" o=
r so?
> >>
> >> Or should it be passed as a member of 'dw_dma_platform_data', because =
it
> >> is a property of the (entire) DMA controller?
> > I think second option is better. But can there be some supportive scena=
rios of
> > first option?
> >
> > We have a system, with two different memory controllers, one supporting=
 32 bit
> > and other 64 bit?
> >
> > Or what we can do now is: go with option 2, i.e. update dw_dma_platform=
_data
> > and if some platform like what i mentioned above comes, then we can mov=
e it
> > to slave data.
> What about this:
>=20
> In case of AVR32, the arch code will indicate:
>=20
> static struct dw_dma_platform_data dw_dmac0_data =3D {
> 	.nr_channels    =3D 3,
> 	/* DMAC supports up to 32-bit memory access */
> 	.mem_access_32_bit_only =3D true,
> };
>=20
> ARM users won't have to change anything because mem_access_32_bit_only
> will be false and therefor 'dw->mem_64_bit' will become true
>=20
> Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
>=20
> ---
>  drivers/dma/dw_dmac.c      |   11 ++++++++---
>  drivers/dma/dw_dmac_regs.h |    2 ++
>  include/linux/dw_dmac.h    |    2 ++
>  3 files changed, 12 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 7212961..a37053c 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -618,6 +618,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t=
 dest, dma_addr_t src,
>  		size_t len, unsigned long flags)
>  {
>  	struct dw_dma_chan	*dwc =3D to_dw_dma_chan(chan);
> +	struct dw_dma		*dw =3D to_dw_dma(dwc->chan.device);
>  	struct dw_desc		*desc;
>  	struct dw_desc		*first;
>  	struct dw_desc		*prev;
> @@ -639,7 +640,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t=
 dest, dma_addr_t src,
>  	 * We can be a lot more clever here, but this should take care
>  	 * of the most common optimization.
>  	 */
> -	if (!((src | dest  | len) & 7))
> +	if (dw->mem_64_bit && !((src | dest  | len) & 7))
>  		src_width =3D dst_width =3D 3;
>  	else if (!((src | dest  | len) & 3))
>  		src_width =3D dst_width =3D 2;
> @@ -710,6 +711,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatt=
erlist *sgl,
>  	struct dw_dma_chan	*dwc =3D to_dw_dma_chan(chan);
>  	struct dw_dma_slave	*dws =3D chan->private;
>  	struct dma_slave_config	*sconfig =3D &dwc->dma_sconfig;
> +	struct dw_dma		*dw =3D to_dw_dma(dwc->chan.device);
>  	struct dw_desc		*prev;
>  	struct dw_desc		*first;
>  	u32			ctllo;
> @@ -746,7 +748,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatt=
erlist *sgl,
>  			mem =3D sg_dma_address(sg);
>  			len =3D sg_dma_len(sg);
> =20
> -			if (!((mem | len) & 7))
> +			if (dw->mem_64_bit && !((mem | len) & 7))
>  				mem_width =3D 3;
>  			else if (!((mem | len) & 3))
>  				mem_width =3D 2;
> @@ -813,7 +815,7 @@ slave_sg_todev_fill_desc:
>  			mem =3D sg_dma_address(sg);
>  			len =3D sg_dma_len(sg);
> =20
> -			if (!((mem | len) & 7))
> +			if (dw->mem_64_bit && !((mem | len) & 7))
>  				mem_width =3D 3;
>  			else if (!((mem | len) & 3))
>  				mem_width =3D 2;
> @@ -1419,6 +1421,9 @@ static int __init dw_probe(struct platform_device *=
pdev)
>  		goto err_kfree;
>  	}
> =20
> +	/* Remember if 64-bit access to memory is allowed */
> +	dw->mem_64_bit =3D !pdata->mem_access_32_bit_only;
> +
>  	dw->regs =3D ioremap(io->start, DW_REGLEN);
>  	if (!dw->regs) {
>  		err =3D -ENOMEM;
> diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
> index 9758651..e24562e 100644
> --- a/drivers/dma/dw_dmac_regs.h
> +++ b/drivers/dma/dw_dmac_regs.h
> @@ -199,6 +199,8 @@ struct dw_dma {
>  	struct clk		*clk;
> =20
>  	u8			all_chan_mask;
> +	/* 64-bit access to memory is allowed */
> +	bool			mem_64_bit;
> =20
>  	struct dw_dma_chan	chan[0];
>  };
> diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
> index 2412e02..d01d63f 100644
> --- a/include/linux/dw_dmac.h
> +++ b/include/linux/dw_dmac.h
> @@ -29,6 +29,8 @@ struct dw_dma_platform_data {
>  #define CHAN_PRIORITY_ASCENDING		0	/* chan0 highest */
>  #define CHAN_PRIORITY_DESCENDING	1	/* chan7 highest */
>  	unsigned char	chan_priority;
> +	/* Make true if 64-bit access to memory is not implemented */
> +	bool		mem_access_32_bit_only;
>  };

Can you not read this from any internal register ? Synopsys generally
adds a set of read only registers which we can use to guess which
features where enabled in the IP when configuring it with their IP
configuration tool.

--=20
balbi

--00hq2S6J2Jlg6EbK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQPHWSAAoJEIaOsuA1yqREkmgP/0BHdOH6e2HKQebqRe08ivrD
9EtoalkI6dKqVZTV18abuiM6qCyiyWFEsSlOIVxJI1BHYAjHPSEpa+ITTpK4pXjk
6+TFdfSapwgNNttiQUaAMSD5W/ZyDZZd7kcfxRdc8FgJJLHfZmOwPWSUHtNzN1rB
Gi6w/F5ccsFYrLZCEtDasRAAEDTkYyndN5VG11D1Ck12uII9vr2O+44FdXnRV9j2
srEPUIE+EpBPxq29cEU40tXnei47QwZpsupasyJ/Poo4qu+IgEeO0Hki/WGQGlet
aeMENS1colkx4U55A2NPgCakcbxOmndesh3OhgThpnwvmndl95oC7Gm8vNz2toOc
PiJlvRtgVukxA6gfqQtJ80ihq3mA1JGiTId8Zvg9dA7Stzzu6A+8tFHmnulcWVHv
Uq+9cYMjbiNdBqDXh1yJyUJpGYaaZMe9fIFMzjYx1vwhdo8OFo9Bu02sPBCklnWJ
cWTygHqy6+7GvvuNqGbgI5apXoL5duOS3LvxVio2qAG6MnZLQOj6nTwtjDRIYXjH
U0P2vnsOPvB9WaOOXGx6TEZbFaYT/saEWiBlFX2XCQEqtLwDgV2/MBsK9RjgkPkt
zwN9EJ62a/qqjwTReT849IK3GCkhnMZysKCxxpSkktV69qLGmM+wUIQY4w4045Jy
TRPzvUZHPLmVd8ffn1C2
=aprH
-----END PGP SIGNATURE-----

--00hq2S6J2Jlg6EbK--
