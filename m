Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2K2UD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:03:26 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:42042 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab2K2UDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:03:24 -0500
Date: Thu, 29 Nov 2012 21:03:21 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel/rcutree.c:2850:13: warning: array subscript is above
 array bounds
Message-ID: <20121129200321.GC248@x4>
References: <20121129134752.GB219@x4>
 <20121129170241.GT2474@linux.vnet.ibm.com>
 <20121129174358.GA248@x4>
 <20121129181013.GW2474@linux.vnet.ibm.com>
 <20121129182254.GB248@x4>
 <20121129191933.GX2474@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121129191933.GX2474@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.11.29 at 11:19 -0800, Paul E. McKenney wrote:
> On Thu, Nov 29, 2012 at 07:22:54PM +0100, Markus Trippelsdorf wrote:
> > On 2012.11.29 at 10:10 -0800, Paul E. McKenney wrote:
> > > On Thu, Nov 29, 2012 at 06:43:58PM +0100, Markus Trippelsdorf wrote:
> > > > On 2012.11.29 at 09:02 -0800, Paul E. McKenney wrote:
> > > > > On Thu, Nov 29, 2012 at 02:47:52PM +0100, Markus Trippelsdorf wrote:
> > > > > > With gcc-4.8 I get:
> > > > > > 
> > > > > >   CC      kernel/rcutree.o
> > > > > >   kernel/rcutree.c: In function ‘rcu_init_one’:
> > > > > >   kernel/rcutree.c:2850:13: warning: array subscript is above array bounds [-Warray-bounds]
> > > > > >      rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
> > > > > >                   ^
> > > > > > 2849    for (i = 1; i < rcu_num_lvls; i++)
> > > > > > 2850           rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
> > > > > > 
> > > > > > At first I thought that the warning was bogus, but rcu_num_lvls isn't static
> > > > > > and gets modified prior to the for loop.
> > > > > 
> > > > So, in your opinion, what would be the best way to silence this warning?
> > > 
> > > Good question.  Are you saying that if the compiler cannot prove that
> > > the index is in bounds, it is going to throw a warning?  
> > 
> > Yes, it does seem to be the case. See also my gcc bug report (closed as
> > invalid): http://gcc.gnu.org/bugzilla/show_bug.cgi?id=55529
> > 
> > > If that is the case, perhaps telling the compiler to cool it via the
> > > command line would be best.
> > > Or is this really one of a very few places in the kernel where the
> > > compiler is complaining?
> > 
> > Yes. With my (admittedly minimal) config this is only place. 
> 
> Hmmmm...  In that case...
> 
> Given that this is initialization code that is far from any fastpath,
> could you try putting something like this at the beginning of
> rcu_init_one()?
> 
> 	if (rcu_num_lvls > RCU_NUM_LVLS)
> 		panic("rcu_num_lvls overflow");
> 
> If the compiler doesn't know that panic() never returns (despite the
> __noreturn), you could add a "return" after the panic().
> 
> Does that help?

Yes. This fixes the issue. Many thanks.

(Perhaps not surprisingly the warning never occurred for
CONFIG_NR_CPUS>64.

I've also built a allyesconfig config and there was no -Warray-bounds
warning at all.)

-- 
Markus
