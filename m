Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865Ab1AFQSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:18:17 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:36319 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751257Ab1AFQSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:18:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=amUoe6
	ONVDaIDesiCRjA6vyg5TCGX/tF9hg62+1c0PmVEaHurXXTdGyGFoSS7WhfJMIdN3
	tOUJizFpOy9ixFQAepMseer/79dW3k2omorarq0KiGjFg9u810wusefOdOkacfwB
	esKWWGXVZW+czZ7dcX+fY0uiHX5wP58ENwomM=
Message-ID: <4D25EB30.4020905@pobox.com>
Date: Fri, 07 Jan 2011 01:17:52 +0900
From: Shinya Kuribayashi <skuribay@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13)
 Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, macro@linux-mips.org,
        raiko@niisi.msk.ru, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, skuribay@pobox.com
Subject: Re: [PATCH RESEND 1/6] MIPS: sync after cacheflush
References: <8eec0c63f92528c501c0e6a0c8396359@localhost>
In-Reply-To: <8eec0c63f92528c501c0e6a0c8396359@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 8B7BBEFC-19B0-11E0-81CE-DD55F7BC62F2-47602734!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sorry for my silence for several resending posts.  I talked with Ralf
on this briefly, when the patch was posted for the first time last
year.  He seems busy these days, so I'm trying to move things forward.

On 01/06/2011 04:31 PM, Kevin Cernekee wrote:
> On processors with deep write buffers, it is likely that many cycles
> will pass between a CACHE instruction and the time the data actually
> gets written out to DRAM.  Add a SYNC instruction to ensure that the
> buffers get emptied before the flush functions return.

Having a talk with appropriate people (probably including MIPS guys),
such CACHE behavior would be eventually considered to be _legitimate_,
Ralf said.  Thus we agree with this change required not only for BMIPS
cores, but also for the rest of processors, as one of cache features.

The problem is how to implement it.

Most of SYNC-equipped processors work fine without this treatment,
so unless it's required, we don't want to have __sync() after every
cacheflush operations.  Having SYNC there is somewhat waste of time.

> diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
> index b4923a7..dc5d9c4 100644
> --- a/arch/mips/mm/c-r4k.c
> +++ b/arch/mips/mm/c-r4k.c
> @@ -604,6 +604,7 @@ static void r4k_dma_cache_wback_inv(unsigned long addr, unsigned long size)
>  			r4k_blast_scache();
>  		else
>  			blast_scache_range(addr, addr + size);
> +		__sync();
>  		return;
>  	}
>  

Just random thought, how it's going to be when implementing this as,
- sort of barrier
- sort of hazard
- one of cache features (e.g., cpu_has_xxx or similar way)
- and so on...

Another concern is that, except for four __sync() insertions, are we
missing other places?

Ralf also thinks that run-time probe & detection would be better than
build-time configuration.  Optimization is easy and won't be problem
here, so we'd like to keep things synthesized as much as possible.

I couldn't imagine the final shape how this patch should be as of now,
sorry!

  Shinya
