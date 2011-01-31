Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab1AaU0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:26:11 -0500
Received: from mail4.comsite.net ([205.238.176.238]:17155 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1AaU0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:26:10 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: Re: call_function_many: fix list delete vs add race
To: Peter Zijlstra <peterz@infradead.org>
From: Milton Miller <miltonm@bga.com>
Cc: akpm@linux-foundation.org, Anton Blanchard <anton@samba.org>,
        xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, jaxboe@fusionio.com,
        npiggin@gmail.com, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Message-ID: <smp-cfm-list-comment@mdm.bga.com>
In-Reply-To: <1296469665.15234.361.camel@laptop>
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com>
	 <1296469665.15234.361.camel@laptop>
Date: Mon, 31 Jan 2011 14:26:08 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 about 11:27:45 +0100, Peter Zijlstra wrote: 
> On Fri, 2011-01-28 at 18:20 -0600, Milton Miller wrote:
> > Peter pointed out there was nothing preventing the list_del_rcu in
> > smp_call_function_interrupt from running before the list_add_rcu in
> > smp_call_function_many.   Fix this by not setting refs until we have put
> > the entry on the list.  We can use the lock acquire and release instead
> > of a wmb.
> > 
> > Reported-by: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Milton Miller <miltonm@bga.com>
> > Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > ---
> > 
> > I tried to force this race with a udelay before the lock & list_add and
> > by mixing all 64 online cpus with just 3 random cpus in the mask, but
> > was unsuccessful.  Still, it seems to be a valid race, and the fix
> > is a simple change to the current code.
> 
> Yes, I think this will fix it, I think simply putting that assignment
> under the lock is sufficient, because then the list removal will
> serialize again the list add. But placing it after the list add does
> also seem sufficient.
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 

I was worried some architectures would allow a write before the spinlock
to drop into the spinlock region, in which case the data or function
pointer could be found stale with the cpu mask bit set.  The unlock
must flush all prior writes and therefore the new function and data
will be seen before refs is set.

milton
