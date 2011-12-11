Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab1LKGIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 01:08:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab1LKGIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 01:08:39 -0500
Date: Sun, 11 Dec 2011 17:08:13 +1100
From: NeilBrown <neilb@suse.de>
To: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Commit 09d28d2c19 introduces set-after-free in
 arch/arm/mach-omap2/mcbsp.c
Message-ID: <20111211170813.02fd478a@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/62CuFcmZKT=0=I7v2d4sjQ9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/62CuFcmZKT=0=I7v2d4sjQ9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



Hi,

commit 09d28d2c19fe5c2d51b3133329584166dec89f86
Author: Jarkko Nikula <jarkko.nikula@bitmer.com>
Date:   Mon Sep 26 10:45:48 2011 +0300

    ARM: OMAP: mcbsp: Start generalize omap2_mcbsp_set_clks_src
   =20
...

contains (when displayed with "-U10"):

diff --git a/arch/arm/mach-omap2/mcbsp.c b/arch/arm/mach-omap2/mcbsp.c
index 92bd5e2..3dd4c47 100644
--- a/arch/arm/mach-omap2/mcbsp.c
+++ b/arch/arm/mach-omap2/mcbsp.c
....
@@ -181,20 +173,21 @@ static int omap_init_mcbsp(struct omap_hwmod *oh, voi=
d *unused)
        }
        pdev =3D omap_device_build_ss(name, id, oh_device, count, pdata,
                                sizeof(*pdata), omap2_mcbsp_latency,
                                ARRAY_SIZE(omap2_mcbsp_latency), false);
        kfree(pdata);
        if (IS_ERR(pdev))  {
                pr_err("%s: Can't build omap_device for %s:%s.\n", __func__,
                                        name, oh->name);
                return PTR_ERR(pdev);
        }
+       pdata->set_clk_src =3D omap2_mcbsp_set_clk_src;
        omap_mcbsp_count++;
        return 0;
 }
=20
 static int __init omap2_mcbsp_init(void)
 {
        omap_hwmod_for_each_by_class("mcbsp", omap_init_mcbsp, NULL);
=20
        mcbsp_ptr =3D kzalloc(omap_mcbsp_count * sizeof(struct omap_mcbsp *=
),
                                                                GFP_KERNEL);



which sets a field in pdata after it has been freed.

commit 7bc0c4bac72375517d904e02c46da2a23e079e8b
Author: Jarkko Nikula <jarkko.nikula@bitmer.com>
Date:   Mon Sep 26 10:45:49 2011 +0300


then adds

@@ -181,6 +184,8 @@ static int omap_init_mcbsp(struct omap_hwmod *oh, void =
*unused)
                return PTR_ERR(pdev);
        }
        pdata->set_clk_src =3D omap2_mcbsp_set_clk_src;
+       if (id =3D=3D 1)
+               pdata->mux_signal =3D omap2_mcbsp1_mux_rx_clk;
        omap_mcbsp_count++;
        return 0;
 }


which sets another field.

Should these settings just be moved up before the call to
omap_device_build_ss?? Doing that removes=20
[    0.196014] Slab corruption: size-32 start=3Dded3edc0, len=3D32
warning.

Thanks,
NeilBrown

--Sig_/62CuFcmZKT=0=I7v2d4sjQ9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTuRIzTnsnt1WYoG5AQLGMg//X/r8G2g0GZWfucAD/P3bgbPB28+7FdK5
pLkRM7ENPXwHRzGa3+fRuKRLMpeR6gshK+0wDxaYu7AqHDIKyB0+vBOGz93wIeCb
vlxbDnAzuQRO7xi9gha2u2hInvnBOsG79e24EPidO+GsAfjklFO/fBTVX5rRujmn
xEwOxn2b7Bjzya4GwDwvJsfMsnl0bLnlbkfdfNpLnfqHlOoMAuhmtQWP4GJXtkN1
gKv0Kwh7e7Tybm2eIzoN+vcrMwWw0GQpyP6BXBvf3/mFPo6noinhuuDJcnp9Bw29
Wmhk0h3TkwgKSUeCKAZdBzKSNTN4zrfijsLx10z6/6/2f3EgzdLwIbRBT/t1/0yK
YUv99KBPUbnJLiy2hMQGAbhUQHcj0SNLiTmvAU6ZA2ZOGk+vJhoIffojaAuTGUlQ
3yGMGIyxLxeSFPOoVVGNNA82V88pVscQ7dwr44MlohtN/vHodr63cL0jUpcvQbSL
ztZYYeASl5bG8iCDevUp+LloQEhOvXrbvR201RyftURs+r+bZObRJEHOFoa1MkAE
2tXz9GHX/xdJ16YrtyINRsRGTtZStfWL9s+pj8Gc19GfHVBaiO9ipogtpR70gENJ
HG8CcRPya1afRFB/P8cFanr3Q6LlFgUNu4YMM4BM27DIWldP1+W+HDMm2MMYbGJZ
FjVTTb+0leQ=
=C4a2
-----END PGP SIGNATURE-----

--Sig_/62CuFcmZKT=0=I7v2d4sjQ9--
