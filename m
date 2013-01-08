Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab3AHSRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:17:36 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46584 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab3AHSRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:17:34 -0500
Date: Tue, 8 Jan 2013 10:17:29 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: use new hashtable implementation
Message-ID: <20130108181729.GB3926@htj.dyndns.org>
References: <50EBD011.7040801@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EBD011.7040801@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Tue, Jan 08, 2013 at 03:51:45PM +0800, Li Zefan wrote:
> -static struct hlist_head *css_set_hash(struct cgroup_subsys_state *css[])
> +static unsigned long css_set_hash(struct cgroup_subsys_state *css[])
>  {
>  	int i;
> -	int index;
> -	unsigned long tmp = 0UL;
> +	unsigned long key = 0UL;
>  
>  	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
> -		tmp += (unsigned long)css[i];
> -	tmp = (tmp >> 16) ^ tmp;
> +		key += (unsigned long)css[i];
> +	key = (key >> 16) ^ key;

@key is gonna go through hash function anyway.  Do we still need the
above (key >> 16) ^ key?  It's not gonna help anything.

> -	index = hash_long(tmp, CSS_SET_HASH_BITS);
> -
> -	return &css_set_table[index];
> +	return key;
>  }
>  
>  /* We don't maintain the lists running through each css_set to its
> @@ -4503,23 +4498,17 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
>  	 * this is all done under the css_set_lock.
>  	 */
>  	write_lock(&css_set_lock);
> -	for (i = 0; i < CSS_SET_TABLE_SIZE; i++) {
> -		struct css_set *cg;
> -		struct hlist_node *node, *tmp;
> -		struct hlist_head *bucket = &css_set_table[i], *new_bucket;
> -
> -		hlist_for_each_entry_safe(cg, node, tmp, bucket, hlist) {
> -			/* skip entries that we already rehashed */
> -			if (cg->subsys[ss->subsys_id])
> -				continue;
> -			/* remove existing entry */
> -			hlist_del(&cg->hlist);
> -			/* set new value */
> -			cg->subsys[ss->subsys_id] = css;
> -			/* recompute hash and restore entry */
> -			new_bucket = css_set_hash(cg->subsys);
> -			hlist_add_head(&cg->hlist, new_bucket);
> -		}
> +	hash_for_each_safe(css_set_table, i, node, tmp, cg, hlist) {
> +		/* skip entries that we already rehashed */
> +		if (cg->subsys[ss->subsys_id])
> +			continue;
> +		/* remove existing entry */
> +		hlist_del(&cg->hlist);

		hash_del()?

Thanks.

-- 
tejun
