Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0KPPpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:45:40 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50388 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab0KPPpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:45:38 -0500
Subject: Re: [RFC][PATCH v2 4/7] taskstats: Add per task steal time
 accounting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
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
In-Reply-To: <20101116163325.755a709f@mschwide.boeblingen.de.ibm.com>
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
	 <20101116163325.755a709f@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Nov 2010 16:45:29 +0100
Message-ID: <1289922329.2109.627.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 16:33 +0100, Martin Schwidefsky wrote:
> > Oh, you guys don't have a hypercall wrapper to exploit? Because from
> > what I heard from the kvm/xen/lguest people I gathered they could in
> > fact do something like I proposed.
> 
> We could do something along the lines of a hypercall wrapper (we would call
> it a diagnose wrapper, same thing). The diagnoses we have on s390 do vastly
> different things, so it is not easy to have a common diagnose wrapper.
> Would be easier to add a tracepoint for each diagnose inline assembly.

Right, bummer that.

> > In fact, kvm seems to already have these tracepoints: kvm_exit/kvm_entry
> > and it has a separate excplicit hypercall tracepoint as well:
> > kvm_hypercall.
> 
> But the kvm tracepoints are used when Linux is the hypervisor, no? For our
> situation that would be a tracepoint in z/VM - or the equivalent. This is
> out of scope of this patch.

Ah crud, you might be right.. Avi could a kvm guest generate events on
vcpu enter/exit?

> > Except that the per-task steal time gives you lot less detail, being
> > able to profile on vcpu exit/enter gives you a much more powerfull
> > performance tool. Aside from being able to measure the steal-time it
> > allows you to instantly find hypercalls (both explicit as well as
> > implicit), so you can also measure the hypercall induced steal-time as
> > well.
> 
> Yes and no. The tracepoint idea looks interesting in itself. But that does
> not completely replace the per-task steal time. The hypervisor can take
> away the cpu anytime, it is still interesting to know which task was hit
> hardest by that. You could view the cpu time lost by a hypercall as
> "synchronous" steal time for the task, the remaining delta to the total
> per-task steal time as "asynchronous" steal time. 

Right, so there is no way the guest knows about the vcpu getting
scheduled, it can only derive the fact from hardware clocks after the
fact?
