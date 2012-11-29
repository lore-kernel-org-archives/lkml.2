Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab2K2T2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:28:53 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:51818 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2K2T2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:28:52 -0500
Date: Thu, 29 Nov 2012 11:19:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel/rcutree.c:2850:13: warning: array subscript is above
 array bounds
Message-ID: <20121129191933.GX2474@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121129134752.GB219@x4>
 <20121129170241.GT2474@linux.vnet.ibm.com>
 <20121129174358.GA248@x4>
 <20121129181013.GW2474@linux.vnet.ibm.com>
 <20121129182254.GB248@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121129182254.GB248@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112919-7282-0000-0000-00000F82ABAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 07:22:54PM +0100, Markus Trippelsdorf wrote:
> On 2012.11.29 at 10:10 -0800, Paul E. McKenney wrote:
> > On Thu, Nov 29, 2012 at 06:43:58PM +0100, Markus Trippelsdorf wrote:
> > > On 2012.11.29 at 09:02 -0800, Paul E. McKenney wrote:
> > > > On Thu, Nov 29, 2012 at 02:47:52PM +0100, Markus Trippelsdorf wrote:
> > > > > With gcc-4.8 I get:
> > > > > 
> > > > >   CC      kernel/rcutree.o
> > > > >   kernel/rcutree.c: In function ‘rcu_init_one’:
> > > > >   kernel/rcutree.c:2850:13: warning: array subscript is above array bounds [-Warray-bounds]
> > > > >      rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
> > > > >                   ^
> > > > > 2849    for (i = 1; i < rcu_num_lvls; i++)
> > > > > 2850           rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
> > > > > 
> > > > > At first I thought that the warning was bogus, but rcu_num_lvls isn't static
> > > > > and gets modified prior to the for loop.
> > > > 
> > > > You are quite correct that rcu_num_lvls does get modified, but there
> > > > are checks in rcu_init_geometry() to ensure that it does not increase:
> > > > 
> > > > 	/*
> > > > 	 * The boot-time rcu_fanout_leaf parameter is only permitted
> > > > 	 * to increase the leaf-level fanout, not decrease it.  Of course,
> > > > 	 * the leaf-level fanout cannot exceed the number of bits in
> > > > 	 * the rcu_node masks.  Finally, the tree must be able to accommodate
> > > > 	 * the configured number of CPUs.  Complain and fall back to the
> > > > 	 * compile-time values if these limits are exceeded.
> > > > 	 */
> > > > 	if (rcu_fanout_leaf < CONFIG_RCU_FANOUT_LEAF ||
> > > > 	    rcu_fanout_leaf > sizeof(unsigned long) * 8 ||
> > > > 	    n > rcu_capacity[MAX_RCU_LVLS]) {
> > > > 		WARN_ON(1);
> > > > 		return;
> > > > 	}
> > > > 
> > > > The value of rcu_num_lvls starts out at RCU_NUM_LVLS, the same as
> > > > the dimension of the ->level[] array.  The loop goes only to one less
> > > > than rcu_num_lvls, as needed, and rcu_num_lvls is never greater than
> > > > RCU_NUM_LVLS, so this should be safe.
> > > > 
> > > > So what am I missing here?
> > > 
> > > rcu_num_lvls does get modified in rcu_init_geometry:
> > > 
> > > 2942         /* Calculate the number of rcu_nodes at each level of the tree. */
> > > 2943         for (i = 1; i <= MAX_RCU_LVLS; i++)
> > > 2944                 if (n <= rcu_capacity[i]) {
> > > 2945                         for (j = 0; j <= i; j++)
> > > 2946                                 num_rcu_lvl[j] =
> > > 2947                                         DIV_ROUND_UP(n, rcu_capacity[i - j]);
> > > 2948                         rcu_num_lvls = i;
> > > 
> > > And rcu_init_geometry gets called before rcu_init_one, so the compiler assumes
> > > the worst and issues a warning.
> > > So, in your opinion, what would be the best way to silence this warning?
> > 
> > Good question.  Are you saying that if the compiler cannot prove that
> > the index is in bounds, it is going to throw a warning?  
> 
> Yes, it does seem to be the case. See also my gcc bug report (closed as
> invalid): http://gcc.gnu.org/bugzilla/show_bug.cgi?id=55529
> 
> > If that is the case, perhaps telling the compiler to cool it via the
> > command line would be best.
> > Or is this really one of a very few places in the kernel where the
> > compiler is complaining?
> 
> Yes. With my (admittedly minimal) config this is only place. 

Hmmmm...  In that case...

Given that this is initialization code that is far from any fastpath,
could you try putting something like this at the beginning of
rcu_init_one()?

	if (rcu_num_lvls > RCU_NUM_LVLS)
		panic("rcu_num_lvls overflow");

If the compiler doesn't know that panic() never returns (despite the
__noreturn), you could add a "return" after the panic().

Does that help?

							Thanx, Paul

