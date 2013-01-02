Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3ABNzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 08:55:32 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62464 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3ABNza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 08:55:30 -0500
Date: Wed, 2 Jan 2013 14:55:18 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCH 1/2] pwm: vt8500: Register write busy test performed
 incorrectly
Message-ID: <20130102135518.GB4414@avionic-0098.adnet.avionic-design.de>
References: <1356899005-8876-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline
In-Reply-To: <1356899005-8876-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ELj+zdljN57BpN8IrdzCFxEtj2l8QYwp7GeeTDM9zjP
 x1tcmmZFWTTXA8/IYI9VpYfsWB1cJz0n4vTHF7f/CORn+xCDE4
 BOgGbRBHQ7Ipl3k+Q6TVKsPVla7D3qFqlI7R9saDaYoNAiKudD
 Nxu9oAldZwGPOZCz44FD1LT7PaI7IOIWGLp4g29FmyiMRXCURU
 N4J5ucGy7wUQTgd6EpjQ6NQx7DpHU4IwDy4RDqqkXIV2CecSFg
 mnBs4IdJtErK4ONl4a+WAyC+k3pcDOGYzojsI/wAUhriLF72DZ
 9Kyc9U+7T2Kz2kolvEve5zEFBgowjMcv0uVA+Pzl2CpNC8zHXE
 i6ryhmp+X+t1pEN5t4NaUehgsXcsgozjUMTaABhIpZ621nO/Zg
 nlWRCfJxyM9lupjC6+CtGECIgFhYGYPJFQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 31, 2012 at 09:23:24AM +1300, Tony Prisk wrote:
> Correct operation for register writes is to perform a busy-wait
> after writing the register. Currently the busy wait it performed
> before, meaning subsequent register writes to bitfields may occur
> before the previous field has been updated.
>=20
> Also, all registers are defined as 32-bit read/write. Change
> pwm_busy_wait() to use readl rather than readb.
>=20
> Improve readability of code with defines for registers and bitfields.
>=20
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
> Thierry,
>=20
> This patch is a fix but it can go to 3.9 rather than 3.8 (if you prefer)
> as the incorrect behaviour doesn't seem to cause a problem on current
> hardware.
>=20
>  drivers/pwm/pwm-vt8500.c |   62 +++++++++++++++++++++++++++++++++++-----=
------
>  1 file changed, 48 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
> index b0ba2d4..27ed0f4 100644
> --- a/drivers/pwm/pwm-vt8500.c
> +++ b/drivers/pwm/pwm-vt8500.c
> @@ -36,6 +36,25 @@
>   */
>  #define VT8500_NR_PWMS	2
> =20
> +#define REG_CTRL(pwm)		(pwm << 4) + 0x00
> +#define REG_SCALAR(pwm)		(pwm << 4) + 0x04
> +#define REG_PERIOD(pwm)		(pwm << 4) + 0x08
> +#define REG_DUTY(pwm)		(pwm << 4) + 0x0C

To be on the safe side, I think these should be:

	(((pwm) << 4) + offset)

> -static inline void pwm_busy_wait(void __iomem *reg, u8 bitmask)
> +static inline void pwm_busy_wait(struct vt8500_chip *vt8500, int nr, u8 =
bitmask)
>  {
>  	int loops =3D msecs_to_loops(10);
> -	while ((readb(reg) & bitmask) && --loops)
> +	u32 mask =3D bitmask << (nr << 8);
> +
> +	while ((readl(vt8500->base + REG_STATUS) & mask) && --loops)
>  		cpu_relax();
> =20
>  	if (unlikely(!loops))
>  		pr_warn("Waiting for status bits 0x%x to clear timed out\n",
> -			   bitmask);
> +			   mask);
>  }

Now that you're passing a struct vt8500_chip, couldn't you use
dev_warn() instead?

Thierry

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ5DxGAAoJEN0jrNd/PrOhSk8P/3lHzP04PLPvKMgeTbS+SDDL
9n5suR+nCPAPYL01hI9VU1SIZ6y+gYSOXJNLyPaA4wtMBzbKfCTGNYG7/hrAT10t
q2ShigGlevYPg4NHU1frzPi4SJNWeMT/SVkUWJMEAbEko3DELqpaf0BTV381PoNr
I3KKjemJY1N6a94kkDWnL7a1ssA8fwOlPJ6Ds5R1fEYDEJw0/8pG/53eIZqEpQJ9
+cc8/JOf3o0hJ3ybCqH2cLFNZNdtPpxPyc8mzoswLTNkK7IqOoBhnkCl1qv75Mc5
kqFvxjp2WzjuEgst9d8+9CCNSGgV9uuLHa9B/UbdCycJuMlHRc/B4H0J5IFomk4v
/SqiGGmP41vXoGtchoMyujzZzYQVgwrLJMfDTZL59VU+4n5RZd/K/1ASN0R2Dosg
O+rk2qLT2kiSpJWcigINH9ZDc3IDCU6UZ4oVbsXXdik2dVcpw0eIEWLKZo8pdxJC
b10N8fdqncU2bykI4MzdONJtJBKR5CWppr3Fi7J6QzQWF0WAUNhb2Lu9TjSCWpbG
8GQoCoYa6UnZlC8hyNfCwDuD6Qi2VAy5wNnwSWcOgfY65DLR9RtWHyqqhpuWhlJ8
dsRzQm6DzfW8E+UsppxNbN7a0C/MdvSlcoFeN/yZvO504QtxNiUyQ63svryCEdnc
DWq5tHCeXNIKvgknmpFq
=46Ml
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
