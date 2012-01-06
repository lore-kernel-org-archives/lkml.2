Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030249Ab2AFBDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 20:03:38 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:58357 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964926Ab2AFBDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 20:03:35 -0500
Date: Fri, 6 Jan 2012 12:03:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120106120333.e3a0d1685099750bcba8606d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_12_03_33_+1100_2BWO8mCaufhHFNNp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_12_03_33_+1100_2BWO8mCaufhHFNNp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got conflicts in
arch/arm/mach-at91/at91cap9.c, arch/arm/mach-at91/at91sam9260.c,
arch/arm/mach-at91/at91sam9261.c, arch/arm/mach-at91/at91sam9263.c
arch/arm/mach-at91/at91sam9g45.c and arch/arm/mach-at91/at91sam9rl.c
between commits 1b2073e77894 ("ARM: restart: at91: use new restart hook")
and 8994cb50fee0 ("ARM: mach-at91: move special idle code out of line")
from the arm tree and commit f22deee523e0 ("ARM: at91: make shutdown
controler soc independent") from the arm-soc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-at91/at91cap9.c
index f1c829f,506a26c..0000000
--- a/arch/arm/mach-at91/at91cap9.c
+++ b/arch/arm/mach-at91/at91cap9.c
@@@ -13,9 -13,7 +13,8 @@@
   */
 =20
  #include <linux/module.h>
- #include <linux/pm.h>
 =20
 +#include <asm/proc-fns.h>
  #include <asm/irq.h>
  #include <asm/mach/arch.h>
  #include <asm/mach/map.h>
@@@ -340,11 -328,16 +335,17 @@@ static void __init at91cap9_map_io(void
  	at91_init_sram(0, AT91CAP9_SRAM_BASE, AT91CAP9_SRAM_SIZE);
  }
 =20
+ static void __init at91cap9_ioremap_registers(void)
+ {
+ 	at91_ioremap_shdwc(AT91CAP9_BASE_SHDWC);
+ 	at91sam926x_ioremap_pit(AT91CAP9_BASE_PIT);
+ 	at91sam9_ioremap_smc(0, AT91CAP9_BASE_SMC);
+ }
+=20
  static void __init at91cap9_initialize(void)
  {
 -	at91_arch_reset =3D at91cap9_reset;
 +	arm_pm_idle =3D at91cap9_idle;
 +	arm_pm_restart =3D at91cap9_restart;
- 	pm_power_off =3D at91cap9_poweroff;
  	at91_extern_irq =3D (1 << AT91CAP9_ID_IRQ0) | (1 << AT91CAP9_ID_IRQ1);
 =20
  	/* Register GPIO subsystem */

diff --cc arch/arm/mach-at91/at91sam9260.c
index f2237ac,3a960d2..0000000
--- a/arch/arm/mach-at91/at91sam9260.c
+++ b/arch/arm/mach-at91/at91sam9260.c
@@@ -11,9 -11,7 +11,8 @@@
   */
 =20
  #include <linux/module.h>
- #include <linux/pm.h>
 =20
 +#include <asm/proc-fns.h>
  #include <asm/irq.h>
  #include <asm/mach/arch.h>
  #include <asm/mach/map.h>
@@@ -326,17 -320,16 +321,23 @@@ static void __init at91sam9260_map_io(v
  	}
  }
 =20
 +static void at91sam9260_idle(void)
 +{
 +	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
 +	cpu_do_idle();
 +}
 +
+ static void __init at91sam9260_ioremap_registers(void)
+ {
+ 	at91_ioremap_shdwc(AT91SAM9260_BASE_SHDWC);
+ 	at91sam926x_ioremap_pit(AT91SAM9260_BASE_PIT);
+ 	at91sam9_ioremap_smc(0, AT91SAM9260_BASE_SMC);
+ }
+=20
  static void __init at91sam9260_initialize(void)
  {
 -	at91_arch_reset =3D at91sam9_alt_reset;
 +	arm_pm_idle =3D at91sam9260_idle;
 +	arm_pm_restart =3D at91sam9_alt_restart;
- 	pm_power_off =3D at91sam9260_poweroff;
  	at91_extern_irq =3D (1 << AT91SAM9260_ID_IRQ0) | (1 << AT91SAM9260_ID_IR=
Q1)
  			| (1 << AT91SAM9260_ID_IRQ2);
 =20
diff --cc arch/arm/mach-at91/at91sam9261.c
index 40ac620,a0538c5..0000000
--- a/arch/arm/mach-at91/at91sam9261.c
+++ b/arch/arm/mach-at91/at91sam9261.c
@@@ -11,9 -11,7 +11,8 @@@
   */
 =20
  #include <linux/module.h>
- #include <linux/pm.h>
 =20
 +#include <asm/proc-fns.h>
  #include <asm/irq.h>
  #include <asm/mach/arch.h>
  #include <asm/mach/map.h>
@@@ -286,17 -278,16 +279,23 @@@ static void __init at91sam9261_map_io(v
  		at91_init_sram(0, AT91SAM9261_SRAM_BASE, AT91SAM9261_SRAM_SIZE);
  }
 =20
 +static void at91sam9261_idle(void)
 +{
 +	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
 +	cpu_do_idle();
 +}
 +
+ static void __init at91sam9261_ioremap_registers(void)
+ {
+ 	at91_ioremap_shdwc(AT91SAM9261_BASE_SHDWC);
+ 	at91sam926x_ioremap_pit(AT91SAM9261_BASE_PIT);
+ 	at91sam9_ioremap_smc(0, AT91SAM9261_BASE_SMC);
+ }
+=20
  static void __init at91sam9261_initialize(void)
  {
 -	at91_arch_reset =3D at91sam9_alt_reset;
 +	arm_pm_idle =3D at91sam9261_idle;
 +	arm_pm_restart =3D at91sam9_alt_restart;
- 	pm_power_off =3D at91sam9261_poweroff;
  	at91_extern_irq =3D (1 << AT91SAM9261_ID_IRQ0) | (1 << AT91SAM9261_ID_IR=
Q1)
  			| (1 << AT91SAM9261_ID_IRQ2);
 =20
diff --cc arch/arm/mach-at91/at91sam9263.c
index 5e2485b,5ffbbb0..0000000
--- a/arch/arm/mach-at91/at91sam9263.c
+++ b/arch/arm/mach-at91/at91sam9263.c
@@@ -11,9 -11,7 +11,8 @@@
   */
 =20
  #include <linux/module.h>
- #include <linux/pm.h>
 =20
 +#include <asm/proc-fns.h>
  #include <asm/irq.h>
  #include <asm/mach/arch.h>
  #include <asm/mach/map.h>
@@@ -304,17 -298,17 +299,24 @@@ static void __init at91sam9263_map_io(v
  	at91_init_sram(1, AT91SAM9263_SRAM1_BASE, AT91SAM9263_SRAM1_SIZE);
  }
 =20
 +static void at91sam9263_idle(void)
 +{
 +	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
 +	cpu_do_idle();
 +}
 +
+ static void __init at91sam9263_ioremap_registers(void)
+ {
+ 	at91_ioremap_shdwc(AT91SAM9263_BASE_SHDWC);
+ 	at91sam926x_ioremap_pit(AT91SAM9263_BASE_PIT);
+ 	at91sam9_ioremap_smc(0, AT91SAM9263_BASE_SMC0);
+ 	at91sam9_ioremap_smc(1, AT91SAM9263_BASE_SMC1);
+ }
+=20
  static void __init at91sam9263_initialize(void)
  {
 -	at91_arch_reset =3D at91sam9_alt_reset;
 +	arm_pm_idle =3D at91sam9263_idle;
 +	arm_pm_restart =3D at91sam9_alt_restart;
- 	pm_power_off =3D at91sam9263_poweroff;
  	at91_extern_irq =3D (1 << AT91SAM9263_ID_IRQ0) | (1 << AT91SAM9263_ID_IR=
Q1);
 =20
  	/* Register GPIO subsystem */
diff --cc arch/arm/mach-at91/at91sam9g45.c
index e3a0f0c,f61eb64..0000000
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@@ -344,11 -333,16 +339,17 @@@ static void __init at91sam9g45_map_io(v
  	init_consistent_dma_size(SZ_4M);
  }
 =20
+ static void __init at91sam9g45_ioremap_registers(void)
+ {
+ 	at91_ioremap_shdwc(AT91SAM9G45_BASE_SHDWC);
+ 	at91sam926x_ioremap_pit(AT91SAM9G45_BASE_PIT);
+ 	at91sam9_ioremap_smc(0, AT91SAM9G45_BASE_SMC);
+ }
+=20
  static void __init at91sam9g45_initialize(void)
  {
 -	at91_arch_reset =3D at91sam9g45_reset;
 +	arm_pm_idle =3D at91sam9g45_idle;
 +	arm_pm_restart =3D at91sam9g45_restart;
- 	pm_power_off =3D at91sam9g45_poweroff;
  	at91_extern_irq =3D (1 << AT91SAM9G45_ID_IRQ0);
 =20
  	/* Register GPIO subsystem */
diff --cc arch/arm/mach-at91/at91sam9rl.c
index 5309b44,96247f6..0000000
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@@ -10,9 -10,7 +10,8 @@@
   */
 =20
  #include <linux/module.h>
- #include <linux/pm.h>
 =20
 +#include <asm/proc-fns.h>
  #include <asm/irq.h>
  #include <asm/mach/arch.h>
  #include <asm/mach/map.h>
@@@ -291,17 -283,16 +284,23 @@@ static void __init at91sam9rl_map_io(vo
  	at91_init_sram(0, AT91SAM9RL_SRAM_BASE, sram_size);
  }
 =20
 +static void at91sam9rl_idle(void)
 +{
 +	at91_sys_write(AT91_PMC_SCDR, AT91_PMC_PCK);
 +	cpu_do_idle();
 +}
 +
+ static void __init at91sam9rl_ioremap_registers(void)
+ {
+ 	at91_ioremap_shdwc(AT91SAM9RL_BASE_SHDWC);
+ 	at91sam926x_ioremap_pit(AT91SAM9RL_BASE_PIT);
+ 	at91sam9_ioremap_smc(0, AT91SAM9RL_BASE_SMC);
+ }
+=20
  static void __init at91sam9rl_initialize(void)
  {
 -	at91_arch_reset =3D at91sam9_alt_reset;
 +	arm_pm_idle =3D at91sam9rl_idle;
 +	arm_pm_restart =3D at91sam9_alt_restart;
- 	pm_power_off =3D at91sam9rl_poweroff;
  	at91_extern_irq =3D (1 << AT91SAM9RL_ID_IRQ0);
 =20
  	/* Register GPIO subsystem */

--Signature=_Fri__6_Jan_2012_12_03_33_+1100_2BWO8mCaufhHFNNp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBkhlAAoJEECxmPOUX5FE1iwP/RnMe82E3Ey2dnwCQcqAcHQW
rVbHp4EZ2en9kUNW8qRRK0gFhkAJohGuitid0wFSEJDOJVXLF39CtWTu5qCORLZx
cgV+m1arlrp1T28lVw/Ag9oHddMlYhed5hq4viHYD7ZZSPQpPo4UcEcugjPAP2gg
IlDt6oQDVZ50nnkMcr5/tlVj6OHl3lwe7lbnhEWTXP75nBwj56S0yg/H4JQZ+Q3+
Xk65FGgFz/N3Yrku7vHpdykTuQGxSxXd+ZQoFLount4y1efdB70twZihg+MfhyJv
agxD5DcxNO3RG46Z0BhRsGxOnyAWOYRfpdWS3n+33kypBlSfPoEt/rdJPNwwICrm
izigyGoJg9QIqV/puaTR6NfVvYwtfM2JTFdyYhoUv0GqmzRspQ/JpCekRdCPVLlm
AzlBQo3IwPqA/QyixAp6DqQyj/wnvdUyqtFiyfo8ggpBTmBtqIuCxqlZHwFXP72V
ey2GjpILDfXolvQOcok+R/smoTbuymYv7rbBZ7tcwU8yJ3a1DKqoCmclgpqgtWcy
vZMS3L52QjoU0YNxjJFjREO64KwoLDDtS58W4zRS5Y09s0wqMNgKFE0lVr7PckuR
HQ+iff05qCLsFrTQFKyVfDXEgSPJfPMonJ0eAEu6zYGJnOLD6ZCEAsvjt1yFhAB/
IByClbvUeCGTOHjtvlNx
=vU/7
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_12_03_33_+1100_2BWO8mCaufhHFNNp--
