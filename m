Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab1BWXMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:12:21 -0500
Received: from smtp-out.google.com ([74.125.121.67]:47615 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1BWXMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:12:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Q3m47Pt72QbI1fMIdgNy4i2q5GEcbC+D71Mbn72IoHn+t5xRUSTrmafToKv8neKo3f
         MmA3Bpz9CaBl98ZFlEtw==
Date: Wed, 23 Feb 2011 15:12:02 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
        hch@infradead.org, a.p.zijlstra@chello.nl, gurudas.pai@oracle.com,
        lkml20101129@newton.leun.net, rjw@sisk.pl, florian@mickler.org,
        trond.myklebust@fys.uio.no, maciej.rutecki@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: prevent concurrent unmap_mapping_range() on the same
 inode
In-Reply-To: <AANLkTimeihuzjgR2f7Avq2PJrCw1vZxtjh=wBPXO3aHP@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1102231448460.5732@sister.anvils>
References: <E1PsEA7-0007G0-29@pomaz-ex.szeredi.hu> <AANLkTimeihuzjgR2f7Avq2PJrCw1vZxtjh=wBPXO3aHP@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011, Linus Torvalds wrote:
> On Wed, Feb 23, 2011 at 4:49 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > This resolves Bug 25822 listed in the regressions since 2.6.36 (though
> > it's a bug much older than that, for some reason it only started
> > triggering for people recently).
> 
> Gaah. I hate this patch. It is, in fact, a patch that makes me finally
> think that the mm preemptibility is actually worth it, because then
> i_mmap_lock turns into a mutex and makes the whole "drop the lock"
> thing hopefully a thing of the past (see the patch "mm: Remove
> i_mmap_mutex lockbreak").
> 
> Because as far as I can see, the only thing that makes this thing
> needed in the first place is that horribly ugly "we drop i_mmap_lock
> in the middle of random operations that really still need it".
> 
> That said, I don't really see any alternatives - I guess we can't
> really just say "remove that crazy lock dropping". Even though I
> really really really would like to.

Those feelings understood and shared.

> 
> Of course, we could also just decide that we should apply the mm
> preemptibility series instead. Can people confirm that that fixes the
> bug too?

It would fix it, but there's a but.

In his [2/8] mm: remove i_mmap_mutex lockbreak patch, Peter says
"shouldn't hold up reclaim more than lock_page() would".  But (apart
from a write error case) we always use trylock_page() in reclaim, we
never dare hold it up on a lock_page().  So page reclaim would get
held up on truncation more than at present - though he's right to
point out that truncation will usually be freeing pages much faster.

I'm not sure whether it will prove good enough to abandon the lock
breaking if we move to a mutex there.  And besides, this unmapping
BUG does need a fix in stable, well before we want to try out the
preemptible mmu gathering.

I'd rather hold out Peter's series as a hope that we can
eliminate this extra unmapping mutex in a few months time.

Hugh
