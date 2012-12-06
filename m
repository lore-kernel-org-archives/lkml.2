Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab2LFWCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 17:02:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13672 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab2LFWCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 17:02:34 -0500
X-Authority-Analysis: v=2.0 cv=EshQXFgA c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=jD6vK9AFjAsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=5k3KMLIQJ_UA:10 a=GVqhK2efiGaW6eB2NvcA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354831350.17101.31.camel@gandalf.local.home>
Subject: Re: [RFC PATCH v2 01/10] CPU hotplug: Provide APIs for "light"
	atomic readers to prevent CPU offline
From: Steven Rostedt <rostedt@goodmis.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, tj@kernel.org, tglx@linutronix.de,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, sbw@mit.edu,
        amit.kucheria@linaro.org, rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 06 Dec 2012 17:02:30 -0500
In-Reply-To: <50C0F3CA.7070105@linux.vnet.ibm.com>
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com>
	 <20121205184258.3750.31879.stgit@srivatsabhat.in.ibm.com>
	 <50BF96DF.3000500@linux.vnet.ibm.com> <50BF979A.50304@linux.vnet.ibm.com>
	 <50BF982D.7090704@linux.vnet.ibm.com> <50BF98F7.3030600@linux.vnet.ibm.com>
	 <50BF999C.6030707@linux.vnet.ibm.com> <50BFAB17.3090603@linux.vnet.ibm.com>
	 <20121206161850.GA6710@redhat.com> <50C0E88E.9050909@linux.vnet.ibm.com>
	 <1354822103.17101.24.camel@gandalf.local.home>
	 <50C0F3CA.7070105@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 01:06 +0530, Srivatsa S. Bhat wrote:
> On 12/07/2012 12:58 AM, Steven Rostedt wrote:
> > On Fri, 2012-12-07 at 00:18 +0530, Srivatsa S. Bhat wrote:
> >> On 12/06/2012 09:48 PM, Oleg Nesterov wrote:
> >>> On 12/06, Srivatsa S. Bhat wrote:
> >>>>
> >>>> +void get_online_cpus_atomic(void)
> >>>> +{
> >>>> +	int c, old;
> >>>> +
> >>>> +	preempt_disable();
> >>>> +	read_lock(&hotplug_rwlock);
> >>>
> >>> Confused... Why it also takes hotplug_rwlock?
> >>
> >> To avoid ABBA deadlocks.
> >>
> >> hotplug_rwlock was meant for the "light" readers.
> >> The atomic counters were meant for the "heavy/full" readers.
> >> I wanted them to be able to nest in any manner they wanted,
> >> such as:
> >>
> >> Full inside light:
> >>
> >> get_online_cpus_atomic_light()
> >> 	...
> >> 	get_online_cpus_atomic_full()
> >> 	...
> >> 	put_online_cpus_atomic_full()
> >> 	...
> >> put_online_cpus_atomic_light()
> >>
> >> Or, light inside full:
> >>
> >> get_online_cpus_atomic_full()
> >> 	...
> >> 	get_online_cpus_atomic_light()
> >> 	...
> >> 	put_online_cpus_atomic_light()
> >> 	...
> >> put_online_cpus_atomic_full()
> >>
> >> 



> The root-cause of this deadlock is again lock-ordering mismatch right?
> CPU0 takes locks in order A, B
> CPU1 takes locks in order B, A
> 
> And the writer facilitates in actually getting deadlocked.
> 
> I avoid this in this patchset by always taking the locks in the same
> order. So we won't be deadlocking like this.

OK, I haven't looked closely at the patch yet. I'm currently hacking on
my own problems. But just from the description above, it looked like you
were using rw_locks() to be able to inverse the order of the locks.

-- Steve


