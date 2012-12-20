Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab2LTKIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 05:08:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54582 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2LTKIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 05:08:38 -0500
Date: Thu, 20 Dec 2012 12:06:25 +0200
From: Felipe Balbi <balbi@ti.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        Jason Cooper <jason@lakedaemon.net>, Shawn Guo <shawn.guo@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/9] ARM: tegra: # of CPU cores detection w/ & w/o
 HAVE_ARM_SCU
Message-ID: <20121220100625.GB24693@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1355996654-6579-1-git-send-email-hdoyu@nvidia.com>
 <1355996654-6579-4-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Content-Disposition: inline
In-Reply-To: <1355996654-6579-4-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 20, 2012 at 11:44:01AM +0200, Hiroshi Doyu wrote:
> The method to detect the number of CPU cores on Cortex-A9 MPCore and
> Cortex-A15 MPCore is different. On Cortex-A9 MPCore we can get this
> information from the Snoop Control Unit(SCU). On Cortex-A15 MPCore we
> have to read it from the system coprocessor(CP15), because the SCU on
> Cortex-A15 MPCore does not have software readable registers. This
> patch selects the correct method at runtime based on the CPU ID.
>=20
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
>  arch/arm/mach-tegra/platsmp.c |   31 ++++++++++++++++++++++++++++---
>  1 file changed, 28 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
> index 1b926df..68e76ef 100644
> --- a/arch/arm/mach-tegra/platsmp.c
> +++ b/arch/arm/mach-tegra/platsmp.c
> @@ -23,6 +23,7 @@
>  #include <asm/hardware/gic.h>
>  #include <asm/mach-types.h>
>  #include <asm/smp_scu.h>
> +#include <asm/cputype.h>
> =20
>  #include <mach/powergate.h>
> =20
> @@ -34,9 +35,13 @@
>  #include "common.h"
>  #include "iomap.h"
> =20
> +#define CPU_MASK		0xff0ffff0
> +#define CPU_CORTEX_A9		0x410fc090
> +#define CPU_CORTEX_A15		0x410fc0f0
> +
>  extern void tegra_secondary_startup(void);
> =20
> -static void __iomem *scu_base =3D IO_ADDRESS(TEGRA_ARM_PERIF_BASE);
> +static void __iomem *scu_base;
> =20
>  #define EVP_CPU_RESET_VECTOR \
>  	(IO_ADDRESS(TEGRA_EXCEPTION_VECTORS_BASE) + 0x100)
> @@ -149,7 +154,26 @@ done:
>   */
>  static void __init tegra_smp_init_cpus(void)
>  {
> -	unsigned int i, ncores =3D scu_get_core_count(scu_base);
> +	unsigned int i, cpu_id, ncores;
> +	u32 l2ctlr;
> +	phys_addr_t pa;
> +
> +	cpu_id =3D read_cpuid(CPUID_ID) & CPU_MASK;
> +	switch (cpu_id) {
> +	case CPU_CORTEX_A15:
> +		asm("mrc p15, 1, %0, c9, c0, 2\n" : "=3Dr" (l2ctlr));
> +		ncores =3D ((l2ctlr >> 24) & 3) + 1;
> +		break;
> +	case CPU_CORTEX_A9:
> +		/* Get SCU physical base */
> +		asm("mrc p15, 4, %0, c15, c0, 0" : "=3Dr" (pa));
> +		scu_base =3D IO_ADDRESS(pa);
> +		ncores =3D scu_get_core_count(scu_base);
> +		break;
> +	default:
> +		BUG();

instead of bugging out, how about setting ncores to 1 instead ?

--=20
balbi

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ0uMhAAoJEIaOsuA1yqRE/G0P/j/wRzPw1pqokYea51C+P7Jb
Cp3qsO6Bp00pvVubctCbhYYwR+yh4SBn3UT6R247qOFJBRmdFtYukGQB1V23Q9BP
ZJeuKumgpJTIDge6MX+MPaE5SqaB7BBUyOWnQhRyH7KEIbxKBDoBHftoVT3SgnHk
YVx5qhieYtE3oou6WpMpu/+hdh/lE6YHhRCpw3ZnPP3x9u+hviFbjM5AvgHsHMIC
X+dmvxm8cMsWEqrLrwqT2kSfstR01cBSGnsdeST7GpNghtfcrtC7TpOm9Je1hRGR
2+TldBJNALQBbfb1kUW/7Q0GyAo5om1+XrEOLAb6mrTZeaGzm5JOHvnuPgNKEZo9
WtBEKaAh8Ogv1BdOIG8tIEDBgIH2rTchof+8CUZQrso94SU23JZVwYAQqe6tguV4
s8oxtSFFqlaY19sN2glYVrpBSNyY0jGrKShrskkWh8qCP2e9In6L7+64NcmLFJnb
TKLXD05Ynv9ssgRlvz7g+nRN+PoFX41j/c1Wiu6lKrR62oW26VOrAz0y+eBBPw+u
d7I7T/U5m5+fs88uNziXnMAtVbBQuEho3OO0Ba6VPvqkiG6TUSlg8WN72bvHN4us
uZXe1Vij0jrFSBGncz8kglkBdTnlkwx5Q7DzBOvrQDvxXYTj7waw2Gophld9NUUi
5YwNo2yMpqDEpi6syuCj
=yaO7
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
