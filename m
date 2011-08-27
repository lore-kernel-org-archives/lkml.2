Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab1H0JmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 05:42:06 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49077 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab1H0JmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 05:42:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:to:cc:subject:message-id:
	references:mime-version:content-type:content-disposition:in-reply-to:
	user-agent:x-system-of-record;
	b=a8L+kl5/+ye42Nck5GzvJTSIKgtiYT58prSzcvENwatXmfFvMKtPfTLQNLI8DDB0Y
	9sQkybmuz1erwTZ9cQTKQ==
Date: Sat, 27 Aug 2011 02:41:52 -0700
From: Michel Lespinasse <walken@google.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] thp: tail page refcounting fix #3
Message-ID: <20110827094152.GA16402@google.com>
References: <1313740111-27446-1-git-send-email-walken@google.com>
 <20110822213347.GF2507@redhat.com>
 <CANN689HE=TKyr-0yDQgXEoothGJ0Cw0HLB2iOvCKrOXVF2DNww@mail.gmail.com>
 <20110824000914.GH23870@redhat.com>
 <20110824002717.GI23870@redhat.com>
 <20110824133459.GP23870@redhat.com>
 <20110826062436.GA5847@google.com>
 <20110826161048.GE23870@redhat.com>
 <20110826185430.GA2854@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110826185430.GA2854@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 08:54:36PM +0200, Andrea Arcangeli wrote:
> Subject: thp: tail page refcounting fix
> 
> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> Michel while working on the working set estimation code, noticed that calling
> get_page_unless_zero() on a random pfn_to_page(random_pfn) wasn't safe, if the
> pfn ended up being a tail page of a transparent hugepage under splitting by
> __split_huge_page_refcount(). He then found the problem could also
> theoretically materialize with page_cache_get_speculative() during the
> speculative radix tree lookups that uses get_page_unless_zero() in SMP if the
> radix tree page is freed and reallocated and get_user_pages is called on it
> before page_cache_get_speculative has a chance to call get_page_unless_zero().
> 
> So the best way to fix the problem is to keep page_tail->_count zero at all
> times. This will guarantee that get_page_unless_zero() can never succeed on any
> tail page. page_tail->_mapcount is guaranteed zero and is unused for all tail
> pages of a compound page, so we can simply account the tail page references
> there and transfer them to tail_page->_count in __split_huge_page_refcount() (in
> addition to the head_page->_mapcount).
> 
> While debugging this s/_count/_mapcount/ change I also noticed get_page is
> called by direct-io.c on pages returned by get_user_pages. That wasn't entirely
> safe because the two atomic_inc in get_page weren't atomic. As opposed other
> get_user_page users like secondary-MMU page fault to establish the shadow
> pagetables would never call any superflous get_page after get_user_page
> returns. It's safer to make get_page universally safe for tail pages and to use
> get_page_foll() within follow_page (inside get_user_pages()). get_page_foll()
> is safe to do the refcounting for tail pages without taking any locks because
> it is run within PT lock protected critical sections (PT lock for pte and
> page_table_lock for pmd_trans_huge). The standard get_page() as invoked by
> direct-io instead will now take the compound_lock but still only for tail
> pages. The direct-io paths are usually I/O bound and the compound_lock is per
> THP so very finegrined, so there's no risk of scalability issues with it. A
> simple direct-io benchmarks with all lockdep prove locking and spinlock
> debugging infrastructure enabled shows identical performance and no overhead.
> So it's worth it. Ideally direct-io should stop calling get_page() on pages
> returned by get_user_pages(). The spinlock in get_page() is already optimized
> away for no-THP builds but doing get_page() on tail pages returned by GUP is
> generally a rare operation and usually only run in I/O paths.
> 
> This new refcounting on page_tail->_mapcount in addition to avoiding new RCU
> critical sections will also allow the working set estimation code to work
> without any further complexity associated to the tail page refcounting
> with THP.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Reported-by: Michel Lespinasse <walken@google.com>

Looks great !

I understand you may have to remove the VM_BUG_ON(page_mapcount(page) <= 0)
that I had suggested in __get_page_tail() (sorry about that).

My only additional suggestion is about the put_page_testzero in
__get_page_tail(), maybe if you could just increment the tail page count
instead of calling __get_page_tail_foll(), then you wouldn't have to
release the extra head page count there. And it would even look kinda
natural, head page count gets acquired before compound_lock_irqsave(),
so we only have to acquire an extra tail page count after confirming
this is still a tail page.

Either way, the code looks OK by now.

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
