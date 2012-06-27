Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab2F0F1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 01:27:15 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:44868 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2F0F1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 01:27:13 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApxHAJuY6k9V5qg+PGdsb2JhbABFihWoTINYGQEBAQE3NIIYAQEEATocIwULCANGFCUKGogZCblWFJBNYAOVMYVmjH8
X-IronPort-AV: E=Sophos;i="4.77,482,1336341600"; 
   d="scan'208";a="363252993"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 27 Jun 2012 07:30:32 +0200
To: Dave Airlie <airlied@linux.ie>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
Message-ID: <20120627053032.GA518@polaris.bitmath.org>
References: <alpine.DEB.2.00.1206261455320.18392@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206261455320.18392@skynet.skynet.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> just two changes, one udl endian fix, one nouveau memory corruption on 
> some GPUs.

I have been tracking an elusive memory corruption bug appearing on my
MacBookAir3,1 (nv50) since -rc0, but unfortunately it seems to be
different from the one fixed here. The problem is of the random kind,
which made bisection tricky. It seems the patch below fixes the
symptoms, but I have no idea why:

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 7f80ed5..bff34f4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -935,7 +935,6 @@ nouveau_bo_move_init(struct nouveau_channel *chan)
                {  "COPY", 0, 0xa0b5, nve0_bo_move_copy, nvc0_bo_move_init },
                { "COPY1", 5, 0x90b8, nvc0_bo_move_copy, nvc0_bo_move_init },
                { "COPY0", 4, 0x90b5, nvc0_bo_move_copy, nvc0_bo_move_init },
-               {  "COPY", 0, 0x85b5, nva3_bo_move_copy, nv50_bo_move_init },
                { "CRYPT", 0, 0x74c1, nv84_bo_move_exec, nv50_bo_move_init },
                {  "M2MF", 0, 0x9039, nvc0_bo_move_m2mf, nvc0_bo_move_init },
                {  "M2MF", 0, 0x5039, nv50_bo_move_m2mf, nv50_bo_move_init },

With the patch applied, the log shows this:

Jun 27 07:01:15 polaris kernel: [drm] nouveau 0000:02:00.0: MM: using M2MF for buffer copies

Without the patch applied, when the problem appears, the log shows this:

Jun 27 06:50:34 polaris kernel: [drm] nouveau 0000:02:00.0: MM: using COPY for buffer copies

As I start X, and when the stars are in the right position, I get a bunch of errors like these:

Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_M2MF IN
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_M2MF 00320251 203afd00 00000000 04000e00
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - ch 2 (0x0000829000) subc 0 class 0x5039 mthd 0x0328 data 0x00000000
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: VM: trapped read at 0x00203abe80 on ch 2 [0x00000829] PGRAPH/DISPATCH/M2M_IN reason: VRAM_LIMIT
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_M2MF IN
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_M2MF 00320151 40442000 00000000 04000000
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - ch 2 (0x0000829000) subc 0 class 0x5039 mthd 0x0328 data 0x00000000
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: VM: trapped read at 0x0040410000 on ch 2 [0x00000829] PGRAPH/DISPATCH/M2M_IN reason: NULL_DMAOBJ
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_M2MF IN
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_M2MF 00320251 203c7600 00000000 04000e00
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - ch 2 (0x0000829000) subc 0 class 0x5039 mthd 0x0328 data 0x00000000
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: VM: trapped read at 0x00203c3780 on ch 2 [0x00000829] PGRAPH/DISPATCH/M2M_IN reason: VRAM_LIMIT
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_M2MF IN
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_M2MF 00320151 40855000 00000000 04000000
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - ch 2 (0x0000829000) subc 0 class 0x5039 mthd 0x0328 data 0x00000000
Jun 27 06:51:52 polaris kernel: [drm] nouveau 0000:02:00.0: VM: trapped read at 0x0040820000 on ch 2 [0x00000829] PGRAPH/DISPATCH/M2M_IN reason: NULL_DMAOBJ
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_M2MF OUT
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_M2MF 00340241 2014bb80 00000000 05000e00
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - ch 2 (0x0000829000) subc 0 class 0x5039 mthd 0x0328 data 0x00000000
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: VM: trapped write at 0x002014ad00 on ch 2 [0x00000829] PGRAPH/DISPATCH/M2M_OUT reason: VRAM_LIMIT
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_M2MF OUT
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_M2MF 00340241 2014bb80 00000000 05000e00
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - ch 2 (0x0000829000) subc 0 class 0x5039 mthd 0x0328 data 0x00000000
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: VM: trapped write at 0x00201770f0 on ch 2 [0x00000829] PGRAPH/DISPATCH/M2M_OUT reason: VRAM_LIMIT
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_M2MF IN
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_M2MF 00320251 2019fc00 00000000 04000000
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - ch 2 (0x0000829000) subc 0 class 0x5039 mthd 0x0328 data 0x00000000
Jun 27 06:51:53 polaris kernel: [drm] nouveau 0000:02:00.0: VM: trapped read at 0x002019f000 on ch 2 [0x00000829] PGRAPH/DISPATCH/M2M_IN reason: NULL_DMAOBJ
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: magic set 0:
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: 	0x00408604: 0x2008ca0f
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: 	0x00408608: 0x002008b7
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: 	0x0040860c: 0x40000e00
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: 	0x00408610: 0x08b00003
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_TEXTURE - TP0: Unhandled ustatus 0x00000003
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: magic set 1:
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: 	0x00408e04: 0x2009d60f
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: 	0x00408e08: 0x002008b3
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: 	0x00408e0c: 0x40000e00
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: 	0x00408e10: 0x08b00003
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_TEXTURE - TP1: Unhandled ustatus 0x00000003
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - ch 2 (0x0000829000) subc 7 class 0x8697 mthd 0x1414 data 0x00000000
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: VM: trapped read at 0x002008b300 on ch 2 [0x00000829] PGRAPH/TEXTURE/00 reason: VRAM_LIMIT
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: magic set 0:
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: 	0x00408604: 0x20098108
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: 	0x00408608: 0x0020093d
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: 	0x0040860c: 0x80000e00
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: 	0x00408610: 0x08f00003
Jun 27 06:51:56 polaris kernel: [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_TEXTURE - TP0: Unhandled ustatus 0x00000003

Any idea what this could be?

Thanks,
Henrik
