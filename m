Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1EJIcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:32:16 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:34430 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756064Ab1EJIcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:32:12 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+nxKAhPCKn2K1yEPr9gNHwK+TpgGAIR1FRGyNuKW
	CDbm85Mb1bI6zE
Subject: Re: [patch 01/15] sched: (fixlet) dont update shares twice on
 on_rq parent
From: Mike Galbraith <efault@gmx.de>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <4DC8E5C2.9090701@jp.fujitsu.com>
References: <20110503092846.022272244@google.com>
	 <20110503092904.541414484@google.com>  <4DC8E5C2.9090701@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 10:32:06 +0200
Message-ID: <1305016326.14565.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 16:14 +0900, Hidetoshi Seto wrote:
> (2011/05/03 18:28), Paul Turner wrote:
> > In dequeue_task_fair() we bail on dequeue when we encounter a parenting entity
> > with additional weight.  However, we perform a double shares update on this
> > entity since we continue the shares update traversal from that point, despite
> > dequeue_entity() having already updated its queuing cfs_rq.
> > 
> > Avoid this by starting from the parent when we resume.
> > 
> > Signed-off-by: Paul Turner <pjt@google.com>
> > ---
> >  kernel/sched_fair.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > Index: tip/kernel/sched_fair.c
> > ===================================================================
> > --- tip.orig/kernel/sched_fair.c
> > +++ tip/kernel/sched_fair.c
> > @@ -1355,8 +1355,10 @@ static void dequeue_task_fair(struct rq 
> >  		dequeue_entity(cfs_rq, se, flags);
> >  
> >  		/* Don't dequeue parent if it has other entities besides us */
> > -		if (cfs_rq->load.weight)
> > +		if (cfs_rq->load.weight) {
> > +			se = parent_entity(se);
> >  			break;
> > +		}
> >  		flags |= DEQUEUE_SLEEP;
> >  	}
> >  
> 
> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> 
> This small fixlet can stand alone.
> Peter, how about getting this into git tree first?

tip 2f36825b176f67e5c5228aa33d828bc39718811f contains the below.

                /* Don't dequeue parent if it has other entities besides us */
-               if (cfs_rq->load.weight)
+               if (cfs_rq->load.weight) {
+                       /*
+                        * Bias pick_next to pick a task from this cfs_rq, as
+                        * p is sleeping when it is within its sched_slice.
+                        */
+                       if (task_sleep && parent_entity(se))
+                               set_next_buddy(parent_entity(se));
                        break;
+               }
                flags |= DEQUEUE_SLEEP;
        }


