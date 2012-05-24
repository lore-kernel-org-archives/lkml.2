Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab2EXPeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:34:22 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40019 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab2EXPeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:34:20 -0400
Date: Thu, 24 May 2012 17:34:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] x86: Avoid intermixing cpu dump_stack output on
 multi-processor systems
Message-ID: <20120524153409.GM1663@somewhere>
References: <20120524144229.GA27713@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524144229.GA27713@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 09:42:29AM -0500, Russ Anderson wrote:
> When multiple cpus on a multi-processor system call dump_stack()
> at the same time, the backtrace lines get intermixed, making 
> the output worthless.  Add a lock so each cpu stack dump comes
> out as a coherent set.
> 
> For example, when a multi-processor system is NMIed, all of the
> cpus call dump_stack() at the same time, resulting in output for
> all of cpus getting intermixed, making it impossible to tell what
> any individual cpu was doing.  With this patch each cpu prints
> its stack lines as a coherent set, so one can see what each cpu
> was doing.
> 
> It has been tested on a 4069 cpu system.
> 
> Signed-off-by: Russ Anderson <rja@sgi.com>

I don't think this is a good idea. What if an interrupt comes
and calls this at the same time? Sure you can mask irqs but NMIs
can call that too. In this case I prefer to have a messy report
rather than a deadlock on the debug path.

May be something like that:

static atomic_t dump_lock = ATOMIC_INIT(-1);

static void dump_stack(void)
{
	int was_locked;
	int old;
	int cpu;

	preempt_disable();
retry:
	cpu = smp_processor_id();
	old = atomic_cmpxchg(&dump_lock, -1, cpu);
	if (old == -1) {
		was_locked = 0;
	} else if (old == cpu) {
		was_locked = 1;
	} else {
		cpu_relax();
		goto retry;
	}

	__dump_trace();

	if (!was_locked)
		atomic_set(&dump_lock, -1);

	preempt_enable();
}

You could also use a spinlock with irq disabled and test in_nmi()
but we could have a dump_trace() in an NMI before the nmi count is
incremented. So the above is perhaps more robust.
