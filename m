Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab2LUCfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:35:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15543 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2LUCfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:35:36 -0500
X-Authority-Analysis: v=2.0 cv=QPnqt33L c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=o1ovI4eXLzoA:10 a=D19gQVrFAAAA:8 a=VwQbUJbxAAAA:8 a=NEAV23lmAAAA:8 a=G-MNBS28Cp8ZvU8IpI0A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1356057332.5896.81.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.7-nohz1
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Date: Thu, 20 Dec 2012 21:35:32 -0500
In-Reply-To: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-20 at 19:32 +0100, Frederic Weisbecker wrote:
> Hi,
> 

Nice work Frederic!

> So this is a new version of the nohz cpusets based on 3.7, except it's not using
> cpusets anymore and I actually based it on the middle of the 3.8 merge window
> in order to get latest upstream full dynticks preparatory work: cputime cleanups,
> RCU user mode, context tracking subsystem, nohz code consolidation, ...
> 
> So the big changes since the last nohz cpuset release are:
> 
> * printk now uses irq work so it doesn't rely on the tick anymore (provided
> your arch implements irq work with IPIs or alike). This chunk has been proposed
> for the 3.8 merge window: https://lkml.org/lkml/2012/12/17/177
> May be Linus will pull, may be not. We'll see. In any case I've included it in this tree
> but I'm not reposting this part of the patchset to avoid spamming you.
> 
> * cputime doesn't rely on IPIs anymore. Now the reader does a special computation to
> remotely get the tickless cputime.
> 
> * No more cpusets interface. Paul McKenney suggested me to start with a boot time
> kernel parameter to define the full dynticks cpumask. And he was totally right, it
> makes the code much more simple. That's a good way to start and to make the mainlining
> easier. We can still add a runtime configuration later if necessary.
> 
> * Now there is always a CPU handling the timekeeping. This can be further optimized
> and more power-friendly, I really did something simple-stupid. I guess we'll try to get
> that into a better shape with Hakan. But at least the timekeeping now works.
> 
> * It uses the new RCU callbacks offlining feature. This way a full dynticks CPU doesn't
> need to keep the tick to handle local callbacks. This is still very experimental though.
> 
> * No more specific IPI vector for full dynticks. We just use the scheduler ipi.
> 
> The branch is:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	3.7-nohz1
> 
> There is still quite some work to do.
> 
> == How to use? ==
> 
> Select:
> 	CONFIG_NO_HZ
> 	CONFIG_RCU_USER_QS
> 	CONFIG_VIRT_CPU_ACCOUNTING_GEN
> 	CONFIG_RCU_NOCB_CPU
> 	CONFIG_NO_HZ_FULL
> 
> You always need at least one timekeeping CPU.
> 
> Let's imagine you have 4 CPUs. We keep the CPU 0 to offline RCU callbacks there and to
> handle the timekeeping. We set the rest as full dynticks. So you need the following kernel
> parameters:
> 
> 	rcu_nocbs=1-3 full_nohz=1-3
> 
> (Note rcu_nocbs value must always be the same as full_nohz).

Why? You can't have: rcu_nocbs=1-4 full_nohz=1-3
  or: rcu_nocbs=1-3 full_nohz=1-4 ?

That needs to be fixed. Either with a warning, and/or to force the two
to be the same. That is, if they specify:

  rcu_nocbs=1-3 full_nohz=1-4

Then set rcu_nocbs=1-4 with a warning about it. Or simply set
 full_nohz=1-3.

-- Steve

> 
> Now if you want proper isolation you need to:
> 
> * Migrate your processes adequately
> * Migrate your irqs to CPU 0
> * Migrate the RCU nocb threads to CPU 0. Example with the above configuration:
> 
> 	for p in $(ps -o pid= -C rcuo1,rcuo2,rcuo3)
> 	do
> 		taskset -cp 0 $p
> 	done
> 
> Then run what you want on the full dynticks CPUs. For best results, run 1 task
> per CPU, mostly in userspace and mostly CPU bound (otherwise more IO = more kernel
> mode execution = more chances to get IPIs, tick restarted, workqueues, kthreads, etc...)
> 
> This page contains a good reminder for those interested in CPU isolation: https://github.com/gby/linux/wiki
> 
> But keep in mind that my tree is not yet ready for serious production.
> 


