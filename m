Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030388Ab2AFP36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 10:29:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030340Ab2AFP34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 10:29:56 -0500
Date: Fri, 6 Jan 2012 16:23:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20120106152356.GA23995@redhat.com>
References: <20111221034334.GD17668@somewhere> <20111221130848.GA19679@redhat.com> <20111221175632.GF17668@somewhere> <20111221190102.GE13529@google.com> <20111221190817.GI17668@somewhere> <20111221192413.GF13529@google.com> <20111221200422.GJ17668@somewhere> <20111222153004.GA30522@redhat.com> <20120104193614.GF9511@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104193614.GF9511@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04, Mandeep Singh Baines wrote:
>
> Oleg Nesterov (oleg@redhat.com) wrote:
> > On 12/21, Frederic Weisbecker wrote:
> > >
> > > On Wed, Dec 21, 2011 at 11:24:13AM -0800, Mandeep Singh Baines wrote:
> > > >
> > > > If you call exec from a thread other than g, g is now unlinked. So
> > > > "t != g" will always be true. If you then pthread_create, you now
> > > > have two threads so "t != __prev" will also always be true. So
> > > > you now have an infinite loop.
> > >
> > > Oh you're right.
> > >
> > > But then we can't use t != t->group_leader because that assumes while_each_thread()
> > > started on the leader.
> >
> > Yes, this can't work.
> >
> > Besides, we need more burriers to rely on the ->group_leader check.
> >
> > See http://marc.info/?t=127688987300002
> >
>
> I went through the thread. Were there any other concerns other than
> requiring that you start with the group_leader and the barrier?
>
> You could modify zap_other_threads to start with the group leader by
> skipping p:
>
> if (p == t)
>    continue;

Yes, we can but there are other while_each_thread(nonleader) users.
Yes we can fix them too but this looks a bit ugly and we need to
change while_each_thread() anyway. And I do not see why this change
will be simpler if we restrict it to group_leader.

And note that zap_other_threads() is fine in any case, it is called
under ->siglock.

> > in particular, http://marc.info/?l=linux-kernel&m=127714242731448
> > I think this should work, but then we should do something with the
> > users like zap_threads().
> >
>
> With that patch, won't you potentially miss the exec thread if an exec
> occurs while you're iterating over the list? Is that OK?

Of course it is not OK ;) Note the "we should do something with" above.

Oleg.

