Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab0INRvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:51:36 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:50373 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab0INRvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:51:33 -0400
Message-ID: <4C8FB616.2070807@free.fr>
Date: Tue, 14 Sep 2010 19:51:18 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-next@vger.kernel.org
CC: Arjan van de Ven <arjan@infradead.org>, James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>
Subject: Re: [PATCH 2/3 V8] [tip:x86/mm] NX protection for kernel data
References: <4C856211.7080802@free.fr>
In-Reply-To: <4C856211.7080802@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

any feedback on that ?

Thanks,

Matthieu


matthieu castet a écrit :
>    Note: this patch depends on "Correct improper large page 
> preservation" patch
>       This patch expands functionality of CONFIG_DEBUG_RODATA to set main
>    (static) kernel data area as NX.
>    The following steps are taken to achieve this:
>    1. Linker script is adjusted so .text always starts and ends on a 
> page bound
>    2. Linker script is adjusted so .rodata always start and
>    end on a page boundary
>    3. NX is set for all pages from _etext through _end in mark_rodata_ro.
>    4. free_init_pages() sets released memory NX in arch/x86/mm/init.c
>    5. bios rom is set to x when pcibios is used.
>       The results of patch application may be observed in the diff of 
> kernel page
>    table dumps.
>    pcibios :
>    --- data_nx_pt_before.txt       2009-10-13 07:48:59.000000000 -0400
>    +++ data_nx_pt_after.txt        2009-10-13 07:26:46.000000000 -0400
>    @@ -2,8 +2,9 @@
>     0x00000000-0xc0000000           3G                           pmd
>     ---[ Kernel Mapping ]---
>    -0xc0000000-0xc0100000           1M     RW             GLB x  pte
>    +0xc0000000-0xc00a0000         640K     RW             GLB NX pte
>    +0xc00a0000-0xc0100000         384K     RW             GLB x  pte
>    -0xc0100000-0xc03d7000        2908K     ro             GLB x  pte
>    +0xc0100000-0xc0318000        2144K     ro             GLB x  pte
>    +0xc0318000-0xc03d7000         764K     ro             GLB NX pte
>    -0xc03d7000-0xc0600000        2212K     RW             GLB x  pte
>    +0xc03d7000-0xc0600000        2212K     RW             GLB NX pte
>     0xc0600000-0xf7a00000         884M     RW         PSE GLB NX pmd
>     0xf7a00000-0xf7bfe000        2040K     RW             GLB NX pte
>     0xf7bfe000-0xf7c00000           8K                           pte
>       no pcibios :
>    --- data_nx_pt_before.txt       2009-10-13 07:48:59.000000000 -0400
>    +++ data_nx_pt_after.txt        2009-10-13 07:26:46.000000000 -0400
>    @@ -2,8 +2,9 @@
>     0x00000000-0xc0000000           3G                           pmd
>     ---[ Kernel Mapping ]---
>    -0xc0000000-0xc0100000           1M     RW             GLB x  pte
>    +0xc0000000-0xc0100000           1M     RW             GLB NX pte
>    -0xc0100000-0xc03d7000        2908K     ro             GLB x  pte
>    +0xc0100000-0xc0318000        2144K     ro             GLB x  pte
>    +0xc0318000-0xc03d7000         764K     ro             GLB NX pte
>    -0xc03d7000-0xc0600000        2212K     RW             GLB x  pte
>    +0xc03d7000-0xc0600000        2212K     RW             GLB NX pte
>     0xc0600000-0xf7a00000         884M     RW         PSE GLB NX pmd
>     0xf7a00000-0xf7bfe000        2040K     RW             GLB NX pte
>     0xf7bfe000-0xf7c00000           8K                           pte
>       The patch have been developed for Linux 2.6.34-rc2 x86 by Siarhei 
> Liakh
>    <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.
>       V1:  initial patch for 2.6.30
>    V2:  patch for 2.6.31-rc7
>    V3:  moved all code into arch/x86, adjusted credits
>    V4:  fixed ifdef, removed credits from CREDITS
>    V5:  fixed an address calculation bug in mark_nxdata_nx()
>    V6:  added acked-by and PT dump diff to commit log
>    V7:  minor adjustments for -tip
>    V8:  rework with the merge of "Set first MB as RW+NX"
>       Signed-off-by: Siarhei Liakh <sliakh.lkml@gmail.com>
>    Signed-off-by: Xuxian Jiang <jiang@cs.ncsu.edu>
>    Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> 

