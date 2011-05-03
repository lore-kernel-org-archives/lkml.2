Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1ECTL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:11:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62806 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab1ECTL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:11:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=gduRZ2K7J0JOQoZcOqe874DmztD94MVGqwjMCGFuExscqwtWruAQdw/8A9hWayhxgp
         acYEhoMyCDBS3sIixfhQ==
Date: Tue, 3 May 2011 12:11:28 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] mm: get rid of CONFIG_STACK_GROWSUP ||
 CONFIG_IA64
In-Reply-To: <20110503141044.GA25351@tiehlicka.suse.cz>
Message-ID: <alpine.LSU.2.00.1105031142260.7349@sister.anvils>
References: <20110503141044.GA25351@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Tue, 3 May 2011, Michal Hocko wrote:

> Hi Andrew,
> the patch bellow probably got lost in the huge "parisc crashes with slub"
> thread triggered by my earlier clean up in this area so I am resending
> it standalone.
> ---
> From 2e79c7e73a39a09389a84a8f37eb2a2f2f2859f5 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Tue, 19 Apr 2011 11:11:41 +0200
> Subject: [PATCH] mm: get rid of CONFIG_STACK_GROWSUP || CONFIG_IA64
> 
> IA64 needs some trickery for Register Backing Store so we have to
> export expand_stack_upwards for it even though the architecture expands
> its stack downwards normally.
> We have defined VM_GROWSUP which is defined only for the above
> configuration so let's use it everywhere rather than hardcoded
> CONFIG_STACK_GROWSUP || CONFIG_IA64
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Sorry to be negative, but this seems more clever than helpful to me:
it does not optimize anything (apart from saving a few bytes in mm/mmap.c
itself), obscures the special IA64 case, and relies upon the ways in which
we happen to define VM_GROWSUP elsewhere.

Not a nack: others may well disagree with me.

And, though I didn't find time to comment on your later "symmetrical"
patch before it went into mmotm, I didn't see how renaming expand_downwards
and expand_upwards to expand_stack_downwards and expand_stack_upwards was
helpful either - needless change, and you end up using expand_stack_upwards
on something which is not (what we usually call) the stack.

Now, if you're looking to make a nice cleanup, how about getting rid
of find_vma_prev(), which Linus made redundant when he suddenly added
vm_prev in 2.6.36?  There's at least one place where I apologize for
its expense in a BUG_ON, I'd be glad to see that killed off.

Hey, but it's certainly not for me to assign work to you!

Hugh

> ---
>  mm/mmap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 29c68b0..3ff9edf 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1726,7 +1726,7 @@ static int acct_stack_growth(struct vm_area_struct *vma, unsigned long size, uns
>  	return 0;
>  }
>  
> -#if defined(CONFIG_STACK_GROWSUP) || defined(CONFIG_IA64)
> +#if VM_GROWSUP
>  /*
>   * PA-RISC uses this for its stack; IA64 for its Register Backing Store.
>   * vma is the last one with address > vma->vm_end.  Have to extend vma.
> @@ -1777,7 +1777,7 @@ int expand_stack_upwards(struct vm_area_struct *vma, unsigned long address)
>  	khugepaged_enter_vma_merge(vma);
>  	return error;
>  }
> -#endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
> +#endif /* VM_GROWSUP */
>  
>  /*
>   * vma is the first one with address < vma->vm_start.  Have to extend vma.
> -- 
> 1.7.4.4
