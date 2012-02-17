Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab2BQNNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:13:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39320 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab2BQNNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:13:47 -0500
Date: Fri, 17 Feb 2012 13:12:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Jon Medhurst <tixy@yxit.co.uk>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sumit Bhattacharya <sumitb@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dma-mapping: fix leak in consistent_init
Message-ID: <20120217131247.GN27825@n2100.arm.linux.org.uk>
References: <1329484195-26361-1-git-send-email-ajeet.yadav.77@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329484195-26361-1-git-send-email-ajeet.yadav.77@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 06:39:55PM +0530, Ajeet Yadav wrote:
> Although the error in this case is unlikely, but logically
> if error occurs then we leak memory.
> 
> Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
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

Please get rid of these unlikelys.  This really isn't a performance
critical path.
