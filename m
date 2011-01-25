Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab1AYWqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:46:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab1AYWqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:46:43 -0500
Date: Tue, 25 Jan 2011 23:46:35 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        =?utf-8?B?QUtQTeOAgA==?= <akpm@linux-foundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>, LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Fix unsuitable behavior for poisoned tail pages of
 THP.
Message-ID: <20110125224635.GL926@random.random>
References: <4D3E63B8.4040701@np.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3E63B8.4040701@np.css.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 02:46:32PM +0900, Jin Dongming wrote:
> When a tail page of THP is poisoned, memory-failure will do
> nothing except setting poison flag, while the expected behavior is
> that the process, who is using the poisoned tail page, should be
> killed.
> 
> The above problem is caused by lru checking of the poisoned tail page
> of THP. Because PG_lru flag is only set on the head page of
> THP, the check always consider the poisoned tail page as NON
> lru page.
> 
> So avoid checking NON lru for THP, as like as hugetlb.
> 
> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  mm/memory-failure.c |   27 +++++++++++++++------------
>  1 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 5396603..44a1bdf 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1046,19 +1046,22 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
>  	 * The check (unnecessarily) ignores LRU pages being isolated and
>  	 * walked by the page reclaim code, however that's not a big loss.
>  	 */
> -	if (!PageLRU(p) && !PageHuge(p))
> -		shake_page(p, 0);
> -	if (!PageLRU(p) && !PageHuge(p)) {
> -		/*
> -		 * shake_page could have turned it free.
> -		 */
> -		if (is_free_buddy_page(p)) {
> -			action_result(pfn, "free buddy, 2nd try", DELAYED);
> -			return 0;
> +	if (!PageCompound(p)) {

Here the check could become a:

        if (!PageHuge(p) && !PageTransCompound(p))

so the whole branch is optimized away at build time when both
hugetlbfs and THP are set =n (or in archs not supporting either of
those).

