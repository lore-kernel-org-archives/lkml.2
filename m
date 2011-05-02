Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab1EBXgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:36:46 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46928 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761Ab1EBXgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:36:44 -0400
Date: Mon, 2 May 2011 16:03:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: query: [PATCH 2/2] cgroup: Remove call to synchronize_rcu in
 cgroup_attach_task
Message-ID: <20110502230314.GR2294@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1302170153.12304.31.camel@marge.simson.net>
 <4DA50430.8020701@cn.fujitsu.com>
 <1302664313.7407.29.camel@marge.simson.net>
 <BANLkTikqvP90Etu=L24DPWbckrawM-6n=Q@mail.gmail.com>
 <1303136494.7542.20.camel@marge.simson.net>
 <1303983516.7460.5.camel@marge.simson.net>
 <1304080487.21536.16.camel@marge.simson.net>
 <20110502134635.GB4197@linux.vnet.ibm.com>
 <1304346554.6281.15.camel@marge.simson.net>
 <1304348640.6281.33.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304348640.6281.33.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 05:04:00PM +0200, Mike Galbraith wrote:
> On Mon, 2011-05-02 at 16:29 +0200, Mike Galbraith wrote:
> > On Mon, 2011-05-02 at 06:46 -0700, Paul E. McKenney wrote:
> > > On Fri, Apr 29, 2011 at 02:34:47PM +0200, Mike Galbraith wrote:
> > 
> > > > Makes one wonder what these things do for a living.
> > > 
> > > If you are adding something to an RCU-protected data structure, then you do
> > > not need synchronize_rcu().  But if you are removing something from
> > > an RCU-protected data structure, then you really do need them.  If you
> > > leave them out, you can see the following type of failure:
> > > 
> > > 1.	CPU 0, running in an RCU read-side critical section, obtains
> > > 	a pointer to data item A.
> > > 
> > > 2.	CPU 1 removes data item A from the structure.
> > > 
> > > 3.	CPU 1 does not do a synchronize_rcu().  If CPU 1 had done a
> > > 	synchronize_rcu(), then it would have waited until CPU 0 had
> > > 	left its RCU read-side critical section, and thus until
> > > 	CPU 0 stopped using its pointer to data item A.  But there was
> > > 	no synchronize_rcu(), so CPU 0 is still looking at data item A.
> > > 
> > > 4.	CPU 1 frees data item A.
> > > 
> > > This is very bad.  CPU 0 has a pointer into the freelist.  Worse yet,
> > > some other CPU might allocate memory and get a pointer to data item A.
> > > That CPU and CPU 0 would then have an interesting but short lived
> > > disagreement about that memory's type.  Crash goes the kernel.
> > > 
> > > So please do not remove synchronize_rcu() calls unless you can prove
> > > that it is safe to do so!
> > 
> > In these instances are a little different.
> > 
> > We have..
> >     start teardown
> >     synchronize_rcu()
> >     finish teardown
> >     call_rcu(kfree_it) 
> > ..so removal wouldn't trigger the standard "let's rummage around in
> > freed memory" kind of excitement.
> > 
> > But yeah, removing them without proof is out.
> > 
> > My box was telling me that they _are_ safe to remove, by not exploding
> > with list/slub debug enabled while I beat the snot out of it.. which is
> > evidence, but not proof :)
> 
> P.S. the explosions I was looking into were caused by that finish
> teardown being in flight via schedule_work() when android removed
> synchronize_rcu() _and synchronization on in-flight teardown_.  I became
> curious wrt the need for synchronize_rcu() at all when I fixed these
> explosions by ensuring that teardown was _not_ in flight before
> shredding the cgroup via rmdir, by doing synchronous teardown if
> possible, and only synchronizing if it wasn't possible.  Only removing
> synchronize_rcu() does essentially the same, since teardown is then done
> synchronously under the big mutex.  Freeing is still done via rcu.
> 
> So it wasn't "these things make userspace sleepy, let's remove them".

OK, but you did have me going for a bit there!  ;-)

							Thanx, Paul
