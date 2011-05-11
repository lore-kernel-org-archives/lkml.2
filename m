Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab1EKPwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:52:45 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53855 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752152Ab1EKPwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:52:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18XVXJTR1EXtTeqRU1ZzNVavyCDFy244HyREfWP5C
	eqC8Pklrff9FTs
Subject: Re: [patch 01/15] sched: (fixlet) dont update shares twice on
 on_rq parent
From: Mike Galbraith <efault@gmx.de>
To: Paul Turner <pjt@google.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <BANLkTimr31i9hA375__Kw+i0GBFq5fPfvw@mail.gmail.com>
References: <20110503092846.022272244@google.com>
	 <20110503092904.541414484@google.com> <4DC8E5C2.9090701@jp.fujitsu.com>
	 <1305016326.14565.2.camel@marge.simson.net>
	 <4DCA40E8.3090805@jp.fujitsu.com>
	 <BANLkTimr31i9hA375__Kw+i0GBFq5fPfvw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 10:45:49 +0200
Message-ID: <1305103549.14389.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 01:13 -0700, Paul Turner wrote:
> On Wed, May 11, 2011 at 12:55 AM, Hidetoshi Seto
> <seto.hidetoshi@jp.fujitsu.com> wrote:
> > (2011/05/10 17:32), Mike Galbraith wrote:
> >> On Tue, 2011-05-10 at 16:14 +0900, Hidetoshi Seto wrote:
> >>> This small fixlet can stand alone.
> >>> Peter, how about getting this into git tree first?
> >>
> >> tip 2f36825b176f67e5c5228aa33d828bc39718811f contains the below.
> >>
> >>                 /* Don't dequeue parent if it has other entities besides us */
> >> -               if (cfs_rq->load.weight)
> >> +               if (cfs_rq->load.weight) {
> >> +                       /*
> >> +                        * Bias pick_next to pick a task from this cfs_rq, as
> >> +                        * p is sleeping when it is within its sched_slice.
> >> +                        */
> >> +                       if (task_sleep && parent_entity(se))
> >> +                               set_next_buddy(parent_entity(se));
> >>                         break;
> >> +               }
> >>                 flags |= DEQUEUE_SLEEP;
> >>         }
> >
> > Oh, thanks Mike!
> > It seems that this change in tip is better one.
> >
> > Paul, don't you mind rebasing your patches onto tip/sched/core next time?
> > (...or is there better branch for rebase?)
> >
> 
> I thought I had but apparently I missed this.
> 
> We still need to set se = parent_entity(se) to avoid the pointless
> double update below.
> 
> Will definitely rebase.

Wish I could, wouldn't have 114 other patches just to get evaluation
tree up to speed :)

Index: linux-2.6.32/kernel/sched_fair.c
===================================================================
--- linux-2.6.32.orig/kernel/sched_fair.c
+++ linux-2.6.32/kernel/sched_fair.c
@@ -1308,12 +1308,15 @@ static void dequeue_task_fair(struct rq

                /* Don't dequeue parent if it has other entities besides us */
                if (cfs_rq->load.weight) {
+                       /* Avoid double update below. */
+                       se = parent_entity(se);
+
                        /*
                         * Bias pick_next to pick a task from this cfs_rq, as
                         * p is sleeping when it is within its sched_slice.
                         */
-                       if (task_sleep && parent_entity(se))
-                               set_next_buddy(parent_entity(se));
+                       if (task_sleep && se)
+                               set_next_buddy(se);
                        break;
                }
                flags |= DEQUEUE_SLEEP;


