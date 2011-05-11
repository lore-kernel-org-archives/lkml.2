Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab1EKQOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:14:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60889 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab1EKQOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:14:06 -0400
Message-ID: <4DCA6593.80403@ru.mvista.com>
Date: Wed, 11 May 2011 14:31:47 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 20/19] ARM: LPAE: Invalidate the TLB before freeing the
 PMD
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com> <1305109399-13156-1-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1305109399-13156-1-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11-05-2011 14:23, Catalin Marinas wrote:

> Similar to the PTE freeing, this patch introduced __pmd_free_tlb() which
> invalidates the TLB before freeing a PMD page. This is needed because on
> newer processors the entry in the upper page table may be cached by the
> TLB and point to random data after the PMD has been freed.

> Signed-off-by: Catalin Marinas<catalin.marinas@arm.com>
> ---

> This patch should be part of the LPAE series but I haven't included it in the
> latest series post.

>   arch/arm/include/asm/tlb.h |   12 +++++++++++-
>   1 files changed, 11 insertions(+), 1 deletions(-)

> diff --git a/arch/arm/include/asm/tlb.h b/arch/arm/include/asm/tlb.h
> index f9f6ecd..ef72f19 100644
> --- a/arch/arm/include/asm/tlb.h
> +++ b/arch/arm/include/asm/tlb.h
> @@ -181,8 +181,18 @@ static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
>   	tlb_remove_page(tlb, pte);
>   }
>
> +static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
> +				  unsigned long addr)
> +{
> +#ifdef CONFIG_ARM_LPAE
> +	tlb_add_flush(tlb, addr);
> +	tlb_flush(tlb);
> +	pmd_free((tlb)->mm, pmdp);

    This is not a macro, so parens around 'tlb' are not needed.

> +#endif
> +}
> +

    Perhaps a better style would be (as SubmittingPatches suggest):

+#ifdef CONFIG_ARM_LPAE
+static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
+				  unsigned long addr)
+{
+	tlb_add_flush(tlb, addr);
+	tlb_flush(tlb);
+	pmd_free(tlb->mm, pmdp);
+}
+#else
+static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmdp,
+				  unsigned long addr) {}
+#endif
+

WBR, Sergei
