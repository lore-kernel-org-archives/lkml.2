Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab0DJAUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 20:20:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab0DJAUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 20:20:23 -0400
Message-ID: <4BBFC3F8.6050608@redhat.com>
Date: Fri, 09 Apr 2010 20:19:04 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Borislav Petkov <bp@alien8.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
References: <alpine.LFD.2.00.1004081610020.3558@i5.linux-foundation.org> <20100408234721.GB25834@a1.tnic> <alpine.LFD.2.00.1004081744150.3558@i5.linux-foundation.org> <20100409013012.GA8153@liondog.tnic> <20100409092111.GA998@a1.tnic> <alpine.LFD.2.00.1004090917070.3558@i5.linux-foundation.org> <20100409174041.GA10780@a1.tnic> <alpine.LFD.2.00.1004091043490.3558@i5.linux-foundation.org> <20100409191425.GB10780@a1.tnic> <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org> <20100409204328.GG28964@cmpxchg.org> <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org> <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 07:56 PM, Linus Torvalds wrote:

> So _instead_ of all the patches that have floated about, I would suggest
> this simple change to "find_mergeable_anon_vma()" instead..

Boris, this is your chance to really ruin our week :)

If the bug persists with Linus's patch, we've been fixing
the wrong bug all week long, and you are experiencing
something else...

I'm getting really curious now.

> ---
>   mm/mmap.c |    6 ++++--
>   1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 75557c6..462a8ca 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -850,7 +850,8 @@ struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma)
>   	vm_flags = vma->vm_flags&  ~(VM_READ|VM_WRITE|VM_EXEC);
>   	vm_flags |= near->vm_flags&  (VM_READ|VM_WRITE|VM_EXEC);
>
> -	if (near->anon_vma&&  vma->vm_end == near->vm_start&&
> +	if (near->anon_vma&&  list_is_singular(&near->anon_vma_chain)&&
> +			vma->vm_end == near->vm_start&&
>    			mpol_equal(vma_policy(vma), vma_policy(near))&&
>   			can_vma_merge_before(near, vm_flags,
>   				NULL, vma->vm_file, vma->vm_pgoff +
> @@ -871,7 +872,8 @@ try_prev:
>   	vm_flags = vma->vm_flags&  ~(VM_READ|VM_WRITE|VM_EXEC);
>   	vm_flags |= near->vm_flags&  (VM_READ|VM_WRITE|VM_EXEC);
>
> -	if (near->anon_vma&&  near->vm_end == vma->vm_start&&
> +	if (near->anon_vma&&  list_is_singular(&near->anon_vma_chain)&&
> +			near->vm_end == vma->vm_start&&
>     			mpol_equal(vma_policy(near), vma_policy(vma))&&
>   			can_vma_merge_after(near, vm_flags,
>   				NULL, vma->vm_file, vma->vm_pgoff))

