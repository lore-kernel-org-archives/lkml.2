Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1GPXuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 19:50:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:33041 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab1GPXun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 19:50:43 -0400
Subject: Re: [PATCH 1/1] Fixup write permission of TLB on powerpc e500 core
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Shan Hai <haishan.bai@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
        tglx@linutronix.de, walken@google.com, dhowells@redhat.com,
        cmetcalf@tilera.com, tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <4E21A526.8010904@gmail.com>
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com>
	 <1310717238-13857-2-git-send-email-haishan.bai@gmail.com>
	 <1310725418.2586.309.camel@twins>  <4E21A526.8010904@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Jul 2011 09:49:54 +1000
Message-ID: <1310860194.25044.17.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-16 at 10:50 -0400, Shan Hai wrote:
> 
> That's right the gup(.write=1) want to do the same thing as the
> above code snippet, but it failed for the following reason:
> because the get_user_pages() would not dirty pte for the reason
> the follow_page() returns not NULL on *present* and *writable*
> page, the page which holds the lock is present because its a shared
> page,
> writable because demand paging set that up so for shared
> writable page, so the handle_mm_fault() in the __get_user_page()
> could not be called.
> 
> Why the above code could do the same task, because by calling
> handle_mm_fault() will set pte dirty by
> [do_annonymous_page(), memory.c]
> if (vma->vm_flags & VM_WRITE)
>                  entry = pte_mkwrite(pte_mkdirty(entry));
> 

Right. gup won't set page_dirty, it expects the caller to do so (in case
it doesn't dirty all the gup'ed pages a suppose).

You could probably fix the problem here by setting dirty after gup in
the futex code if you know you're going to write. You must do that with
the PTE lock held though and -not- at interrupt time.

Note however that the exact same problem exist with normal "read"
accesses and page_young (_PAGE_ACCESSED on powerpc). The page will not
be accessible until that bit is set and it's set by SW.

As I wrote earlier, fixing that by making "atomic" page faults perform
the dirty/accessed tracking is not right, since such faults can happen
at interrupt time and the PTE lock cannot be taken at interrupt time.

IE. The implementation of those "SW" TLB archs heavily relies on the PTE
lock to serialize write access to the PTE and writing it outside of that
lock would do really bad things.

So there's a deeper problem here. The whole user access "in atomic"
concept is by itself a violation of some of the basic access rules of
user memory that have existed from day 1 of the kernel. That we allow it
for semi-harmless (and allowed to fail) things like snapshot of
backtraces for perf is one thing, but relying on it for the futex case
like that is not going to fly very well. I sincerely hope that this kind
of usage is not going to become a habit.

In the meantime, other than rewriting the futex code to not require
those in-atomic accesses (can't it just access the pages via the linear
mapping and/or kmap after the gup ?), all I see would be a way to force
dirty and young after gup, with appropriate locks, or a variant of gup
(via a flag ?) to require it to do so.

Cheers,
Ben.

