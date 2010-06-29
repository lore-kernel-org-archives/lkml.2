Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab0F2Rz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:55:57 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:37267 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab0F2Rzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:55:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 12/25] x86, lmb: Add get_free_all_memory_range()
Date: Tue, 29 Jun 2010 11:56:36 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org> <1277227614-11581-13-git-send-email-yinghai@kernel.org>
In-Reply-To: <1277227614-11581-13-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006291156.38178.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 22, 2010 11:26:41 am Yinghai Lu wrote:

> +	pr_info("Subtract (%d early reservations)\n", count);
> +
> +	for_each_lmb(reserved, r) {
> +		pr_info("  [%010llx - %010llx]\n", (u64)r->base, (u64)r->base + r->size);

Use %pR format and consider adding text to the line, e.g.,
"lmb: early reservation [%#010llx-%#010llx] removed" so that
grep output is useful all by itself, without requiring the
context of the preceding lines.

> +		final_start = PFN_DOWN(r->base);
> +		final_end = PFN_UP(r->base + r->size);
> +		if (final_start >= final_end)
> +			continue;
> +		subtract_range(range, az, final_start, final_end);
> +	}
> +	/* Put region array back ? */
> +	if (lmb.reserved.regions != lmb_reserved_init_regions)
> +		lmb_reserve(__pa(lmb.reserved.regions), sizeof(struct lmb_region) * lmb.reserved.max);
> +}
> +
> +struct count_data {
> +	int nr;
> +};
> +
> +static int __init count_work_fn(unsigned long start_pfn,
> +				unsigned long end_pfn, void *datax)
> +{
> +	struct count_data *data = datax;
> +
> +	data->nr++;
> +
> +	return 0;
> +}
> +
> +static int __init count_early_node_map(int nodeid)
> +{
> +	struct count_data data;
> +
> +	data.nr = 0;
> +	work_with_active_regions(nodeid, count_work_fn, &data);
> +
> +	return data.nr;
> +}
> +
> +int __init get_free_all_memory_range(struct range **rangep, int nodeid)
> +{
> +	int count;
> +	struct range *range;
> +	int nr_range;
> +
> +	count = (lmb.reserved.cnt + count_early_node_map(nodeid)) * 2;
> +
> +	range = find_range_array(count);
> +	nr_range = 0;
> +
> +	/*
> +	 * Use early_node_map[] and lmb.reserved.region to get range array
> +	 * at first
> +	 */
> +	nr_range = add_from_early_node_map(range, count, nr_range, nodeid);
> +#ifdef CONFIG_X86_32
> +	subtract_range(range, count, max_low_pfn, -1ULL);
> +#endif
> +	subtract_lmb_reserved(range, count);
> +	nr_range = clean_sort_range(range, count);
> +
> +	*rangep = range;
> +	return nr_range;
> +}
> +#else
>  void __init lmb_to_bootmem(u64 start, u64 end)
>  {
>  	int count;
> 
