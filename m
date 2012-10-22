Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab2JVPbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:31:41 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:50710 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab2JVPbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:31:38 -0400
Date: Mon, 22 Oct 2012 11:19:27 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/19] x86, mm: Let "memmap=" take more entries one time
Message-ID: <20121022151927.GG22780@phenom.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
 <1350593430-24470-22-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350593430-24470-22-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 01:50:29PM -0700, Yinghai Lu wrote:
> Current "memmap=" only can take one entry every time.
> when we have more entries, we have to use memmap= for each of them.
> 
> For pxe booting, we have command line length limitation, those extra
> "memmap=" would waste too much space.
> 
> This patch make memmap= could take several entries one time,
> and those entries will be split with ','

Um, not sure what this patch has to do with this patchset?
Should this be sent seperatly?

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/kernel/e820.c |   16 +++++++++++++++-
>  1 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index ed858e9..f281328 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -835,7 +835,7 @@ static int __init parse_memopt(char *p)
>  }
>  early_param("mem", parse_memopt);
>  
> -static int __init parse_memmap_opt(char *p)
> +static int __init parse_memmap_one(char *p)
>  {
>  	char *oldp;
>  	u64 start_at, mem_size;
> @@ -877,6 +877,20 @@ static int __init parse_memmap_opt(char *p)
>  
>  	return *p == '\0' ? 0 : -EINVAL;
>  }
> +static int __init parse_memmap_opt(char *str)
> +{
> +	while (str) {
> +		char *k = strchr(str, ',');
> +
> +		if (k)
> +			*k++ = 0;
> +
> +		parse_memmap_one(str);
> +		str = k;
> +	}
> +
> +	return 0;
> +}
>  early_param("memmap", parse_memmap_opt);
>  
>  void __init finish_e820_parsing(void)
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
