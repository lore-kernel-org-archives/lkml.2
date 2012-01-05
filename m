Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab2AEG3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 01:29:10 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:56883 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2AEG3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 01:29:09 -0500
Date: Thu, 5 Jan 2012 17:28:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Jan Beulich <JBeulich@suse.com>, Kay Sievers <kay.sievers@vrfy.org>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20120105172856.07fc66f37d76f16a88d22799@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_17_28_56_+1100_2a+Zu7F3f7VtEgvG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_17_28_56_+1100_2a+Zu7F3f7VtEgvG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (x86_64
allmodconfig) failed like this:

arch/x86/kernel/microcode_core.c: In function 'microcode_init':
arch/x86/kernel/microcode_core.c:557:2: error: implicit declaration of func=
tion 'sysdev_driver_unregister' [-Werror=3Dimplicit-function-declaration]
arch/x86/kernel/microcode_core.c:557:28: error: 'cpu_sysdev_class' undeclar=
ed (first use in this function)
arch/x86/kernel/microcode_core.c:557:47: error: 'mc_sysdev_driver' undeclar=
ed (first use in this function)

Caused by commit 8a25a2fd126c ("cpu: convert 'cpu' and 'machinecheck'
sysdev_class to a regular subsystem") interacting with commit
bd399063976c ("x86, microcode: Fix the failure path of microcode update
driver init code") which was added to Linux' tree in v3.2-rc5,

I have applied the following merge fix patch:

=46rom e4aefaed98c4462d5d5d71099756606b547e7364 Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 5 Jan 2012 17:26:14 +1100
Subject: [PATCH] cpu: fix up for sysdev removal

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kernel/microcode_core.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_c=
ore.c
index ef127e54..fb34a56 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -540,7 +540,7 @@ static int __init microcode_init(void)
=20
 	error =3D microcode_dev_init();
 	if (error)
-		goto out_sysdev_driver;
+		goto out_driver;
=20
 	register_syscore_ops(&mc_syscore_ops);
 	register_hotcpu_notifier(&mc_cpu_notifier);
@@ -550,11 +550,11 @@ static int __init microcode_init(void)
=20
 	return 0;
=20
-out_sysdev_driver:
+out_driver:
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
=20
-	sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
+	subsys_interface_unregister(&mc_cpu_interface);
=20
 	mutex_unlock(&microcode_mutex);
 	put_online_cpus();
--=20
1.7.8.197.g73c6b

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Jan_2012_17_28_56_+1100_2a+Zu7F3f7VtEgvG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBUMoAAoJEECxmPOUX5FE1AcP/0ItjsVqARo2nymieDboahCZ
6m1DuDXkKbwO3ecCvFYFPuFNFp23ZmCin7VVGzzr7VcLN46SKM1GkDXChs0cbErm
eNesIwGiY3St07rBE6iM4RxgRL3OY3lsz+TqayT5y1To38542gKwI2xakIv5Derk
CRheoCqFE6epYTdOt85IvEqqSFJ2sWyoT7oIGQx/Gq81XpSwsqaTHWnUromInTnm
CsFfCXoUITtLjJVfODGd5afKeCNUoDHjZ4ThoQ1BexL3IEcijd1FoirQSA1nmR1i
8EPp5fbo2JX2t5C7b3JUSjVfG96BbOI/cHGM/UHodDtqtQ1owMfX/EVuYaO5nbVZ
KEi70le2PI4dgR9vQX3Ga+aLou1VacxAqRlOb+85D9UmrFInGsaWIEaErPH63xhn
KYwPZOGMMBb/DE3ZPx4dK+2JbQCv+aAm3198u03Hl7JU5c6z0O/t6hptK2vq+L2X
7s4N4ElVkFxeKQkD+nQRpzQeTwVZM32JgIYxpS5+RV397wGxvX/K1NqsvuOJ9MBu
z35PELCho6Qu56MqNn4P9lQKdC8Igl/ype5R1PUkmQ8LDgUKzj/oYkt3fmjIo8gl
ilS/IfrwDEwKESR6ELY+K05PiZiIaJBd39SE0cHUu7SS3KhS2hc9VHEWu5un6tDl
wqy83oQ/f/5zbgv0bVuy
=uI9k
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_17_28_56_+1100_2a+Zu7F3f7VtEgvG--
