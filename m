Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2ILSws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:52:48 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50558 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab2ILSwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:52:45 -0400
Date: Wed, 12 Sep 2012 11:52:03 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org, bhalevy@tonian.com, dhillf@gmail.com
Subject: Re: + mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch
 added to -mm tree
In-Reply-To: <alpine.DEB.2.00.1209111843010.19285@chino.kir.corp.google.com>
Message-ID: <alpine.LSU.2.00.1209121133210.15274@eggly.anvils>
References: <20120816200105.C14EA1E0048@wpzn4.hot.corp.google.com> <alpine.DEB.2.00.1209111054510.30962@chino.kir.corp.google.com> <alpine.LSU.2.00.1209111110330.2575@eggly.anvils> <alpine.DEB.2.00.1209111843010.19285@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2012, David Rientjes wrote:
> On Tue, 11 Sep 2012, Hugh Dickins wrote:
> 
> > > > This does revert 2.6.27's dfe195fb79e88 ("mm: fix uninitialized variables
> > > > for find_vma_prepare callers"), but it looks like gcc 4.3.0 was one of
> > > > those releases too eager to shout about uninitialized variables: only
> > > > copy_vma() warns with 4.5.1 and 4.7.1, which a BUG on error silences.
> > > > 
> > > 
> > > That trick doesn't work if CONFIG_BUG=n.
> > > 
> > > mm/mmap.c: In function 'copy_vma':
> > > mm/mmap.c:2344: warning: 'prev' may be used uninitialized in this function
> > > mm/mmap.c:2345: warning: 'rb_link' may be used uninitialized in this function
> > > mm/mmap.c:2345: warning: 'rb_parent' may be used uninitialized in this function
> > 
> > Hmm, right: not an option I ever choose, and I hadn't given it a thought.
> > 
> > But do we care?  If this introduced the only such warning, I would care.
> 
> It now has the distinction of being the only warning for CONFIG_BUG=n in 
> mm/*.

You're tempting me to ask "Hey, what's so special about mm/ ?" ;)
No, but seriously, I do share your pride in keeping mm/ clean.

> 
> > But that seems to be far from the case - building my usual config without
> > CONFIG_BUG gives me 36 warnings, of uninitialized and unused and
> > control reaches end of non-void varieties.
> > 
> 
> What's so special about copy_vma()

I don't know: why does copy_vma() give a warning but __insert_vm_struct()
not?  Rhetorical question, I don't expect an answer, but suspect it's
some accident of inlining, or how hard gcc has to try to work it out.

What I didn't notice yesterday when I reported 36 warnings with CONFIG_BUG
off, is that for me mm/mmap.c was not amongst them: and doesn't warn now
if I remove the BUG, although obviously it did before I added the BUG.

> that we can't fix it all up to use 
> uninitialized_var() so this is handled the proper way?

I do prefer to avoid it when we can, some reasons given below.

> If CONFIG_BUG exists, then we should support it, right?

Up to a point, yes: we don't encourage switching it off ("Just say Y").
I'm reluctant to add a notation just for this discouraged case, but how
how about this patch - does it actually fix the warning you see, David?


[PATCH mmotm] mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links fix

Strangely, I can no longer get an uninitialized variable warning out of
copy_vma(), with or without the BUG() there; but David Rientjes gets it
when he builds with CONFIG_BUG off, which is understandable.

uninitialized_var() can be a useful tool, but I do prefer to avoid it:
partly because it might hide future errors, partly because I misspell
it, but mainly because the need for it comes and goes so mysteriously.

Given David's preference for no warning, mine for no uninitialized_var,
and Linus's for renaming BUG() to I_AM_A_MORON() to discourage its use
in the first place: copy_vma() seems a prime candidate for returning
failure to mremap instead of crashing the system.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm/mm/mmap.c	2012-09-07 12:39:38.124019726 -0700
+++ linux/mm/mmap.c	2012-09-12 11:11:51.340174537 -0700
@@ -2356,7 +2356,7 @@ struct vm_area_struct *copy_vma(struct v
 	}
 
 	if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent))
-		BUG();
+		return NULL;	/* should never get here */
 	new_vma = vma_merge(mm, prev, addr, addr + len, vma->vm_flags,
 			vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma));
 	if (new_vma) {
