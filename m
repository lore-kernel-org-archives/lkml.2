Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab2LKBlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 20:41:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2LKBlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 20:41:14 -0500
X-Authority-Analysis: v=2.0 cv=Jaw+XD2V c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DhgVYC8l6PEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=PwOMEcHXvqEA:10 a=gt-LYy8D8DmCgHPhieoA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355190071.17101.272.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH RT 3/4] sched/rt: Use IPI to trigger RT task push
 migration instead of pulling
From: Steven Rostedt <rostedt@goodmis.org>
To: frank.rowand@am.sony.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Mon, 10 Dec 2012 20:41:11 -0500
In-Reply-To: <50C682F6.5030709@am.sony.com>
References: <20121207235615.206108556@goodmis.org>
	 <20121208000900.613917378@goodmis.org> <50C682F6.5030709@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-10 at 16:48 -0800, Frank Rowand wrote:
>  
> > I've tried various methods to lesson the load, but things like an
> > atomic counter to only let one CPU grab the task wont work, because
> > the task may have a limited affinity, and we may pick the wrong
> > CPU to take that lock and do the pull, to only find out that the
> > CPU we picked isn't in the task's affinity.
> 
> You are saying that the pulling CPU might not be in the pulled task's
> affinity?  But isn't that checked:
> 
>   pull_rt_task()

But here you forgot:
    double_lock_balance();

which is what we are trying to avoid.

>      pick_next_highest_task_rt()
>         pick_rt_task()
>            if ( ... || cpumask_test_cpu(cpu, tsk_cpus_allowed(p) ...
> 
> > 
> > Instead of doing the PULL, I now have the CPUs that want the pull to
> > send over an IPI to the overloaded CPU, and let that CPU pick what
> > CPU to push the task to. No more need to grab the rq lock, and the
> > push/pull algorithm still works fine.
> 
> That gives me the opposite of a warm fuzzy feeling.  Processing an IPI
> on the overloaded CPU is not free (I'm being ARM-centric), and this is
> putting more load on the already overloaded CPU.

Note that when I say overloaded, it's not quite the normal term for
overload. It means that there's more than one RT task scheduled to run
on that CPU *and* that one of the waiting RT tasks can migrate. If all
RT tasks are pinned to a CPU, none of this happens.

> 
> I do recognize that you have actual measurements below that show goodness
> for the pathological case you debugged.  I'm still mulling this all over...

I guess it comes down to if we want to send out IPI storms or lock up
other CPUs grabbing the rq lock and serializing the rest of the system.

It's really easy to reproduce. When my local systems are done testing,
I'll see what the effect is with just 4 CPUS (still x86).

-- Steve


