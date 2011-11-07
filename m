Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab1KGPnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:43:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab1KGPnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:43:12 -0500
Date: Mon, 7 Nov 2011 16:42:35 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Nai Xia <nai.xia@gmail.com>, Hugh Dickins <hughd@google.com>,
        Pawel Sikora <pluto@agmk.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mremap: enforce rmap src/dst vma ordering in case of
 vma_merge succeeding in copy_vma
Message-ID: <20111107154235.GE3249@redhat.com>
References: <20111031171441.GD3466@redhat.com>
 <1320082040-1190-1-git-send-email-aarcange@redhat.com>
 <alpine.LSU.2.00.1111032318290.2058@sister.anvils>
 <20111104235603.GT18879@redhat.com>
 <CAPQyPG5i87VcnwU5UoKiT6_=tzqO_NOPXFvyEooA1Orbe_ztGQ@mail.gmail.com>
 <20111105013317.GU18879@redhat.com>
 <CAPQyPG5Y1e2dac38OLwZAinWb6xpPMWCya2vTaWLPi9+vp1JXQ@mail.gmail.com>
 <20111107131413.GA18279@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107131413.GA18279@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 01:14:13PM +0000, Mel Gorman wrote:
> I'm tending to agree. The number of cases that must be kept in mind
> is getting too tricky. Taking the anon_vma lock may be slower but at
> the risk of sounding chicken, it's easier to understand.
> 
> > But I think Mel indicated that anon_vma_locking might be
> > harmful to JVM SMP performance.
> > How severe you expect this to be, Mel ?
> > 
> 
> I would only expect it to be a problem during garbage collection when
> there is a greater likelihood that mremap is heavily used. While it
> would have been nice to avoid additional overhead in mremap, I don't
> think the JVM GC case on its own is sufficient justification to avoid
> taking the anon_vma lock.

Adding one liner in the error path and a bugcheck in the *vmap case,
doesn't seem the end of the world compared to my previous fix that you
acked. I suspect last friday I was probably confused for a little
while because I was recovering from some flu I picked up with the cold
weather and the confusion around the vmap case which I assumed as safe
(not only if no page was faulted in yet) also didn't help.

BTW, with regard to those comments about human brain being all weak,
well I doubt monkey brain would work better, so in absence of some
alien brain which may work better than ours, we should concentrate and
handle it :). The ordering constraints isn't going away no matter what
we do in mremap, fork has the exact same issue, except it won't
require reordering but my patch documents that.

NOTE: f we could remove _all_ the ordering dependencies between the
vmas pointed by the anon_vma_chains queued in the same_anon_vma list,
and all the rmap_walk then I would be more inclined to agree on
keeping the simpler way, because then we would stop playing the
ordering games all together, but regardless of mremap, we'll be still
playing ordering games with fork vs rmap_walk, so we can exploit that
to run a bit faster in mremap too, play the same ordering game (though
I admit more complex to play the ordering games in mremap as it
requires 2 more function calls for the vma_merge case) but not
fundamentally different.
