Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab1KKOM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 09:12:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757214Ab1KKOMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 09:12:25 -0500
Date: Fri, 11 Nov 2011 14:12:21 +0000
From: Mel Gorman <mgorman@suse.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/4] mm: remove debug_pagealloc_enabled
Message-ID: <20111111141221.GL3083@suse.de>
References: <1321014994-2426-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1321014994-2426-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 01:36:31PM +0100, Stanislaw Gruszka wrote:
> After we finish (no)bootmem, pages are passed to buddy allocator. Since
> debug_pagealloc_enabled is not set, we do not protect pages, what is
> not what we want with CONFIG_DEBUG_PAGEALLOC=y. That could be fixed by
> calling enable_debug_pagealloc() before free_all_bootmem(), but actually
> I do not see any reason why we need that global variable. Hence patch
> remove it.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  arch/x86/mm/pageattr.c |    6 ------
>  include/linux/mm.h     |   10 ----------
>  init/main.c            |    5 -----
>  mm/debug-pagealloc.c   |    3 ---
>  4 files changed, 0 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index f9e5267..5031eef 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -1334,12 +1334,6 @@ void kernel_map_pages(struct page *page, int numpages, int enable)
>  	}
>  
>  	/*
> -	 * If page allocator is not up yet then do not call c_p_a():
> -	 */
> -	if (!debug_pagealloc_enabled)
> -		return;
> -
> -	/*

According to commit [12d6f21e: x86: do not PSE on
CONFIG_DEBUG_PAGEALLOC=y], the intention of debug_pagealloc_enabled
was to force additional testing of splitting large pages due to
cpa. Presumably this was because when bootmem was retired, all the
pages would be mapped forcing the protection to be applied later
while the system was running and races would be more interesting.

This patch is trading additional CPA testing for better detecting
of memory corruption with DEBUG_PAGEALLOC. I see no issue with this
per-se, but I'm cc'ing Ingo for comment as it was his patch and this
is something that should go by the x86 maintainers.

-- 
Mel Gorman
SUSE Labs
