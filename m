Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab1D2AFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 20:05:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40432 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758106Ab1D2AFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 20:05:02 -0400
Subject: Re: [PATCH 1/2] break out page allocation warning code
From: john stultz <johnstul@us.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1304034500.2971.160.camel@work-vm>
References: <alpine.DEB.2.00.1104201317410.31768@chino.kir.corp.google.com>
	 <1303331695.2796.159.camel@work-vm>
	 <20110421103009.731B.A69D9226@jp.fujitsu.com>
	 <1303846026.2816.117.camel@work-vm>
	 <alpine.DEB.2.00.1104271641350.25369@chino.kir.corp.google.com>
	 <1303950728.2971.35.camel@work-vm> <1303954193.2971.43.camel@work-vm>
	 <alpine.DEB.2.00.1104281545590.24536@chino.kir.corp.google.com>
	 <1304034500.2971.160.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 17:04:55 -0700
Message-ID: <1304035495.2971.169.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-28 at 16:48 -0700, john stultz wrote:
> On Thu, 2011-04-28 at 15:48 -0700, David Rientjes wrote:
> > On Wed, 27 Apr 2011, john stultz wrote:
> > 
> > > So thinking further, this can be simplified by adding the seqlock first,
> > > and then retaining the task_locking only in the set_task_comm path until
> > > all comm accessors are converted to using get_task_comm.
> > > 
> > 
> > On second thought, I think it would be better to just retain using a 
> > spinlock but instead of using alloc_lock, introduce a new spinlock to 
> > task_struct for the sole purpose of protecting comm.
> > 
> > And, instead, of using get_task_comm() to write into a preallocated 
> > buffer, I think it would be easier in the vast majority of cases that 
> > you'll need to convert to just provide task_comm_lock(p) and 
> > task_comm_unlock(p) so that p->comm can be dereferenced safely.  

Ok.. trying to find a middle ground here by replying to my own
concerns. :)

> So my concern with this is that it means one more lock that could be
> mis-nested. By keeping the locking isolated to the get/set_task_comm, we
> can be sure that won't happen. 
> 
> Also tracking new current->comm references will be easier if we just
> don't allow new ones. Validating that all the comm references are
> correctly locked becomes more difficult if we need locking at each use
> site.

So maybe we still ban current->comm access and instead have a
lightweight get_comm_locked() accessor or something that. Then we can
add debugging options to validate that the lock is properly held
internally.

> Further, since I'm not convinced that we never reference current->comm
> from irq context, if we go with spinlocks, we're going to have to
> disable irqs in the read path as well. seqlocks were nice for that
> aspect.

rwlocks can resolve this concern.


Any other thoughts?

-john

