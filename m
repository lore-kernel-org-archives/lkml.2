Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab0LUBY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 20:24:26 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:41411 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932864Ab0LUBYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 20:24:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ijmjazFlEmHCXejHwlnSJIojPEvWBqDw4ldoR6HfJSFCLFSL3M0jz16+DKXwpBQW6j
         SxaP6M3Mfr9HDKJnpwtVD15WdMFJPOaTAAeDOnnbrE3dB4mfVrRrWns48DuluvMIwdzn
         8ijXzK1lm6epsJUB3HE5B9PQBzRgjJstzf9/k=
Date: Tue, 21 Dec 2010 02:24:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 15/15] nohz_task: Procfs interface
Message-ID: <20101221012418.GI1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-16-git-send-email-fweisbec@gmail.com>
 <1292859744.5021.4.camel@laptop>
 <20101220155737.GA1742@nowhere>
 <1292861799.5021.27.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292861799.5021.27.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 05:16:39PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:57 +0100, Frederic Weisbecker wrote:
> 
> > Should I?
> 
> Well yes, this interface of explicitly marking a task and cpu as
> task_no_hz is kinda restrictive and useless.

Yeah indeed. I did the mistake to focus on the HPC specific worflow,
or rather what I imagine as the HPC specific workflow: a single task
per cpu doing intensive work.

But this should also work without even tweaks on the affinity or so.

> When I run 4 cpu-bound tasks on a quad-core I shouldn't have to do
> anything to benefit from this.

Yeah exactly. If the scheduler load balancer does the appropriate
share between CPUs, having only one task running on each should
happen often enough.

And let the user optimize that by playing with irq and task affinity.

We still need to do the echo 1 > /proc/pid/nohz though.
 
> I don't see why having this cpumask is restricting you in any way,
> user-space tasks don't migrate around, that all happens in kernel space.

The cpumask is useful to find unbound targets and for RCU to know if it
should send the specific IPI. Ah and also to keep at least one
CPU that has no nohz task to handle the timekeeping.

- For the unbound targets, we are discussing that elsewhere, that's one
reason for which we need to keep a CPU without nohz task, so that it
can handle those unbound timers. But if there is no such CPU, we can
just fallback as we did before.

- RCU can unconditonally send the specific IPI which can fallback into
executing the simple resched IPI callback if no nohz task is runnning
on the CPU.

- The last reason to keep at least one CPU without nohz task is then
the timekeeping. But again, if every CPU has a nohz task, we can
fallback to a random one

> Also, I'm not quite happy with the pure userspace restriction, but at
> least I see why you did that event though you didn't mention that.

What do you mean? The fact that kernel threads can not be nohz task?
