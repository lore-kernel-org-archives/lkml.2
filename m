Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab1BXTBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:01:39 -0500
Received: from www.tglx.de ([62.245.132.106]:42245 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab1BXTBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:01:37 -0500
Date: Thu, 24 Feb 2011 20:01:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] msm: scm: Get cacheline size from CTR
In-Reply-To: <1298573085-23217-5-git-send-email-sboyd@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1102241959290.2701@localhost6.localdomain6>
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org> <1298573085-23217-5-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Stephen Boyd wrote:

> Instead of hardcoding the cacheline size as 32, get the cacheline
> size from the CTR register.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/mach-msm/scm.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/scm.c b/arch/arm/mach-msm/scm.c
> index cfa808d..0528c71 100644
> --- a/arch/arm/mach-msm/scm.c
> +++ b/arch/arm/mach-msm/scm.c
> @@ -26,9 +26,6 @@
>  
>  #include "scm.h"
>  
> -/* Cache line size for msm8x60 */
> -#define CACHELINESIZE 32
> -
>  #define SCM_ENOMEM		-5
>  #define SCM_EOPNOTSUPP		-4
>  #define SCM_EINVAL_ADDR		-3
> @@ -207,6 +204,14 @@ static int __scm_call(const struct scm_command *cmd)
>  	return ret;
>  }
>  
> +static inline u32 dcache_line_size(void)
> +{
> +	u32 ctr;
> +
> +	asm volatile("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
> +	return 4 << ((ctr >> 16) & 0xf);
> +}
> +
>  /**
>   * scm_call() - Send an SCM command
>   * @svc_id: service identifier
> @@ -243,11 +248,13 @@ int scm_call(u32 svc_id, u32 cmd_id, const void *cmd_buf, size_t cmd_len,
>  	do {
>  		u32 start = (u32)rsp;
>  		u32 end = (u32)scm_get_response_buffer(rsp) + resp_len;
> -		start &= ~(CACHELINESIZE - 1);
> +		u32 cacheline_size = dcache_line_size();

And why do you want to do that on every scm_call() invocation and on
every loop of that code? If your dcache_line_size() changes at
runtime, then you might have other problems.

Thanks,

	tglx


