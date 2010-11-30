Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0K3DHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 22:07:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871Ab0K3DHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 22:07:44 -0500
Date: Mon, 29 Nov 2010 19:07:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v2 3/3] ACPI, APEI, report GHES error information via
 printk
Message-Id: <20101129190700.92bae717.akpm@linux-foundation.org>
In-Reply-To: <1291085501-31494-4-git-send-email-ying.huang@intel.com>
References: <1291085501-31494-1-git-send-email-ying.huang@intel.com>
	<1291085501-31494-4-git-send-email-ying.huang@intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 10:51:41 +0800 Huang Ying <ying.huang@intel.com> wrote:

> printk is one of the methods to report hardware errors to user space.
> This patch implements hardware error reporting for GHES via printk.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  drivers/acpi/apei/ghes.c |   21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -255,11 +255,23 @@ static void ghes_do_proc(struct ghes *gh
>  		}
>  #endif
>  	}
> +}
>  
> -	if (!processed && printk_ratelimit())
> -		pr_warning(GHES_PFX
> -		"Unknown error record from generic hardware error source: %d\n",
> -			   ghes->generic->header.source_id);
> +static void ghes_print_estatus(const char *pfx, struct ghes *ghes)
> +{
> +	if (pfx == NULL) {
> +		if (ghes_severity(ghes->estatus->error_severity) <=
> +		    GHES_SEV_CORRECTED)
> +			pfx = KERN_WARNING HW_ERR;
> +		else
> +			pfx = KERN_ERR HW_ERR;
> +	}
> +	if (printk_ratelimit()) {
> +		printk(
> +	"%s""Hardware error from APEI Generic Hardware Error Source: %d\n",
> +	pfx, ghes->generic->header.source_id);
> +		apei_estatus_print(pfx, ghes->estatus);

That code layout is just ghastly.  Please, if it can't be done nicely
in 80-cols then simply exceed the 80 cols.

And please don't use (or retain) printk_ratelimit().  It was a mistake.
A printk_ratelimt() site shares state with all other
printk_ratelimit() states, so if a random firewire driver is doing a lot of
printk_ratelimit() calls, your messages get suppressed!  Use
printk_ratelimited() or __ratelimit().

>
> ...
>
