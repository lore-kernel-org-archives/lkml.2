Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab2KTPvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:51:14 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:58882 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2KTPvN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Tue, 20 Nov 2012 10:51:13 -0500
Message-Id: <50ABB53702000078000AA11D@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Tue, 20 Nov 2012 15:52:07 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <andrew.cooper3@citrix.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <kexec@lists.infradead.org>,
        <virtualization@lists.linux-foundation.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <ebiederm@xmission.com>, <hpa@zytor.com>
Subject: Re: [PATCH v2 02/11] x86/kexec: Add extra pointers to
 transition page table PGD, PUD, PMD and PTE
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
 <1353423893-23125-3-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1353423893-23125-3-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.11.12 at 16:04, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> Some implementations (e.g. Xen PVOPS) could not use part of identity page 
> table
> to construct transition page table. It means that they require separate 
> PUDs,
> PMDs and PTEs for virtual and physical (identity) mapping. To satisfy that
> requirement add extra pointer to PGD, PUD, PMD and PTE and align existing 
> code.

As said for v1 already - this is not really a requirement of the
interface, or else none of our Xen kernels since 2.6.30 would
have worked. I don't think it is desirable to introduce overhead
for everyone if it's not even needed for Xen.

Jan

> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> ---
>  arch/x86/include/asm/kexec.h       |   10 +++++++---
>  arch/x86/kernel/machine_kexec_64.c |   12 ++++++------
>  2 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
> index 317ff17..3cf5600 100644
> --- a/arch/x86/include/asm/kexec.h
> +++ b/arch/x86/include/asm/kexec.h
> @@ -157,9 +157,13 @@ struct kimage_arch {
>  };
>  #else
>  struct kimage_arch {
> -	pud_t *pud;
> -	pmd_t *pmd;
> -	pte_t *pte;
> +	pgd_t *pgd;
> +	pud_t *pud0;
> +	pud_t *pud1;
> +	pmd_t *pmd0;
> +	pmd_t *pmd1;
> +	pte_t *pte0;
> +	pte_t *pte1;
>  };
>  #endif
>  
> diff --git a/arch/x86/kernel/machine_kexec_64.c 
> b/arch/x86/kernel/machine_kexec_64.c
> index b3ea9db..976e54b 100644
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -137,9 +137,9 @@ out:
>  
>  static void free_transition_pgtable(struct kimage *image)
>  {
> -	free_page((unsigned long)image->arch.pud);
> -	free_page((unsigned long)image->arch.pmd);
> -	free_page((unsigned long)image->arch.pte);
> +	free_page((unsigned long)image->arch.pud0);
> +	free_page((unsigned long)image->arch.pmd0);
> +	free_page((unsigned long)image->arch.pte0);
>  }
>  
>  static int init_transition_pgtable(struct kimage *image, pgd_t *pgd)
> @@ -157,7 +157,7 @@ static int init_transition_pgtable(struct kimage *image, 
> pgd_t *pgd)
>  		pud = (pud_t *)get_zeroed_page(GFP_KERNEL);
>  		if (!pud)
>  			goto err;
> -		image->arch.pud = pud;
> +		image->arch.pud0 = pud;
>  		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
>  	}
>  	pud = pud_offset(pgd, vaddr);
> @@ -165,7 +165,7 @@ static int init_transition_pgtable(struct kimage *image, 
> pgd_t *pgd)
>  		pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
>  		if (!pmd)
>  			goto err;
> -		image->arch.pmd = pmd;
> +		image->arch.pmd0 = pmd;
>  		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
>  	}
>  	pmd = pmd_offset(pud, vaddr);
> @@ -173,7 +173,7 @@ static int init_transition_pgtable(struct kimage *image, 
> pgd_t *pgd)
>  		pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
>  		if (!pte)
>  			goto err;
> -		image->arch.pte = pte;
> +		image->arch.pte0 = pte;
>  		set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
>  	}
>  	pte = pte_offset_kernel(pmd, vaddr);
> -- 
> 1.5.6.5



