Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2D3TTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 15:19:42 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:63402 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515Ab2D3TTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 15:19:40 -0400
Message-ID: <4F9EE5BF.9070005@openvz.org>
Date: Mon, 30 Apr 2012 23:19:27 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pavel Emelianov <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH bugfix] proc/pagemap: correctly report non-present ptes
 and holes between vmas
References: <1335799542-8159-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1335799542-8159-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi wrote:
> Hi,
>
> On Sat, Apr 28, 2012 at 08:22:30PM +0400, Konstantin Khlebnikov wrote:
>> This patch resets current pagemap-entry if current pte isn't present,
>> or if current vma is over. Otherwise pagemap reports last entry again and again.
>>
>> non-present pte reporting was broken in commit v3.3-3738-g092b50b
>> ("pagemap: introduce data structure for pagemap entry")
>>
>> reporting for holes was broken in commit v3.3-3734-g5aaabe8
>> ("pagemap: avoid splitting thp when reading /proc/pid/pagemap")
>>
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> Reported-by: Pavel Emelyanov<xemul@parallels.com>
>> Cc: Naoya Horiguchi<n-horiguchi@ah.jp.nec.com>
>> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>> Cc: Andi Kleen<ak@linux.intel.com>
>
> Thanks for your efforts.
> I confirmed that this patch fixes the problem on v3.4-rc4.
> But originally (before the commits you pointed to above) initializing
> pagemap entries (originally labelled with confusing 'pfn') were done
> in for-loop in pagemap_pte_range(), so I think it's better to get it
> back to things like that.
>
> How about the following?

I don't like this. Functions which returns void should always initialize its "output"
argument, it much more clear than relying on preinitialized value.

> ---
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 2b9a760..538f8d8 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -779,13 +779,14 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>   	struct pagemapread *pm = walk->private;
>   	pte_t *pte;
>   	int err = 0;
> -	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT);
> +	pagemap_entry_t pme;
>
>   	/* find the first VMA at or above 'addr' */
>   	vma = find_vma(walk->mm, addr);
>   	if (pmd_trans_huge_lock(pmd, vma) == 1) {
>   		for (; addr != end; addr += PAGE_SIZE) {
>   			unsigned long offset;
> +			pme = make_pme(PM_NOT_PRESENT);
>
>   			offset = (addr&  ~PAGEMAP_WALK_MASK)>>
>   					PAGE_SHIFT;
> @@ -801,6 +802,7 @@ static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>   	if (pmd_trans_unstable(pmd))
>   		return 0;
>   	for (; addr != end; addr += PAGE_SIZE) {
> +		pme = make_pme(PM_NOT_PRESENT);
>
>   		/* check to see if we've left 'vma' behind
>   		 * and need a new, higher one */
> @@ -842,10 +844,10 @@ static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
>   {
>   	struct pagemapread *pm = walk->private;
>   	int err = 0;
> -	pagemap_entry_t pme = make_pme(PM_NOT_PRESENT);
>
>   	for (; addr != end; addr += PAGE_SIZE) {
>   		int offset = (addr&  ~hmask)>>  PAGE_SHIFT;
> +		pagemap_entry_t pme = make_pme(PM_NOT_PRESENT);
>   		huge_pte_to_pagemap_entry(&pme, *pte, offset);
>   		err = add_to_pagemap(addr,&pme, pm);
>   		if (err)
>
> ---
> Thanks,
> Naoya

