Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429Ab1LQAmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 19:42:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab1LQAmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 19:42:44 -0500
Date: Fri, 16 Dec 2011 16:42:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genalloc: add support of named pool
Message-Id: <20111216164243.01c41930.akpm@linux-foundation.org>
In-Reply-To: <1323359408-24407-1-git-send-email-plagnioj@jcrosoft.com>
References: <1323359408-24407-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Dec 2011 16:50:08 +0100
Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> wrote:

> so we can get the pool in the driver by name instead of passing it via
> parameter

I'm not seeing any code whcih actually uses this interface, so there's
no reason to apply the patch?

The changelog should tell us why you believe this patch is needed: use
case, end-user value, etc.

> --- a/include/linux/genalloc.h
> +++ b/include/linux/genalloc.h
> @@ -33,9 +33,12 @@
>   *  General purpose special memory pool descriptor.
>   */
>  struct gen_pool {
> +	char *name;			/* pool name */
>  	spinlock_t lock;
>  	struct list_head chunks;	/* list of chunks in this pool */
>  	int min_alloc_order;		/* minimum allocation order */
> +
> +	struct list_head list;

The other fields have nice descriptive comments - why shouldn't this one?

> +static LIST_HEAD(pools);

Except for certain special circumstances (which I don't think apply
here), a global list needs a global lock to protect it.

> +
>  static int set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
>  {
>  	unsigned long val, nval;
> @@ -136,23 +138,50 @@ static int bitmap_clear_ll(unsigned long *map, int start, int nr)
>  }
>  
>  /**
> + * gen_pool_byname - get pool by name
> + * @name: pool name
> + *

Remove that empty comment line.

> + */
> +struct gen_pool* gen_pool_byname(char *name)

The patch has several minor coding-style errors which can be detected
by scripts/checkpatch.pl.

> +{
> +	struct gen_pool *pool;
> +
> +	if (!name)
> +		return NULL;
> +
> +	list_for_each_entry(pool, &pools, list) {
> +		if(pool->name && strcmp(pool->name, name) == 0)
> +			return pool;
> +	}
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL(gen_pool_byname);

This function is racy and cannot be fixed.  If some other process comes
along and deletes *pool immediately after this function has completed,
the caller of this function is left holding a dead pointer.


