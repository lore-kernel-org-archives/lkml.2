Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965416Ab2EOPjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:39:25 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52401 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965021Ab2EOPjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:39:23 -0400
Date: Tue, 15 May 2012 08:37:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Moore <paul@paul-moore.com>
Cc: Eric Paris <eparis@parisplace.org>, Dave Jones <davej@redhat.com>,
        sds@tycho.nsa.gov, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: suspicious RCU usage in security/selinux/netnode.c
Message-ID: <20120515153757.GF2461@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120515044145.GA21910@redhat.com>
 <20120515144658.GC2461@linux.vnet.ibm.com>
 <CACLa4pt=Hh1=E9Jno_BAU-6stRL=hY3wehpWycKCYYJbJzYEGw@mail.gmail.com>
 <1923713.Kphzxkir2y@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1923713.Kphzxkir2y@sifl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051515-7606-0000-0000-0000005D1EBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 11:12:27AM -0400, Paul Moore wrote:
> On Tuesday, May 15, 2012 10:52:07 AM Eric Paris wrote:
> > On Tue, May 15, 2012 at 10:46 AM, Paul E. McKenney
> > 
> > <paulmck@linux.vnet.ibm.com> wrote:
> > > On Tue, May 15, 2012 at 10:24:23AM -0400, Eric Paris wrote:
> > >> On Tue, May 15, 2012 at 1:16 AM, Paul E. McKenney
> > >> 
> > >> <paulmck@linux.vnet.ibm.com> wrote:
> > >> > On Tue, May 15, 2012 at 12:41:45AM -0400, Dave Jones wrote:
> > >> >> I just triggered this on Linus' current tree.
> > >> > 
> > >> > This is a bare:
> > >> > 
> > >> >        rcu_dereference(sel_netnode_hash[idx].list.prev)
> > >> > 
> > >> > which needs to be in an RCU read-side critical section.  Alternatively,
> > >> > the above should instead be something like:
> > >> > 
> > >> >        rcu_dereference_check(sel_netnode_hash[idx].list.prev,
> > >> >                              lockdep_is_held(&sel_netnode_lock));
> > >> 
> > >> Right, but that 'bare' dereference comes from
> > >> list_for_each_entry_rcu(), [from sel_netnode_sid_slow()] which I don't
> > >> see how to easily annotate with the lock.  Nor do I think it's within
> > >> my brain power (or my willingness to maintain such in the future) to
> > >> want to open code that logic.
> > > 
> > > You lost me on this one.  The lockdep splat called out the
> > > rcu_dereference() above, not a list_for_each_entry_rcu().  Besides which,
> > > the list_for_each_entry_rcu() does not do the checking -- at the time,
> > > I was not willing to explode the API that much.
> > 
> > Ohhhh, ok.  I assumed we needed to annotate list_for_each_entry_rcu()
> > under the spinlock as well as the bare dereference in the insert code.
> >  Ok, should be very easy to fix, although the list running code is
> > still going to be un-annotated in any way.  Thanks
> 
> Sorry, email filters went awry and I lost this thread until Eric pointed it 
> out to me ...
> 
> Despite a common first name, the other Paul is the RCU expert, no I 
> unfortunately.  Can someone explain the difference between 
> rcu_dereference_check() and rcu_dereference_protected()?  We use 
> rcu_dereference_protected() for a very similar reason in 
> selinux/netport.c:sel_netport_insert() and it seems like a better choice ... ?

Here you go:

o	rcu_dereference_check() is for code shared between readers and
	writers, so that it might be protected by either rcu_read_lock()
	or some lock.

o	rcu_dereference_protected() is for code that is only used by
	updaters and never by readers.  So rcu_dereference_protected()
	is (slightly) lighter weight than rcu_dereference_check()
	because it does not need to protect against concurrent
	updates.

							Thanx, Paul

> I'll throw a patch together but wanted to clear this up first.
> 
> -- 
> paul moore
> www.paul-moore.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

