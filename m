Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab0KORmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:42:14 -0500
Received: from mtagate6.de.ibm.com ([195.212.17.166]:34968 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933137Ab0KORmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:42:12 -0500
Date: Mon, 15 Nov 2010 18:42:06 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        "jeremy.fitzhardinge" <jeremy.fitzhardinge@citrix.com>
Subject: Re: [RFC][PATCH v2 4/7] taskstats: Add per task steal time
 accounting
Message-ID: <20101115184206.4463fd05@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1289833883.2109.494.camel@laptop>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	<20101111170815.024542355@linux.vnet.ibm.com>
	<1289677083.2109.167.camel@laptop>
	<20101115155057.15f3be35@mschwide.boeblingen.de.ibm.com>
	<1289833883.2109.494.camel@laptop>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010 16:11:23 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Mon, 2010-11-15 at 15:50 +0100, Martin Schwidefsky wrote:
> > On Sat, 13 Nov 2010 20:38:02 +0100
> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Thu, 2010-11-11 at 18:03 +0100, Michael Holzheu wrote:
> > > > From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> > > > 
> > > > Currently steal time is only accounted for the whole system. With this
> > > > patch we add steal time to the per task CPU time accounting.
> > > > The triplet "user time", "system time" and "steal time" represents
> > > > all consumed CPU time on hypervisor based systems. 
> > > 
> > > Does that really make sense? Its not like the hypervisor really knows
> > > anything about tasks and won't steal from one? Its really a vcpu
> > > feature.
> > > 
> > > What added benefit will all this extra accounting give?
> > 
> > Currently the linux kernel keeps track of used cpu cycles per task,
> > steal time is reported only per cpu. With the patch steal cycles are
> > reported per task just like used cpu cycles, giving the complete picture
> > on a per task basis. Without the patch you don't know if the task has
> > been waiting or got its cycles stolen. A matter of granularity. 
> 
> That doesn't answer my question at all. Why do you want to know? Also,
> once we change the scheduler to not account steal time to tasks like it
> currently does (as Jeremy has been proposing to do several times now)
> this should become totally redundant as it will always be 0, no?

At least on s390 and powerpc we already do not account steal time to tasks,
the user and system time is "real" cpu. I do not know if that is true for
ia64 as well which is the third architecture with VIRT_CPU_ACCOUNTING=y.
The steal time of a task tells us how much more progress a task could have
done if the hypervisor would not steal cpu. Now you could argue that the
steal time for a cpu is good enough for that purpose but steal time is not
necessarily uniform over all tasks. And we already do calculate this number,
we just do not store it right now.

> Thing is, all I'm seeing is overhead here, the vast majority of systems
> simply don't have any steal time at all. So again, what does this buy us
> except a gazillion wasted bytes and cycles?

There are 40 bytes more in the task structure and a few instructions more
in account_steal_time. I would not call that gazillions wasted bytes and
cycles. It is a minimal overhead. Would you prefer another #ifdef orgy to
avoid the overhead for VIRT_CPU_ACCOUNTING=n? We can certainly do that.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

