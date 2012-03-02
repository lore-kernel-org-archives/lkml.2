Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105Ab2CBHWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:22:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50114 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964803Ab2CBHWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:22:16 -0500
Date: Fri, 2 Mar 2012 08:21:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Venki Pallipadi <venki@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Aaron Durbin <adurbin@google.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES
 interrupts to an idle CPU -v1
Message-ID: <20120302072147.GA32401@elte.hu>
References: <1329957415-15239-1-git-send-email-venki@google.com>
 <20120223075027.GB15306@elte.hu>
 <CABeCy1YeGjTAGKRwwaryY9bx9UwMq9nhGAsVV-o2QEjPH=4ErA@mail.gmail.com>
 <1330651732.30167.63.camel@sbsiddha-desk.sc.intel.com>
 <CABeCy1btewB-oTgyL06qvebLLXTqareYNy-wdNZ3oiHR3KPwEw@mail.gmail.com>
 <1330652258.30167.70.camel@sbsiddha-desk.sc.intel.com>
 <CABeCy1a7RszUWBV10tVbdsxAdPpQAMSQXw-pMG2znTqYb5WN5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABeCy1a7RszUWBV10tVbdsxAdPpQAMSQXw-pMG2znTqYb5WN5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Venki Pallipadi <venki@google.com> wrote:

> On Thu, Mar 1, 2012 at 5:37 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > On Thu, 2012-03-01 at 17:35 -0800, Venki Pallipadi wrote:
> >> On Thu, Mar 1, 2012 at 5:28 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> >> > On Thu, 2012-03-01 at 16:33 -0800, Venki Pallipadi wrote:
> >> >> >
> >> >> > fork_idle() should also make sure it does not schedule the child
> >> >> > thread: thus we'd also be able to further simplify smpboot.c and
> >> >> > get rid of all that extremely ugly 'struct create_idle'
> >> >> > gymnastics in smpboot.c.
> >> >>
> >> >> But not this. I am not sure where fork_idle results in resched of the child.
> >> >> As I saw it, fork_idle calls init_idle and that sets the affinity of
> >> >> idle_task to target CPU. So, reschedule should not be a problem. What
> >> >> am I missing here?
> >> >
> >> > I think Ingo is referring to the fact that we can't use kthread_create()
> >> > here and hence we were relying on fork_idle().
> >> >
> >> >> Also, I tried this silly test patch (Cut and paste... Sorry) and it
> >> >> seemed to work fine both with and without CPU hotplug.
> >> >>
> >> >
> >> > I don't think we can do this today, as we need to make 
> >> > sure we have the correct current context. With dynamic 
> >> > cpu hotplug, current context can be any process and hence 
> >> > we were depending on the schedule_work() context.
> >>
> >> schedule_work() is only done at boot time. In case of 
> >> dynamic cpu hotplug, we skip the whole fork_idle as we 
> >> already have the task struct and just do init_idle().
> >>
> >
> > What happens if we boot with "maxcpus=" and later online the 
> > remaining cpu's?
> 
> Yes. This case will be problematic. So, we still need struct 
> create_idle work stuff even after percpu idle_task. Or was 
> Ingo's suggestion to do something along the lines of - init 
> any CPU's idle task from CPU 0's idle task?

If the percpu area of possible CPUs is already allocated at this 
point then we should probably do that.

If not then what is the problem with doing fork_idle() from the 
hotplug process context? Where does the assymetry in the dynamic 
case come from?

Thanks,

	Ingo
