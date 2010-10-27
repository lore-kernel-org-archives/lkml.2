Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887Ab0J0Kk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:40:29 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39216 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab0J0Kk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:40:26 -0400
Date: Wed, 27 Oct 2010 12:40:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
Message-ID: <20101027104020.GA16954@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ian Campbell <ian.campbell@citrix.com>,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 09:50:13AM +0100, Ian Campbell wrote:
> Page tables should always be updated using the proper accessor
> methods. Not doing so bypasses the paravirt infrastructure.
> 
> In this case the failure to do so was exposed under Xen by
> b40827fa7268 "x86-32, mm: Add an initial page table for core
> bootstrapping".
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> ---
>  arch/x86/include/asm/pgtable.h |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index ada823a..0b4c514 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -619,7 +619,10 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
>   */
>  static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
>  {
> -       memcpy(dst, src, count * sizeof(pgd_t));
> +	int i;
> +
> +	for (i=0; i<count; i++)
> +		set_pgd(&dst[i], src[i]);

Hmm, this slows down clone_pgd_range(). It is called at 3 sites total,
two of which happen only on boot in setup_arch() so they can be ignored
but the callchain

copy_process()
...
mm_init()
|->mm_alloc_pgd()
  |->pgd_alloc()
    |->pgd_ctor()
      |->clone_pgd_range()

could become noticeable. To be on the safe side, I'd make
clone_pgd_range() a macro calling either the native or the xen version..

hpa?

-- 
Regards/Gruss,
Boris.
