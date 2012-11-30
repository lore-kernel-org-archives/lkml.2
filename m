Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560Ab2K3PAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:00:46 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57447 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab2K3PAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:00:45 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Vitaly Andrianov <vitalya@ti.com>, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-keystone@list.ti.com
Cc: Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>
Subject: Re: [PATCH] drivers: cma: fix addressing on PAE machines
In-Reply-To: <1354280283-28365-1-git-send-email-vitalya@ti.com>
Organization: http://mina86.com/
References: <1354280283-28365-1-git-send-email-vitalya@ti.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Fri, 30 Nov 2012 16:00:35 +0100
Message-ID: <xa1tk3t36sq4.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On Fri, Nov 30 2012, Vitaly Andrianov <vitalya@ti.com> wrote:
> This patch fixes a couple of bugs that otherwise impair CMA functionality=
 on
> PAE machines:
>
>   - alignment must be a 64-bit type when running on systems with 64-bit
>     physical addresses.  If this is not the case, the limit calculation t=
hunks
>     allocations down to an address range < 4G.
>
>   - The allocated range check is removed. On 32bit ARM kernel with LPAE
>     enabled the base may be allocated outside the fist 4GB of physical
>     memory (keystone SoC for example).
>
> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>

To be consistent, you should also change the type in:

static long size_cmdline =3D -1;
static const unsigned long size_bytes =3D CMA_SIZE_MBYTES * SZ_1M;
static unsigned long __init __maybe_unused cma_early_percent_memory(void)

and in

void __init dma_contiguous_reserve(phys_addr_t limit)

> ---
>  drivers/base/dma-contiguous.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 9a14694..7936b2e 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -234,7 +234,7 @@ int __init dma_declare_contiguous(struct device *dev,=
 unsigned long size,
>  				  phys_addr_t base, phys_addr_t limit)
>  {
>  	struct cma_reserved *r =3D &cma_reserved[cma_reserved_count];
> -	unsigned long alignment;
> +	phys_addr_t alignment;
>=20=20
>  	pr_debug("%s(size %lx, base %08lx, limit %08lx)\n", __func__,
>  		 (unsigned long)size, (unsigned long)base,
> @@ -271,10 +271,6 @@ int __init dma_declare_contiguous(struct device *dev=
, unsigned long size,
>  		if (!addr) {
>  			base =3D -ENOMEM;
>  			goto err;
> -		} else if (addr + size > ~(unsigned long)0) {
> -			memblock_free(addr, size);
> -			base =3D -EINVAL;
> -			goto err;
>  		} else {
>  			base =3D addr;
>  		}
> --=20
> 1.7.9.5
>

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQuMoTAAoJECBgQBJQdR/003wP/iqFB3QkwW/8lQIoxHrInD6n
49MCPcBfv7NnS5v+BUyj5ZR/g9VKNPIU8K2mApTaNpZNPPSEW3kcniLE1YIJd+MF
2YvWZNKG4DCzH/9SV0EreZdD3E+6TAKQ/JFSIpiE9H++eqjvjEmiKd9VPMDTn+ro
UmTQBnNBZd1XB93b7L6DzXQcaCyd0bv3t4XF6Hrq8yR+yqJwCsKD4Nmmm3nDS1fo
1VtPrkPppfgqMKpT5nRUw/kddo9o5/HnNrmMv+tkoWsHzKwWy/falS5PivF8V5UA
Thvxbp0NRecapmZzNDXqdLrhIEfynxQy2pXc4FgsfX2Jm0bLjEru5xTV9nZfTNor
DPkGZsN0wocBP9SwwfBxNFcAkNtrJqLZFrL7vkBDMTHlF3IXTVNurQZoJZ1Y9DgQ
ZMf9Qo5nt+KuiPKyg+EDYR9YdicHRtHfZ9VrpqNDOPmMVrmDMbkS7FbyI5U2rg9a
5l61Eiaqxh34AVlE2lLF8TPxld/IgOkrDZ2PEweEoiuNpKjKaTUXoopVHaidibZu
fx5Zs4gNuBWu9HLkc6CGsmt49nvlseuwXWKEG9pB3XAHW6j5XPfbmL0kvEYuc4iu
b21U2TUCMNJqbDWtAXI8ntmQIueYZN2JfAZ/h9DHIzKOddR4cqBijPXYKb8UgDnI
Tq+6rvE1AIDikyb7nTWd
=hMoW
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
