Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1I0Mt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:49:29 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:35795 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461Ab1I0Mt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:49:27 -0400
Date: Tue, 27 Sep 2011 15:49:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH] x86/dma: make a zero length mapping length not dma
 capable
Message-ID: <20110927124921.GA19603@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1316540665-15622-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <1316540665-15622-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Tue, Sep 20, 2011 at 07:44:25PM +0200, Sebastian Andrzej Siewior wrote:
> The following ooops happens during a call to dma_map_single():
>=20
> | ------------[ cut here ]------------
> | kernel BUG at lib/swiotlb.c:409!
> | invalid opcode: 0000 [#1] SMP
> | CPU 1
> |
> | RIP: 0010:[<ffffffff811a00c9>]  [<ffffffff811a00c9>] swiotlb_tbl_map_si=
ngle+0x87/0x1e0
> | Call Trace:
> |  [<ffffffff813170e0>] ? printk+0x43/0x48
> |  [<ffffffff8100d027>] ? load_TLS+0x7/0xa
> |  [<ffffffff811a0261>] ? map_single+0x3f/0x3f
> |  [<ffffffff811a02be>] ? swiotlb_map_page+0x5d/0xcd
> |  [<ffffffff811a0261>] ? map_single+0x3f/0x3f
> |  [<ffffffffa02946ca>] ? dwc3_map_buffer_to_dma+0x8a/0xe2 [dwc3]
>=20
> As you know from the line 409 the size parameter was 0. This happens
> because the upper layer sends a zero length packet which the dwc3 driver
> tried to map.
> The memory is not really used and the hardware should not really issue a
> dma request however we must setup a dma descriptor which contains an
> address field and a size field which is set to 0 for the zero length
> packet to be sent. So the unconditional mapping was kinda convenient to
> do. ARM does not complain about length =3D=3D 0, the swiotlb which is
> used on x86 makes trouble. Looking at other udc drivers, they either
> ignore this case or workaround it by incrementing the size by 1 which
> looks nasty.
> For now I fixed this by not mapping zero packets at all. Anything what I
> should expect from the DMA API? I.e. should it be okay to call
> dma_map_single() with size =3D 0?
> This patch is untested due to -ENODEV. Changing each implementation of
> dma_map_single() will result in large patch and it is also question if
> this is worth the effort.
>=20
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

This helps my dwc3 driver:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/x86/include/asm/dma-mapping.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dm=
a-mapping.h
> index d4c419f..e73d921 100644
> --- a/arch/x86/include/asm/dma-mapping.h
> +++ b/arch/x86/include/asm/dma-mapping.h
> @@ -65,6 +65,8 @@ static inline bool dma_capable(struct device *dev, dma_=
addr_t addr, size_t size)
>  {
>  	if (!dev->dma_mask)
>  		return 0;
> +	if (!size)
> +		return 0;
> =20
>  	return addr + size - 1 <=3D *dev->dma_mask;
>  }
> --=20
> 1.7.6.3
>=20

--=20
balbi

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOgcZRAAoJEAv8Txj19kN1A8oH/2QU4N2f8tHPfpHU3qan1C5B
fJTP6oezYJH5cm8snXW4fs9qqBrvPx/HxEzF5wRlPogC1Huv1WxxPewDdHUyFf0T
yvLbOiAFuFAM4w35nH0mUT+SZ0e0GJFBrucZgCgCMyizsv+++HbWvs6vJolftgCI
xGVIsGdynijpcUaKTqI5Y4NcfAf23bE+2EG1Jr2j1HvA2VP4SVsb9XrLJCoCpVtO
n+/xrM4de2Kxp69xyUv+esSgm7Yb5mVNNmT8tPYSOaoFaSa9f5LLLAHiwcV+m17C
D4j4YynWh9aXW2eSssU08IkWIahqTVgvkcu1GVQm7IitR0TnTNSGUv901oRWzD8=
=HdMW
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
