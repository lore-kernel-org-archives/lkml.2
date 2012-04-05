Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab2DEVnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 17:43:55 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:32783 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2DEVnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 17:43:53 -0400
Date: Thu, 5 Apr 2012 10:55:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: CPU Hotplug rework
Message-ID: <20120405175549.GA9127@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F674649.2000300@linux.vnet.ibm.com>
 <4F67474A.20707@linux.vnet.ibm.com>
 <20120405173918.GC8194@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120405173918.GC8194@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040521-6148-0000-0000-000004D69BF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 10:39:18AM -0700, Paul E. McKenney wrote:
> On Mon, Mar 19, 2012 at 08:18:42PM +0530, Srivatsa S. Bhat wrote:
> > On 03/19/2012 08:14 PM, Srivatsa S. Bhat wrote:
> > 
> > > Hi,
> > > 
> > > There had been some discussion on CPU Hotplug redesign/rework
> > > some time ago, but it was buried under a thread with a different
> > > subject.
> > > (http://thread.gmane.org/gmane.linux.kernel/1246208/focus=1246404)
> > > 
> > > So I am opening a new thread with an appropriate subject to discuss
> > > what needs to be done and how to go about it, as part of the rework.
> > > 
> > > Peter Zijlstra and Paul McKenney had come up with TODO lists for the
> > > rework, and here are their extracts from the previous discussion:
> 
> Finally getting around to looking at this in more detail...
> 
> > Additional things that I would like to add to the list:
> > 
> > 1. Fix issues with CPU Hotplug callback registration. Currently there
> >    is no totally-race-free way to register callbacks and do setup
> >    for already online cpus.
> > 
> >    I had posted an incomplete patchset some time ago regarding this,
> >    which gives an idea of the direction I had in mind.
> >    http://thread.gmane.org/gmane.linux.kernel/1258880/focus=15826
> 
> Another approach is to have the registration function return the
> CPU mask corresponding to the instant at which registration occurred,
> perhaps via an additional function argument that points to a
> cpumask_var_t that can be NULL if you don't care.  Then you can
> do setup for the CPUs indicated in the mask.
> 
> Or am I missing the race you had in mind?  Or is the point to make
> sure that the notifiers execute in order?
> 
> > 2. There is a mismatch between the code and the documentation around
> >    the difference between [un/register]_hotcpu_notifier and
> >    [un/register]_cpu_notifier. And I remember seeing several places in
> >    the code that uses them inconsistently. Not terribly important, but
> >    good to fix it up while we are at it.
> 
> The following lead me to believe that they were the same:
> 
> #define register_hotcpu_notifier(nb)    register_cpu_notifier(nb)
> #define unregister_hotcpu_notifier(nb)  unregister_cpu_notifier(nb)
> 
> What am I missing here?
> 
> > 3. There was another thread where stuff related to CPU hotplug had been
> >    discussed. It had exposed some new challenges to CPU hotplug, if we
> >    were to support asynchronous smp booting.
> > 
> >    http://thread.gmane.org/gmane.linux.kernel/1246209/focus=48535
> >    http://thread.gmane.org/gmane.linux.kernel/1246209/focus=48542
> >    http://thread.gmane.org/gmane.linux.kernel/1246209/focus=1253241
> >    http://thread.gmane.org/gmane.linux.kernel/1246209/focus=1253267
> 
> Good points!  ;-)
> 
> > 4. Because the current CPU offline code depends on stop_machine(), every
> >    online CPU must cooperate with the offline event. This means, whenever
> >    we do a preempt_disable(), it ensures not only that that particular
> >    CPU won't go offline, but also that *any* CPU cannot go offline. This
> >    is more like a side-effect of using stop_machine().
> > 
> >    So when trying to move over to stop_one_cpu(), we have to carefully audit
> >    places where preempt_disable() has been used in that manner (ie.,
> >    preempt_disable used as a light-weight and non-blocking form of
> >    get_online_cpus()). Because when we move to stop_one_cpu() to do CPU offline,
> >    a preempt disabled section will prevent only that particular CPU from
> >    going offline.
> > 
> >    I haven't audited preempt_disable() calls yet, but one such use was there
> >    in brlocks (include/linux/lglock.h) until quite recently.
> 
> I was thinking in terms of the offline code path doing a synchronize_sched()
> to allow preempt_disable() to retain a reasonable approximation of its
> current semantics.  This would require a pair of CPU masks, one for code
> using CPU-based primitives (e.g., sending IPIs) and another for code
> implementing those primitives.
> 
> Or is there some situation that makes this approach fail?

Hmmm...  I suppose that -rt's use of migrate_disable() needs some other
approach in any case, unless -rt's offlining waits for all pre-existing
migrate_disable() sections to finish.

							Thanx, Paul

