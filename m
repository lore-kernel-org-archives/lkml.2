Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab2LASvI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 13:51:08 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41250 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2LASvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 13:51:06 -0500
MIME-Version: 1.0
In-Reply-To: <20121201184135.GA32449@gmail.com>
References: <1354305521-11583-1-git-send-email-mingo@kernel.org>
 <CA+55aFwjxm7OYuucHeE2WFr4p+jwr63t=kSdHndta_QkyFbyBQ@mail.gmail.com>
 <20121201094927.GA12366@gmail.com> <20121201122649.GA20322@gmail.com>
 <CA+55aFx8QtP0hg8qxn__4vHQuzH7QkhTN-4fwgOpM-A=KuBBjA@mail.gmail.com> <20121201184135.GA32449@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Dec 2012 10:50:44 -0800
X-Google-Sender-Auth: LQA3KasDVLV2ObRvpcHWjAgJ01Y
Message-ID: <CA+55aFyq7OaUxcEHXvJhp0T57KN14o-RGxqPmA+ks8ge6zJh5w@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/migration: Remove anon vma locking from
 try_to_unmap() use
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 1, 2012 at 10:41 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> I'll try the rwsem and see how it goes?

Yeah. That should be an easy conversion (just convert everything to
use the write-lock first, and then you can make one or two migration
places use the read version).

Side note: The mutex code tends to potentially generate slightly
faster noncontended locks than rwsems, and it does have the
MUTEX_SPIN_ON_OWNER feature that makes the contention case often
*much* better, so there are real downsides to rw-semaphores.

But for this load, it does seem like the scalability advantages of an
rwsem *might* be worth it.

Side note: in contrast, the rwlock spinning reader-writer locks are
basically never a win - the downsides just about always negate any
theoretical scalability advantage. rwsem's can work well, we already
use it for mmap_sem, for example, to allow concurrent page faults, and
it was a *big* scalabiloity win there. Although then we did the "drop
mmap_sem over IO and retry", and that might have negated many of the
advantages of the mmap_sem.

> Hm, indeed. For performance runs I typically disable lock
> debugging - which might have made me not directly notice some of
> the performance problems.

Yeah, lock debugging really tends to make anything that is close to
contended be absolutely *horribly* contended. Doubly so for the
mutexes because it disables the spinning code, but it's true in
general too.

                Linus
