Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2KMHVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:21:11 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:44090 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab2KMHVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:21:08 -0500
Date: Tue, 13 Nov 2012 08:21:01 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Shan Wei <shanwei88@gmail.com>
Cc: David Miller <davem@davemloft.net>, NetDev <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org
Subject: Re: [PATCH v4 3/9] net: xfrm: use __this_cpu_read per-cpu helper
Message-ID: <20121113072101.GG22290@secunet.com>
References: <50A1A7C9.3060703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A1A7C9.3060703@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 13 Nov 2012 07:21:02.0051 (UTC) FILETIME=[6F8ACB30:01CDC16F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 09:52:09AM +0800, Shan Wei wrote:
> From: Shan Wei <davidshan@tencent.com>
> 

Please add a proper commit message, explaining why you do this change.

> 
> Signed-off-by: Shan Wei <davidshan@tencent.com>
> ---
> v4:
>   derefrence pointer before reading to avoid compile warning.
> ---
>  net/xfrm/xfrm_ipcomp.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
> index e5246fb..2906d52 100644
> --- a/net/xfrm/xfrm_ipcomp.c
> +++ b/net/xfrm/xfrm_ipcomp.c
> @@ -276,18 +276,16 @@ static struct crypto_comp * __percpu *ipcomp_alloc_tfms(const char *alg_name)
>  	struct crypto_comp * __percpu *tfms;
>  	int cpu;
>  
> -	/* This can be any valid CPU ID so we don't need locking. */
> -	cpu = raw_smp_processor_id();
>  
>  	list_for_each_entry(pos, &ipcomp_tfms_list, list) {
>  		struct crypto_comp *tfm;
>  
> -		tfms = pos->tfms;
> -		tfm = *per_cpu_ptr(tfms, cpu);
> +		/* This can be any valid CPU ID so we don't need locking. */
> +		tfm = __this_cpu_read(*pos->tfms);

This should just fetch the tfm pointer, so why exactly __this_cpu_read
is better than __this_cpu_ptr? Please keep in mind that performance is
not the most important thing here. It's much more important that it
works in any case.
