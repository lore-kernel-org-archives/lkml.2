Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab0GVLMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:12:52 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:59472 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759228Ab0GVLMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:12:44 -0400
Date: Thu, 22 Jul 2010 13:12:39 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time
 accounting
Message-ID: <20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
References: <1279583835-22854-1-git-send-email-venki@google.com>
	<20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
	<AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010 09:55:29 -0700
Venkatesh Pallipadi <venki@google.com> wrote:

> On Tue, Jul 20, 2010 at 12:55 AM, Martin Schwidefsky
> <schwidefsky@de.ibm.com> wrote:
> > On Mon, 19 Jul 2010 16:57:11 -0700
> > Venkatesh Pallipadi <venki@google.com> wrote:
> >
> >> Currently, the softirq and hardirq time reporting is only done at the
> >> CPU level. There are usecases where reporting this time against task
> >> or task groups or cgroups will be useful for user/administrator
> >> in terms of resource planning and utilization charging. Also, as the
> >> accoounting is already done at the CPU level, reporting the same at
> >> the task level does not add any significant computational overhead
> >> other than task level storage (patch 1).
> >
> > I never understood why the softirq and hardirq time gets accounted to a
> > task at all. Why is it that the poor task that is running gets charged
> > with the cpu time of an interrupt that has nothing to do with the task?
> > I consider this to be a bug, and now this gets formalized in the
> > taskstats interface? Imho not a good idea.
> 
> Agree that this is a bug. I started by looking at resolving that. But,
> it was not exactly easy. Ideally we want irq times to be charged to
> right task as much as possible. With things like network rcv softirq
> for example, there is a task thats is going to consume the packet
> eventually that should be charged. If we cant find a suitable match we
> may have to charge it to some system thread. Things like threaded
> interrupts will mitigate this problem a bit. But, until we have a good
> enough solution, this bug will be around with us.

Yes, fixing that behavior will be tough. Just consider a standard page
cache I/O that gets merged with other I/O. You would need to "split" the
interrupt time for a block I/O to the process that benefit from it. An
added twist is that there can be multiple processes that require the
page. Split the time even more to the different requesters of a page?
Then the order when the requests come in suddenly gets important. Or
consider the IP packets in a network buffer, split the interrupt time
to the recipients?
The list goes on and on, my guess is that it will be next to impossible
to do it right. If the current situation is wrong because the ire
and softorq system time gets misaccounted and the "correct" solution is
impossible the only thing left to do is to stop accounting irq and
softirq time to processes.

> > To get fine granular accounting for interrupts you need to do a
> > sched_clock call on irq entry and another one on irq exit. Isn't that
> > too expensive on a x86 system? (I do think this is a good idea but
> > still there is the worry about the overhead).
> 
> On x86: Yes. Overhead is a potential problem. Thats the reason I had
> this inside a CONFIG option. But, I have tested this with few
> workloads on different systems released in past two years timeframe
> and I did  not see any measurable overhead. Note that this is used
> only when sched_clock is based off of TSC and not when it is based on
> jiffies. The sched_clock overhead I measured on different platforms
> was in 30-150 cycles range, which probably isn't going to be highly
> visible in generic workloads.

That makes sense to me, with a working TSC the overhead should be
small. But you will need to a performance analysis to prove it.

> Archs like s390/powerpc/ia64 already do this kind of accounting with
> VIRT_CPU_ACCOUNTING. So, this patch will give them task and cgroup
> level info free of charge (other than potential bugs with this code
> change :-)).

Well, the task and cgroup information is there but what does it really
tell me? As long as the irq & softirq time can be caused by any other
process I don't see the value of this incorrect data point.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

