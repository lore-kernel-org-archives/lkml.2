Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab0DAPPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:15:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752635Ab0DAPPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:15:34 -0400
Date: Thu, 1 Apr 2010 08:10:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Matt Mackall <mpm@selenic.com>, San Mehat <san@google.com>,
       linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, n-horiguchi@ah.jp.nec.com
Subject: Re: [PATCH] proc: pagemap: Hold mmap_sem during page walk
In-Reply-To: <20100401153428.d49c6345.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1004010747540.3707@i5.linux-foundation.org>
References: <20100401144329.BE42.A69D9226@jp.fujitsu.com> <20100401145509.47f7f1c3.kamezawa.hiroyu@jp.fujitsu.com> <20100401150128.BE45.A69D9226@jp.fujitsu.com> <20100401150956.4f6821c2.kamezawa.hiroyu@jp.fujitsu.com>
 <20100401153428.d49c6345.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Apr 2010, KAMEZAWA Hiroyuki wrote:
>
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> In initial design, walk_page_range() was designed just for walking page table and
> it didn't require mmap_sem. Now, find_vma() etc.. are used in walk_page_range()
> and we need mmap_sem around it.
> 
> This patch adds mmap_sem around walk_page_range().
> 
> Because /proc/<pid>/pagemap's callback routine use put_user(), we have to get
> rid of it to do sane fix.
> 
> Changelog:
>  - fixed start_vaddr calculation
>  - removed unnecessary cast.
>  - removed unnecessary change in smaps.
>  - use GFP_TEMPORARY instead of GFP_KERNEL
>  - use min().

Looks mostly correct to me (but just looking at the source, no testing, 
obviously). And I like how the double buffering removes more lines of code 
than it adds.

However, I think there is a subtle problem with this:

> +	while (count && (start_vaddr < end_vaddr)) {
> +		int len;
> +		unsigned long end;
> +
> +		pm.pos = 0;
> +		end = min(start_vaddr + PAGEMAP_WALK_SIZE, end_vaddr);
> +		down_read(&mm->mmap_sem);
> +		ret = walk_page_range(start_vaddr, end, &pagemap_walk);
> +		up_read(&mm->mmap_sem);
> +		start_vaddr += PAGEMAP_WALK_SIZE;

I think "start_vaddr + PAGEMAP_WALK_SIZE" might overflow, and then 'end' 
ends up being odd. You'll never notice on architectures where the user 
space doesn't go all the way up to the end (walk_page_range will return 0 
etc), but it will do the wrong thing if 'start' is close to the end, end 
is _at_ the end, and you'll not be able to read that range (because of the 
overflow).

So I do think you should do something like

	end = start_vaddr + PAGEMAP_WALK_SIZE;
	/* overflow?  or final chunk? */
	if (end < start_vaddr || end > end_vaddr)
		end = end_vaddr;

instead of using 'min()'.

(This only matters if TASK_SIZE_OF() can be ~0ul, but I think that can 
happen on sparc, for example)

			Linus
