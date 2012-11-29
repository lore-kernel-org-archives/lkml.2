Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab2K2RZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:25:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab2K2RZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:25:47 -0500
Date: Thu, 29 Nov 2012 19:25:41 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, avi@redhat.com
Subject: Re: [RFC PATCH v2] Add rcu user eqs exception hooks for async page
 fault
Message-ID: <20121129172541.GA20873@redhat.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
 <CAFTL4hx0fc_Jo8wkuRZedW4DVEeQceiHMrWVqTqB5k065Wsg8Q@mail.gmail.com>
 <1354090704.3054.13.camel@ThinkPad-T5421.cn.ibm.com>
 <CAFTL4hxPSp1fs4=2g0yFs0d5nFisfUsfDAA9bHWcu+-+tO_ySw@mail.gmail.com>
 <1354153788.2499.9.camel@ThinkPad-T5421.cn.ibm.com>
 <CAFTL4hzOsXWdZC-PZu4ONzunTyq6vJ8C3_=Tvx6Kt3bJDBRbkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hzOsXWdZC-PZu4ONzunTyq6vJ8C3_=Tvx6Kt3bJDBRbkQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:40:05PM +0100, Frederic Weisbecker wrote:
> 2012/11/29 Li Zhong <zhong@linux.vnet.ibm.com>:
> > On Wed, 2012-11-28 at 13:55 +0100, Frederic Weisbecker wrote:
> >> > With rcu_user_exit() at the beginning, now rcu_irq_enter() only protects
> >> > the cpu idle eqs, but it's not good to call rcu_irq_exit() after the cpu
> >> > halt and the page ready.
> >>
> >> Hmm, why is it not good?
> >
> > I think in this case, as cpu halts and waits for page ready, it is
> > really in idle, and it's better for rcu to think it as rcu idle. But
> > with rcu_irq_enter(), the rcu would not think this cpu as idle. And the
> > rcu_irq_exit() is only called after this idle period to mark this cpu as
> > rcu idle again.
> 
> 
> Indeed. How about calling rcu_irq_exit() before native_safe_halt() and
> rcu_irq_enter() right after?
> 
We can't. If exception happens in the middle of rcu read section while
preemption is disabled then calling rcu_irq_exit() before halt is
incorrect. We can do that only if exception happen during idle and this
should be rare enough for us to not care.

> >> > So I still want to remove it. And later if it shows that we really needs
> >> > rcu somewhere in this code path, maybe we could use RCU_NONIDLE() to
> >> > protect it. ( The suspicious RCU usage reported in commit
> >> > c5e015d4949aa665 seems related to schedule(), which is not in the code
> >> > path if we are in cpu idle eqs )
> >>
> >> Yes but if rcu_irq_*() calls are fine to be called there, and I
> >> believe they are because exception_enter() exits the user mode, we
> >> should start to protect there right now instead of waiting for a
> >> potential future warning of illegal RCU use.
> >
> > I agree, but I think by only protecting the necessary code avoids
> > marking the entire waiting period as rcu non idle.
> 
> If we use RCU_NONIDLE(), this assume we need to check all the code
> there deeply for potential RCU uses and ensure it will never be
> extended later to use RCU. We really don't scale enough for that.
> There are too much subsystems involved there: waitqueue, spinlocks,
> slab, per cpu, etc...
> 
> So I strongly suggest we use rcu_irq_*() APIs, and relax them around
> native_safe_halt() like I suggested above. This seems to me the safest
> solution.

--
			Gleb.
