Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab2GZFqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 01:46:39 -0400
Received: from claw.goop.org ([74.207.240.146]:45853 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab2GZFqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 01:46:38 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jul 2012 01:46:38 EDT
Message-ID: <5010D82C.4050802@goop.org>
Date: Wed, 25 Jul 2012 22:39:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Yuanhan Liu <yliu.null@gmail.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/mm: stop allocating pmd page if failed
References: <1343135751-8336-1-git-send-email-yliu.null@gmail.com>
In-Reply-To: <1343135751-8336-1-git-send-email-yliu.null@gmail.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 06:15 AM, Yuanhan Liu wrote:
> The old code would call __get_free_page() even though previous
> allocation fail met. This is not needed.

Yeah, I guess, but its hardly worth changing.

    J


>
> Signed-off-by: Yuanhan Liu <yliu.null@gmail.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/mm/pgtable.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index 8573b83..6760348 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -181,24 +181,24 @@ static void free_pmds(pmd_t *pmds[])
>  {
>  	int i;
>  
> -	for(i = 0; i < PREALLOCATED_PMDS; i++)
> -		if (pmds[i])
> -			free_page((unsigned long)pmds[i]);
> +	for(i = 0; i < PREALLOCATED_PMDS; i++) {
> +		if (pmds[i] == NULL)
> +			break;
> +		free_page((unsigned long)pmds[i]);
> +	}
>  }
>  
>  static int preallocate_pmds(pmd_t *pmds[])
>  {
>  	int i;
> -	bool failed = false;
>  
>  	for(i = 0; i < PREALLOCATED_PMDS; i++) {
> -		pmd_t *pmd = (pmd_t *)__get_free_page(PGALLOC_GFP);
> -		if (pmd == NULL)
> -			failed = true;
> -		pmds[i] = pmd;
> +		pmds[i] = (pmd_t *)__get_free_page(PGALLOC_GFP);
> +		if (pmds[i] == NULL)
> +			break;
>  	}
>  
> -	if (failed) {
> +	if (i < PREALLOCATED_PMDS) {
>  		free_pmds(pmds);
>  		return -ENOMEM;
>  	}

