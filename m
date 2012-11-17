Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2KQTiG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 14:38:06 -0500
Received: from smtp1.uu.se ([130.238.7.54]:41815 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab2KQTiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 14:38:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20647.59126.898316.299551@pilspetsen.it.uu.se>
Date: Sat, 17 Nov 2012 20:35:18 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Airlie <airlied@linux.ie>
Cc: Kelly Doran <kel.p.doran@gmail.com>, linux-kernel@vger.kernel.org
Subject: [3.7-rc5/rc6 regression] "drm/nvc0/disp: fix regression in vblank semaphore release" broke nouveau driver and mplayer
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mplayer worked fine on my Dell Latitude E6510 (nVidia GT218 [NVS 3100M] graphics)
up to and including kernel 3.7-rc4. However, with 3.7-rc5 or -rc6, any attempt to
run mplayer just blanks the screen, shows some stray white pixels in the upper left
corner, kills the X server, and spews the following errors from the kernel:

nouveau E[  PGRAPH][0000:01:00.0] TRAP_M2MF NOTIFY
nouveau E[  PGRAPH][0000:01:00.0] TRAP_M2MF 00304041 000043e0 00000000 06000434
nouveau  [  PGRAPH][0000:01:00.0]  TRAP
nouveau E[  PGRAPH][0000:01:00.0] ch 2 [0x001fb44000] subc 3 class 0x5039 mthd 0x0328 data 0x00000000
nouveau E[     PFB][0000:01:00.0] trapped read at 0x002001a020 on channel 0x0001fb44 SEMAPHORE_BG/PFIFO_READ/00 reason: PAGE_NOT_PRESENT
nouveau  [   PFIFO][0000:01:00.0] CACHE_ERROR - Ch 2/4 Mthd 0x0068 Data 0x11111111
nouveau E[  PGRAPH][0000:01:00.0] TRAP_DISPATCH (unknown 0x00000004)
nouveau  [  PGRAPH][0000:01:00.0]  ILLEGAL_MTHD ILLEGAL_CLASS
nouveau E[  PGRAPH][0000:01:00.0] ch -1 [0x001fb44000] subc 3 class 0x0000 mthd 0x0860 data 0x00000000
nouveau E[     PFB][0000:01:00.0] trapped read at 0x002001a024 on channel 0x0001fb44 PFIFO/PFIFO_READ/SEMAPHORE reason: PAGE_NOT_PRESENT
nouveau  [  PGRAPH][0000:01:00.0]  ILLEGAL_MTHD ILLEGAL_CLASS
nouveau E[  PGRAPH][0000:01:00.0] ch -1 [0x001fb44000] subc 3 class 0x0000 mthd 0x0860 data 0x00000000
nouveau  [  PGRAPH][0000:01:00.0]  ILLEGAL_MTHD ILLEGAL_CLASS
nouveau E[  PGRAPH][0000:01:00.0] ch -1 [0x001fb44000] subc 3 class 0x0000 mthd 0x0860 data 0x00000000
nouveau  [  PGRAPH][0000:01:00.0]  ILLEGAL_MTHD ILLEGAL_CLASS

(this bit repeats itself for 700+ lines)

nouveau E[  PGRAPH][0000:01:00.0] ch -1 [0x001fb44000] subc 3 class 0x0000 mthd 0x0860 data 0x00000000
nouveau  [  PGRAPH][0000:01:00.0]  ILLEGAL_MTHD ILLEGAL_CLASS
nouveau E[  PGRAPH][0000:01:00.0] ch -1 [0x001fb44000] subc 5 class 0x0000 mthd 0x0860 data 0x00000000
nouveau  [  PGRAPH][0000:01:00.0]  ILLEGAL_MTHD ILLEGAL_CLASS

(this bit repeats itself for 30+ lines)

nouveau E[  PGRAPH][0000:01:00.0] ch -1 [0x001fb44000] subc 5 class 0x0000 mthd 0x03c4 data 0x40000000
nouveau  [  PGRAPH][0000:01:00.0]  ILLEGAL_MTHD ILLEGAL_CLASS
nouveau E[  PGRAPH][0000:01:00.0] ch -1 [0x001fb44000] subc 5 class 0x0000 mthd 0x03c8 data 0x00000000
nouveau E[     PFB][0000:01:00.0] trapped write at 0x0000000000 on channel 0x0001fb44 PGRAPH/DISPATCH/GRCTX reason: DMAOBJ_LIMIT
nouveau E[  PGRAPH][0000:01:00.0] TRAP_DISPATCH (unknown 0x00000004)
nouveau  [  PGRAPH][0000:01:00.0]  ILLEGAL_MTHD ILLEGAL_CLASS
nouveau E[  PGRAPH][0000:01:00.0] ch -1 [0x001fb44000] subc 5 class 0x0000 mthd 0x03cc data 0x40000000
nouveau E[     PFB][0000:01:00.0] trapped write at 0x0000000420 on channel 0x0001fb44 PGRAPH/DISPATCH/GRCTX reason: DMAOBJ_LIMIT
nouveau  [  PGRAPH][0000:01:00.0]  ILLEGAL_MTHD ILLEGAL_CLASS
nouveau E[  PGRAPH][0000:01:00.0] ch -1 [0x001fb44000] subc 3 class 0x502d mthd 0x0860 data 0x00000000
nouveau E[     PFB][0000:01:00.0] trapped write at 0x000002b000 on channel 0x0001fcb0 PGRAPH/DISPATCH/GRCTX reason: DMAOBJ_LIMIT

The error is 100% repeatable.

git bisect identified the following culprit:

11d92561c81be2f4a7af37f035e1af294b960abe is the first bad commit
commit 11d92561c81be2f4a7af37f035e1af294b960abe
Author: Kelly Doran <kel.p.doran@gmail.com>
Date:   Wed Nov 7 10:02:04 2012 +1000

    drm/nvc0/disp: fix regression in vblank semaphore release
    
    Signed-off-by: Kelly Doran <kel.p.doran@gmail.com>
    Reviewed-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

:040000 040000 e539bc754b029da133f89f3bcf5bf31495cb07c5 4e779444a976c40cb07aafefc8e6e7b1e64f092c M      drivers

I've confirmed that reverting this from -rc5 and -rc6 allows mplayer to work again.

User-space is Fedora 15 x86_64 w/ final updates, plus mplayer-1.0-0.129.20110917svn from rpmfusion.
There are no binary-only or otherwise out-of-tree kernel or X drivers anywhere on the machine.

Please revert or fix this breakage before kernel 3.7.0 final.

/Mikael
