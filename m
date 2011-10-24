Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1JXUxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:53:12 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:34203 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab1JXUxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:53:10 -0400
Date: Tue, 25 Oct 2011 07:52:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Changhwan Youn <chaos.youn@samsung.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111025075253.ec6a5b720ccd5e14426ae780@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_07_52_53_+1100_S6KEoST7Ve5uEn+t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_07_52_53_+1100_S6KEoST7Ve5uEn+t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-exynos4/mct.c between commit 28af690a284d ("ARM: gic, local
timers: use the request_percpu_irq() interface") from the arm tree and
commit 3a0622811292 ("ARM: EXYNOS4: Add support MCT PPI for EXYNOS4212")
from the arm-soc tree.

I hacked it up (probably incorrectly - see below and dropping the
local_timer_ack() change from the latter, since the former removed that
function).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos4/mct.c
index 582b874,eb182f2..0000000
--- a/arch/arm/mach-exynos4/mct.c
+++ b/arch/arm/mach-exynos4/mct.c
@@@ -384,15 -400,17 +400,19 @@@ static void exynos4_mct_tick_init(struc
 =20
  	exynos4_mct_write(0x1, mct_tick[cpu].base + MCT_L_TCNTB_OFFSET);
 =20
- 	if (cpu =3D=3D 0) {
- 		mct_tick0_event_irq.dev_id =3D &mct_tick[cpu];
- 		evt->irq =3D IRQ_MCT_L0;
- 		setup_irq(IRQ_MCT_L0, &mct_tick0_event_irq);
+ 	if (mct_int_type =3D=3D MCT_INT_SPI) {
+ 		if (cpu =3D=3D 0) {
+ 			mct_tick0_event_irq.dev_id =3D &mct_tick[cpu];
++			evt->irq =3D IRQ_MCT_L0;
+ 			setup_irq(IRQ_MCT_L0, &mct_tick0_event_irq);
+ 		} else {
+ 			mct_tick1_event_irq.dev_id =3D &mct_tick[cpu];
++			evt->irq =3D IRQ_MCT_L1;
+ 			setup_irq(IRQ_MCT_L1, &mct_tick1_event_irq);
+ 			irq_set_affinity(IRQ_MCT_L1, cpumask_of(1));
+ 		}
  	} else {
- 		mct_tick1_event_irq.dev_id =3D &mct_tick[cpu];
- 		evt->irq =3D IRQ_MCT_L1;
- 		setup_irq(IRQ_MCT_L1, &mct_tick1_event_irq);
- 		irq_set_affinity(IRQ_MCT_L1, cpumask_of(1));
+ 		gic_enable_ppi(IRQ_MCT_LOCALTIMER);
  	}
  }
 =20

--Signature=_Tue__25_Oct_2011_07_52_53_+1100_S6KEoST7Ve5uEn+t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpdAlAAoJEECxmPOUX5FEVooQAKFGr/680xzT2QugZFyqLiLm
Q/Dl2v73VEK7dFpqfdcSwrtcu5V8BpY5M6l8fMht/8ZCMJrMRT8YAnrFDjHEkcCr
Zb2m4WaDHpa/K9UDk/J0UxTdyn1latjWJt22JOOvP3lMRQJFnqfgTewlTK7O4ouW
lF9hhsPrneBx5mkPcKZU520BxbNoUqe1eoqpcWgYjqcdYQMBhyNZ+fViHbHOvd4U
AdI2+em/H2cvawWp4XMlpwZRB3mJcQ8upy9GKuquyK0UpqtKQsgP6ObngwA0wUAl
/k3I6eTexMS2oos5FkWmNZ52rEVKjAlmDQ0fKpZudN5l/OBvMIw4xIf/fegyoqsS
kzMqRdzwlj+XgUP/e9LtMb8qX8krzb94eDoTkjraIb2KcmLEr0k3jISTEhEEXhjL
pbmddtq4beQfH4kavOqDL+Wl3EKuu1R66T9GRIsBw+RWpc6Jd7bQ3EVhrJdQtwh5
1Nen+jE4VFOBmxZMoTQcrmNfmyyJ/fvwAcgyXDeK1JLOQgmxgsjWjvByWVet7Sz4
p5wHA2uZ2bcAebjkuQcEVZVNpJeTqjMNBqDKXobQioSxUWaKcwatmJlHroX/VRpE
Eor7RBq8UCzcj+PiP0wYEJElgjtbCVGQTUc+r9EEkZB9jPunqoOYlXDi8rMgBO0e
j3iTW84uxCdSP6mM2UDM
=3KIs
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_07_52_53_+1100_S6KEoST7Ve5uEn+t--
