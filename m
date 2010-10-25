Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab0JYCIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 22:08:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:63797 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab0JYCIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 22:08:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,233,1286175600"; 
   d="scan'208";a="850622956"
Subject: Re: [PATCH 1/9] ACPI, APEI, Add ERST record ID cache
From: Huang Ying <ying.huang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <20101022120404.GF10456@basil.fritz.box>
References: <1287538620-7442-1-git-send-email-ying.huang@intel.com>
	 <1287538620-7442-2-git-send-email-ying.huang@intel.com>
	 <20101022120404.GF10456@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 10:08:27 +0800
Message-ID: <1287972507.2862.302.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andi,

On Fri, 2010-10-22 at 20:04 +0800, Andi Kleen wrote:
> On Wed, Oct 20, 2010 at 09:36:52AM +0800, Huang Ying wrote:
> > 1
> > 			2
> > 3
> > 			4
> > -1
> > 			-1
> > 
> > where -1 signals there is no more record ID.
> > 
> > Reader 1 has no chance to check record 2 and 4, while reader 2 has no
> > chance to check record 1 and 3. And any other GET_NEXT_RECORD_ID will
> > return -1, that is, other readers will has no chance to check any
> > record even they are not cleared by anyone.
> > 
> > This makes raw GET_NEXT_RECORD_ID not suitable for usage of multiple
> > users.
> > 
> > To solve the issue, an in memory ERST record ID cache is designed and
> > implemented. When enumerating record ID, the ID returned by
> > GET_NEXT_RECORD_ID is added into cache in addition to be returned to
> > caller. So other readers can check the cache to get all record ID
> > available.
> 
> Generally it looks ok, just a minor cleanup nit below.
> 
> Reviewed-by: Andi Kleen <ak@linux.intel.com>

Thanks.

> > +static int erst_record_id_cache_add_one(void)
> > +{
> > +	u64 id, prev_id, first_id;
> > +	int i, rc;
> > +	struct erst_record_id_entry *entries;
> > +	unsigned long flags;
> > +
> > +	id = prev_id = first_id = APEI_ERST_INVALID_RECORD_ID;
> > +retry:
> > +	spin_lock_irqsave(&erst_lock, flags);
> > +	rc = __erst_get_next_record_id(&id);
> > +	spin_unlock_irqrestore(&erst_lock, flags);
> > +	if (rc == -ENOENT)
> > +		return 0;
> > +	if (rc)
> > +		return rc;
> > +	if (id == APEI_ERST_INVALID_RECORD_ID)
> > +		return 0;
> > +	/* can not skip current ID, or look back to first ID */
> > +	if (id == prev_id || id == first_id)
> > +		return 0;
> > +	if (first_id == APEI_ERST_INVALID_RECORD_ID)
> > +		first_id = id;
> > +	prev_id = id;
> > +
> > +	entries = erst_record_id_cache.entries;
> > +	for (i = 0; i < erst_record_id_cache.len; i++) {
> > +		if (!entries[i].cleared && entries[i].id == id)
> > +			break;
> > +	}
> > +	/* record id already in cache, try next */
> > +	if (i < erst_record_id_cache.len)
> > +		goto retry;
> > +	if (erst_record_id_cache.len >= erst_record_id_cache.size) {
> > +		int new_size, alloc_size;
> > +		struct erst_record_id_entry *new_entries;
> > +
> > +		new_size = erst_record_id_cache.size * 2;
> > +		new_size = max_t(int, new_size, ERST_RECORD_ID_CACHE_SIZE_MIN);
> > +		new_size = min_t(int, new_size, ERST_RECORD_ID_CACHE_SIZE_MAX);
> 
> This is clamp_t() 

Yes. Will change it.

> > +		if (new_size <= erst_record_id_cache.size) {
> > +			if (printk_ratelimit())
> > +				pr_warning(FW_WARN ERST_PFX
> > +					   "too many record ID!\n");
> > +			return 0;
> > +		}
> > +		alloc_size = new_size * sizeof(struct erst_record_id_entry);
> > +		if (alloc_size < PAGE_SIZE)
> > +			new_entries = kmalloc(alloc_size, GFP_KERNEL);
> > +		else
> > +			new_entries = vmalloc(alloc_size);
> 
> This is essentially kremalloc with vmalloc. Since this a common
> pattern it would be nicer to put a generic helper for this somewhere.

Yes. But will try to do that in another patch.

Best Regards,
Huang Ying


