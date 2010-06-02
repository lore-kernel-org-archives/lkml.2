Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab0FBVMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:12:09 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47134 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab0FBVMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:12:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=l7vBACtIfUP+Bu2Q6hCOY29Z5nNXw7buBVHdxxMyHP/lgkXm2SBOH5WRskmWzoTf6
	3vCO0+ieQAqX/MQBEHNKQ==
Date: Wed, 2 Jun 2010 14:11:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>, balbir@linux.vnet.ibm.com,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
In-Reply-To: <20100602220429.F51E.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006021410300.32666@chino.kir.corp.google.com>
References: <20100601173535.GD23428@uudg.org> <alpine.DEB.2.00.1006011347060.13136@chino.kir.corp.google.com> <20100602220429.F51E.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jun 2010, KOSAKI Motohiro wrote:

> > > @@ -291,9 +309,10 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
> > >  		 * Otherwise we could get an easy OOM deadlock.
> > >  		 */
> > >  		if (p->flags & PF_EXITING) {
> > > -			if (p != current)
> > > +			if (p != current) {
> > > +				boost_dying_task_prio(p, mem);
> > >  				return ERR_PTR(-1UL);
> > > -
> > > +			}
> > >  			chosen = p;
> > >  			*ppoints = ULONG_MAX;
> > >  		}
> > 
> > This has the potential to actually make it harder to free memory if p is 
> > waiting to acquire a writelock on mm->mmap_sem in the exit path while the 
> > thread holding mm->mmap_sem is trying to run.
> 
> if p is waiting, changing prio have no effect. It continue tol wait to release mmap_sem.
> 

And that can reduce the runtime of the thread holding a writelock on 
mm->mmap_sem, making the exit actually take longer than without the patch 
if its priority is significantly higher, especially on smaller machines.
