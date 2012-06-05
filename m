Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2FEUT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 16:19:28 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:48967 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab2FEUT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 16:19:27 -0400
Message-ID: <4FCE69BC.6060300@linux.vnet.ibm.com>
Date: Tue, 05 Jun 2012 15:19:08 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: gregkh@linuxfoundation.org, dan.magenheimer@oracle.com,
        konrad.wilk@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zcache: don't limit number of pools per client
References: <1338894352-23054-1-git-send-email-levinsasha928@gmail.com>
In-Reply-To: <1338894352-23054-1-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060520-4242-0000-0000-000001E0FE9E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 06:05 AM, Sasha Levin wrote:

> Currently the amount of pools each client can use is limited to 16, this is
> and arbitrary limit which isn't really required by current implementation.


Might want to add something like "This places and arbitrary limit on the number of mounted filesystems that can use cleancache"

> 
> This patch removes that limit and uses IDR to do sparse mapping of pools
> in each client.

> 

> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  drivers/staging/zcache/zcache-main.c |   41 +++++++++++++++++++--------------
>  1 files changed, 24 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index 784c796..b068bd8 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c


need to #include <linux/idr.h> yes?

> @@ -53,15 +53,13 @@
>  	(__GFP_FS | __GFP_NORETRY | __GFP_NOWARN | __GFP_NOMEMALLOC)
>  #endif
> 
> -#define MAX_POOLS_PER_CLIENT 16
> -
>  #define MAX_CLIENTS 16
>  #define LOCAL_CLIENT ((uint16_t)-1)
> 
>  MODULE_LICENSE("GPL");
> 
>  struct zcache_client {
> -	struct tmem_pool *tmem_pools[MAX_POOLS_PER_CLIENT];
> +	struct idr tmem_pools;
>  	struct zs_pool *zspool;
>  	bool allocated;
>  	atomic_t refcount;
> @@ -949,11 +947,9 @@ static struct tmem_pool *zcache_get_pool_by_id(uint16_t cli_id, uint16_t poolid)
>  			goto out;
>  		atomic_inc(&cli->refcount);
>  	}
> -	if (poolid < MAX_POOLS_PER_CLIENT) {
> -		pool = cli->tmem_pools[poolid];
> -		if (pool != NULL)
> -			atomic_inc(&pool->refcount);
> -	}
> +	pool = idr_find(&cli->tmem_pools, poolid);
> +	if (pool != NULL)
> +		atomic_inc(&pool->refcount);


This is called on the main path, so it needs to be fast.  There is so much
contention elsewhere in the stack I don't think it'll be an issue. It looks
like idr_find() is fast, even though it contains a loop.  Just needs to be
considered.

>  out:
>  	return pool;
>  }
> @@ -987,6 +983,7 @@ int zcache_new_client(uint16_t cli_id)
>  	cli->zspool = zs_create_pool("zcache", ZCACHE_GFP_MASK);
>  	if (cli->zspool == NULL)
>  		goto out;
> +	idr_init(&cli->tmem_pools);
>  #endif
>  	ret = 0;
>  out:
> @@ -1673,10 +1670,10 @@ static int zcache_destroy_pool(int cli_id, int pool_id)
>  	if (cli == NULL)
>  		goto out;
>  	atomic_inc(&cli->refcount);
> -	pool = cli->tmem_pools[pool_id];
> +	pool = idr_find(&cli->tmem_pools, pool_id);
>  	if (pool == NULL)
>  		goto out;
> -	cli->tmem_pools[pool_id] = NULL;
> +	idr_remove(&cli->tmem_pools, pool_id);
>  	/* wait for pool activity on other cpus to quiesce */
>  	while (atomic_read(&pool->refcount) != 0)
>  		;
> @@ -1696,6 +1693,7 @@ static int zcache_new_pool(uint16_t cli_id, uint32_t flags)
>  	int poolid = -1;
>  	struct tmem_pool *pool;
>  	struct zcache_client *cli = NULL;
> +	int r;
> 
>  	if (cli_id == LOCAL_CLIENT)
>  		cli = &zcache_host;
> @@ -1710,20 +1708,29 @@ static int zcache_new_pool(uint16_t cli_id, uint32_t flags)
>  		goto out;
>  	}
> 
> -	for (poolid = 0; poolid < MAX_POOLS_PER_CLIENT; poolid++)
> -		if (cli->tmem_pools[poolid] == NULL)
> -			break;
> -	if (poolid >= MAX_POOLS_PER_CLIENT) {
> -		pr_info("zcache: pool creation failed: max exceeded\n");
> +retry:
> +	r = idr_pre_get(&cli->tmem_pools, GFP_ATOMIC);

> +	if (r != 1) {
> +		kfree(pool);
> +		pr_info("zcache: pool creation failed: out of memory\n");
> +		goto out;
> +	}
> +	r = idr_get_new(&cli->tmem_pools, pool, &poolid);
> +	switch (r) {
> +	case 0:
> +		break;
> +	case -EAGAIN:
> +		goto retry;
> +	default:
> +		pr_info("zcache: pool creation failed: error %d\n", r);
>  		kfree(pool);
> -		poolid = -1;
>  		goto out;
>  	}
> +


how about:
=====
do {
	r = idr_pre_get(&cli->tmem_pools, GFP_ATOMIC);
	if (r != 1) {
		kfree(pool);
		pr_info("zcache: pool creation failed: out of memory\n");
		goto out;
	}
	r = idr_get_new(&cli->tmem_pools, pool, &poolid);
}
while (r == -EAGAIN)

if (r) {
	pr_info("zcache: pool creation failed: error %d\n", r);
	kfree(pool);
	goto out;
}
=====
so we can lose the label/goto.

Also, do we want GFP_ATOMIC?  Why not GFP_KERNEL?

>  	atomic_set(&pool->refcount, 0);
>  	pool->client = cli;
>  	pool->pool_id = poolid;
>  	tmem_new_pool(pool, flags);
> -	cli->tmem_pools[poolid] = pool;
>  	pr_info("zcache: created %s tmem pool, id=%d, client=%d\n",
>  		flags & TMEM_POOL_PERSIST ? "persistent" : "ephemeral",
>  		poolid, cli_id);


Thanks,
Seth

