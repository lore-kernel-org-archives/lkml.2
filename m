Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab0GHK5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 06:57:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46734 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab0GHK5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 06:57:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: FYI: mmap_sem OOM patch
Cc: kosaki.motohiro@jp.fujitsu.com, Michel Lespinasse <walken@google.com>,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Divyesh Shah <dpshah@google.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1278586173.1900.50.camel@laptop>
References: <AANLkTimLSnNot2byTWYuIHE8rhGLXbl1zKsQQhmci1Do@mail.gmail.com> <1278586173.1900.50.camel@laptop>
Message-Id: <20100708195421.CD48.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  8 Jul 2010 19:57:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2010-07-08 at 03:39 -0700, Michel Lespinasse wrote:
> > 
> > 
> >         One way to fix this is to have T4 wake from the oom queue and return an
> >         allocation failure instead of insisting on going oom itself when T1
> >         decides to take down the task.
> > 
> > How would you have T4 figure out the deadlock situation ? T1 is taking down T2, not T4... 
> 
> If T2 and T4 share a mmap_sem they belong to the same process. OOM takes
> down the whole process by sending around signals of sorts (SIGKILL?), so
> if T4 gets a fatal signal while it is waiting to enter the oom thingy,
> have it abort and return an allocation failure.
> 
> That alloc failure (along with a pending fatal signal) will very likely
> lead to the release of its mmap_sem (if not, there's more things to
> cure).
> 
> At which point the cycle is broken an stuff continues as it was
> intended.

Now, I've reread current code. I think mmotm already have this.


T4 call out_of_memory and get TIF_MEMDIE
=========================================================
void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
                int order, nodemask_t *nodemask)
{
(snip)
        /*
         * If current has a pending SIGKILL, then automatically select it.  The
         * goal is to allow it to allocate so that it may quickly exit and free
         * its memory.
         */
        if (fatal_signal_pending(current)) {
                set_thread_flag(TIF_MEMDIE);
                boost_dying_task_prio(current, NULL);
                return;
        }
==================================================================


alloc_pages immediately return if the task have TIF_MEMDIE
==================================================================
static inline struct page *
__alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
        struct zonelist *zonelist, enum zone_type high_zoneidx,
        nodemask_t *nodemask, struct zone *preferred_zone,
        int migratetype)
{
(snip)
        /* Avoid allocations with no watermarks from looping endlessly */
        if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
                goto nopage;
==========================================================================


Thought?



