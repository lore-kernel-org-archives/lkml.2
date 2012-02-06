Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab2BFVUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:20:09 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:43285 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2BFVUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:20:07 -0500
Message-ID: <4F3043BC.6060301@linux.vnet.ibm.com>
Date: Mon, 06 Feb 2012 15:18:52 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: zcache: fix serialization bug in zv stats
References: <1325263335-16254-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1325263335-16254-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020621-7408-0000-0000-000002711D2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg,

Just wanted to bump this fix again.  It's small and already Acked by
Dan Magenheimer.  It can go in an -rc release.

https://lkml.org/lkml/2011/12/30/48

Congrats on becoming a Linux Foundation Fellow!

--
Seth

On 12/30/2011 10:42 AM, Seth Jennings wrote:
> In a multithreaded workload, the zv_curr_dist_counts
> and zv_cumul_dist_counts statistics are being corrupted
> because the increments and decrements in zv_create
> and zv_free are not atomic.
> 
> This patch converts these statistics and their corresponding
> increments/decrements/reads to atomic operations.
> 
> Based on v3.2-rc7
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  drivers/staging/zcache/zcache-main.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index 56c1f9c..d39bb51 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -655,8 +655,8 @@ static unsigned int zv_max_zsize = (PAGE_SIZE / 8) * 7;
>   */
>  static unsigned int zv_max_mean_zsize = (PAGE_SIZE / 8) * 5;
> 
> -static unsigned long zv_curr_dist_counts[NCHUNKS];
> -static unsigned long zv_cumul_dist_counts[NCHUNKS];
> +static atomic_t zv_curr_dist_counts[NCHUNKS];
> +static atomic_t zv_cumul_dist_counts[NCHUNKS];
> 
>  static struct zv_hdr *zv_create(struct xv_pool *xvpool, uint32_t pool_id,
>  				struct tmem_oid *oid, uint32_t index,
> @@ -675,8 +675,8 @@ static struct zv_hdr *zv_create(struct xv_pool *xvpool, uint32_t pool_id,
>  			&page, &offset, ZCACHE_GFP_MASK);
>  	if (unlikely(ret))
>  		goto out;
> -	zv_curr_dist_counts[chunks]++;
> -	zv_cumul_dist_counts[chunks]++;
> +	atomic_inc(&zv_curr_dist_counts[chunks]);
> +	atomic_inc(&zv_cumul_dist_counts[chunks]);
>  	zv = kmap_atomic(page, KM_USER0) + offset;
>  	zv->index = index;
>  	zv->oid = *oid;
> @@ -698,7 +698,7 @@ static void zv_free(struct xv_pool *xvpool, struct zv_hdr *zv)
> 
>  	ASSERT_SENTINEL(zv, ZVH);
>  	BUG_ON(chunks >= NCHUNKS);
> -	zv_curr_dist_counts[chunks]--;
> +	atomic_dec(&zv_curr_dist_counts[chunks]);
>  	size -= sizeof(*zv);
>  	BUG_ON(size == 0);
>  	INVERT_SENTINEL(zv, ZVH);
> @@ -738,7 +738,7 @@ static int zv_curr_dist_counts_show(char *buf)
>  	char *p = buf;
> 
>  	for (i = 0; i < NCHUNKS; i++) {
> -		n = zv_curr_dist_counts[i];
> +		n = atomic_read(&zv_curr_dist_counts[i]);
>  		p += sprintf(p, "%lu ", n);
>  		chunks += n;
>  		sum_total_chunks += i * n;
> @@ -754,7 +754,7 @@ static int zv_cumul_dist_counts_show(char *buf)
>  	char *p = buf;
> 
>  	for (i = 0; i < NCHUNKS; i++) {
> -		n = zv_cumul_dist_counts[i];
> +		n = atomic_read(&zv_cumul_dist_counts[i]);
>  		p += sprintf(p, "%lu ", n);
>  		chunks += n;
>  		sum_total_chunks += i * n;

