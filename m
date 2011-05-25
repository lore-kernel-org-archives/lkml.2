Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1EYCcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 22:32:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58691 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1EYCcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 22:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=WEIyQOp7eg80KSe0OMzEZPv808BxCQmLGLC7yWlwpcYCXyYxNr5yrrD7iAkyVuu3H4
         hSRtQ7Y1Xpe6Empg1iRLhwdunopAEjpMm6VWW1hWQzSQuO9GbabpPB4UN5L9rPdwNQsv
         dN4X3JFMsNXZKibgclMujwWwfn/rAtlGyr+zc=
MIME-Version: 1.0
Date: Wed, 25 May 2011 04:32:00 +0200
Message-ID: <BANLkTimd6nvXTbn2hM+cKDNKFpxzsQLHog@mail.gmail.com>
Subject: [Regression 2.6.39][nouveau][bisected?] leaving fullscreen XV
 "crashes" with KDE desktop effects enabled
From: Jan Seiffert <kaffeemonster@googlemail.com>
To: nouveau@lists.freedesktop.org
Cc: bskeggs@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC as not subscribed.

HW: 01:00.0 VGA compatible controller: nVidia Corporation G92 [GeForce
8800 GTS 512] (rev a2)
Xorg log says: (--) NOUVEAU(0): Chipset: "NVIDIA NV92"
System is 64Bit x86

Saw it on first test of 2.6.39 with 2.6.39-rc3, but only now had time
to bisect from 2.6.39-rc3 to 2.6.38.
Since with desktop effects other corruptions are also much much worse
with 2.6.39 i found that this only happens with desktop effects.
To reproduce:
- enable KDE desktop effects
 (or make sure they are enabled, during bisect KDE disabled them due
to the crashes)
- start a video with mplayer using XV
- switch to full screen
- switch out of full screen
- quit mplayer
computer is "dead", really dead...

During bisect it also crashed on switching out of full screen,
sometime it wasn't totally dead, but only X11, or just badly
distorted/hangy (mouse still working, but nothing else of X11).

I tried to bisect it, but since i hit other problems (no graphics at
all or corrupted graphic from the start but could still operate blind
to test if leaving fullscreen/ending XV crashes) and the exact form of
crash changed during bisect, i'm not sure i hit the right commit (some
needed skips also do NOT raise the confidence).
2.6.39 final "crashes" on leaving full screen and only X11 is dead.
(during bisect if machine is still alive but X11 dead only one time i
found X11 stuck at 100% D-State (multicore helps...))

Unfortunately i'm to stupid to revert the commit.

If the machine was not deadly dead, things like this made it to syslog
(and syslog was on, thanks to the permission check patch...), from the
first derail point.
Example 1:
[drm] nouveau 0000:01:00.0: magic set 1:
[drm] nouveau 0000:01:00.0:        0x00409904: 0x20085205
[drm] nouveau 0000:01:00.0:        0x00409908: 0x00000000
[drm] nouveau 0000:01:00.0:        0x0040990c: 0x40000e04
[drm] nouveau 0000:01:00.0:        0x00409910: 0x00000000
[drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TEXTURE - TP1: Unhandled
ustatus 0x00000003
[drm] nouveau 0000:01:00.0: magic set 4:
[drm] nouveau 0000:01:00.0:        0x0040c904: 0x20082805
[drm] nouveau 0000:01:00.0:        0x0040c908: 0x00000000
[drm] nouveau 0000:01:00.0:        0x0040c90c: 0x40000e04
[drm] nouveau 0000:01:00.0:        0x0040c910: 0x00000000
[drm] nouveau 0000:01:00.0: PGRAPH - TRAP_TEXTURE - TP4: Unhandled
ustatus 0x00000003
[drm] nouveau 0000:01:00.0: PGRAPH - TRAP
[drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000aa0000) subc 5 class
0x8297 mthd 0x15e0 data 0x00000000
[drm] nouveau 0000:01:00.0: VM: trapped write at 0x002000f004 on ch 2
[0x00000aa0] PFIFO/PFIFO_READ/SEMAPHORE reason: DMAOBJ_LIMIT
....
....

Example 2:
[drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR BEGIN_END_ACTIVE
[drm] nouveau 0000:01:00.0: PGRAPH - DATA_ERROR
[drm] nouveau 0000:01:00.0: PGRAPH - ch 2 (0x0000aa0000) subc 5 class
0x8297 mthd 0x1360 data 0x00000001
[drm] nouveau 0000:01:00.0: VM: trapped write at 0x002000f004 on ch 2
[0x00000aa0] PFIFO/PFIFO_READ/SEMAPHORE reason: DMAOBJ_LIMIT
....
....

$ git bisect bad
c3b90a7d4ce28c5c25de8aad3956c5c3f188d6a1 is the first bad commit
commit c3b90a7d4ce28c5c25de8aad3956c5c3f188d6a1
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Fri Jan 28 12:08:29 2011 +1000

    drm/nv84: switch to new-style semaphores

    These are the same semaphores nvc0 will use, and they potentially allow
    us to do much cooler things than our current inter-channel sync impl.

    Lets switch to them where possible now for some testing.

$ git bisect log
git bisect start
# good: [521cb40b0c44418a4fd36dc633f575813d59a43d] Linux 2.6.38
git bisect good 521cb40b0c44418a4fd36dc633f575813d59a43d
# bad: [a6360dd37e1a144ed11e6548371bade559a1e4df] Linux 2.6.39-rc3
git bisect bad a6360dd37e1a144ed11e6548371bade559a1e4df
# skip: [e240ae4aad9c5c0da189cb6c956cca58abd428d0] xen: Use new
irq_move functions
git bisect skip e240ae4aad9c5c0da189cb6c956cca58abd428d0
# good: [b3ed3a174c419702eddf9fb28636f6e4baa29d03] ARM: EXYNOS4:
Update Clock part
git bisect good b3ed3a174c419702eddf9fb28636f6e4baa29d03
# good: [0ff1731a1ae51e8e48cd559d70db536281c47f8e] HID: bt: Add
support for hidraw HIDIOCGFEATURE and HIDIOCSFEATURE
git bisect good 0ff1731a1ae51e8e48cd559d70db536281c47f8e
# good: [0a27d7f9f417c0305f7efa70631764a53c7af219] perf record: Use
perf_evlist__mmap
git bisect good 0a27d7f9f417c0305f7efa70631764a53c7af219
# bad: [401a18e92ce32cd0ddfa5738899ca2b8114f2bbf] block: fix bug with
inserting flush requests as sort/merge
git bisect bad 401a18e92ce32cd0ddfa5738899ca2b8114f2bbf
# good: [e34551339a195aa548eaf698523714a8fe7f1984] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu
git bisect good e34551339a195aa548eaf698523714a8fe7f1984
# bad: [d3e458d78167102cc961237cfceef6fffc80c0b3] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git bisect bad d3e458d78167102cc961237cfceef6fffc80c0b3
# bad: [6d7ed21d17e640b120b902a314143e5ef4917a70] Merge branches
'defcfg', 'drivers' and 'cyberpro-next' of
master.kernel.org:/home/rmk/linux-2.6-arm
git bisect bad 6d7ed21d17e640b120b902a314143e5ef4917a70
# bad: [c8def554d031664e984323f6a5d667f070717776]
smp_call_function_interrupt: use typedef and %pf
git bisect bad c8def554d031664e984323f6a5d667f070717776
# bad: [c87a8d8dcd2587c203f3dd8a3c5c15d1e128ec0d] drm/radeon: fixup
refcounts in radeon dumb create ioctl.
git bisect bad c87a8d8dcd2587c203f3dd8a3c5c15d1e128ec0d
# bad: [8aa75009bca5e700e9236c8e066d2f943069c883] drm/radeon/kms:
cayman/evergreen cs checker updates
git bisect bad 8aa75009bca5e700e9236c8e066d2f943069c883
# bad: [30d81817a2a7eefcf4aa8b703d5f8330451c2648] drm/nv50-nvc0: disp
channels have fixed purposes, don't "allocate" them
git bisect bad 30d81817a2a7eefcf4aa8b703d5f8330451c2648
# skip: [63871f89d158e3f3e469dde00dd15763d474cb3c] Merge branch
'drm-mm-cleanup' into drm-next
git bisect skip 63871f89d158e3f3e469dde00dd15763d474cb3c
# good: [4546b2c1d6e256c716e5240f5d6198a078fd7a22] radeon: move blit
functions to radeon_asic.h
git bisect good 4546b2c1d6e256c716e5240f5d6198a078fd7a22
# good: [e11d57ca0b6dada29007ce3ad3db6c84034a768f] Merge
remote-tracking branch 'airlied/drm-core-next' into drm-nouveau-next
git bisect good e11d57ca0b6dada29007ce3ad3db6c84034a768f
# bad: [ea5f2786a0942832f32deb7c507531b766028356] drm/nouveau: silence
some compiler warnings
git bisect bad ea5f2786a0942832f32deb7c507531b766028356
# good: [e0435120a8e91990e995ffacb109f82cd44fdfc1] drm/nv40: support
for 39-bit dma addresses on native PCIE chipsets
git bisect good e0435120a8e91990e995ffacb109f82cd44fdfc1
# bad: [cc8cd6479cb9d6b384ccdaa4b21fcbf0826bd232] drm/nvc0/pfifo:
semi-handle a couple more irqs
git bisect bad cc8cd6479cb9d6b384ccdaa4b21fcbf0826bd232
# bad: [c3b90a7d4ce28c5c25de8aad3956c5c3f188d6a1] drm/nv84: switch to
new-style semaphores
git bisect bad c3b90a7d4ce28c5c25de8aad3956c5c3f188d6a1


Other software involved now ATM:
[ebuild   R   ] x11-drivers/xf86-video-nouveau-0.0.16_pre20110323
[ebuild   R   ] kde-base/kde-meta-4.6.2  USE="accessibility nls
semantic-desktop (-aqua) (-kdeprefix) -sdk"
[ebuild   R   ] x11-base/xorg-server-1.9.4  USE="doc ipv6 kdrive nptl
udev xorg -dmx -minimal -static-libs -tslib"
[ebuild   R   ]  media-libs/mesa-7.10.2  USE="classic gallium llvm
motif nptl -debug -gles -hardened -pic (-selinux)"
VIDEO_CARDS="nouveau -intel -mach64 -mga -r128 -radeon -savage -sis
-tdfx -via -vmware"
[ebuild   R   ]   sys-devel/llvm-2.8-r2  USE="libffi -alltargets
-debug -llvm-gcc -ocaml -test -udis86"
[ebuild   R   ]   x11-libs/libdrm-2.4.25  USE="libkms -static-libs"
VIDEO_CARDS="nouveau -intel -radeon -vmware"
But since i noticed this at 2.6.39-rc3 KDE was updated from 4.5 and if
i remember right also the other stuff.


So, throw patches at me, or tell me what other info you need, as long
as it does not contain a serial console or such things...

Greetings
Jan
