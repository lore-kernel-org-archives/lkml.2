Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946977Ab2LFT23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:28:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20323 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946963Ab2LFT20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:28:26 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=jD6vK9AFjAsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=5k3KMLIQJ_UA:10 a=D19gQVrFAAAA:8 a=ayC55rCoAAAA:8 a=m0D0claWAAAA:8 a=kxJQqpslPjn0vE-tOvcA:9 a=PUjeQqilurYA:10 a=E6k37eg1NvgA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354822103.17101.24.camel@gandalf.local.home>
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
Date: Thu, 06 Dec 2012 14:28:23 -0500
In-Reply-To: <50C0E88E.9050909@linux.vnet.ibm.com>
References: <20121205184041.3750.64945.stgit@srivatsabhat.in.ibm.com>
	 <20121205184258.3750.31879.stgit@srivatsabhat.in.ibm.com>
	 <50BF96DF.3000500@linux.vnet.ibm.com> <50BF979A.50304@linux.vnet.ibm.com>
	 <50BF982D.7090704@linux.vnet.ibm.com> <50BF98F7.3030600@linux.vnet.ibm.com>
	 <50BF999C.6030707@linux.vnet.ibm.com> <50BFAB17.3090603@linux.vnet.ibm.com>
	 <20121206161850.GA6710@redhat.com> <50C0E88E.9050909@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 00:18 +0530, Srivatsa S. Bhat wrote:
> On 12/06/2012 09:48 PM, Oleg Nesterov wrote:
> > On 12/06, Srivatsa S. Bhat wrote:
> >>
> >> +void get_online_cpus_atomic(void)
> >> +{
> >> +	int c, old;
> >> +
> >> +	preempt_disable();
> >> +	read_lock(&hotplug_rwlock);
> > 
> > Confused... Why it also takes hotplug_rwlock?
> 
> To avoid ABBA deadlocks.
> 
> hotplug_rwlock was meant for the "light" readers.
> The atomic counters were meant for the "heavy/full" readers.
> I wanted them to be able to nest in any manner they wanted,
> such as:
> 
> Full inside light:
> 
> get_online_cpus_atomic_light()
> 	...
> 	get_online_cpus_atomic_full()
> 	...
> 	put_online_cpus_atomic_full()
> 	...
> put_online_cpus_atomic_light()
> 
> Or, light inside full:
> 
> get_online_cpus_atomic_full()
> 	...
> 	get_online_cpus_atomic_light()
> 	...
> 	put_online_cpus_atomic_light()
> 	...
> put_online_cpus_atomic_full()
> 
> To allow this, I made the two sets of APIs take the locks
> in the same order internally.
> 
> (I had some more description of this logic in the changelog
> of 2/10; the only difference there is that instead of atomic
> counters, I used rwlocks for the full-readers as well.
> https://lkml.org/lkml/2012/12/5/320)
> 

You know reader locks can deadlock with each other, right? And this
isn't caught be lockdep yet. This is because rwlocks have been made to
be fair with writers. Before writers could be starved if a CPU always
let a reader in. Now if a writer is waiting, a reader will block behind
the writer. But this has introduced new issues with the kernel as
follows:


   CPU0			   CPU1	 	   CPU2		   CPU3
   ----			   ----		   ----		   ----
read_lock(A);
			read_lock(B)
					write_lock(A) <- block
							write_lock(B) <- block
read_lock(B) <-block

			read_lock(A) <- block

DEADLOCK!

-- Steve



