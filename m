Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab1L3RDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 12:03:00 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:38087 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1L3RC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 12:02:58 -0500
MIME-Version: 1.0
Message-ID: <d9558871-53ec-4d49-8df4-c09bee100a49@default>
Date: Fri, 30 Dec 2011 09:02:35 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brian King <brking@linux.vnet.ibm.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: RE: [PATCH] staging: zcache: fix serialization bug in zv stats
References: <<1325263335-16254-1-git-send-email-sjenning@linux.vnet.ibm.com>>
In-Reply-To: <<1325263335-16254-1-git-send-email-sjenning@linux.vnet.ibm.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4EFDEEBB.003D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Friday, December 30, 2011 9:42 AM
> To: Greg Kroah-Hartman
> Cc: Seth Jennings; Dan Magenheimer; Brian King; devel@driverdev.osuosl.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] staging: zcache: fix serialization bug in zv stats
> 
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

I'm inclined to nack this change, at least unless inside an #ifdef DEBUG,
as these counts are interesting to a developer but not useful to a normal
end user, whereas the incremental cost for atomic_inc and atomic_dec are
non-trivial.  I don't think any off-by-one in these counters could
result in a bug and, before promotion from staging, they probably
should just go away.  (They are fun to "watch -d" though ;-)

That said, as a developer, I too am annoyed by the occasional 64-bit
"negative unsigned" that show up in the output but IMHO a good fix for
that might be simply for the "show" routine to convert negative values
to zero before printing.

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
> --
> 1.7.5.4
