Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964973Ab2EOOr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:47:28 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34097 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964782Ab2EOOr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:47:26 -0400
Date: Tue, 15 May 2012 07:46:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Dave Jones <davej@redhat.com>, sds@tycho.nsa.gov,
        Linux Kernel <linux-kernel@vger.kernel.org>, paul@paul-moore.com
Subject: Re: suspicious RCU usage in security/selinux/netnode.c
Message-ID: <20120515144658.GC2461@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120515044145.GA21910@redhat.com>
 <20120515051607.GH2412@linux.vnet.ibm.com>
 <CACLa4psGwEC96GfonAJ+-v0ocdvb_ZBxB6v=zAXbnbqFmuCNuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACLa4psGwEC96GfonAJ+-v0ocdvb_ZBxB6v=zAXbnbqFmuCNuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051514-6148-0000-0000-000005DC40AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 10:24:23AM -0400, Eric Paris wrote:
> On Tue, May 15, 2012 at 1:16 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Tue, May 15, 2012 at 12:41:45AM -0400, Dave Jones wrote:
> >> I just triggered this on Linus' current tree.
> >
> > This is a bare:
> >
> >        rcu_dereference(sel_netnode_hash[idx].list.prev)
> >
> > which needs to be in an RCU read-side critical section.  Alternatively,
> > the above should instead be something like:
> >
> >        rcu_dereference_check(sel_netnode_hash[idx].list.prev,
> >                              lockdep_is_held(&sel_netnode_lock));
> 
> Right, but that 'bare' dereference comes from
> list_for_each_entry_rcu(), [from sel_netnode_sid_slow()] which I don't
> see how to easily annotate with the lock.  Nor do I think it's within
> my brain power (or my willingness to maintain such in the future) to
> want to open code that logic.

You lost me on this one.  The lockdep splat called out the
rcu_dereference() above, not a list_for_each_entry_rcu().  Besides which,
the list_for_each_entry_rcu() does not do the checking -- at the time,
I was not willing to explode the API that much.

> Should we just take the rcu_read_lock() where we take the spinlock?
> Is that a perf hit and figuring out how to do the annotation correctly
> is the better idea?

If the spinlock is protecting the data, then just add the spinlock
to the rcu_dereference_check() as shown above.

							Thanx, Paul

