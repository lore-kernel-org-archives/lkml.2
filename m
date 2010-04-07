Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab0DGPgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:36:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758004Ab0DGPgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:36:00 -0400
Date: Wed, 7 Apr 2010 08:30:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <20100407105454.2e7ab9bf@annuminas.surriel.com>
Message-ID: <alpine.LFD.2.00.1004070827140.3487@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org> <20100406195459.554265e7@annuminas.surriel.com> <20100407151357.FB7E.A69D9226@jp.fujitsu.com> <20100407105454.2e7ab9bf@annuminas.surriel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Apr 2010, Rik van Riel wrote:
>
>  - fix the locking issues spotted by Kosaki Motohiro

No, they're broken.

And Rik, please explain the locking rather than make even more of these 
kinds of random ad-hoc locking rules.

I've said this now _three_ times, but let me repeat once more:

 - the locking rules for that anon_vma_chain are very unclear. I _think_ 
   you mean for them to be "mmap_sem held for writing, _or_ mmap_sem held 
   for reading and page_table_lock held", but nowhere is that actually 
   documented.

Why is it so hard for you to just admit that? Especially after you 
yourself got it wrong.

> +		merge_vma = find_mergeable_anon_vma(vma);
> +		if (merge_vma) {
> +			int ret;
> +			spin_lock(&mm->page_table_lock);
> +			ret = anon_vma_clone(vma, merge_vma);
> +			if (!ret)
> +				vma->anon_vma = merge_vma->anon_vma;
> +			spin_unlock(&mm->page_table_lock);
> +			return ret;
> +		}

Rik, the above is obviously total crap.

anon_vma_clone() needs to allocate memory, and it does so with GFP_KERNEL. 
You can't do that with a spinlock held.

		Linus
