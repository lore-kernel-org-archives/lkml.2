Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab2CPFAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 01:00:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53427 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2CPFAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 01:00:45 -0400
Message-ID: <1331874035.2790.5.camel@aks>
Subject: Re: [RFC 2/2] kvm: guest-side changes for tmem on KVM
From: Akshay Karle <akshay.a.karle@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, Dan Magenheimer <dan.magenheimer@oracle.com>,
        kvm@vger.kernel.org, ashu tripathi <er.ashutripathi@gmail.com>,
        nishant gulhane <nishant.s.gulhane@gmail.com>,
        Shreyas Mahure <shreyas.mahure@gmail.com>,
        amarmore2006 <amarmore2006@gmail.com>,
        mahesh mohan <mahesh6490@gmail.com>
Date: Fri, 16 Mar 2012 10:30:35 +0530
In-Reply-To: <20120315170316.GM30250@phenom.dumpdata.com>
References: <1331226157.2585.33.camel@aks>
	 <20120315170316.GM30250@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +/* kvm tmem foundation ops/hypercalls */
>> +
>> +static inline int kvm_tmem_op(u32 tmem_cmd, u32 tmem_pool, struct tmem_oid oid,
>> +	u32 index, u32 tmem_offset, u32 pfn_offset, unsigned long pfn, u32 len, uint16_t cli_id)
>
> That is rather long list of arguments. Could you pass in a structure instead?
>
> Are you actually using all of the arguments in every call?

For different functions different parameters are used. If we want to reduce the number of arguments,
the tmem_ops structure can be created in the functions calling kvm_tmem_op instead of creating it here
and that can be passed, will make these changes in the next patch.

>> +{
>> +	struct tmem_ops op;
>> +	int rc = 0;
>> +	op.cmd = tmem_cmd;
>> +	op.pool_id = tmem_pool;
>> +	op.u.gen.oid[0] = oid.oid[0];
>> +	op.u.gen.oid[1] = oid.oid[1];
>> +	op.u.gen.oid[2] = oid.oid[2];
>> +	op.u.gen.index = index;
>> +	op.u.gen.tmem_offset = tmem_offset;
>> +	op.u.gen.pfn_offset = pfn_offset;
>> +	op.u.gen.pfn = pfn;
>> +	op.u.gen.len = len;
>> +	op.u.gen.cli_id = cli_id;
>> +	rc = kvm_hypercall1(KVM_HC_TMEM, virt_to_phys(&op));
>> +	rc = rc + 1000;
>
> Why the addition?

If you notice the host patch I had subtracted 1000 while passing the return value
in the kvm_emulate_hypercall function. This was to avoid the guest kernel panic due to
the return of a non-negative value by the kvm_hypercall. In order to get the original value
back I added 1000.

>> +	return rc;
>> +}
>> +
>> +static int kvm_tmem_new_pool(uint16_t cli_id,
>> +				u32 flags, unsigned long pagesize)
>> +{
>> +	struct tmem_ops op;
>> +	int rc, pageshift;
>> +	for (pageshift = 0; pagesize != 1; pageshift++)
>> +		pagesize >>= 1;
>> +	flags |= (pageshift - 12) << TMEM_POOL_PAGESIZE_SHIFT;
>
> Instead of 12, just use PAGE_SHIFT

Yeah will do it.

>> +static int kvm_tmem_enabled;
>> +
>> +static int __init enable_tmem_kvm(char *s)
>> +{
>> +	kvm_tmem_enabled = 1;
>> +	return 1;
>> +}
>> +__setup("tmem", enable_tmem_kvm);
>
> I would say do it the other way around. Provide an argument
> to disable it.

Will do.

>> +
>> +/* cleancache ops */
>> +
>> +#ifdef CONFIG_CLEANCACHE
>> +static void tmem_cleancache_put_page(int pool, struct cleancache_filekey key,
>> +				     pgoff_t index, struct page *page)
>> +{
>> +	u32 ind = (u32) index;
>> +	struct tmem_oid oid = *(struct tmem_oid *)&key;
>> +	unsigned long pfn = page_to_pfn(page);
>> +
>> +	if (pool < 0)
>> +		return;
>> +	if (ind != index)
>> +		return;
>> +	mb(); /* ensure page is quiescent; tmem may address it with an alias */
>
> Can you explain this some more please?

Sorry Konrad but I'm not sure about why this is used. We used the Xen's code by Dan
and I didn't understand what this function does exactly and I did not want to mess 
around so I kept the code as it is. Maybe Dan can help answering this one.

>> +static int tmem_cleancache_get_page(int pool, struct cleancache_filekey key,
>> +				    pgoff_t index, struct page *page)
>> +{
>> +	u32 ind = (u32) index;
>> +	struct tmem_oid oid = *(struct tmem_oid *)&key;
>> +	unsigned long pfn = page_to_pfn(page);
>> +	int ret;
>> +
>> +	/* translate return values to linux semantics */
>
> Hm.. What Linux semantics? -1? Can't it deal with -ENODEV and such?

If you check the cleancache_get_page usage in the kernel(while reading any page), 
its in a if or a while statement just checking if the function is returning 0.
And the "failure" of retrieval of page from cleancache simply results in a read from
the disk so there seems no need to return errno's like -ENODEV.

>> +static int tmem_frontswap_get_page(unsigned type, pgoff_t offset,
>> +				   struct page *page)
>> +{
>> +	u64 ind64 = (u64)offset;
>> +	u32 ind = (u32)offset;
>> +	unsigned long pfn = page_to_pfn(page);
>> +	int pool = tmem_frontswap_poolid;
>> +	int ret;
>> +
>> +	if (pool < 0)
>> +		return -1;
>> +	if (ind64 != ind)
>> +		return -1;
>> +	ret = kvm_tmem_get_page(pool, oswiz(type, ind), iswiz(ind), pfn);
>> +	/* translate kvm tmem return values to linux semantics */
>> +	return ret;
>
> So shouldn't you do something like:
> 	return (ret ? 0 : -1) 
> ?

If its to be done this way, shouldn't it be:
	return (!ret ? 0  : -1)
Because kvm_tmem_get is returning 0 for success and otherwise -1.
But this is not needed, as kvm_tmem_get_page returns the 0 or -1 only so return ret
should also work right?

We also need help in benchmarking tmem. We don't know any benchmarking tool or command
for memory management. If there are any linux commands/scripts or tools for testing memory
like we have httperf for server load testing, that will ease down the process of collecting
results.

Also I forgot to mention earlier, thanks for your review Konrad and Bobby!

---
Regards,
Akshay

