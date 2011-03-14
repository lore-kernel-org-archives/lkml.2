Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1CNQiC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 12:38:02 -0400
Received: from smtp-out.google.com ([74.125.121.67]:19093 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab1CNQiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 12:38:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=dQu2Yje24nLTcQtSlnzmBPiMPQvGiAKcz+Gw2ETHvbN3mYh1dg8QUW6bti7hZJPsLb
         LXF7MZtcMAVy+W4xAnew==
Date: Mon, 14 Mar 2011 09:37:43 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] thp+memcg-numa: fix BUG at include/linux/mm.h:370!
In-Reply-To: <20110314155232.GB10696@random.random>
Message-ID: <alpine.LSU.2.00.1103140910570.2601@sister.anvils>
References: <alpine.LSU.2.00.1103140059510.1661@sister.anvils> <20110314155232.GB10696@random.random>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Andrea Arcangeli wrote:
> 
> Correct! I'd suggest to fix it without duplicating the
> mem_cgroup_newpage_charge. It's just one more put_page than needed
> with memcg enabled and NUMA disabled (I guess most memcg testing
> happened with NUMA enabled). The larger diff likely rejects with -mm
> NUMA code... I'll try to diff it with a smaller -U2 (this code has
> little change to be misplaced) that may allow it to apply clean
> regardless of the merging order, so it may make life easier.

I did try it that way at first (didn't help when I mistakenly put
#ifndef instead of #ifdef around the put_page!), but was repulsed
by seeing yet another #ifdef CONFIG_NUMA, so went with the duplicating
version - which Linus has now taken.

> 
> It may have been overkill to keep the NUMA case separated in order to
> avoid spurious allocations for the not-NUMA case, code become more
> complex and I'm not sure if it's really worthwhile. The optimization
> makes sense but it's minor and it created more complexity than
> strictly needed. For now we can't change it in the short term as it
> has been tested this way, but if people dislike the additional
> complexity that this optimization created, I'm not against dropping it
> in the future. Your comment was positive about the optimization (you
> said understandable) so I wanted to share my current thinking on these
> ifdefs...

I was certainly tempted to remove all the non-NUMA cases, but as you
say, now is not the right time for that since we needed a quick bugfix.

I do appreciate why you did it that way, it is nicer to be allocating
on the outside, though unsuitable in the NUMA case.  But given how this
bug has passed unnoticed for so long, it seems like nobody has been
testing non-NUMA, so yes, best to simplify and make non-NUMA do the
same as NUMA in 2.6.39.

Since Linus has taken my version that you didn't like, perhaps you can
get even by sending him your "mm: PageBuddy cleanups" patch, the version
I didn't like (for its silly branches) so was reluctant to push myself.

I'd really like to see that fix in, since it's a little hard to argue
for in -stable, being all about a system which is already unstable.
But I think it needs a stronger title than "PageBuddy cleanups" -
"fix BUG in bad_page()"?

Hugh
