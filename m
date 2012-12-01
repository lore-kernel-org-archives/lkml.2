Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2LASii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 13:38:38 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34032 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab2LASih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 13:38:37 -0500
MIME-Version: 1.0
In-Reply-To: <20121201122649.GA20322@gmail.com>
References: <1354305521-11583-1-git-send-email-mingo@kernel.org>
 <CA+55aFwjxm7OYuucHeE2WFr4p+jwr63t=kSdHndta_QkyFbyBQ@mail.gmail.com>
 <20121201094927.GA12366@gmail.com> <20121201122649.GA20322@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Dec 2012 10:38:16 -0800
X-Google-Sender-Auth: V2yII4FQgjFot-T00hWHuGduNHg
Message-ID: <CA+55aFx8QtP0hg8qxn__4vHQuzH7QkhTN-4fwgOpM-A=KuBBjA@mail.gmail.com>
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

On Sat, Dec 1, 2012 at 4:26 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
>
> So as a quick concept hack I wrote the patch attached below.
> (It's not signed off, see the patch description text for the
> reason.)

Well, it confirms that anon_vma locking is a big problem, but as
outlined in my other email it's completely incorrect from an actual
behavior standpoint.

Btw, I think the anon_vma lock could be made a spinlock instead of a
mutex or rwsem, but that would probably take more work. We *shouldn't*
be doing anything that needs IO inside the anon_vma lock, though, so
it *should* be doable. But there are probably quite a bit of
allocations inside the lock, and I know it covers huge areas, so a
spinlock might not only be hard to convert to, it quite likely has
latency issues too.

Oh, btw, MUTEX_SPIN_ON_OWNER may well improve performance too, but it
gets disabled by DEBUG_MUTEXES. So some of the performance impact of
the vma locking may be *very* kernel-config dependent.

                  Linus
