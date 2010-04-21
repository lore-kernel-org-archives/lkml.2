Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185Ab0DUDOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 23:14:15 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49180 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab0DUDON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 23:14:13 -0400
Date: Tue, 20 Apr 2010 20:14:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Eric Paris <eparis@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Eric Paris <eparis@parisplace.org>, Miles Lane <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: INFO: suspicious rcu_dereference_check() usage -
 include/linux/cgroup.h:492 invoked rcu_dereference_check() without
 protection!
Message-ID: <20100421031410.GB2613@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <a44ae5cd1003071726u1f94336h7ab6c7b80d16723b@mail.gmail.com>
 <20100311032843.GE6767@linux.vnet.ibm.com>
 <q2x7e0fb38c1004121144rb097e521hd2a7d8cea77c54b7@mail.gmail.com>
 <1271098032.4807.137.camel@twins>
 <1271242058.32749.19.camel@laptop>
 <1271701612.2972.5.camel@dhcp231-113.rdu.redhat.com>
 <20100419230136.GA16856@linux.vnet.ibm.com>
 <4BCE4F6E.10301@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCE4F6E.10301@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 09:05:50AM +0800, Li Zefan wrote:
> > commit 2836f18139267ea918ed2cf39023fb0eb38c4361
> > Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Date:   Mon Apr 19 15:59:50 2010 -0700
> > 
> >     rcu: fix RCU lockdep splat on freezer_fork path
> >     
> >     Add an RCU read-side critical section to suppress this false positive.
> >     
> >     Located-by: Eric Paris <eparis@parisplace.org>
> >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
> > index da5e139..e5c0244 100644
> > --- a/kernel/cgroup_freezer.c
> > +++ b/kernel/cgroup_freezer.c
> > @@ -205,9 +205,12 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
> >  	 * No lock is needed, since the task isn't on tasklist yet,
> >  	 * so it can't be moved to another cgroup, which means the
> >  	 * freezer won't be removed and will be valid during this
> > -	 * function call.
> > +	 * function call.  Nevertheless, apply RCU read-side critical
> > +	 * section to suppress RCU lockdep false positives.
> >  	 */
> 
> It was me that added the original comment.
> 
> > +	rcu_read_lock();
> >  	freezer = task_freezer(task);
> > +	rcu_read_unlock();
> >  
> >  	/*
> >  	 * The root cgroup is non-freezable, so we can skip the
> 
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>

Thank you, Li!  I have added your Acked-by.

							Thanx, Paul
