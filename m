Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab2HCSA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 14:00:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43401 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab2HCSA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 14:00:57 -0400
Subject: Re: [RFC v2 7/7] net,9p: use new hashtable implementation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org
In-Reply-To: <1344003788-1417-8-git-send-email-levinsasha928@gmail.com>
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com>
	 <1344003788-1417-8-git-send-email-levinsasha928@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Aug 2012 20:00:51 +0200
Message-ID: <1344016851.9299.1415.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-03 at 16:23 +0200, Sasha Levin wrote:
> Switch 9p error table to use the new hashtable implementation. This reduces the amount of
> generic unrelated code in 9p.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  net/9p/error.c |   17 ++++++++---------
>  1 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/net/9p/error.c b/net/9p/error.c
> index 2ab2de7..f1037db 100644
> --- a/net/9p/error.c
> +++ b/net/9p/error.c
> @@ -34,7 +34,7 @@
>  #include <linux/jhash.h>
>  #include <linux/errno.h>
>  #include <net/9p/9p.h>
> -
> +#include <linux/hashtable.h>
>  /**
>   * struct errormap - map string errors from Plan 9 to Linux numeric ids
>   * @name: string sent over 9P
> @@ -50,8 +50,8 @@ struct errormap {
>  	struct hlist_node list;
>  };
>  
> -#define ERRHASHSZ		32
> -static struct hlist_head hash_errmap[ERRHASHSZ];


> +#define ERRHASHSZ 5

This name is confusing, it should mention SHIFT or BITS maybe...


> +DEFINE_STATIC_HASHTABLE(hash_errmap, ERRHASHSZ);
>  
>  /* FixMe - reduce to a reasonable size */
>  static struct errormap errmap[] = {
> @@ -196,15 +196,14 @@ int p9_error_init(void)
>  	int bucket;

remove "int bucket" and use :

	u32 hash;

>  
>  	/* initialize hash table */
> -	for (bucket = 0; bucket < ERRHASHSZ; bucket++)
> -		INIT_HLIST_HEAD(&hash_errmap[bucket]);
> +	hash_init(&hash_errmap, ERRHASHSZ);

Why is hash_init() even needed ?

If hash is "DEFINE_STATIC_HASHTABLE(...)", its already ready for use !

>  
>  	/* load initial error map into hash table */
>  	for (c = errmap; c->name != NULL; c++) {
>  		c->namelen = strlen(c->name);
> -		bucket = jhash(c->name, c->namelen, 0) % ERRHASHSZ;
> +		bucket = jhash(c->name, c->namelen, 0);

bucket is a wrong name here, its more like "key" or "hash"

>  		INIT_HLIST_NODE(&c->list);
> -		hlist_add_head(&c->list, &hash_errmap[bucket]);
> +		hash_add(&hash_errmap, &c->list, bucket);
>  	}
>  
>  	return 1;
> @@ -228,8 +227,8 @@ int p9_errstr2errno(char *errstr, int len)
>  	errno = 0;
>  	p = NULL;
>  	c = NULL;
> -	bucket = jhash(errstr, len, 0) % ERRHASHSZ;
> -	hlist_for_each_entry(c, p, &hash_errmap[bucket], list) {
> +	bucket = jhash(errstr, len, 0);

	hash = jhash(errstr, len, 0);

> +	hash_for_each_possible(&hash_errmap, p, c, list, bucket) {
>  		if (c->namelen == len && !memcmp(c->name, errstr, len)) {
>  			errno = c->val;
>  			break;


