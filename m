Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab1HYGl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 02:41:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60179 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab1HYGlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 02:41:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 25 Aug 2011 15:33:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        hughd@google.com, ngupta@vflare.org, konrad.wilk@oracle.com,
        JBeulich@novell.com, kurt.hackel@oracle.com, npiggin@kernel.dk,
        akpm@linux-foundation.org, riel@redhat.com, hannes@cmpxchg.org,
        matthew@wil.cx, chris.mason@oracle.com, sjenning@linux.vnet.ibm.com,
        jackdachef@gmail.com, cyclonusj@gmail.com
Subject: Re: Subject: [PATCH V7 3/4] mm: frontswap: add swap hooks and
 extend try_to_unuse
Message-Id: <20110825153347.1e42a607.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110823145835.GA23222@ca-server1.us.oracle.com>
References: <20110823145835.GA23222@ca-server1.us.oracle.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 07:58:35 -0700
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> From: Dan Magenheimer <dan.magenheimer@oracle.com>
> Subject: [PATCH V7 3/4] mm: frontswap: add swap hooks and extend try_to_unuse
> 
> This third patch of four in the frontswap series adds hooks in the swap
> subsystem and extends try_to_unuse so that frontswap_shrink can do a
> "partial swapoff".  Also, declarations for the extern-ified swap variables
> in the first patch are declared.
> 
> Note that failed frontswap_map allocation is safe... failure is noted
> by lack of "FS" in the subsequent printk.
> 
> [v7: rebase to 3.0-rc3]
> [v7: JBeulich@novell.com: use new static inlines, no-ops if not config'd]
> [v6: rebase to 3.1-rc1]
> [v6: lliubbo@gmail.com: use vzalloc]
> [v5: accidentally posted stale code for v4 that failed to compile :-(]
> [v4: rebase to 2.6.39]
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Reviewed-by: Konrad Wilk <konrad.wilk@oracle.com>
> Acked-by: Jan Beulich <JBeulich@novell.com>
> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Chris Mason <chris.mason@oracle.com>
> Cc: Rik Riel <riel@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> --- linux/mm/swapfile.c	2011-08-08 08:19:26.336684746 -0600
> +++ frontswap/mm/swapfile.c	2011-08-23 08:21:15.301998803 -0600
> @@ -32,6 +32,8 @@
>  #include <linux/memcontrol.h>
>  #include <linux/poll.h>
>  #include <linux/oom.h>
> +#include <linux/frontswap.h>
> +#include <linux/swapfile.h>
>  
>  #include <asm/pgtable.h>
>  #include <asm/tlbflush.h>
> @@ -43,7 +45,7 @@ static bool swap_count_continued(struct 
>  static void free_swap_count_continuations(struct swap_info_struct *);
>  static sector_t map_swap_entry(swp_entry_t, struct block_device**);
>  
> -static DEFINE_SPINLOCK(swap_lock);
> +DEFINE_SPINLOCK(swap_lock);
>  static unsigned int nr_swapfiles;
>  long nr_swap_pages;
>  long total_swap_pages;
> @@ -54,9 +56,9 @@ static const char Unused_file[] = "Unuse
>  static const char Bad_offset[] = "Bad swap offset entry ";
>  static const char Unused_offset[] = "Unused swap offset entry ";
>  
> -static struct swap_list_t swap_list = {-1, -1};
> +struct swap_list_t swap_list = {-1, -1};
>  
> -static struct swap_info_struct *swap_info[MAX_SWAPFILES];
> +struct swap_info_struct *swap_info[MAX_SWAPFILES];
>  
>  static DEFINE_MUTEX(swapon_mutex);
>  
> @@ -557,6 +559,7 @@ static unsigned char swap_entry_free(str
>  			swap_list.next = p->type;
>  		nr_swap_pages++;
>  		p->inuse_pages--;
> +		frontswap_flush_page(p->type, offset);
>  		if ((p->flags & SWP_BLKDEV) &&
>  				disk->fops->swap_slot_free_notify)
>  			disk->fops->swap_slot_free_notify(p->bdev, offset);
> @@ -1022,7 +1025,7 @@ static int unuse_mm(struct mm_struct *mm
>   * Recycle to start on reaching the end, returning 0 when empty.
>   */
>  static unsigned int find_next_to_unuse(struct swap_info_struct *si,
> -					unsigned int prev)
> +					unsigned int prev, bool frontswap)
>  {
>  	unsigned int max = si->max;
>  	unsigned int i = prev;
> @@ -1048,6 +1051,12 @@ static unsigned int find_next_to_unuse(s
>  			prev = 0;
>  			i = 1;
>  		}

> +		if (frontswap) {
> +			if (frontswap_test(si, i))
> +				break;
> +			else
> +				continue;
> +		}

Could you add comment ? If frontswap==true, only scan frontswap ?



>  		count = si->swap_map[i];
>  		if (count && swap_count(count) != SWAP_MAP_BAD)
>  			break;
> @@ -1059,8 +1068,12 @@ static unsigned int find_next_to_unuse(s
>   * We completely avoid races by reading each swap page in advance,
>   * and then search for the process using it.  All the necessary
>   * page table adjustments can then be made atomically.
> + *
> + * if the boolean frontswap is true, only unuse pages_to_unuse pages;
> + * pages_to_unuse==0 means all pages; ignored if frontswap is false
>   */
> -static int try_to_unuse(unsigned int type)
> +int try_to_unuse(unsigned int type, bool frontswap,
> +		 unsigned long pages_to_unuse)
>  {
>  	struct swap_info_struct *si = swap_info[type];
>  	struct mm_struct *start_mm;
> @@ -1093,7 +1106,7 @@ static int try_to_unuse(unsigned int typ
>  	 * one pass through swap_map is enough, but not necessarily:
>  	 * there are races when an instance of an entry might be missed.
>  	 */
> -	while ((i = find_next_to_unuse(si, i)) != 0) {
> +	while ((i = find_next_to_unuse(si, i, frontswap)) != 0) {
>  		if (signal_pending(current)) {
>  			retval = -EINTR;
>  			break;
> @@ -1260,6 +1273,10 @@ static int try_to_unuse(unsigned int typ
>  		 * interactive performance.
>  		 */
>  		cond_resched();
> +		if (frontswap && pages_to_unuse > 0) {
> +			if (!--pages_to_unuse)
> +				break;
> +		}
>  	}

Is this a best-effort function and doesn't need to return condition 
of pages_to_unuse ?
Caller of try_to_unuse(si, true....) is frontswap_shrink(). Right ?

Thanks,
-Kame

