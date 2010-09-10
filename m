Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0IJDqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 23:46:09 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52663 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab0IJDqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 23:46:07 -0400
Date: Thu, 9 Sep 2010 20:46:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: do not use ++ in rcu_dereference() argument
Message-ID: <20100910034603.GA2612@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1283711539-7123-1-git-send-email-segooon@gmail.com>
 <201009072200.59509.arnd@arndb.de>
 <20100907205015.GJ2448@linux.vnet.ibm.com>
 <201009091714.44013.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009091714.44013.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 05:14:43PM +0200, Arnd Bergmann wrote:
> On Tuesday 07 September 2010, Paul E. McKenney wrote:
> > On Tue, Sep 07, 2010 at 10:00:58PM +0200, Arnd Bergmann wrote:
> > > On Tuesday 07 September 2010 21:21:55 Kulikov Vasiliy wrote:
> > > > #define __rcu_dereference_check(p, c, space) \
> > > >         ({ \
> > > >                 typeof(*p) *_________p1 = (typeof(*p)*__force )ACCESS_ONCE(p); \
> > > >                                                                    ^
> > > >                 rcu_lockdep_assert(c); \
> > > >                 (void) (((typeof (*p) space *)p) == p); \
> > > >                                       ^     ^
> > > >                 smp_read_barrier_depends(); \
> > > >                 ((typeof(*p) __force __kernel *)(_________p1)); \
> > > >         })
> > > > 
> > > > If I understand this, it is evaluated three times, right?
> > > 
> > > Yes, that looks like my own fault, I added that :(
> > > 
> > > This patch seems to fix it, but I need to think about it some more
> > > to make sure it still does everything we need.
> > 
> > Let me know when you are satisfied with it, and then I will pick it up.
> 
> I guess it would be good to put it in now. I haven't had the time
> to try out all cases, but the current code in -next is definitely
> broken, so please put the fix in now.

Hmmm...  One approach would be have a secondary macro that was:

	#define __rcu_dereference_check_sparse(p, space) \
		(void) (((typeof (*p) space *)p) == p);

when running sparse and:

	#define __rcu_dereference_check_sparse(p, space)

otherwise.

Would that do the trick?

							Thanx, Paul
