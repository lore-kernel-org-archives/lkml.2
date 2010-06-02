Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab0FBXgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 19:36:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50199 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518Ab0FBXgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 19:36:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, balbir@linux.vnet.ibm.com,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
In-Reply-To: <alpine.DEB.2.00.1006021410300.32666@chino.kir.corp.google.com>
References: <20100602220429.F51E.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006021410300.32666@chino.kir.corp.google.com>
Message-Id: <20100603083259.7231.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Jun 2010 08:36:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2 Jun 2010, KOSAKI Motohiro wrote:
> 
> > > > @@ -291,9 +309,10 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
> > > >  		 * Otherwise we could get an easy OOM deadlock.
> > > >  		 */
> > > >  		if (p->flags & PF_EXITING) {
> > > > -			if (p != current)
> > > > +			if (p != current) {
> > > > +				boost_dying_task_prio(p, mem);
> > > >  				return ERR_PTR(-1UL);
> > > > -
> > > > +			}
> > > >  			chosen = p;
> > > >  			*ppoints = ULONG_MAX;
> > > >  		}
> > > 
> > > This has the potential to actually make it harder to free memory if p is 
> > > waiting to acquire a writelock on mm->mmap_sem in the exit path while the 
> > > thread holding mm->mmap_sem is trying to run.
> > 
> > if p is waiting, changing prio have no effect. It continue tol wait to release mmap_sem.
> > 
> 
> And that can reduce the runtime of the thread holding a writelock on 
> mm->mmap_sem, making the exit actually take longer than without the patch 
> if its priority is significantly higher, especially on smaller machines.

If p need mmap_sem, p is going to sleep to wait mmap_sem. if p doesn't,
quickly exit is good thing. In other word, task fairness is not our goal
when oom occur.



