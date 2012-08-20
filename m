Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab2HTJj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:39:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60447 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2HTJj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:39:27 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1208200032450.24855@eggly.anvils>
References: <20120816024610.GA5350@evergreen.ssec.wisc.edu>
	<502D42E5.7090403@redhat.com>
	<20120818000312.GA4262@evergreen.ssec.wisc.edu>
	<502F100A.1080401@redhat.com>
	<alpine.LSU.2.00.1208200032450.24855@eggly.anvils>
Date: Mon, 20 Aug 2012 02:39:26 -0700
Message-ID: <CANN689Ej7XLh8VKuaPrTttDrtDGQbXuYJgS2uKnZL2EYVTM3Dg@mail.gmail.com>
Subject: Re: Repeated fork() causes SLAB to grow without bound
From: Michel Lespinasse <walken@google.com>
To: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>, Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 1:00 AM, Hugh Dickins <hughd@google.com> wrote:
> On Fri, 17 Aug 2012, Rik van Riel wrote:
>> Of course, that leaves the big question: do we want the
>> overhead of having the atomic addition and decrement for
>> every anonymous memory page, or is it easier to fix this
>> issue in userspace?
>
> I've not given any thought to alternatives, and I've not done any
> performance analysis; but my instinct says that we really do not
> want another atomic increment and decrement (and another cache
> line redirtied) for every single page mapped.

I am concerned about this as well.

> May I dare to think: what if we just backed out all the anon_vma_chain
> complexity, and returned to the simple anon_vma list we had in 2.6.33?
>
> Just how realistic was the workload which led you to anon_vma_chains?
> And isn't it correct to say that the performance evaluation was made
> while believing that each anon_vma->lock was useful, before the sad
> realization that anon_vma->root->lock (or ->mutex) had to be used?

Thanks for suggesting this - I certainly wish we could go that way. I
suspect there will be a strong case against this, but I'd certainly
like to hear it (and see if it can be addressed another way).

Here we just don't have processes that fork a lot of children that
don't immediately exec, so anon_vmas don't bring any value for us.

> I've Cc'ed Michel, because I think he has plans (or at least hopes) for
> the anon_vmas, in his relentless pursuit of world domination by rbtree.

Unfortunately I don't have great ideas there.

It would be easy to add a flag to track if an anon_vma has ever been
referenced by a struct page, and not clone the anon_vma if the flag
isn't set. But, this wouldn't help at all with the DOS potential here.

If there are pages referencing the anon_vma, we could reassign these
to the parent anon_vma, but finding all such pages would be expensive
too.

Instead of adding an atomic count for page references, we could limit
the anon_vma stacking depth. In fork, we would only clone anon_vmas
that have a low enough generation count. I think that's not great
(adds a special case for the deep-fork-without-exec behavior), but
still better than the atomic page reference counter.

I would still prefer if we could just remove the anon_vma_chain stuff, though.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
