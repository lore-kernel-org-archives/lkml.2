Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab1HWSFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 14:05:24 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35807 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1HWSFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 14:05:21 -0400
Message-ID: <4E53DDC7.3040702@linux.vnet.ibm.com>
Date: Tue, 23 Aug 2011 12:05:11 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: cascardo@holoscopio.com, dan.magenheimer@oracle.com, rdunlap@xenotime.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] staging: zcache: fix highmem crash on 32-bit
References: <1314115590-20942-1-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1314115590-20942-1-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please disregard, I sent this one out before on 8/10 :-/

Sorry for the noise.

I couldn't find the original post in the LKML archives, 
so I thought I had never sent it.  Turns out that I only 
sent it to the driver project list.

On 08/23/2011 11:06 AM, Seth Jennings wrote:
> After commit 966b9016a1, zcache_put_page() was modified to pass
> page_address(page) instead of the actual page pointer. In
> combination with the function signature changes to tmem_put()
> and zcache_pampd_create(), zcache_pampd_create() tries to (re)derive
> the page structure from the virtual address.  However, if the
> original page is a high memory page (or any unmapped page),
> this virt_to_page() fails because the page_address() in
> zcache_put_page() returned NULL.
> 
> This patch changes zcache_put_page() and zcache_get_page() to pass
> the page structure instead of the page's virtual address, which
> may or may not exist.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  drivers/staging/zcache/zcache-main.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index 855a5bb..a3f5162 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -1158,7 +1158,7 @@ static void *zcache_pampd_create(char *data, size_t size, bool raw, int eph,
>  	size_t clen;
>  	int ret;
>  	unsigned long count;
> -	struct page *page = virt_to_page(data);
> +	struct page *page = (struct page *)(data);
>  	struct zcache_client *cli = pool->client;
>  	uint16_t client_id = get_client_id_from_client(cli);
>  	unsigned long zv_mean_zsize;
> @@ -1227,7 +1227,7 @@ static int zcache_pampd_get_data(char *data, size_t *bufsize, bool raw,
>  	int ret = 0;
> 
>  	BUG_ON(is_ephemeral(pool));
> -	zv_decompress(virt_to_page(data), pampd);
> +	zv_decompress((struct page *)(data), pampd);
>  	return ret;
>  }
> 
> @@ -1539,7 +1539,7 @@ static int zcache_put_page(int cli_id, int pool_id, struct tmem_oid *oidp,
>  		goto out;
>  	if (!zcache_freeze && zcache_do_preload(pool) == 0) {
>  		/* preload does preempt_disable on success */
> -		ret = tmem_put(pool, oidp, index, page_address(page),
> +		ret = tmem_put(pool, oidp, index, (char *)(page),
>  				PAGE_SIZE, 0, is_ephemeral(pool));
>  		if (ret < 0) {
>  			if (is_ephemeral(pool))
> @@ -1572,7 +1572,7 @@ static int zcache_get_page(int cli_id, int pool_id, struct tmem_oid *oidp,
>  	pool = zcache_get_pool_by_id(cli_id, pool_id);
>  	if (likely(pool != NULL)) {
>  		if (atomic_read(&pool->obj_count) > 0)
> -			ret = tmem_get(pool, oidp, index, page_address(page),
> +			ret = tmem_get(pool, oidp, index, (char *)(page),
>  					&size, 0, is_ephemeral(pool));
>  		zcache_put_pool(pool);
>  	}

