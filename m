Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab1KPDBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 22:01:20 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50775 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab1KPDBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 22:01:17 -0500
Date: Wed, 16 Nov 2011 11:00:09 +0800
From: wangyanqing <udknight@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        castet.matthieu@free.fr, x86@kernel.org
Subject: Re: [PATCH -V1] x86: make executable for video bios area
Message-ID: <20111116030009.GA7850@udknight.homenetwork>
Mail-Followup-To: wangyanqing <Udknight@gmail.com>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, castet.matthieu@free.fr, x86@kernel.org
References: <20111115064237.GA3990@udknight.homenetwork>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111115064237.GA3990@udknight.homenetwork>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 02:42:37PM +0800, wangyanqing wrote:
> 5bd5a452662bc37c54fb6828db1a3faf87e6511c make area
> between BIOS_BEGIN and BIOS_END have NX protection
> when boot machine with acpi enable(acpi will disable pcibios).
> 
> This commit make my machine can't boot, system hang with black screen
> very early when I enable CONFIG_FB_UVESA, CONFIG_X86_PAE, CONFIG_ACPI.
> 
> below is the maps when boot normal without acpi:
> 00000000-00001000 rw-s 00000000 00:01 822        /dev/mem
> 00009000-0000a000 r-xp 00001000 00:01 912        /sbin/v86d
> 00010000-00050000 rwxp 00000000 00:01 818        /dev/zero
> 000a0000-000c0000 rw-s 000a0000 00:01 822        /dev/mem
> 000c0000-00100000 r-xs 000c0000 00:01 822        /dev/mem <== must executable
> 08048000-0804c000 r-xp 00001000 00:01 912        /sbin/v86d
> 0804c000-0804d000 rw-p 00004000 00:01 912        /sbin/v86d
> b7875000-b7876000 r-xp 00000000 00:00 0          [vdso]
> bfe9d000-bfebe000 rw-p 00000000 00:00 0          [stack]
> 
> So I prepare this patch.It works with me.
> Any comment is welcome.
> 
> Thanks.
> 
> Signed-off-by: Wang YanQing <Udknight@gmail.com>
> ---
>  arch/x86/include/asm/e820.h |    2 ++
>  arch/x86/mm/pageattr.c      |    3 ++-
>  2 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
> index 908b969..a6fa897 100644
> --- a/arch/x86/include/asm/e820.h
> +++ b/arch/x86/include/asm/e820.h
> @@ -72,6 +72,8 @@ struct e820map {
>  #define BIOS_BEGIN		0x000a0000
>  #define BIOS_END		0x00100000
>  
> +#define BIOS_VIDEO		0x000c0000
> +
>  #define BIOS_ROM_BASE		0xffe00000
>  #define BIOS_ROM_END		0xffffffff
>  
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index f9e5267..12acac0 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -260,7 +260,8 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
>  	 * PCI BIOS based config access (CONFIG_PCI_GOBIOS) support.
>  	 */
>  #ifdef CONFIG_PCI_BIOS
> -	if (pcibios_enabled && within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
> +	if ((pcibios_enabled || within(pfn, BIOS_VIDEO >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT)) &&
> +	     within(pfn, BIOS_BEGIN >> PAGE_SHIFT, BIOS_END >> PAGE_SHIFT))
>  		pgprot_val(forbidden) |= _PAGE_NX;
>  #endif
>  
> -- 
> 1.7.3.4
> 

This issue also imply another question.
mmap on /dev/mem haven't check whether the target area can mmap with the request privilege.
Any comments? Linus
