Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1DRDAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 23:00:24 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8732 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1DRDAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 23:00:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=eUkFv4ixJIUsNVVvif8jf2CueOGFvAlr1G0zNB/WxaNP82Mw6/KWthrTTr3yWahTqm
         heIIVQZlQuXSQUwiX/2Q==
Date: Sun, 17 Apr 2011 20:00:17 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Michal Hocko <mhocko@suse.cz>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <20110415135144.GE8828@tiehlicka.suse.cz>
Message-ID: <alpine.LSU.2.00.1104171952040.22679@sister.anvils>
References: <20110415135144.GE8828@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Apr 2011, Michal Hocko wrote:

> Hi,
> the following patch is just a cleanup for better readability without any
> functional changes. What do you think about it?
> ---
> From 71de71aaa725ee87459b3a256e8bb0af7de4abeb Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Fri, 15 Apr 2011 14:56:26 +0200
> Subject: [PATCH] mm: make expand_downwards symmetrical to expand_upwards
> 
> Currently we have expand_upwards exported while expand_downwards is
> accessible only via expand_stack.
> 
> check_stack_guard_page is a nice example of the asymmetry. It uses
> expand_stack for VM_GROWSDOWN while expand_upwards is called for
> VM_GROWSUP case. Let's make this consistent and export expand_downwards
> same way we do with expand_upwards.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Yes, I've just been looking around here, and I like your symmetry.
But two points:

> ---
>  include/linux/mm.h |    2 ++
>  mm/memory.c        |    2 +-
>  mm/mmap.c          |    2 +-
>  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 692dbae..765cf4e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1498,8 +1498,10 @@ unsigned long ra_submit(struct file_ra_state *ra,
>  extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
>  #if VM_GROWSUP
>  extern int expand_upwards(struct vm_area_struct *vma, unsigned long address);
> +  #define expand_downwards(vma, address) do { } while (0)

I think this is wrong: doesn't the VM_GROWSUP case actually want
a real expand_downwards() in addition to expand_upwards()?

>  #else
>    #define expand_upwards(vma, address) do { } while (0)
> +extern int expand_downwards(struct vm_area_struct *vma, unsigned long address);
>  #endif
>  extern int expand_stack_downwards(struct vm_area_struct *vma,
>  				  unsigned long address);

And if you're going for symmetry, wouldn't it be nice to add fs/exec.c
to the patch and remove this silly expand_stack_downwards() wrapper?

Hugh


> diff --git a/mm/memory.c b/mm/memory.c
> index ce22a25..f404fb6 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2969,7 +2969,7 @@ static inline int check_stack_guard_page(struct vm_area_struct *vma, unsigned lo
>  		if (prev && prev->vm_end == address)
>  			return prev->vm_flags & VM_GROWSDOWN ? 0 : -ENOMEM;
>  
> -		expand_stack(vma, address - PAGE_SIZE);
> +		expand_downwards(vma, address - PAGE_SIZE);
>  	}
>  	if ((vma->vm_flags & VM_GROWSUP) && address + PAGE_SIZE == vma->vm_end) {
>  		struct vm_area_struct *next = vma->vm_next;
> diff --git a/mm/mmap.c b/mm/mmap.c
> index e27e0cf..6b2a817 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1782,7 +1782,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
>  /*
>   * vma is the first one with address < vma->vm_start.  Have to extend vma.
>   */
> -static int expand_downwards(struct vm_area_struct *vma,
> +int expand_downwards(struct vm_area_struct *vma,
>  				   unsigned long address)
>  {
>  	int error;
> -- 
> 1.7.4.1
