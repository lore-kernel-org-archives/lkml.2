Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2AFG5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 01:57:25 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:46934 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2AFG5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 01:57:23 -0500
Date: Fri, 6 Jan 2012 17:57:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: linux-next: manual merge of the driver-core tree with the arm tree
Message-Id: <20120106175717.5c39c7f62d73889e29e9b764@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_17_57_17_+1100_mXIpRfhrgZRGZOXM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_17_57_17_+1100_mXIpRfhrgZRGZOXM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
arch/arm/mach-s5pv210/common.c between commit 1f34f0e2fb86 ("ARM: 7252/1:
restart: S5PV210: use new restart hook") from the arm tree and commit
4a858cfc9af8 ("arm: convert sysdev_class to a regular subsystem") from
the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s5pv210/common.c
index 2622b8a,28e71ef..0000000
--- a/arch/arm/mach-s5pv210/common.c
+++ b/arch/arm/mach-s5pv210/common.c
@@@ -231,38 -185,20 +232,38 @@@ static struct device s5pv210_dev =3D=20
 =20
  static int __init s5pv210_core_init(void)
  {
- 	return sysdev_class_register(&s5pv210_sysclass);
+ 	return subsys_system_register(&s5pv210_subsys, NULL);
  }
 -
  core_initcall(s5pv210_core_init);
 =20
  int __init s5pv210_init(void)
  {
  	printk(KERN_INFO "S5PV210: Initializing architecture\n");
- 	return sysdev_register(&s5pv210_sysdev);
++	return device_register(&s5pv210_dev);
 +}
 =20
 -	/* set idle function */
 -	pm_idle =3D s5pv210_idle;
 +static struct s3c24xx_uart_clksrc s5pv210_serial_clocks[] =3D {
 +	[0] =3D {
 +		.name		=3D "pclk",
 +		.divisor	=3D 1,
 +		.min_baud	=3D 0,
 +		.max_baud	=3D 0,
 +	},
 +};
 =20
 -	/* set sw_reset function */
 -	s5p_reset_hook =3D s5pv210_sw_reset;
 +/* uart registration process */
 =20
 -	return device_register(&s5pv210_dev);
 +void __init s5pv210_init_uarts(struct s3c2410_uartcfg *cfg, int no)
 +{
 +	struct s3c2410_uartcfg *tcfg =3D cfg;
 +	u32 ucnt;
 +
 +	for (ucnt =3D 0; ucnt < no; ucnt++, tcfg++) {
 +		if (!tcfg->clocks) {
 +			tcfg->clocks =3D s5pv210_serial_clocks;
 +			tcfg->clocks_size =3D ARRAY_SIZE(s5pv210_serial_clocks);
 +		}
 +	}
 +
 +	s3c24xx_init_uartdevs("s5pv210-uart", s5p_uart_resources, cfg, no);
  }

--Signature=_Fri__6_Jan_2012_17_57_17_+1100_mXIpRfhrgZRGZOXM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBptNAAoJEECxmPOUX5FENpsP/0j8pWQTRoQ5MslwR7cz1s6M
c73QWIreWOZFu6TQtogTvJq6iNZqAjatk+u9AfdY/Zlie/wvsd3W1GipuLGwa/4u
VylIdVnjHcIzLOFJw42xSk0fSF+M3kYQQdDqxQHP9/aam0jwL7zhpVA44IYsS69Y
CV/s/MfaQmqSrkuFvlH5d61sdlDhK8IYg4JGNknitCRNVmHtSiGct4wGoETb1SXX
OTIBZtjQgaEWVzPnH9f6agiiY+QcdzIkGe/X9yY/rIgjV64b++LHgg8KPZhoGMTD
WfF7nyYHHKMOR/mTnjdvHALYqshmqKW134G0gZl+c+mYeLgt4oZbrj7dqS0blLNt
3dwsyIw/p/4ukYhRqLo0i2xM5t+fgUTOlSRlKDKv+C9Y11ZV0hXLebXGhHCLN/zK
jM6gtubZk+JXVt7LmZcQ6ITaOH8n44kUL0uufO/xR/mUHishJiLKoj5ArUXRmalQ
6JPQ2Im+/qZL5qJMjLwwbBgFODH87cHU7R5lp2fkYwhgc0oyvFnQnYGNnXL7mw8V
zbVWdMnIfQh3irALVs8g3P1ZPwgIejvg+Bf3PpUerM1PcEzhypmaxml9mvF2JK/M
Jc/AjhiShlb48HFGePoGqrwp7NRli5B+0QUHxglU1vrSh2wzHXc+0EJIjta+lXv/
t8CmHIWlDaGWYI4267Gi
=fCV3
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_17_57_17_+1100_mXIpRfhrgZRGZOXM--
