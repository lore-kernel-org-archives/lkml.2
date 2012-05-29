Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab2E2Quu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:50:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab2E2Qus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:50:48 -0400
Date: Tue, 29 May 2012 18:49:52 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 30/35] autonuma: reset autonuma page data when pages are
 freed
Message-ID: <20120529164952.GG21339@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
 <1337965359-29725-31-git-send-email-aarcange@redhat.com>
 <1338309029.26856.123.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338309029.26856.123.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 06:30:29PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-05-25 at 19:02 +0200, Andrea Arcangeli wrote:
> > When pages are freed abort any pending migration. If knuma_migrated
> > arrives first it will notice because get_page_unless_zero would fail.
> 
> But knuma_migrated can run on a different cpu than this free is
> happening, ACCESS_ONCE() won't cure that.

knuma_migrated won't alter the last_nid and it generally won't work on
any page that has page_count() = 0.

last_nid is the false sharing avoidance information (btw, that really
better exist for every page, unlike the list node, which might be
limited maybe).

Then there's a second false sharing avoidance through the implicit
properties of the autonuma_migrate_head lrus and the
migration-cancellation in numa_hinting_fault_memory_follow_cpu (which
is why I wouldn't like the idea of an insert-only list, even if it
would save a pointer per page, but then I couldn't cancel the
migration when a false sharing is detected and knuma_migrated is
congested).

> What's that ACCESS_ONCE() good for?

The ACCESS_ONCE was used when setting last_nid, to tell gcc the value
can change from under it. It shouldn't alter the code emitted here and
probably it's superfluous in any case.

But considering that the page is being freed, I don't think it can
change from under us here so this was definitely superflous, numa
hinting page faults can't run on that page. I will remove it, thanks!

> 
> Also, you already have an autonuma_ hook right there, why add more
> #ifdeffery ?

Agreed, the #ifdef is in fact already cleaned up in page_autonuma,
with autonuma_page_free.

-       autonuma_migrate_page_remove(page);
-#ifdef CONFIG_AUTONUMA
-       ACCESS_ONCE(page->autonuma_last_nid) = -1;
-#endif
+       autonuma_free_page(page);

> 
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> > ---
> >  mm/page_alloc.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 3d1ee70..1d3163f 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -614,6 +614,10 @@ static inline int free_pages_check(struct page *page)
> >  		bad_page(page);
> >  		return 1;
> >  	}
> > +	autonuma_migrate_page_remove(page);
> > +#ifdef CONFIG_AUTONUMA
> > +	ACCESS_ONCE(page->autonuma_last_nid) = -1;
> > +#endif
> >  	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
> >  		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
> >  	return 0;
> 
