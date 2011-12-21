Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1LUUEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:04:36 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57044 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1LUUEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:04:32 -0500
Date: Wed, 21 Dec 2011 21:04:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20111221200422.GJ17668@somewhere>
References: <20111221034334.GD17668@somewhere>
 <20111221130848.GA19679@redhat.com>
 <20111221175632.GF17668@somewhere>
 <20111221190102.GE13529@google.com>
 <20111221190817.GI17668@somewhere>
 <20111221192413.GF13529@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221192413.GF13529@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 11:24:13AM -0800, Mandeep Singh Baines wrote:
> Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > On Wed, Dec 21, 2011 at 11:01:02AM -0800, Mandeep Singh Baines wrote:
> > > Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > > > On Wed, Dec 21, 2011 at 02:08:48PM +0100, Oleg Nesterov wrote:
> > > > > On 12/21, Frederic Weisbecker wrote:
> > > > > > Hi,
> > > > > >
> > > > > > Starring at some parts of cgroups, I have a few questions:
> > > > > >
> > > > > > - Is cgroup_enable_task_cg_list()'s while_each_thread() safe
> > > > > > against concurrent exec()? The leader may change in de_thread()
> > > > > > and invalidate the test done in while_each_thread().
> > > > > 
> > > > > Yes. Oh, we need to do something with while_each_thread.
> > > > 
> > > > Would something like this work?
> > > > 
> > > > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > > > index c0c5876..e002a00 100644
> > > > --- a/include/linux/sched.h
> > > > +++ b/include/linux/sched.h
> > > > @@ -2293,8 +2293,12 @@ extern bool current_is_single_threaded(void);
> > > >  #define do_each_thread(g, t) \
> > > >  	for (g = t = &init_task ; (g = t = next_task(g)) != &init_task ; ) do
> > > >  
> > > > -#define while_each_thread(g, t) \
> > > > -	while ((t = next_thread(t)) != g)
> > > > +#define while_each_thread(g, t)					\
> > > > +	while (({						\
> > > > +		struct task_struct *__prev = t;			\
> > > > +		t = next_thread(t);				\
> > > > +		t != __prev && t != g;				\
> > > 
> > > Hi,
> > > 
> > > Don't you still have an (highly unlikely) race if you exec
> > > and then pthread_create()?
> > 
> > I'm not sure what you mean.
> 
> Here is what I'm thinking:
> 
> If you call exec from a thread other than g, g is now unlinked. So
> "t != g" will always be true. If you then pthread_create, you now
> have two threads so "t != __prev" will also always be true. So
> you now have an infinite loop.

Oh you're right.

But then we can't use t != t->group_leader because that assumes while_each_thread()
started on the leader. Or may be we can take this assumption...

> 
> > 
> > > 
> > > Instead of:
> > > 
> > > t != __prev && t != g;
> > > 
> > > How about:
> > > 
> > > t != t->group_leader;
> > 
> > That might work too but we need a pair of memory barriers.
> 
> next_thread() calls list_entry_rcu. Shouldn't that protect against
> a dereference? You don't need to synchronize group_leader since
> you are only using it as a value. You don't dereference it.
> 
> Regards,
> Mandeep
