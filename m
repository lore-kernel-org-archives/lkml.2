Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab2JYMZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:25:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:10302 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab2JYMZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:25:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,646,1344236400"; 
   d="asc'?scan'208";a="238260865"
Date: Thu, 25 Oct 2012 15:16:46 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, Asias He <asias.hejun@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [BUG] lkvm crash on crashkernel boot
Message-ID: <20121025121645.GA28475@otc-wbsnb-06>
References: <20121024152740.GA25303@otc-wbsnb-06>
 <CAOJsxLFD36jYiyE5sfN+uPT5G9G9ttf=K2UB=abEjBiTFNeehA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <CAOJsxLFD36jYiyE5sfN+uPT5G9G9ttf=K2UB=abEjBiTFNeehA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 25, 2012 at 10:17:27AM +0300, Pekka Enberg wrote:
> On Wed, Oct 24, 2012 at 6:27 PM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > Hi,
> >
> > I've tried to play with kexec using lkvm. Unfortunately, lkvm crashes w=
hen
> > I try to switch to crashkernel.
> >
> > I use Linus tree + penberg/kvmtool/next + one x86 mm patch[1].
> >
> > Kernel is defconfig + kvmconfig. I use the same kernel image for system=
 and
> > crash env.
> >
> > Host:
> >
> > % lkvm run --cpus 1 -m 1024 --params 'crashkernel=3D256M loglevel=3D8'
> >
> > Guest:
> >
> > # kexec -p bzImage --reuse-cmdline
> > # echo c > /proc/sysrq-trigger
> > ...
> > [    0.947984] loop: module loaded
> > [    0.950078] virtio-pci 0000:00:01.0: irq 40 for MSI/MSI-X
> > [    0.950925] virtio-pci 0000:00:01.0: irq 41 for MSI/MSI-X
> > [    0.952944] virtio-pci 0000:00:01.0: irq 42 for MSI/MSI-X
> > zsh: segmentation fault (core dumped)  lkvm run --cpus 1 -m 1024 --para=
ms 'crashkernel=3D256M loglevel=3D8'
>=20
> This seems to work OK on my machine.
>=20
> > Guest kernel is somewhere in virtio_net initialization (for the second
> > time). I'm too lazy to find exact line.
> >
> > Backtrace:
> >
> > 0  irq__add_msix_route (kvm=3Dkvm@entry=3D0xbf8010, msg=3D0xe3d090) at =
x86/irq.c:210
> > #1  0x000000000041b3bf in virtio_pci__specific_io_out.isra.5 (offset=3D=
<optimized out>,
> >     data=3D<optimized out>, kvm=3D0xbf8010) at virtio/pci.c:150
> > #2  virtio_pci__io_out.9406 (ioport=3D<optimized out>, kvm=3D0xbf8010, =
port=3D<optimized out>,
> >     data=3D<optimized out>, size=3D<optimized out>) at virtio/pci.c:208
> > #3  0x000000000040f8c3 in kvm__emulate_io (count=3D<optimized out>, siz=
e=3D2, direction=3D1,
> >     data=3D<optimized out>, port=3D25108, kvm=3D0xbf8010) at ioport.c:1=
65
> > #4  kvm_cpu__start (cpu=3D<optimized out>) at x86/include/kvm/kvm-cpu-a=
rch.h:41
> > #5  0x0000000000416ca2 in kvm_cpu_thread.2824 (arg=3D<optimized out>) a=
t builtin-run.c:176
> > #6  0x00007f701ebd0b50 in start_thread (arg=3D<optimized out>) at pthre=
ad_create.c:304
> > #7  0x00007f701e1fe70d in clone () at ../sysdeps/unix/sysv/linux/x86_64=
/clone.S:112
> > #8  0x0000000000000000 in ?? ()
>=20
> Looks like vpci->msix_table might not be initialized properly. Sasha,
> Asias, care to take a look at this?

vec is 0xFFFF in virtio_pci__specific_io_out() on crash.

Let's add proper bounds checking there. It doesn't not solves the issue
with booting crashkernel, but fix lkvm crash.

With the patch below I've got:

[    0.988004] NET: Registered protocol family 17
[    0.988550] 9pnet: Installing 9P2000 support
[    0.989006] virtio-pci 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.989889] virtio-pci 0000:00:02.0: irq 41 for MSI/MSI-X
[    0.991117] virtio-pci 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.991716] virtio-pci 0000:00:02.0: irq 41 for MSI/MSI-X
[    0.993028] 9pnet_virtio: probe of virtio1 failed with error -2
[    0.993811] virtio-pci 0000:00:03.0: irq 40 for MSI/MSI-X
[    0.993895] virtio-pci 0000:00:03.0: irq 41 for MSI/MSI-X
[    0.995186] virtio-pci 0000:00:03.0: irq 40 for MSI/MSI-X
[    0.995899] virtio-pci 0000:00:03.0: irq 41 for MSI/MSI-X
[    0.997030] 9pnet_virtio: probe of virtio2 failed with error -2
[    0.997891] Key type dns_resolver registered
[    0.998536] PM: Hibernation image not present or could not be loaded.
[    0.998902] registered taskstats version 1
[    1.001163]   Magic number: 0:241:128
[    1.001887] console [netcon0] enabled
[    1.002881] netconsole: network logging started
[    1.175863] Switching to clocksource tsc
[   13.017445] ALSA device list:
[   13.017834]   No soundcards found.
[   13.018382] md: Waiting for all devices to be available before
autodetect
[   13.019090] md: If you don't use raid, use raid=3Dnoautodetect
[   13.019867] md: Autodetecting RAID arrays.
[   13.020280] md: Scanned 0 and added 0 devices.
[   13.020728] md: autorun ...
[   13.021008] md: ... autorun DONE.
[   13.021405] 9pnet_virtio: no channels available
[   13.021958] VFS: Cannot open root device "root" or unknown-block(0,0):
error -2
[   13.022749] Please append a correct "root=3D" boot option; here are the
available partitions:
[   13.023641] Kernel panic - not syncing: VFS: Unable to mount root fs on
unknown-block(0,0)
[   13.024462] Pid: 1, comm: swapper/0 Not tainted 3.7.0-rc2+ #20
[   13.024638] Call Trace:
[   13.024638]  [<ffffffff8174ae94>] panic+0xb6/0x1b5
[   13.024638]  [<ffffffff81cc7e0c>] mount_block_root+0x183/0x221
[   13.024638]  [<ffffffff81cc7fa4>] mount_root+0xfa/0x105
[   13.024638]  [<ffffffff81cc80ec>] prepare_namespace+0x13d/0x16a
[   13.024638]  [<ffffffff81729ee6>] kernel_init+0x1c6/0x2e0
[   13.024638]  [<ffffffff81cc75af>] ? do_early_param+0x8c/0x8c
[   13.024638]  [<ffffffff81729d20>] ? rest_init+0x70/0x70
[   13.024638]  [<ffffffff8175db2c>] ret_from_fork+0x7c/0xb0
[   13.024638]  [<ffffffff81729d20>] ? rest_init+0x70/0x70
[   13.024638] Rebooting in 1 seconds..  Warning: serial8250__exit failed.


  # KVM session ended normally.

diff --git a/tools/kvm/virtio/pci.c b/tools/kvm/virtio/pci.c
index b6ac571..b5c0dfb 100644
--- a/tools/kvm/virtio/pci.c
+++ b/tools/kvm/virtio/pci.c
@@ -145,15 +145,21 @@ static bool virtio_pci__specific_io_out(struct kvm *k=
vm, struct virtio_device *v
 	if (type =3D=3D VIRTIO_PCI_O_MSIX) {
 		switch (offset) {
 		case VIRTIO_MSI_CONFIG_VECTOR:
-			vec =3D vpci->config_vector =3D ioport__read16(data);
+			vec =3D ioport__read16(data);
+			if (vec >=3D sizeof(vpci->msix_table))
+				return false;
=20
+			vpci->config_vector =3D vec;
 			gsi =3D irq__add_msix_route(kvm, &vpci->msix_table[vec].msg);
=20
 			vpci->config_gsi =3D gsi;
 			break;
 		case VIRTIO_MSI_QUEUE_VECTOR:
-			vec =3D vpci->vq_vector[vpci->queue_selector] =3D ioport__read16(data);
+			vec =3D ioport__read16(data);
+			if (vec >=3D sizeof(vpci->msix_table))
+				return false;
=20
+			vpci->vq_vector[vpci->queue_selector] =3D vec;
 			gsi =3D irq__add_msix_route(kvm, &vpci->msix_table[vec].msg);
 			vpci->gsis[vpci->queue_selector] =3D gsi;
 			if (vdev->ops->notify_vq_gsi)
--=20
 Kirill A. Shutemov

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiS2tAAoJEAd+omnVudOMpA4QAKLPCeKsppfNkS7gX1HfY9ud
6VO2dlKuQ3rWoNhCRG5422UWle+Y4OrlPgY+ozZsSXkNgf+T12Ppx/K+LDFw0qnt
NnOhMVVBra3PYWo2DDUeqlnUuK6yz+Kuy7TUZTbwz1DeAN7108I253q3lTXoJs8r
PEadz7+vFNvdNp3dd0WSRn34tiYE8j3ngDUvguWC6cJWfvXpW1Mc6EXF5gLZjn7C
rthacVCJzdaTFUc7ewKqo3KIBEF+3ylqTJq1s4aMSt9Id6VCNeOveBVlYsoCAV/1
yXUJGPSPB5EfAcVRxeCiFPCIBciKCY8s/Gz/sDDikzo+g/nEvwAARpdmTJqr8GD5
kIFehRuuHOFCDvPSnQARJL9hkrObUcKhfeCo+gQ2F5eRR11bwuj8z7/SebAovAcQ
cFeAWr32VRroARxUhyJTqzkapy+uI0Y2naF3lbQXvm+q816G2JgObbi378sTWUyV
A9kxaJkpxBHZa7Aw+5YWAbYpPgYdPM2ZQ2NpugzQPaUD334WueBz3EAZxb8DW2Sl
NUqLyRgSIF7aPh6qiptAF7R6aTCdsxyrEF6UL6Reqj6ZTo4UEezipSAhYv+XzJ4x
3T+kloJ+VlNiUtNFrjCJZxEZwsQEEqa0kluFt+tfMTxPnQkDkOaJxhZpdOxRf48J
rCi/7UqbSGuqWA5CIVog
=DAPW
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
