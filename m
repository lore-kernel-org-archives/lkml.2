Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0DEPmG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 11:42:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754611Ab0DEPmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 11:42:00 -0400
Date: Mon, 5 Apr 2010 08:37:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH] rmap: fix anon_vma_fork() memory leak
In-Reply-To: <20100404190925.5daac2f3@annuminas.surriel.com>
Message-ID: <alpine.LFD.2.00.1004050824400.21313@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org> <20100402175937.GA19690@liondog.tnic> <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org> <20100402112428.f46ddc44.akpm@linux-foundation.org> <alpine.LFD.2.00.1004021135530.3634@i5.linux-foundation.org>
 <4BB66941.1060809@redhat.com> <1270397575.1814.106.camel@barrios-desktop> <20100404190925.5daac2f3@annuminas.surriel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Apr 2010, Rik van Riel wrote:
>
> Fix a memory leak in anon_vma_fork(), where we fail to tear down the
> anon_vmas attached to the new VMA in case setting up the new anon_vma
> fails.
> 
> Reported-by: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> ---
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index fcd593c..fb7ce99 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -231,6 +231,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
>  
>   out_error_free_anon_vma:
>  	anon_vma_free(anon_vma);
> +	unlink_anon_vmas(vma);
>   out_error:
>  	return -ENOMEM;
>  }

This looks _very_ wrong to me.

Shouldn't the unlink_anon_vmas() be in the "out_error" case? IOW, we 
should do it even if the "anon_vma_alloc()" failed, nbot just if the 
"anon_vma_chain_alloc()" failed?

No?

What am I missing?

			Linus
