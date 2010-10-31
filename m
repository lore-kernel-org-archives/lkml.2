Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0JaKOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 06:14:53 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:55680 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab0JaKOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 06:14:51 -0400
Date: Sun, 31 Oct 2010 11:14:43 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kerstin Jonsson <kerstin.jonsson@ericsson.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-mmc@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] powerpc: Fix initramfs size in PPC32 build
In-Reply-To: <1287742675-7614-1-git-send-email-kerstin.jonsson@ericsson.com>
Message-ID: <alpine.DEB.2.00.1010311101530.29741@ayla.of.borg>
References: <1287742675-7614-1-git-send-email-kerstin.jonsson@ericsson.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010, Kerstin Jonsson wrote:
> commit ffe8018c3424892c9590048fc36caa6c3e0c8a76 of the -mm tree
> fixes the initramfs size calculation for e.g. s390 but breaks it
> for 32bit architectures which do not define CONFIG_32BIT.
> 
> This patch fix the problem for PPC32 which will elsewise end up
> with a __initramfs_size of 0.
> 
> Signed-off-by: Kerstin Jonsson <kerstin.jonsson@ericsson.com>
> Cc: Paul Mackerras <paulus@samba.org>
> ---
>  arch/powerpc/Kconfig |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 50cc5d9..d536fe4 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -4,6 +4,10 @@ config PPC32
>  	bool
>  	default y if !PPC64
>  
> +config 32BIT
> +	bool
> +	default y if PPC32
> +
>  config 64BIT
>  	bool
>  	default y if PPC64
> -- 
> 1.7.1

Thanks for the hint!

In the future, please CC linux-arch, or at least lkml, for things like this,
as it broke allmost all 32-bit arches.
Only mips, s390, and score set CONFIG_32BIT for 32-bit builds.
Would have saved me a bisection on m68k...

I came up with the alternative patch below to fix it in a single place.
---
>From d51254ca020a23050f1641d92d68113e55cc0467 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 31 Oct 2010 10:56:23 +0100
Subject: [PATCH] initramfs: Fix initramfs size for 32-bit arches

commit ffe8018c3424892c9590048fc36caa6c3e0c8a76 ("initramfs: fix initramfs size
calculation") broke 32-bit arches like (on ARAnyM):

    VFS: Cannot open root device "hda1" or unknown-block(3,1)
    Please append a correct "root=" boot option; here are the available partitions:
    fe80         1059408 nfhd8  (driver?)
      fe81          921600 nfhd8p1 00000000-0000-0000-0000-000000000nfhd8p1
      fe82          137807 nfhd8p2 00000000-0000-0000-0000-000000000nfhd8p2
    0200            3280 fd0  (driver?)
    0201            3280 fd1  (driver?)
    0300         1059408 hda  driver: ide-gd
      0301          921600 hda1 00000000-0000-0000-0000-000000000hda1
      0302          137807 hda2 00000000-0000-0000-0000-000000000hda2
    Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(3,1)

As pointed out by Kerstin Jonsson <kerstin.jonsson@ericsson.com>, this is due
to CONFIG_32BIT not being defined.

Only mips, s390, and score set CONFIG_32BIT for 32-bit builds, so fix it for
all other 32-bit arches by inverting the logic and testing for CONFIG_64BIT,
which should be defined on all 64-bit arches.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 usr/initramfs_data.S |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/usr/initramfs_data.S b/usr/initramfs_data.S
index b9efed5..792a750 100644
--- a/usr/initramfs_data.S
+++ b/usr/initramfs_data.S
@@ -30,8 +30,8 @@ __irf_end:
 .section .init.ramfs.info,"a"
 .globl __initramfs_size
 __initramfs_size:
-#ifdef CONFIG_32BIT
-	.long __irf_end - __irf_start
-#else
+#ifdef CONFIG_64BIT
 	.quad __irf_end - __irf_start
+#else
+	.long __irf_end - __irf_start
 #endif
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
