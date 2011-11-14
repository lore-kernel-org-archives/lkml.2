Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1KNKTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 05:19:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab1KNKTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 05:19:43 -0500
Date: Mon, 14 Nov 2011 11:20:46 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/4] mm: remove debug_pagealloc_enabled
Message-ID: <20111114102045.GA2513@redhat.com>
References: <1321014994-2426-1-git-send-email-sgruszka@redhat.com>
 <20111111141221.GL3083@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111111141221.GL3083@suse.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 02:12:21PM +0000, Mel Gorman wrote:
> On Fri, Nov 11, 2011 at 01:36:31PM +0100, Stanislaw Gruszka wrote:
> > After we finish (no)bootmem, pages are passed to buddy allocator. Since
> > debug_pagealloc_enabled is not set, we do not protect pages, what is
> > not what we want with CONFIG_DEBUG_PAGEALLOC=y. That could be fixed by
> > calling enable_debug_pagealloc() before free_all_bootmem(), but actually
> > I do not see any reason why we need that global variable. Hence patch
> > remove it.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  arch/x86/mm/pageattr.c |    6 ------
> >  include/linux/mm.h     |   10 ----------
> >  init/main.c            |    5 -----
> >  mm/debug-pagealloc.c   |    3 ---
> >  4 files changed, 0 insertions(+), 24 deletions(-)
> > 
> > diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> > index f9e5267..5031eef 100644
> > --- a/arch/x86/mm/pageattr.c
> > +++ b/arch/x86/mm/pageattr.c
> > @@ -1334,12 +1334,6 @@ void kernel_map_pages(struct page *page, int numpages, int enable)
> >  	}
> >  
> >  	/*
> > -	 * If page allocator is not up yet then do not call c_p_a():
> > -	 */
> > -	if (!debug_pagealloc_enabled)
> > -		return;
> > -
> > -	/*
> 
> According to commit [12d6f21e: x86: do not PSE on
> CONFIG_DEBUG_PAGEALLOC=y], the intention of debug_pagealloc_enabled
> was to force additional testing of splitting large pages due to
> cpa. Presumably this was because when bootmem was retired, all the
> pages would be mapped forcing the protection to be applied later
> while the system was running and races would be more interesting.
> 
> This patch is trading additional CPA testing for better detecting
> of memory corruption with DEBUG_PAGEALLOC. I see no issue with this
> per-se, but I'm cc'ing Ingo for comment as it was his patch and this
> is something that should go by the x86 maintainers.

Not sure if I understand all of that (Ok, I clearly do not understend,
I do not even know what CPA mean: change page address ?), but I think
more splitting large pages testing was achived by this hunk

-#ifdef CONFIG_DEBUG_PAGEALLOC
-       /* pse is not compatible with on-the-fly unmapping,
-        * disable it even if the cpus claim to support it.
-        */
-       setup_clear_cpu_cap(X86_FEATURE_PSE);
-#endif

of commit 12d6f21e, because changelog say:

    get more testing of the c_p_a() code done by not turning off
    PSE on DEBUG_PAGEALLOC.

But to make PSE and DEBUG_PAGEALLOC work debug_pagealloc_enabled was
introduced. Now CPA code was changed that PSE and DEBUG_PAGEALLOC works
without problem (I tested that on pse cappable cpu), so I think
debug_pagealloc_enabled is unneeded, or do I'm wrong?

Stanislaw
