Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab2BRP6n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 10:58:43 -0500
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:43184 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490Ab2BRP6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 10:58:41 -0500
X-Greylist: delayed 625 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Feb 2012 10:58:41 EST
Message-ID: <1329580713.2448.17.camel@computer2.home>
Subject: Re: [PATCH 2/2] ARM: dma-mapping: fix leak in consistent_init
From: Tixy <tixy@yxit.co.uk>
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sumit Bhattacharya <sumitb@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 18 Feb 2012 15:58:33 +0000
In-Reply-To: <1329484195-26361-1-git-send-email-ajeet.yadav.77@gmail.com>
References: <1329484195-26361-1-git-send-email-ajeet.yadav.77@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Originating-Smarthost01-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 18:39 +0530, Ajeet Yadav wrote:
> Although the error in this case is unlikely, but logically
> if error occurs then we leak memory.
> 
> Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>

If you want to fix all the memory leaks then the page tables allocated
by pte_alloc_kernel() need freeing as well, (and the pud and pmd
tables?).

However, if we run out of memory this early in boot, then the system is
unusable anyway and it doesn't seem worth adding the extra code
complexity to avoid any of these memory leaks.

-- 
Tixy

> ---
>  arch/arm/mm/dma-mapping.c |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> index 04bfa76..b8cf062 100644
> --- a/arch/arm/mm/dma-mapping.c
> +++ b/arch/arm/mm/dma-mapping.c
> @@ -161,7 +161,6 @@ static struct arm_vmregion_head consistent_head = {
>   */
>  static int __init consistent_init(void)
>  {
> -	int ret = 0;
>  	pgd_t *pgd;
>  	pud_t *pud;
>  	pmd_t *pmd;
> @@ -171,7 +170,7 @@ static int __init consistent_init(void)
>  	unsigned long num_ptes = (CONSISTENT_END - base) >> PMD_SHIFT;
>  
>  	consistent_pte = kmalloc(num_ptes * sizeof(pte_t *), GFP_KERNEL);
> -	if (!consistent_pte) {
> +	if (unlikely(!consistent_pte)) {
>  		pr_err("%s: no memory\n", __func__);
>  		return -ENOMEM;
>  	}
> @@ -183,32 +182,33 @@ static int __init consistent_init(void)
>  		pgd = pgd_offset(&init_mm, base);
>  
>  		pud = pud_alloc(&init_mm, pgd, base);
> -		if (!pud) {
> +		if (unlikely(!pud)) {
>  			printk(KERN_ERR "%s: no pud tables\n", __func__);
> -			ret = -ENOMEM;
> -			break;
> +			goto err;
>  		}
>  
>  		pmd = pmd_alloc(&init_mm, pud, base);
> -		if (!pmd) {
> +		if (unlikely(!pmd)) {
>  			printk(KERN_ERR "%s: no pmd tables\n", __func__);
> -			ret = -ENOMEM;
> -			break;
> +			goto err;
>  		}
>  		WARN_ON(!pmd_none(*pmd));
>  
>  		pte = pte_alloc_kernel(pmd, base);
> -		if (!pte) {
> +		if (unlikely(!pte)) {
>  			printk(KERN_ERR "%s: no pte tables\n", __func__);
> -			ret = -ENOMEM;
> -			break;
> +			goto err;
>  		}
>  
>  		consistent_pte[i++] = pte;
>  		base += PMD_SIZE;
>  	} while (base < CONSISTENT_END);
>  
> -	return ret;
> +	return 0;
> +err:
> +	kfree(consistent_pte);
> +	consistent_pte = NULL;
> +	return -ENOMEM;
>  }
>  
>  core_initcall(consistent_init);



