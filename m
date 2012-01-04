Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab2ADTgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 14:36:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40424 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2ADTga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 14:36:30 -0500
Date: Wed, 4 Jan 2012 11:36:14 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Message-ID: <20120104193614.GF9511@google.com>
References: <20111221034334.GD17668@somewhere>
 <20111221130848.GA19679@redhat.com>
 <20111221175632.GF17668@somewhere>
 <20111221190102.GE13529@google.com>
 <20111221190817.GI17668@somewhere>
 <20111221192413.GF13529@google.com>
 <20111221200422.GJ17668@somewhere>
 <20111222153004.GA30522@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222153004.GA30522@redhat.com>
X-Operating-System: Linux/2.6.38.8-gg621 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov (oleg@redhat.com) wrote:
> On 12/21, Frederic Weisbecker wrote:
> >
> > On Wed, Dec 21, 2011 at 11:24:13AM -0800, Mandeep Singh Baines wrote:
> > >
> > > If you call exec from a thread other than g, g is now unlinked. So
> > > "t != g" will always be true. If you then pthread_create, you now
> > > have two threads so "t != __prev" will also always be true. So
> > > you now have an infinite loop.
> >
> > Oh you're right.
> >
> > But then we can't use t != t->group_leader because that assumes while_each_thread()
> > started on the leader.
> 
> Yes, this can't work.
> 
> Besides, we need more burriers to rely on the ->group_leader check.
> 
> See http://marc.info/?t=127688987300002
> 

I went through the thread. Were there any other concerns other than
requiring that you start with the group_leader and the barrier?

You could modify zap_other_threads to start with the group leader by
skipping p:

if (p == t)
   continue;

> in particular, http://marc.info/?l=linux-kernel&m=127714242731448
> I think this should work, but then we should do something with the
> users like zap_threads().
> 

With that patch, won't you potentially miss the exec thread if an exec
occurs while you're iterating over the list? Is that OK?

Regards,
Mandeep

> Oleg.
> 
