Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890Ab2CMIg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:36:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53805 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759655Ab2CMIgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:36:50 -0400
Date: Tue, 13 Mar 2012 19:36:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120313193641.674b271a134d9dba201cd644@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_19_36_41_+1100_5IZqmzpSJLwxeikC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_19_36_41_+1100_5IZqmzpSJLwxeikC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-ux500/timer.c between commit 8eed6eac103b ("ARM: ux500:
convert to twd_local_timer_register() interface") from the arm tree and
commit b9576623c421 ("ARM: plat-nomadik: get rid of global mtu base
pointer") from the arm-soc tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-ux500/timer.c
index cadf982,fd00024..0000000
--- a/arch/arm/mach-ux500/timer.c
+++ b/arch/arm/mach-ux500/timer.c
@@@ -15,38 -15,22 +15,39 @@@
  #include <mach/setup.h>
  #include <mach/hardware.h>
 =20
 +#ifdef CONFIG_HAVE_ARM_TWD
 +static DEFINE_TWD_LOCAL_TIMER(u5500_twd_local_timer,
 +			      U5500_TWD_BASE, IRQ_LOCALTIMER);
 +static DEFINE_TWD_LOCAL_TIMER(u8500_twd_local_timer,
 +			      U8500_TWD_BASE, IRQ_LOCALTIMER);
 +
 +static void __init ux500_twd_init(void)
 +{
 +	struct twd_local_timer *twd_local_timer;
 +	int err;
 +
 +	twd_local_timer =3D cpu_is_u5500() ? &u5500_twd_local_timer :
 +					   &u8500_twd_local_timer;
 +
 +	err =3D twd_local_timer_register(twd_local_timer);
 +	if (err)
 +		pr_err("twd_local_timer_register failed %d\n", err);
 +}
 +#else
 +#define ux500_twd_init()	do { } while(0)
 +#endif
 +
  static void __init ux500_timer_init(void)
  {
+ 	void __iomem *mtu_timer_base;
  	void __iomem *prcmu_timer_base;
 +	int err;
 =20
  	if (cpu_is_u5500()) {
- 		mtu_base =3D __io_address(U5500_MTU0_BASE);
 -#ifdef CONFIG_LOCAL_TIMERS
 -		twd_base =3D __io_address(U5500_TWD_BASE);
 -#endif
+ 		mtu_timer_base =3D __io_address(U5500_MTU0_BASE);
  		prcmu_timer_base =3D __io_address(U5500_PRCMU_TIMER_3_BASE);
  	} else if (cpu_is_u8500()) {
- 		mtu_base =3D __io_address(U8500_MTU0_BASE);
 -#ifdef CONFIG_LOCAL_TIMERS
 -		twd_base =3D __io_address(U8500_TWD_BASE);
 -#endif
+ 		mtu_timer_base =3D __io_address(U8500_MTU0_BASE);
  		prcmu_timer_base =3D __io_address(U8500_PRCMU_TIMER_4_BASE);
  	} else {
  		ux500_unknown_soc();
@@@ -69,9 -53,8 +70,9 @@@
  	 *
  	 */
 =20
- 	nmdk_timer_init();
+ 	nmdk_timer_init(mtu_timer_base);
  	clksrc_dbx500_prcmu_init(prcmu_timer_base);
 +	ux500_twd_init();
  }
 =20
  static void ux500_timer_reset(void)

--Signature=_Tue__13_Mar_2012_19_36_41_+1100_5IZqmzpSJLwxeikC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXwcZAAoJEECxmPOUX5FE32IP/2s2aHDYZFxebomAbzFeJc6n
T4zUkBchjQ11xoUHKedkpQ+EAVDXisLKOrxLiLuQjvCrwz1OEGYNu9XhAmp0OlT9
w0iF6VkgK6bxKR0TOXrNluqLEnPeudCflkDQveFM6EkNPFAhIOn0gxf+oMDsHGP+
BtEh9aOEKRNK29RdnMhJiodtxTQ3vmHTMtxdsiyzMDZBbGvPedzI/aiisQ95BijA
bkvtJlvyQxph5TLGsUdnF71TfVGP+E3IxlsjxgVq4qyVUe42NWYJkcFXkYhC7LkN
fBhaYwz/szyLk73SJfy+1WPmTpoooX5ajQm279wV4QV+k5zD8Qjfhh2O9rPmXj5j
7wT2mHEMmpROopk/1I+Z2ojR8r/FIi5oiW6yB2PoOQmUF6aQib8w084c0RF0B0ox
7LAapIZWd8OO3H4igggaJtHKWr5994JSfZ2wSg2N5I/9R7xkAg8OmKBvHpgwotKJ
3NOCqtPox1GvlZ9mkQfT3BGnt+Y6KsmRkxIF9wV2WNEYUGRb4B292kBbmO5QXJIt
Lj+r5+KyxVejLb+o2m+h2YFLamdD2aEm9Fa9cY7UrNZcH43Lt8iweTAPoqpnlA1x
MPMRA2QkGj1KKc8sCiA9TZ6OmgLEQEny7ZF6TpDnRZlEHCowNue7x6vGSJ0hAaJI
uqgURUmoUEob0Q4oQDv/
=OoFQ
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_19_36_41_+1100_5IZqmzpSJLwxeikC--
