Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119Ab1AUFPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 00:15:53 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:65440 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1AUFPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 00:15:52 -0500
Date: Fri, 21 Jan 2011 14:15:10 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Unlock the locked hugetlb page without
 MF_COUNT_INCREASED.
Message-ID: <20110121051510.GC16406@spritzera.linux.bs1.fc.nec.co.jp>
References: <4D38E00E.9020509@np.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <4D38E00E.9020509@np.css.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 10:23:26AM +0900, Jin Dongming wrote:
> When the unmapped hugetlb page is poisoned, the page is locked
> for checking some conditions of page. When one of the following condition
> in __memory_failure()
>     if (!PageHWPoison(hpage)
>         || (hwpoison_filter(p) && TestClearPageHWPoison(p))
>         || (p != hpage && TestSetPageHWPoison(hpage) {
>         ...
>     }
> 
> is matched, it just returns from __memory_failure() without unlocking
> the locked hugetlb page. This will block the process which wants to
> map the blocked hugetlb page.
> 
> If some process is blocked, error message could be outputted as following:
>     kernel: INFO: task hmmap:3307 blocked for more than 120 seconds.
>     kernel: "echo 0 > /proc/sys/    kernel/hung_task_timeout_secs" disables this message.
>     kernel: hmmap         D ffff880196946100     0  3307      1 0x00000080
>     kernel:  ffff880196946100 0000000000000086 ffff880195ca6040 0000000000000000
>     kernel:  0000000000000046 ffffffff81036a7d ffffffff81d08980 0000000000000000
>     kernel:  ffffffff8189c74c ffffffff814f6886 000000000000002e 0000000000000246
>     kernel: Call Trace:
>     kernel:  [<ffffffff81036a7d>] ? release_console_sem+0x174/0x18e
>     kernel:  [<ffffffff810914f4>] ? sync_page+0x0/0x48
>     kernel:  [<ffffffff813bcbdb>] ? io_schedule+0x56/0x8c
>     kernel:  [<ffffffff81091538>] ? sync_page+0x44/0x48
>     kernel:  [<ffffffff813bd0ab>] ? __wait_on_bit_lock+0x3e/0x83
>     kernel:  [<ffffffff810914e1>] ? __lock_page+0x5e/0x64
>     kernel:  [<ffffffff8104ea89>] ? wake_bit_function+0x0/0x23
>     kernel:  [<ffffffff810bd723>] ? hugetlb_fault+0x38e/0x6ef
>     kernel:  [<ffffffff813c11ac>] ? do_page_fault+0x283/0x3dd
>     kernel:  [<ffffffff81032546>] ? __wake_up+0x30/0x44
>     kernel:  [<ffffffff813be79f>] ? page_fault+0x1f/0x30
> 
> This is because the hugetlb page has been locked in __memory_failure(),
> the process will be blocked by lock_page() in hugetlb_fault()
> all the time.
> 
> So this patch unlock the locked hugetlb page before returning from
> __memory_failure().
> 
> Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  mm/memory-failure.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 548fbd7..8665eed 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1000,6 +1000,7 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
>  			    || (hwpoison_filter(p) && TestClearPageHWPoison(p))
>  			    || (p != hpage && TestSetPageHWPoison(hpage))) {
>  				atomic_long_sub(nr_pages, &mce_bad_pages);
> +				unlock_page(hpage);

Good fix, thank you.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
