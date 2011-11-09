Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab1KHXB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:01:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687Ab1KHXBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:01:55 -0500
Date: Wed, 9 Nov 2011 01:01:46 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@suse.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] thp: reduce khugepaged freezing latency
Message-ID: <20111109000146.GA5075@redhat.com>
References: <4EB8E969.6010502@suse.cz>
 <1320766151-2619-1-git-send-email-aarcange@redhat.com>
 <1320766151-2619-2-git-send-email-aarcange@redhat.com>
 <4EB98A83.3040101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB98A83.3040101@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 01:31:07AM +0530, Srivatsa S. Bhat wrote:
> On 11/08/2011 08:59 PM, Andrea Arcangeli wrote:
> > Lack of set_freezable_with_signal() prevented khugepaged to be waken
> > up (and prevented to sleep again) across the
> > schedule_timeout_interruptible() calls after freezing() becomes
> > true. The tight loop in khugepaged_alloc_hugepage() also missed one
> > try_to_freeze() call in case alloc_hugepage() would repeatedly fail in
> > turn preventing the loop to break and to reach the try_to_freeze() in
> > the khugepaged main loop.
> > 
> > khugepaged would still freeze just fine by trying again the next
> > minute but it's better if it freezes immediately.
> > 
> > Reported-by: Jiri Slaby <jslaby@suse.cz>
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> > ---
> >  mm/huge_memory.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 4298aba..67311d1 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2277,6 +2277,7 @@ static struct page *khugepaged_alloc_hugepage(void)
> >  		if (!hpage) {
> >  			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
> >  			khugepaged_alloc_sleep();
> > +			try_to_freeze();
> >  		} else
> >  			count_vm_event(THP_COLLAPSE_ALLOC);
> >  	} while (unlikely(!hpage) &&
> > @@ -2331,7 +2332,7 @@ static int khugepaged(void *none)
> >  {
> >  	struct mm_slot *mm_slot;
> > 
> > -	set_freezable();
> > +	set_freezable_with_signal();
> >  	set_user_nice(current, 19);
> > 
> >  	/* serialize with start_khugepaged() */
> > 
> 
> Why do we need to use both set_freezable_with_signal() and an additional
> try_to_freeze()? Won't just using either one of them be good enough?
> Or am I missing something here?

set_freezable_with_signal() makes khugepaged quit and not re-enter the
sleep, try_to_freeze is needed to get the task from freezing to
frozen, otherwise it'll loop without getting frozen.
