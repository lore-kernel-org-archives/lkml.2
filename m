Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab2K1TNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:13:46 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35634 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab2K1TNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:13:45 -0500
Date: Wed, 28 Nov 2012 14:12:51 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 46/46] x86, mm: Let "memmap=" take more entries one
 time
Message-ID: <20121128191251.GT21266@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
 <1353123563-3103-47-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353123563-3103-47-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 07:39:23PM -0800, Yinghai Lu wrote:
> Current "memmap=" only can take one entry every time.
> when we have more entries, we have to use memmap= for each of them.
> 
> For pxe booting, we have command line length limitation, those extra
> "memmap=" would waste too much space.
> 
> This patch make memmap= could take several entries one time,
> and those entries will be split with ','

You should also document that in Documentation/kernel-parameters.txt?

> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/kernel/e820.c |   16 +++++++++++++++-
>  1 files changed, 15 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index df06ade..d32abea 100644
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
