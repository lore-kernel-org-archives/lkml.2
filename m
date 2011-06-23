Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511Ab1FWPLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:11:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:8979 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab1FWPLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:11:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,413,1304319600"; 
   d="scan'208";a="18825940"
Message-ID: <4E035785.6050504@linux.intel.com>
Date: Thu, 23 Jun 2011 08:11:01 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH] futex: replace get_user_pages() with get_user_pages_fast()
References: <4E02DB80.10303@jp.fujitsu.com>
In-Reply-To: <4E02DB80.10303@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/22/2011 11:21 PM, KOSAKI Motohiro wrote:
> Hello,
> 
> Is there any reason to take mmap_sem explicitly here?
> Should we change gup_fast() to allow NULL argument (ie for avoid get_page)?
> 
> ============================
>   down_read(&mm->mmap_sem);
>   get_user_pages(current, current->mm)
>   up_read(&mm->mmap_sem);
> 
> and
> 
>   get_user_pages_fast()
> 
> make an equivalent result, And latter would be better when mamp_sem
> highly contended case, because it can avoid to take mmap_sem if
> the target page doesn't need a page fault.


I can't speak authoritatively here, but it seems to me that
get_user_pages_fast falls back to get_user_pages with mmap_sem anyway,
so this seems like a reasonable optimization for the best case, with a
minor overhead for the slow case.

Peter, am I missing something? Is there a reason you left this as is
during your fast gup futex update?

> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  kernel/futex.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index fe28dc2..9f7b1ae 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -351,13 +351,11 @@ static inline void put_futex_key(union futex_key *key)
>   */
>  static int fault_in_user_writeable(u32 __user *uaddr)
>  {
> -	struct mm_struct *mm = current->mm;
>  	int ret;
> +	struct page *page;
> 
> -	down_read(&mm->mmap_sem);
> -	ret = get_user_pages(current, mm, (unsigned long)uaddr,
> -			     1, 1, 0, NULL, NULL);
> -	up_read(&mm->mmap_sem);
> +	ret = get_user_pages_fast((unsigned long)uaddr, 1, 1, &page);
> +	put_page(page);
> 
>  	return ret < 0 ? ret : 0;
>  }

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
