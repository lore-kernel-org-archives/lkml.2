Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179Ab0KVGJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 01:09:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60629 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab0KVGJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 01:09:24 -0500
Date: Mon, 22 Nov 2010 17:09:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Mark Allyn <mark.a.allyn@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: linux-next: boot failure in sep driver
Message-Id: <20101122170914.efa10679.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Nov_2010_17_09_14_+1100_qcF63Phpe.dmhHEB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Nov_2010_17_09_14_+1100_qcF63Phpe.dmhHEB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

One of my boot tests failed like this:

Unable to handle kernel paging request for data at address 0x00000340
Faulting instruction address: 0xc0000000000b4b98
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=3D1024 NUMA pSeries
last sysfs file:=20
Modules linked in:
NIP: c0000000000b4b98 LR: c00000000094dc60 CTR: 0000000000000000
REGS: c0000007b121fb00 TRAP: 0300   Not tainted  (2.6.37-rc3-autokern1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 24000082  XER: 0000000d
DAR: 0000000000000340, DSISR: 0000000042000000
TASK =3D c0000007b1208330[1] 'swapper' THREAD: c0000007b121c000 CPU: 4
GPR00: 0000000000000338 c0000007b121fd80 c000000000f1bb80 0000000000000330=
=20
GPR04: c000000001475350 c000000000871d70 c0000007aa5ffbc0 0000000000000001=
=20
GPR08: 0000000000000000 0000000000000000 0000000000006c73 c0000007aa5ffbd0=
=20
GPR12: 0000000024000082 c00000000ff60a00 0000000003680000 0000000000677c00=
=20
GPR16: 0000000003680000 0000000002180000 0000000000c894b8 0000000002ad93e0=
=20
GPR20: 0000000000000000 0000000002ad8f60 0000000002ad8eb8 0000000002180000=
=20
GPR24: 000000008b909c7e c0000007b121fe90 0000000002180000 0000000000000000=
=20
GPR28: c000000001475350 0000000000000000 c000000000ec20b0 0000000000000000=
=20
NIP [c0000000000b4b98] .__init_waitqueue_head+0x8/0x20
LR [c00000000094dc60] .sep_init+0x7c/0x3c0
Call Trace:
[c0000007b121fd80] [c00000000094dc24] .sep_init+0x40/0x3c0 (unreliable)
[c0000007b121fe20] [c000000000009894] .do_one_initcall+0x1a4/0x1e0
[c0000007b121fee0] [c0000000009104c4] .kernel_init+0x254/0x310
[c0000007b121ff90] [c0000000000312a4] .kernel_thread+0x54/0x70
Instruction dump:
eba1ffe8 ebc1fff0 ebe1fff8 7c0803a6 4e800020 7c0004ac 9bad0214 4bffff64=20
60000000 60000000 38030008 39200000 <f8030010> 91230000 f8030008 4e800020=20
---[ end trace ee7a73365e284457 ]---
Kernel panic - not syncing: Attempted to kill init!
Call Trace:
[c0000007b121f720] [c0000000000143b4] .show_stack+0x74/0x1c0 (unreliable)
[c0000007b121f7d0] [c00000000066c05c] .panic+0x9c/0x1f4
[c0000007b121f870] [c00000000008ed84] .do_exit+0x714/0x870
[c0000007b121f970] [c00000000002eb64] .die+0x164/0x2c0
[c0000007b121fa10] [c000000000041614] .bad_page_fault+0xc4/0x110
[c0000007b121fa90] [c000000000005248] handle_page_fault+0x3c/0x74
--- Exception: 300 at .__init_waitqueue_head+0x8/0x20
    LR =3D .sep_init+0x7c/0x3c0
[c0000007b121fd80] [c00000000094dc24] .sep_init+0x40/0x3c0 (unreliable)
[c0000007b121fe20] [c000000000009894] .do_one_initcall+0x1a4/0x1e0
[c0000007b121fee0] [c0000000009104c4] .kernel_init+0x254/0x310
[c0000007b121ff90] [c0000000000312a4] .kernel_thread+0x54/0x70

I don't know why the sep driver was built, but even so, the sep_init
function does this:

static struct sep_device *sep_dev;
	.
	.
static int __init sep_init(void)
{
	.
	.
	sep =3D sep_dev;

        init_waitqueue_head(&sep->event);
        init_waitqueue_head(&sep->event_request_daemon);
        spin_lock_init(&sep->snd_rply_lck);
        mutex_init(&sep->sep_mutex);
        mutex_init(&sep->ioctl_mutex);

And sep_dev is not allocated until probe time ... and it never gets
probed on my system, of course.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Nov_2010_17_09_14_+1100_qcF63Phpe.dmhHEB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM6gkKAAoJEDMEi1NhKgbsiTsH/0LaK6hGCya7aOjMRlG7eab/
YH7QPbiEI+eu4PoKLp5cifBl+oM4M1vWcLvxGOZBit1g81k18BhiH3FAvRIijhR1
1O2f+piTursJKiseOV0n5J0audsw9WYKwcTpDh0f9NVyLO8G6BPJ4fM2umQsr0/6
9cgksX67I6+SziKvptNxbP0gVhPLnnx2uti7Bqeyafi0GiDwoEOw5o0j27CcVkO2
dAvtRbuiMGz/p5i84R8TD0VTXOPSVeT2YQd4+k/uz5vDSv7M0GC/7ImksI/ZvYkU
LaI39zyqmmDWAYUiElPjKEi2FQNQovybK8k44b+tGnyYzdu66iKcJzSOnLijDnk=
=CCbq
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Nov_2010_17_09_14_+1100_qcF63Phpe.dmhHEB--
