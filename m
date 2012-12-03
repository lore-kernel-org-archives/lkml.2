Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab2LCSUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 13:20:06 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:50190 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2LCSUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:20:04 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Vitaly Andrianov <vitalya@ti.com>, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-keystone@list.ti.com
Cc: Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>
Subject: Re: [PATCH v2] drivers: cma: fix addressing on PAE machines
In-Reply-To: <1354549570-21445-1-git-send-email-vitalya@ti.com>
Organization: http://mina86.com/
References: <1354549570-21445-1-git-send-email-vitalya@ti.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.2.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Mon, 03 Dec 2012 19:19:55 +0100
Message-ID: <xa1ty5hfroac.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 03 2012, Vitaly Andrianov <vitalya@ti.com> wrote:
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

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index 9a14694..097dd44 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -60,8 +60,8 @@ struct cma *dma_contiguous_default_area;
>   * Users, who want to set the size of global CMA area for their system
>   * should use cma=3D kernel parameter.
>   */
> -static const unsigned long size_bytes =3D CMA_SIZE_MBYTES * SZ_1M;
> -static long size_cmdline =3D -1;
> +static const phys_addr_t size_bytes =3D CMA_SIZE_MBYTES * SZ_1M;
> +static phys_addr_t size_cmdline =3D -1;
>=20=20
>  static int __init early_cma(char *p)
>  {
> @@ -73,7 +73,7 @@ early_param("cma", early_cma);
>=20=20
>  #ifdef CONFIG_CMA_SIZE_PERCENTAGE
>=20=20
> -static unsigned long __init __maybe_unused cma_early_percent_memory(void)
> +static phys_addr_t __init __maybe_unused cma_early_percent_memory(void)
>  {
>  	struct memblock_region *reg;
>  	unsigned long total_pages =3D 0;
> @@ -91,7 +91,7 @@ static unsigned long __init __maybe_unused cma_early_pe=
rcent_memory(void)
>=20=20
>  #else
>=20=20
> -static inline __maybe_unused unsigned long cma_early_percent_memory(void)
> +static inline __maybe_unused phys_addr_t cma_early_percent_memory(void)
>  {
>  	return 0;
>  }
> @@ -109,7 +109,7 @@ static inline __maybe_unused unsigned long cma_early_=
percent_memory(void)
>   */
>  void __init dma_contiguous_reserve(phys_addr_t limit)
>  {
> -	unsigned long selected_size =3D 0;
> +	phys_addr_t selected_size =3D 0;
>=20=20
>  	pr_debug("%s(limit %08lx)\n", __func__, (unsigned long)limit);
>=20=20
> @@ -129,7 +129,7 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
>=20=20
>  	if (selected_size) {
>  		pr_debug("%s: reserving %ld MiB for global area\n", __func__,
> -			 selected_size / SZ_1M);
> +			 (unsigned long)selected_size / SZ_1M);
>=20=20
>  		dma_declare_contiguous(NULL, selected_size, 0, limit);
>  	}
> @@ -230,11 +230,11 @@ core_initcall(cma_init_reserved_areas);
>   * called by board specific code when early allocator (memblock or bootm=
em)
>   * is still activate.
>   */
> -int __init dma_declare_contiguous(struct device *dev, unsigned long size,
> +int __init dma_declare_contiguous(struct device *dev, phys_addr_t size,
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
> diff --git a/include/linux/dma-contiguous.h b/include/linux/dma-contiguou=
s.h
> index 2f303e4..01b5c84 100644
> --- a/include/linux/dma-contiguous.h
> +++ b/include/linux/dma-contiguous.h
> @@ -68,7 +68,7 @@ struct device;
>  extern struct cma *dma_contiguous_default_area;
>=20=20
>  void dma_contiguous_reserve(phys_addr_t addr_limit);
> -int dma_declare_contiguous(struct device *dev, unsigned long size,
> +int dma_declare_contiguous(struct device *dev, phys_addr_t size,
>  			   phys_addr_t base, phys_addr_t limit);
>=20=20
>  struct page *dma_alloc_from_contiguous(struct device *dev, int count,
> @@ -83,7 +83,7 @@ bool dma_release_from_contiguous(struct device *dev, st=
ruct page *pages,
>  static inline void dma_contiguous_reserve(phys_addr_t limit) { }
>=20=20
>  static inline
> -int dma_declare_contiguous(struct device *dev, unsigned long size,
> +int dma_declare_contiguous(struct device *dev, phys_addr_t size,
>  			   phys_addr_t base, phys_addr_t limit)
>  {
>  	return -ENOSYS;

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

iQIcBAEBAgAGBQJQvO1LAAoJECBgQBJQdR/0mYUQAJI8k1pds7mF5LoHcSJbFXzJ
Ah8vM3Jo04B6ftXk+HRpvxUBGXn4WGpiBBjANLN8ZCLyD+B9xz+XE3iKk8ng4wFU
DjzRrjUHz7p+vVS0fxTKg7pEhBXl1LJk6+kwWyOGCH9fItbuZGSXubmB3dUMcftn
A8+6SBHz96BHrgKhBGKPXtMY6vY55hlVifwAhi5wylCHqck6KD42OorlHNxfrgY5
LgI2jAMPsECcK+a1cPgRNUCCYpliSVVPNhqkbvQ14shJZ18IVcvaYFijVMypPjCF
FOVihMPGqJmXtEEB5o9jbiNRSsw5L8bj8TDEQhlfHeM/aF36OGltzmQOK7L8zDg2
1i1ottK+ZPLv0MklNVsd7YJlipvUMyZDzsb/y4deAmS2MAv2v74ukHfhfYPvP9bR
L3MuG617d75LbPPYiiVEpLrzyp/p/iAM5+xBsJunIhhI7pMPJ+E3bY/3e8RLUM7U
nGud3lI3hUN8twxfRP1MESo182TTd+UdsimzrTy64cGD3FoTr7lYRguZeHatDXOI
ely8IeInrIyIuo8gDT19yrjZ7/P+mjR5sbGi9ZWVMmuzatPsOvZMPoabcnXKQfK4
q+jX8YVPMgm+27E2U7yLuWtTtl2bz6yFjTP4YgVqVIXzANKxGsPNUN/BGkqtktN2
yCw86PdpUvbpRnxUf6oB
=O3+w
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
