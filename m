Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab2K2UZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:25:35 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:32810 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab2K2UZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:25:32 -0500
Date: Thu, 29 Nov 2012 12:25:22 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel/rcutree.c:2850:13: warning: array subscript is above
 array bounds
Message-ID: <20121129202522.GB2474@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121129134752.GB219@x4>
 <20121129170241.GT2474@linux.vnet.ibm.com>
 <20121129174358.GA248@x4>
 <20121129181013.GW2474@linux.vnet.ibm.com>
 <20121129182254.GB248@x4>
 <20121129191933.GX2474@linux.vnet.ibm.com>
 <20121129200321.GC248@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121129200321.GC248@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112920-5806-0000-0000-00001C59DE00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 09:03:21PM +0100, Markus Trippelsdorf wrote:
> On 2012.11.29 at 11:19 -0800, Paul E. McKenney wrote:
> > On Thu, Nov 29, 2012 at 07:22:54PM +0100, Markus Trippelsdorf wrote:
> > > On 2012.11.29 at 10:10 -0800, Paul E. McKenney wrote:
> > > > On Thu, Nov 29, 2012 at 06:43:58PM +0100, Markus Trippelsdorf wrote:
> > > > > On 2012.11.29 at 09:02 -0800, Paul E. McKenney wrote:
> > > > > > On Thu, Nov 29, 2012 at 02:47:52PM +0100, Markus Trippelsdorf wrote:
> > > > > > > With gcc-4.8 I get:
> > > > > > > 
> > > > > > >   CC      kernel/rcutree.o
> > > > > > >   kernel/rcutree.c: In function ‘rcu_init_one’:
> > > > > > >   kernel/rcutree.c:2850:13: warning: array subscript is above array bounds [-Warray-bounds]
> > > > > > >      rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
> > > > > > >                   ^
> > > > > > > 2849    for (i = 1; i < rcu_num_lvls; i++)
> > > > > > > 2850           rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
> > > > > > > 
> > > > > > > At first I thought that the warning was bogus, but rcu_num_lvls isn't static
> > > > > > > and gets modified prior to the for loop.
> > > > > > 
> > > > > So, in your opinion, what would be the best way to silence this warning?
> > > > 
> > > > Good question.  Are you saying that if the compiler cannot prove that
> > > > the index is in bounds, it is going to throw a warning?  
> > > 
> > > Yes, it does seem to be the case. See also my gcc bug report (closed as
> > > invalid): http://gcc.gnu.org/bugzilla/show_bug.cgi?id=55529
> > > 
> > > > If that is the case, perhaps telling the compiler to cool it via the
> > > > command line would be best.
> > > > Or is this really one of a very few places in the kernel where the
> > > > compiler is complaining?
> > > 
> > > Yes. With my (admittedly minimal) config this is only place. 
> > 
> > Hmmmm...  In that case...
> > 
> > Given that this is initialization code that is far from any fastpath,
> > could you try putting something like this at the beginning of
> > rcu_init_one()?
> > 
> > 	if (rcu_num_lvls > RCU_NUM_LVLS)
> > 		panic("rcu_num_lvls overflow");
> > 
> > If the compiler doesn't know that panic() never returns (despite the
> > __noreturn), you could add a "return" after the panic().
> > 
> > Does that help?
> 
> Yes. This fixes the issue. Many thanks.
> 
> (Perhaps not surprisingly the warning never occurred for
> CONFIG_NR_CPUS>64.
> 
> I've also built a allyesconfig config and there was no -Warray-bounds
> warning at all.)

OK, I am applying this change with your Reported-by.  But please
understand that if something like this shows up in a fastpath, the
compiler will likely need to be told to keep its array-bounds opinions
to itself.

							Thanx, Paul

