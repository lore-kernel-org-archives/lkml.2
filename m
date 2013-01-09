Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab3AIBzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 20:55:21 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:2691 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab3AIBzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 20:55:19 -0500
Message-ID: <50ECCE00.6040902@huawei.com>
Date: Wed, 9 Jan 2013 09:55:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: use new hashtable implementation
References: <50EBD011.7040801@huawei.com> <20130108181729.GB3926@htj.dyndns.org>
In-Reply-To: <20130108181729.GB3926@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/9 2:17, Tejun Heo wrote:
> Hello, Li.
> 
> On Tue, Jan 08, 2013 at 03:51:45PM +0800, Li Zefan wrote:
>> -static struct hlist_head *css_set_hash(struct cgroup_subsys_state *css[])
>> +static unsigned long css_set_hash(struct cgroup_subsys_state *css[])
>>  {
>>  	int i;
>> -	int index;
>> -	unsigned long tmp = 0UL;
>> +	unsigned long key = 0UL;
>>  
>>  	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++)
>> -		tmp += (unsigned long)css[i];
>> -	tmp = (tmp >> 16) ^ tmp;
>> +		key += (unsigned long)css[i];
>> +	key = (key >> 16) ^ key;
> 
> @key is gonna go through hash function anyway.  Do we still need the
> above (key >> 16) ^ key?  It's not gonna help anything.
> 

Nothing's changed after this patch, so the key will still be passed to
hash_long().

I tested this hash function long ago, and the original version was
without (key >> 16) ^ key, and it produced worse hash collision.

>> -	index = hash_long(tmp, CSS_SET_HASH_BITS);
>> -
>> -	return &css_set_table[index];
>> +	return key;
>>  }
>>  
>>  /* We don't maintain the lists running through each css_set to its
>> @@ -4503,23 +4498,17 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
>>  	 * this is all done under the css_set_lock.
>>  	 */
>>  	write_lock(&css_set_lock);
>> -	for (i = 0; i < CSS_SET_TABLE_SIZE; i++) {
>> -		struct css_set *cg;
>> -		struct hlist_node *node, *tmp;
>> -		struct hlist_head *bucket = &css_set_table[i], *new_bucket;
>> -
>> -		hlist_for_each_entry_safe(cg, node, tmp, bucket, hlist) {
>> -			/* skip entries that we already rehashed */
>> -			if (cg->subsys[ss->subsys_id])
>> -				continue;
>> -			/* remove existing entry */
>> -			hlist_del(&cg->hlist);
>> -			/* set new value */
>> -			cg->subsys[ss->subsys_id] = css;
>> -			/* recompute hash and restore entry */
>> -			new_bucket = css_set_hash(cg->subsys);
>> -			hlist_add_head(&cg->hlist, new_bucket);
>> -		}
>> +	hash_for_each_safe(css_set_table, i, node, tmp, cg, hlist) {
>> +		/* skip entries that we already rehashed */
>> +		if (cg->subsys[ss->subsys_id])
>> +			continue;
>> +		/* remove existing entry */
>> +		hlist_del(&cg->hlist);
> 
> 		hash_del()?
> 

will fix.

