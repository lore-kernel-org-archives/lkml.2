Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1JXUkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:40:03 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:36741 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab1JXUkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:40:00 -0400
Date: Tue, 25 Oct 2011 07:39:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111025073946.019dca49157f5835e1394084@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_07_39_46_+1100_JDVIEHj5r8rfeeof"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_07_39_46_+1100_JDVIEHj5r8rfeeof
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/common/gic.c between commits 292b293ceef2 ("ARM: gic:
consolidate PPI handling") and 28af690a284d ("ARM: gic, local timers: use
the request_percpu_irq() interface") from the arm tree and commits
2071a2a4b8ed ("ARM: gic: add irq_domain support") and e3f14d321b34 ("ARM:
gic: add OF based initialization") from the arm-soc tree.

I hacked it up (almost certainly incorrectly - see below). Someone will
have to provide Linus with a fix for this.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/common/gic.c
index 016c1ae,65cf39d..0000000
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@@ -29,9 -29,10 +29,13 @@@
  #include <linux/cpu_pm.h>
  #include <linux/cpumask.h>
  #include <linux/io.h>
 +#include <linux/interrupt.h>
 +#include <linux/percpu.h>
 +#include <linux/slab.h>
+ #include <linux/of.h>
+ #include <linux/of_address.h>
+ #include <linux/of_irq.h>
+ #include <linux/irqdomain.h>
 =20
  #include <asm/irq.h>
  #include <asm/mach/irq.h>
@@@ -259,14 -259,14 +262,15 @@@ void __init gic_cascade_irq(unsigned in
  	irq_set_chained_handler(irq, gic_handle_cascade_irq);
  }
 =20
- static void __init gic_dist_init(struct gic_chip_data *gic,
- 	unsigned int irq_start)
+ static void __init gic_dist_init(struct gic_chip_data *gic)
  {
- 	unsigned int gic_irqs, irq_limit, i;
+ 	unsigned int i, irq;
  	u32 cpumask;
+ 	unsigned int gic_irqs =3D gic->gic_irqs;
+ 	struct irq_domain *domain =3D &gic->domain;
  	void __iomem *base =3D gic->dist_base;
  	u32 cpu =3D 0;
 +	u32 nrppis =3D 0, ppi_base =3D 0;
 =20
  #ifdef CONFIG_SMP
  	cpu =3D cpu_logical_map(smp_processor_id());
@@@ -279,34 -279,6 +283,23 @@@
  	writel_relaxed(0, base + GIC_DIST_CTRL);
 =20
  	/*
- 	 * Find out how many interrupts are supported.
- 	 * The GIC only supports up to 1020 interrupt sources.
- 	 */
- 	gic_irqs =3D readl_relaxed(base + GIC_DIST_CTR) & 0x1f;
- 	gic_irqs =3D (gic_irqs + 1) * 32;
- 	if (gic_irqs > 1020)
- 		gic_irqs =3D 1020;
-=20
- 	gic->gic_irqs =3D gic_irqs;
-=20
- 	/*
 +	 * Nobody would be insane enough to use PPIs on a secondary
 +	 * GIC, right?
 +	 */
 +	if (gic =3D=3D &gic_data[0]) {
 +		nrppis =3D (32 - irq_start) & 31;
 +
 +		/* The GIC only supports up to 16 PPIs. */
 +		if (nrppis > 16)
 +			BUG();
 +
 +		ppi_base =3D gic->irq_offset + 32 - nrppis;
 +	}
 +
 +	pr_info("Configuring GIC with %d sources (%d PPIs)\n",
 +		gic_irqs, (gic =3D=3D &gic_data[0]) ? nrppis : 0);
 +
 +	/*
  	 * Set all global interrupts to be level triggered, active low.
  	 */
  	for (i =3D 32; i < gic_irqs; i +=3D 16)
@@@ -332,29 -304,12 +325,22 @@@
  		writel_relaxed(0xffffffff, base + GIC_DIST_ENABLE_CLEAR + i * 4 / 32);
 =20
  	/*
- 	 * Limit number of interrupts registered to the platform maximum
- 	 */
- 	irq_limit =3D gic->irq_offset + gic_irqs;
- 	if (WARN_ON(irq_limit > NR_IRQS))
- 		irq_limit =3D NR_IRQS;
-=20
- 	/*
  	 * Setup the Linux IRQ subsystem.
  	 */
 +	for (i =3D 0; i < nrppis; i++) {
 +		int ppi =3D i + ppi_base;
 +
 +		irq_set_percpu_devid(ppi);
 +		irq_set_chip_and_handler(ppi, &gic_chip,
 +					 handle_percpu_devid_irq);
 +		irq_set_chip_data(ppi, gic);
 +		set_irq_flags(ppi, IRQF_VALID | IRQF_NOAUTOEN);
 +	}
 +
- 	for (i =3D irq_start + nrppis; i < irq_limit; i++) {
- 		irq_set_chip_and_handler(i, &gic_chip, handle_fasteoi_irq);
- 		irq_set_chip_data(i, gic);
- 		set_irq_flags(i, IRQF_VALID | IRQF_PROBE);
+ 	irq_domain_for_each_irq(domain, i, irq) {
+ 		irq_set_chip_and_handler(irq, &gic_chip, handle_fasteoi_irq);
+ 		irq_set_chip_data(irq, gic);
+ 		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
  	}
 =20
  	writel_relaxed(1, base + GIC_DIST_CTRL);

--Signature=_Tue__25_Oct_2011_07_39_46_+1100_JDVIEHj5r8rfeeof
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpc0SAAoJEECxmPOUX5FEHCIQAJyGGW+rZLLoC4eLs0I1NlBr
yESbb2o+fKLD3nqH+kZ6lhvBFpQBt+FF0HPCibSf5cHSBw9fUC4Ukoldo0NAuLf0
3Ri0sVQDj+46Md+uUkklrpf53HEsqe4P4/988ZREO/JmPRqxY7u35wiCgmRy3lFR
IsvrHGgahB2W9wPH4kH5RKChnZFAHaWGojlpf04OL4Yk+V+b+9A3gnEEyFWLWq8P
M/fpzmfE6bw26oAxFtPiGr15ufHhCLDRyFSjpqO3FV82Q1ibwEjhMlq8dEWa04l2
XxXoHtbrQmeOZVzZkiR9Eeh1eXz/PkX3+mi/j03TWhCp4GNtf9W8uYz2CHGVE3mV
amGtLP+sJ6fslPBmQfc4j/CtgvrLHBIscg+Z+TVrY2AUUKcBysSQFeTa+sGVfjbK
ce44ps/8cAvp8s6VmdHvDuHjvB8212la2aSmPLU7eMfBqVVyY3TjOwBHagjPisEP
PSXEycpN54n0k0IFkUPabK+m5CaZXC4Nf7mFQsQJM7dNlPEw4/QZ7B48+ktiJkWy
JbD5CYEww2cPK1iWTBgCiOtbCHgy9T3adQ1Sx0FhoWm8buI1+E34gZhQ7YEgOIqY
BIlfUnUShhogt9mY9Ixc+iH6+PXKavWM6laO77n9D99/1pwGA58ZXnnDRLAHEsLA
sA6/oGXA4L3+9rMLxz67
=v2wk
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_07_39_46_+1100_JDVIEHj5r8rfeeof--
