Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab2LQD3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 22:29:24 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48867 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2LQD3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 22:29:23 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrW58pb2w_r0gUDmMVSqi8PBQRdR1dRj2HX0ymq+qnz8XA@mail.gmail.com>
References: <3b624af48f4ba4affd78466b73b6afe0e2f66549.1355463438.git.luto@amacapital.net>
	<2e91ea19fbd30fa17718cb293473ae207ee8fd0f.1355536006.git.luto@amacapital.net>
	<CANN689HG3tYAjijoeU0fMZW+sxGFyKFtzgycLMubT-rEPQhrRw@mail.gmail.com>
	<CALCETrW58pb2w_r0gUDmMVSqi8PBQRdR1dRj2HX0ymq+qnz8XA@mail.gmail.com>
Date: Sun, 16 Dec 2012 19:29:22 -0800
Message-ID: <CANN689GKp-9Bfn6HENeSXe=PZ0Qy5uOP6ju5gosMFKFDPC0D8w@mail.gmail.com>
Subject: Re: [PATCH v2] mm: Downgrade mmap_sem before locking or populating on mmap
From: Michel Lespinasse <walken@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 10:05 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Sun, Dec 16, 2012 at 4:39 AM, Michel Lespinasse <walken@google.com> wrote:
>> My main concern is that just downgrading the mmap_sem only hides the
>> problem: as soon as a writer gets queued on that mmap_sem,
>> reader/writer fairness kicks in and blocks any new readers, which
>> makes the problem reappear. So in order to completely fix the issue,
>> we should look for a way that doesn't require holding the mmap_sem
>> (even in read mode) for the entire duration of the populate or mlock
>> operation.
>
> Ugh.
>
> At least with my patch, mmap in MCL_FUTURE mode is no worse than mmap
> + mlock.  I suspect I haven't hit this because all my mmaping is done
> by one thread, so it never ends up waiting for itself, and the other
> thread have very short mmap_sem hold times.

Yes, you won't hit the problems with long read-side mmap_sem hold
times if you don't have other threads blocking for the write side.

>> I think this could be done by extending the mlock work I did as part
>> of v2.6.38-rc1. The commit message for
>> c explains the idea; basically
>> mlock() was split into do_mlock() which just sets the VM_LOCKED flag
>> on vmas as needed, and do_mlock_pages() which goes through a range of
>> addresses and actually populates/mlocks each individual page that is
>> part of a VM_LOCKED vma.
>
> Doesn't this have the same problem?  It holds mmap_sem for read for a
> long time, and if another writer comes in then r/w starvation
> prevention will kick in.

Well, my point is that do_mlock_pages() doesn't need to hold the
mmap_sem read side for a long time. It currently releases it when
faulting a page requires a disk read, and could conceptually release
it more often if needed.

We can't easily release mmap_sem from within mmap_region() since
mmap_region's callers don't expect it; however we can defer the page
mlocking and we don't have to hold mmap_sem continuously until then.
The only constraints are the new VM_LOCKED region's pages must be
mlocked before we return to userspace, and that if a concurrent thread
modifies the mappings while we don't hold mmap_sem, and creates a new
non-mlocked region, we shouldn't mlock those pages in
do_mlock_pages().

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
