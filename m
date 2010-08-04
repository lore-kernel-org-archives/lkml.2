Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab0HDCg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:36:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48872 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab0HDCg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:36:26 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 4 Aug 2010 11:31:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrea Gelmini <andrea.gelmini@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>, nigel@tuxonice.net,
        stable@kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [BUGFIX][PATCH] fix corruption of hibernation caused by reusing
 swap at saving image
Message-Id: <20100804113122.071a6b8c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100804105054.af68ee5c.kamezawa.hiroyu@jp.fujitsu.com>
References: <201007282320.39528.linux@rainbow-software.org>
	<201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTim5STgpNEdh3JSU_BG5X8Wxh-gbXDmWYLdufNb3@mail.gmail.com>
	<20100804083652.92b5b2df.kamezawa.hiroyu@jp.fujitsu.com>
	<20100804105054.af68ee5c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010 10:50:54 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> This patch is created against 2.6.35. CC'ed stable.
> Thank you for all helps.
> 

I'm sorry I now doubt this patch is wrong.
What should be done is stop swap-reuse before hibernation_snapshot().
But, hmm, this one can't.

Maybe what really happens is someone (kswapd?) reuses swap while
swsusp_alloc() is on going.

please allow me to retry..

Thanks,
-Kame


> =
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Since 2.6.31, swap_map[]'s refcounting was changed to show that
> a used swap entry is just for swap-cache, can be reused.
> Then, while scanning free entry in swap_map[], a swap entry may
> be able to be reclaimed and reused. It was by the commit
> c9e444103b5e7a5a3519f9913f59767f92e33baf.
> 
> But this caused deta corruption at hibernation. Considering how
> the image is saved, the calls of try_to_reclaim_swap() changes the
> status of memory and there will be inconsitency between saved-memory-image's
> swap_map[] / memmap / swapper_space because memory is saved per page with
> swap-allocation per page.
> 
> This patch is for avoiding bug by not reclaiming swap-entry at hibernation.
> This is a quick fix for backporting.
> 
> Cc: stable@kernel.org
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Reported-by: Ondreg Zary <linux@rainbow-software.org>
> Tested-by: Andrea Gelmini <andrea.gelmini@gmail.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  mm/swapfile.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.35.org/mm/swapfile.c
> ===================================================================
> --- linux-2.6.35.org.orig/mm/swapfile.c
> +++ linux-2.6.35.org/mm/swapfile.c
> @@ -318,8 +318,10 @@ checks:
>  	if (offset > si->highest_bit)
>  		scan_base = offset = si->lowest_bit;
>  
> -	/* reuse swap entry of cache-only swap if not busy. */
> -	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
> +	/* reuse swap entry of cache-only swap if not hibernation. */
> +	if (vm_swap_full()
> +		&& usage == SWAP_HAS_CACHE
> +		&& si->swap_map[offset] == SWAP_HAS_CACHE) {
>  		int swap_was_freed;
>  		spin_unlock(&swap_lock);
>  		swap_was_freed = __try_to_reclaim_swap(si, offset);
> 
> 

