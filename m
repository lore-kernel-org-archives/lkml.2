Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2A0UmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:42:04 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:20877 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2A0UmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:42:01 -0500
Date: Fri, 27 Jan 2012 15:39:28 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] zcache: fix deadlock condition
Message-ID: <20120127203928.GA17285@phenom.dumpdata.com>
References: <356ccc29-31af-4274-b372-c8fd1a9b10cb@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <356ccc29-31af-4274-b372-c8fd1a9b10cb@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F230C12.00A5,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 02:32:51PM -0800, Dan Magenheimer wrote:
> I discovered this deadlock condition awhile ago working on RAMster
> but it affects zcache as well.  The list spinlock must be
> locked prior to the page spinlock and released after.  As
> a result, the page copy must also be done while the locks are held.
> 
> Applies to 3.2.  Konrad, please push (via GregKH?)...
> this is definitely a bug fix so need not be pushed during
> a -rc0 window.

Looks good to me. Greg, could you apply the patch to your tree
please? [Or would you rather I sent an GIT pull?]

Thanks!
> 
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index 56c1f9c..5b9f74e 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -358,8 +358,8 @@ static struct zbud_hdr *zbud_create(uint16_t client_id, uint16_t pool_id,
>  	if (unlikely(zbpg == NULL))
>  		goto out;
>  	/* ok, have a page, now compress the data before taking locks */
> -	spin_lock(&zbpg->lock);
>  	spin_lock(&zbud_budlists_spinlock);
> +	spin_lock(&zbpg->lock);
>  	list_add_tail(&zbpg->bud_list, &zbud_unbuddied[nchunks].list);
>  	zbud_unbuddied[nchunks].count++;
>  	zh = &zbpg->buddy[0];
> @@ -389,12 +389,11 @@ init_zh:
>  	zh->oid = *oid;
>  	zh->pool_id = pool_id;
>  	zh->client_id = client_id;
> -	/* can wait to copy the data until the list locks are dropped */
> -	spin_unlock(&zbud_budlists_spinlock);
> -
>  	to = zbud_data(zh, size);
>  	memcpy(to, cdata, size);
>  	spin_unlock(&zbpg->lock);
> +	spin_unlock(&zbud_budlists_spinlock);
> +
>  	zbud_cumul_chunk_counts[nchunks]++;
>  	atomic_inc(&zcache_zbud_curr_zpages);
>  	zcache_zbud_cumul_zpages++;
