Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab1EYJ2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:28:36 -0400
Received: from mail4.comsite.net ([205.238.176.238]:42907 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1EYJ2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:28:35 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
Subject: Re: [v5] powerpc: Force page alignment for initrd reserved memory
To: Dave Carroll <dcarroll@astekcorp.com>
In-Reply-To: <522F24EF533FC546962ECFA2054FF777373072AB79@MAILSERVER2.cos.astekcorp.com>
Cc: LPPC <linuxppc-dev@lists.ozlabs.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <initrd-align-v5-reply@mdm.bga.com>
References: <522F24EF533FC546962ECFA2054FF777373072AB75@MAILSERVER2.cos.astekcorp.com>
 <522F24EF533FC546962ECFA2054FF777373072AB78@MAILSERVER2.cos.astekcorp.com>
 <initrd-align-withdrawn@mdm.bga.com>
 <522F24EF533FC546962ECFA2054FF777373072AB79@MAILSERVER2.cos.astekcorp.com>
Date: Wed, 25 May 2011 04:28:34 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 about 12:54:25 -0000, Dave Carroll wrote:
> When using 64K pages with a separate cpio rootfs, U-Boot will align
> the rootfs on a 4K page boundary. When the memory is reserved, and
> subsequent early memblock_alloc is called, it will allocate memory
> between the 64K page alignment and reserved memory. When the reserved
> memory is subsequently freed, it is done so by pages, causing the
> early memblock_alloc requests to be re-used, which in my case, caused
> the device-tree to be clobbered.
> 
> This patch forces the reserved memory for initrd to be kernel page
> aligned, and adds the same range extension when freeing initrd. It
> will also move the device tree if it overlaps with the reserved memory
> for initrd.
> 
> Many thanks to Milton Miller for his input on this patch.
> 
> Signed-off-by: Dave Carroll <dcarroll@astekcorp.com>
> 
> ---
> * This patch is based on Linus' current tree

Ben if I had reviewed this closely, so I tried to apply it.  First
it failed because it arrived with

Content-Transfer-Encoding: quoted-printable 

patchwork was nice enough to fix that, but it still didn't apply
because tabs were changed to spaces.

While both of those things can be fixed, It would reduce the burden
to test and apply if you can fix your mailer.

> 
>  arch/powerpc/kernel/prom.c |   11 ++++++++---
>  arch/powerpc/mm/init_32.c  |    5 ++++-
>  arch/powerpc/mm/init_64.c  |    5 ++++-
>  3 files changed, 16 insertions(+), 5 deletions(-)
> 
> --
> 1.7.4
> 
> diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
> index 48aeb55..58871df 100644
> --- a/arch/powerpc/kernel/prom.c
> +++ b/arch/powerpc/kernel/prom.c
> @@ -86,7 +86,8 @@ early_param("mem", early_parse_mem);
>   * move_device_tree - move tree to an unused area, if needed.
>   *
>   * The device tree may be allocated beyond our memory limit, or inside the
> - * crash kernel region for kdump. If so, move it out of the way.
> + * crash kernel region for kdump, or within the page aligned range of initrd.
> + * If so, move it out of the way.
>   */
>  static void __init move_device_tree(void)
>  {
> @@ -99,7 +100,9 @@ static void __init move_device_tree(void)
>         size = be32_to_cpu(initial_boot_params->totalsize);
> 
>         if ((memory_limit && (start + size) > PHYSICAL_START + memory_limit) ||
> -                       overlaps_crashkernel(start, size)) {
> +                       overlaps_crashkernel(start, size) ||
> +                       ((start + size) > _ALIGN_DOWN(initrd_start, PAGE_SIZE)
> +                       && start <= _ALIGN_UP(initrd_end, PAGE_SIZE))) {

When reviewing that with Ben, I thought the && should have been ||.  But
upon further review and comparison with overlaps_crashkernel, I see &&
is correct; it checks both the end is after the start and start is after end.

But that does point out the expression is too complex to read.  Please
create a helper overlaps_initrd similar to overlaps_crashkernel.  In that
function you should also return false if initrd_start is 0.

>                 p = __va(memblock_alloc(size, PAGE_SIZE));
>                 memcpy(p, initial_boot_params, size);
>                 initial_boot_params = (struct boot_param_header *)p;
> @@ -555,7 +558,9 @@ static void __init early_reserve_mem(void)
>  #ifdef CONFIG_BLK_DEV_INITRD
>         /* then reserve the initrd, if any */
>         if (initrd_start && (initrd_end > initrd_start))
> -               memblock_reserve(__pa(initrd_start), initrd_end - initrd_start);
> +               memblock_reserve(_ALIGN_DOWN(__pa(initrd_start), PAGE_SIZE),
> +                       _ALIGN_UP(initrd_end, PAGE_SIZE) -
> +                       _ALIGN_DOWN(initrd_start, PAGE_SIZE));
>  #endif /* CONFIG_BLK_DEV_INITRD */
> 
>  #ifdef CONFIG_PPC32
> diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
> index d65b591..4835c4f 100644
> --- a/arch/powerpc/mm/init_32.c
> +++ b/arch/powerpc/mm/init_32.c
> @@ -226,8 +226,11 @@ void free_initmem(void)
>  #ifdef CONFIG_BLK_DEV_INITRD
>  void free_initrd_mem(unsigned long start, unsigned long end)
>  {
> -       if (start < end)
> +       if (start < end) {
> +               start = _ALIGN_DOWN(start, PAGE_SIZE);
> +               end = _ALIGN_UP(end, PAGE_SIZE);
>                 printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
> +       }

With the additional code added, Ben and I both noticed the indent
level can be reduced by reversing the condition and issuing an
early return.  eg:

	if (start >= end)
		return;

This will also bring the printk line back under 80 columns.

>         for (; start < end; start += PAGE_SIZE) {
>                 ClearPageReserved(virt_to_page(start));
>                 init_page_count(virt_to_page(start));
> diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
> index 6374b21..060c952 100644
> --- a/arch/powerpc/mm/init_64.c
> +++ b/arch/powerpc/mm/init_64.c
> @@ -102,8 +102,11 @@ void free_initmem(void)
>  #ifdef CONFIG_BLK_DEV_INITRD
>  void free_initrd_mem(unsigned long start, unsigned long end)
>  {
> -       if (start < end)
> +       if (start < end) {
> +               start = _ALIGN_DOWN(start, PAGE_SIZE);
> +               end = _ALIGN_UP(end, PAGE_SIZE);
>                 printk ("Freeing initrd memory: %ldk freed\n", (end - start) >> 10);
> +       }
>         for (; start < end; start += PAGE_SIZE) {
>                 ClearPageReserved(virt_to_page(start));
>                 init_page_count(virt_to_page(start));

Ben noticed the duplication and asked that the function be moved to
mem.c, which is common for 32 and 64 bit.

I would ask that, in addition, you prepare a second patch that
consolidates the free_initmem functions just above them by
noting that all sections except init were removed in v2.6.15 by
6c45ab992e4299c869fb26427944a8f8ea177024 (powerpc: Remove section
free() and linker script bits), and therefore the bulk of the executed
code is identical.

However, I see its a bit more involved because of that last line in
the 32 bit code which clears ppc_md.progress.  A bit of research shows
we mostly don't call ppc_md.progress after init calls, but powermac
has a late initcall to clear it because they call it from a smp hook,
and the progress function is marked __init.  Further research shows
most are marked init, including somewhat duplicated functions across
64 bit powerpc; the exception seems to be rtas_progress which is
called directly (not through ppc_md) from rtas-proc.c.

So upon further review, clear the ppc_md.progress to NULL at the
beginning of the consolidated function (before we start to release
the pages with the code).  You can then remove the late_initcall in
the powermac code.

Extra credit to create and consolidate a printk_progress companion
to the udbg_progress call (but located somewhere common like
arch/powerpc/kernel/setup-common.c).

Thanks,
milton
