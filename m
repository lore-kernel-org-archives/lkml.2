Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750798Ab2C2EB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 00:01:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:47490 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab2C2EBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 00:01:48 -0400
Message-ID: <1332993706.3010.3.camel@pasglop>
Subject: Re: [PATCH] mm/memblock.c: Correctly check whether to trim a block
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: linux-mm@kvack.org, yinghai@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Thu, 29 Mar 2012 15:01:46 +1100
In-Reply-To: <1332987958-10766-1-git-send-email-lauraa@codeaurora.org>
References: <1332987958-10766-1-git-send-email-lauraa@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 19:25 -0700, Laura Abbott wrote:
> Currently in __memblock_remove, the check to trim the top of
> a block off only checks if the requested base is less than the
> memblock end. If the end of the requested region is equal to
> the start of a memblock, this will incorrectly try to remove
> the block, possibly causing an integer underflow:
> 
>    ---------------------------------------
>    |                    |                |
>    |                    |                |
>   base              end = rgn->base    rend
> 
> An additional check is needed to see if the end of the requested
> region is greater than the memblock region:

__memblock_remove() open coded logic is gone now, re-implemented
in term of memblock_isolate_range()... though I suppose your
patch might have value in -stable...

Cheers,
Ben.


>    ----------------------
>    |                     |
>    |                     |
>   rgn->base    base     rend      end
>                 |                  |
>                 |                  |
>                 --------------------
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
>  mm/memblock.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 5338237..e174ee0 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -459,7 +459,7 @@ static long __init_memblock __memblock_remove(struct memblock_type *type,
>  		}
>  
>  		/* And check if we need to trim the top of a block */
> -		if (base < rend)
> +		if (base < rend && end > rend)
>  			rgn->size -= rend - base;
>  
>  	}


