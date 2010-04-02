Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab0DBLpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 07:45:47 -0400
Received: from sh.osrg.net ([192.16.179.4]:56976 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293Ab0DBLpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 07:45:40 -0400
Date: Fri, 02 Apr 2010 20:45:35 +0900 (JST)
Message-Id: <20100402.204535.212686355.ryusuke@osrg.net>
To: lihong.hi@gmail.com
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-nilfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] nilfs2: Combine nilfs_btree_alloc_path() and
 nilfs_btree_init_path()
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20100402104206.GB9652@xhl>
References: <20100402104206.GB9652@xhl>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 02 Apr 2010 20:45:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Fri, 2 Apr 2010 18:42:06 +0800, Li Hong <lihong.hi@gmail.com> wrote:
> nilfs_btree_alloc_path() and nilfs_btree_init_path() are bound into each other
> tightly. Make them into one procedure to clearify the logic and avoid some
> misusages.
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>

This patch had a style problem:

 $ scripts/checkpatch.pl ../patch1
 ERROR: code indent should use tabs where possible
 #42: FILE: fs/nilfs2/btree.c:79:
 +        path = kmem_cache_alloc(nilfs_btree_path_cache, GFP_NOFS);$

Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/btree.c |   39 +++++++++++++++++----------------------
>  1 files changed, 17 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index 76c38e3..bb31ab3 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -71,23 +71,16 @@ void nilfs_btree_path_cache_destroy(void)
>  	kmem_cache_destroy(nilfs_btree_path_cache);
>  }
>  
> -static inline struct nilfs_btree_path *nilfs_btree_alloc_path(void)
> +static struct nilfs_btree_path *nilfs_btree_alloc_path(void)
>  {
> -	return kmem_cache_alloc(nilfs_btree_path_cache, GFP_NOFS);
> -}
> -
> -static inline void nilfs_btree_free_path(struct nilfs_btree_path *path)
> -{
> -	kmem_cache_free(nilfs_btree_path_cache, path);
> -}
> +	struct nilfs_btree_path *path;
> +	int level = NILFS_BTREE_LEVEL_DATA;
>  
> -static void nilfs_btree_init_path(struct nilfs_btree_path *path)
> -{
> -	int level;
> +        path = kmem_cache_alloc(nilfs_btree_path_cache, GFP_NOFS);
> +	if (path == NULL)
> +		goto out;
>  
> -	for (level = NILFS_BTREE_LEVEL_DATA;
> -	     level < NILFS_BTREE_LEVEL_MAX;
> -	     level++) {
> +	for (; level < NILFS_BTREE_LEVEL_MAX; level++) {
>  		path[level].bp_bh = NULL;
>  		path[level].bp_sib_bh = NULL;
>  		path[level].bp_index = 0;
> @@ -95,6 +88,14 @@ static void nilfs_btree_init_path(struct nilfs_btree_path *path)
>  		path[level].bp_newreq.bpr_ptr = NILFS_BMAP_INVALID_PTR;
>  		path[level].bp_op = NULL;
>  	}
> +
> +out:
> +	return path;
> +}
> +
> +static inline void nilfs_btree_free_path(struct nilfs_btree_path *path)
> +{
> +	kmem_cache_free(nilfs_btree_path_cache, path);
>  }
>  
>  static void nilfs_btree_release_path(struct nilfs_btree_path *path)
> @@ -566,7 +567,6 @@ static int nilfs_btree_lookup(const struct nilfs_bmap *bmap,
>  	path = nilfs_btree_alloc_path();
>  	if (path == NULL)
>  		return -ENOMEM;
> -	nilfs_btree_init_path(path);
>  
>  	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level);
>  
> @@ -594,7 +594,7 @@ static int nilfs_btree_lookup_contig(const struct nilfs_bmap *bmap,
>  	path = nilfs_btree_alloc_path();
>  	if (path == NULL)
>  		return -ENOMEM;
> -	nilfs_btree_init_path(path);
> +
>  	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level);
>  	if (ret < 0)
>  		goto out;
> @@ -1123,7 +1123,6 @@ static int nilfs_btree_insert(struct nilfs_bmap *bmap, __u64 key, __u64 ptr)
>  	path = nilfs_btree_alloc_path();
>  	if (path == NULL)
>  		return -ENOMEM;
> -	nilfs_btree_init_path(path);
>  
>  	ret = nilfs_btree_do_lookup(btree, path, key, NULL,
>  				    NILFS_BTREE_LEVEL_NODE_MIN);
> @@ -1456,7 +1455,7 @@ static int nilfs_btree_delete(struct nilfs_bmap *bmap, __u64 key)
>  	path = nilfs_btree_alloc_path();
>  	if (path == NULL)
>  		return -ENOMEM;
> -	nilfs_btree_init_path(path);
> +
>  	ret = nilfs_btree_do_lookup(btree, path, key, NULL,
>  				    NILFS_BTREE_LEVEL_NODE_MIN);
>  	if (ret < 0)
> @@ -1488,7 +1487,6 @@ static int nilfs_btree_last_key(const struct nilfs_bmap *bmap, __u64 *keyp)
>  	path = nilfs_btree_alloc_path();
>  	if (path == NULL)
>  		return -ENOMEM;
> -	nilfs_btree_init_path(path);
>  
>  	ret = nilfs_btree_do_lookup_last(btree, path, keyp, NULL);
>  
> @@ -1923,7 +1921,6 @@ static int nilfs_btree_propagate(const struct nilfs_bmap *bmap,
>  	path = nilfs_btree_alloc_path();
>  	if (path == NULL)
>  		return -ENOMEM;
> -	nilfs_btree_init_path(path);
>  
>  	if (buffer_nilfs_node(bh)) {
>  		node = (struct nilfs_btree_node *)bh->b_data;
> @@ -2108,7 +2105,6 @@ static int nilfs_btree_assign(struct nilfs_bmap *bmap,
>  	path = nilfs_btree_alloc_path();
>  	if (path == NULL)
>  		return -ENOMEM;
> -	nilfs_btree_init_path(path);
>  
>  	if (buffer_nilfs_node(*bh)) {
>  		node = (struct nilfs_btree_node *)(*bh)->b_data;
> @@ -2175,7 +2171,6 @@ static int nilfs_btree_mark(struct nilfs_bmap *bmap, __u64 key, int level)
>  	path = nilfs_btree_alloc_path();
>  	if (path == NULL)
>  		return -ENOMEM;
> -	nilfs_btree_init_path(path);
>  
>  	ret = nilfs_btree_do_lookup(btree, path, key, &ptr, level + 1);
>  	if (ret < 0) {
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
