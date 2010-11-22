Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0KVDGo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 22:06:44 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57268 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab0KVDGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 22:06:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 22 Nov 2010 12:01:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [BUGFIX][PATCH] pagemap: set pagemap walk limit to PMD boundary
Message-Id: <20101122120102.e0e76373.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1290157665-17215-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1290157665-17215-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 18:07:45 +0900
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Currently one pagemap_read() call walks in PAGEMAP_WALK_SIZE bytes
> (== 512 pages.)  But there is a corner case where walk_pmd_range()
> accidentally runs over a VMA associated with a hugetlbfs file.
> 
> For example, when a process has mappings to VMAs as shown below:
> 
>   # cat /proc/<pid>/maps
>   ...
>   3a58f6d000-3a58f72000 rw-p 00000000 00:00 0
>   7fbd51853000-7fbd51855000 rw-p 00000000 00:00 0
>   7fbd5186c000-7fbd5186e000 rw-p 00000000 00:00 0
>   7fbd51a00000-7fbd51c00000 rw-s 00000000 00:12 8614   /hugepages/test
> 
> then pagemap_read() goes into walk_pmd_range() path and walks in the range
> 0x7fbd51853000-0x7fbd51a53000, but the hugetlbfs VMA should be handled
> by walk_hugetlb_range(). Otherwise PMD for the hugepage is considered bad
> and cleared, which causes undesirable results.
> 
> This patch fixes it by separating pagemap walk range into one PMD.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Matt Mackall <mpm@selenic.com>
> ---
>  fs/proc/task_mmu.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index da6b01d..c126c83 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -706,6 +706,7 @@ static int pagemap_hugetlb_range(pte_t *pte, unsigned long hmask,
>   * skip over unmapped regions.
>   */
>  #define PAGEMAP_WALK_SIZE	(PMD_SIZE)
> +#define PAGEMAP_WALK_MASK	(PMD_MASK)
>  static ssize_t pagemap_read(struct file *file, char __user *buf,
>  			    size_t count, loff_t *ppos)
>  {
> @@ -776,7 +777,7 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  		unsigned long end;
>  
>  		pm.pos = 0;
> -		end = start_vaddr + PAGEMAP_WALK_SIZE;
> +		end = (start_vaddr + PAGEMAP_WALK_SIZE) & PAGEMAP_WALK_MASK;
>  		/* overflow ? */
>  		if (end < start_vaddr || end > end_vaddr)
>  			end = end_vaddr;

Ack. 

But ALIGN() can't be used ?

Thanks,
-Kame



