Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2D0WAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:00:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2D0WAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:00:33 -0400
Date: Fri, 27 Apr 2012 15:00:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, npiggin@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@gmail.com,
        rientjes@google.com, Neil Brown <neilb@suse.de>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sage Weil <sage@newdream.net>
Subject: Re: [RFC] vmalloc: add warning in __vmalloc
Message-Id: <20120427150030.6183a286.akpm@linux-foundation.org>
In-Reply-To: <1335516144-3486-1-git-send-email-minchan@kernel.org>
References: <1335516144-3486-1-git-send-email-minchan@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012 17:42:24 +0900
Minchan Kim <minchan@kernel.org> wrote:

> Now there are several places to use __vmalloc with GFP_ATOMIC,
> GFP_NOIO, GFP_NOFS but unfortunately __vmalloc calls map_vm_area
> which calls alloc_pages with GFP_KERNEL to allocate page tables.
> It means it's possible to happen deadlock.
> I don't know why it doesn't have reported until now.
> 
> Firstly, I tried passing gfp_t to lower functions to support __vmalloc
> with such flags but other mm guys don't want and decided that
> all of caller should be fixed.
> 
> http://marc.info/?l=linux-kernel&m=133517143616544&w=2
> 
> To begin with, let's listen other's opinion whether they can fix it
> by other approach without calling __vmalloc with such flags.
> 
> So this patch adds warning to detect and to be fixed hopely.
> I Cced related maintainers.
> If I miss someone, please Cced them.
> 
> side-note:
>   I added WARN_ON instead of WARN_ONCE to detect all of callers
>   and each WARN_ON for each flag to detect to use any flag easily.
>   After we fix all of caller or reduce such caller, we can merge
>   a warning with WARN_ONCE.

Just WARN_ONCE, please.  If that exposes some sort of calamity then we
can reconsider.

> 
> ...
>
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1700,6 +1700,15 @@ static void *__vmalloc_node(unsigned long size, unsigned long align,
>  			    gfp_t gfp_mask, pgprot_t prot,
>  			    int node, void *caller)
>  {
> +	/*
> +	 * This function calls map_vm_area so that it allocates
> +	 * page table with GFP_KERNEL so caller should avoid using
> +	 * GFP_NOIO, GFP_NOFS and !__GFP_WAIT.
> +	 */
> +	WARN_ON(!(gfp_mask & __GFP_WAIT));
> +	WARN_ON(!(gfp_mask & __GFP_IO));
> +	WARN_ON(!(gfp_mask & __GFP_FS));
> +
>  	return __vmalloc_node_range(size, align, VMALLOC_START, VMALLOC_END,
>  				gfp_mask, prot, node, caller);
>  }

This seems strange.  There are many entry points to this code and the
patch appears to go into a randomly-chosen middle point in the various
call chains and sticks a check in there.  Why was __vmalloc_node()
chosen?  Does this provide full coverage or all entry points?



Also, the patch won't warn in the most problematic cases such as
vmalloc() being called from a __GFP_NOFS context.  Presumably there are
might_sleep() warnings somewhere on the allocation path which will
catch vmalloc() being called from atomic contexts.

I'm not sure what to do about that - we don't have machinery in place
to be able to detect when a GFP_KERNEL allocation is deadlockable. 
Perhaps a lot of hacking on lockdep might get us this - we'd need to
teach lockdep about which locks prohibit FS entry, which locks prevent
IO entry, etc.  And there are secret locks such as ext3/4
journal_start(), and bitlocks and lock_page().  eek.
