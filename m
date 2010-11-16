Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0KPPdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:33:33 -0500
Received: from mtagate7.de.ibm.com ([195.212.17.167]:47149 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab0KPPdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:33:31 -0500
Date: Tue, 16 Nov 2010 16:33:25 +0100
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
        "jeremy.fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
Subject: Re: [RFC][PATCH v2 4/7] taskstats: Add per task steal time
 accounting
Message-ID: <20101116163325.755a709f@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1289909768.2109.592.camel@laptop>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	<20101111170815.024542355@linux.vnet.ibm.com>
	<1289677083.2109.167.camel@laptop>
	<20101115155057.15f3be35@mschwide.boeblingen.de.ibm.com>
	<1289833883.2109.494.camel@laptop>
	<20101115184206.4463fd05@mschwide.boeblingen.de.ibm.com>
	<1289843441.2109.520.camel@laptop>
	<20101115185923.1c353d07@mschwide.boeblingen.de.ibm.com>
	<1289844524.2109.524.camel@laptop>
	<20101116095101.5d86d1e5@mschwide.boeblingen.de.ibm.com>
	<1289909768.2109.592.camel@laptop>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 13:16:08 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2010-11-16 at 09:51 +0100, Martin Schwidefsky wrote:
> > On Mon, 15 Nov 2010 19:08:44 +0100
> > Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Mon, 2010-11-15 at 18:59 +0100, Martin Schwidefsky wrote:
> > > > Steal time per task is at least good for performance problem analysis.
> > > > Sometimes knowing what is not the cause of a performance problem can help you
> > > > tremendously. If a task is slow and has no steal time, well then the hypervisor
> > > > is likely not the culprit. On the other hand if you do see lots of steal time
> > > > for a task while the rest of the system doesn't cause any steal time can tell
> > > > you something as well. That task might hit a specific function which causes
> > > > hypervisor overhead. The usefulness depends on the situation, it is another
> > > > data point which may or may not help you. 
> > > 
> > > If performance analysis is the only reason, why not add a tracepoint on
> > > vcpu enter that reports the duration the vcpu was out for and use perf
> > > to gather said data? It can tell you what process was running and what
> > > instruction it was at when the vcpu went away.
> > > 
> > > No need to add 40 bytes per task for that.
> > 
> > Which vcpu enter? We usually have z/VM as our hypervisor and want to be able
> > to do performance analysis with the data we gather inside the guest. There
> > is no vcpu enter we could put a tracepoint on. We would have to put tracepoints
> > on every possible interaction point with z/VM to get this data. To me it seems
> > a lot simpler to add the per-task steal time.
> 
> Oh, you guys don't have a hypercall wrapper to exploit? Because from
> what I heard from the kvm/xen/lguest people I gathered they could in
> fact do something like I proposed.

We could do something along the lines of a hypercall wrapper (we would call
it a diagnose wrapper, same thing). The diagnoses we have on s390 do vastly
different things, so it is not easy to have a common diagnose wrapper.
Would be easier to add a tracepoint for each diagnose inline assembly.

> In fact, kvm seems to already have these tracepoints: kvm_exit/kvm_entry
> and it has a separate excplicit hypercall tracepoint as well:
> kvm_hypercall.

But the kvm tracepoints are used when Linux is the hypervisor, no? For our
situation that would be a tracepoint in z/VM - or the equivalent. This is
out of scope of this patch.

> Except that the per-task steal time gives you lot less detail, being
> able to profile on vcpu exit/enter gives you a much more powerfull
> performance tool. Aside from being able to measure the steal-time it
> allows you to instantly find hypercalls (both explicit as well as
> implicit), so you can also measure the hypercall induced steal-time as
> well.

Yes and no. The tracepoint idea looks interesting in itself. But that does
not completely replace the per-task steal time. The hypervisor can take
away the cpu anytime, it is still interesting to know which task was hit
hardest by that. You could view the cpu time lost by a hypercall as
"synchronous" steal time for the task, the remaining delta to the total
per-task steal time as "asynchronous" steal time.

> > And if it is really the additional 40 bytes on x86 that bother you so much,
> > we could put them behind #ifdef CONFIG_VIRT_CPU_ACCOUNTING. There already
> > is one in the task_struct for prev_utime and prev_stime. 
> 
> Making it configurable would definitely help the embedded people, not
> sure about VIRT_CPU_ACCOUNTING though, I bet the x86 virt weird^Wpeople
> would like it too -- if only to strive for feature parity if nothing
> else :/
> 
> Its just that I'm not at all convinced its the best approach to solve
> the problem posed, and once its committed we're stuck with it due to
> ABI.
> 
> We should be very careful not to die a death of thousand cuts with all
> this accounting madness, there's way too many weird-ass process
> accounting junk that adds ABI constraints as it is.
> 
> I think its definitely worth investing extra time to implement these
> tracepoints if at all possible on your architecture before committing
> yourself to something like this.

I don't think it is either per-task steal time or tracepoints. Ideally 
we'd have both. But I understand that you want to be careful about
committing an ABI. From my viewpoint per-task steal is a logical
extension, the data it is based on is already there.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

