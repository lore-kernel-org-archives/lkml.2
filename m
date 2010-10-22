Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab0JVMEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 08:04:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36126 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab0JVMEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 08:04:06 -0400
Date: Fri, 22 Oct 2010 14:04:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/9] ACPI, APEI, Add ERST record ID cache
Message-ID: <20101022120404.GF10456@basil.fritz.box>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
 <1287538620-7442-2-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287538620-7442-2-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 09:36:52AM +0800, Huang Ying wrote:
> 1
> 			2
> 3
> 			4
> -1
> 			-1
> 
> where -1 signals there is no more record ID.
> 
> Reader 1 has no chance to check record 2 and 4, while reader 2 has no
> chance to check record 1 and 3. And any other GET_NEXT_RECORD_ID will
> return -1, that is, other readers will has no chance to check any
> record even they are not cleared by anyone.
> 
> This makes raw GET_NEXT_RECORD_ID not suitable for usage of multiple
> users.
> 
> To solve the issue, an in memory ERST record ID cache is designed and
> implemented. When enumerating record ID, the ID returned by
> GET_NEXT_RECORD_ID is added into cache in addition to be returned to
> caller. So other readers can check the cache to get all record ID
> available.

Generally it looks ok, just a minor cleanup nit below.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

> +static int erst_record_id_cache_add_one(void)
> +{
> +	u64 id, prev_id, first_id;
> +	int i, rc;
> +	struct erst_record_id_entry *entries;
> +	unsigned long flags;
> +
> +	id = prev_id = first_id = APEI_ERST_INVALID_RECORD_ID;
> +retry:
> +	spin_lock_irqsave(&erst_lock, flags);
> +	rc = __erst_get_next_record_id(&id);
> +	spin_unlock_irqrestore(&erst_lock, flags);
> +	if (rc == -ENOENT)
> +		return 0;
> +	if (rc)
> +		return rc;
> +	if (id == APEI_ERST_INVALID_RECORD_ID)
> +		return 0;
> +	/* can not skip current ID, or look back to first ID */
> +	if (id == prev_id || id == first_id)
> +		return 0;
> +	if (first_id == APEI_ERST_INVALID_RECORD_ID)
> +		first_id = id;
> +	prev_id = id;
> +
> +	entries = erst_record_id_cache.entries;
> +	for (i = 0; i < erst_record_id_cache.len; i++) {
> +		if (!entries[i].cleared && entries[i].id == id)
> +			break;
> +	}
> +	/* record id already in cache, try next */
> +	if (i < erst_record_id_cache.len)
> +		goto retry;
> +	if (erst_record_id_cache.len >= erst_record_id_cache.size) {
> +		int new_size, alloc_size;
> +		struct erst_record_id_entry *new_entries;
> +
> +		new_size = erst_record_id_cache.size * 2;
> +		new_size = max_t(int, new_size, ERST_RECORD_ID_CACHE_SIZE_MIN);
> +		new_size = min_t(int, new_size, ERST_RECORD_ID_CACHE_SIZE_MAX);

This is clamp_t() 

> +		if (new_size <= erst_record_id_cache.size) {
> +			if (printk_ratelimit())
> +				pr_warning(FW_WARN ERST_PFX
> +					   "too many record ID!\n");
> +			return 0;
> +		}
> +		alloc_size = new_size * sizeof(struct erst_record_id_entry);
> +		if (alloc_size < PAGE_SIZE)
> +			new_entries = kmalloc(alloc_size, GFP_KERNEL);
> +		else
> +			new_entries = vmalloc(alloc_size);

This is essentially kremalloc with vmalloc. Since this a common
pattern it would be nicer to put a generic helper for this somewhere.

-Andi

> +		if (!new_entries)
> +			return -ENOMEM;
> +		memcpy(new_entries, entries,
> +		       erst_record_id_cache.len * sizeof(entries[0]));
> +		if (erst_record_id_cache.size < PAGE_SIZE)
> +			kfree(entries);
> +		else
> +			vfree(entries);

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
