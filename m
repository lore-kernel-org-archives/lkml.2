Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1GZVcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 17:32:14 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:22387 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753112Ab1GZVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 17:32:12 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: k2fNJgEVM1nGTMYKDmSPF14nwkyUuKbKE0anEGqrCM.RBMc
 pUo7i4DTb8ElwzOovKmPUF.crTm4DqD2LigUqbSm0HH4qD.EdG.lSkdRG8Kl
 mSGvp8hKdVoGmJuH0y8mOI6kAO0Eo5b3iYYAxw0jgLvJpZ3tUdB5MLabdZOG
 ZEDFweq1rRIM.4Kwr8P9p8Mb5hBsYXWpLjs11_BiMnnDzoQKSNjpJsrvROPC
 in_8nXcHSs2Jqx3ixhq2N7RD0_Dk5CQO97bHx0u6h3Mm5Ttls6Fv7GaA0a5V
 vAPKd3RoyOqT_ytDE1pmw300ccuFdpn62bq0DCTi47GTPczHI
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 26 Jul 2011 16:32:08 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: per-cpu operation madness vs validation
In-Reply-To: <1311714410.24752.404.camel@twins>
Message-ID: <alpine.DEB.2.00.1107261624210.10273@router.home>
References: <1311714410.24752.404.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011, Peter Zijlstra wrote:

> Hi all,
>
> so recently our per-cpu ops have exploded.. who can say (without
> looking) what the difference is between percpu_read() and
> this_cpu_read() ?
>
> Now Thomas recently did a fresh -rt and ran into the fun problem of
> trying to reconstruct the requirements on a lot of the per-cpu grub
> we've grown over the past few releases.
>
> Does it require preempt-disable, bh disable, irq-disable, is it perhaps
> covered by a lock, what!? I'm sure Thomas can point you to a few gems if
> you're interested in specifics.

The this_cpu stuff attempts to make it more consistent

__this_cpu_xx stuff is to be run in preempt disable contexts or in context
where interrupts were disabled.

this_cpu_xx stuff is for context where preemption is possible.

irqsafe_cpu_xx stuff is for contexts where access is also possible from
an interrupt context.

Those all fold to the same operation on x86. The x86 cpu operations with
segment prefix are interrupt and preempt safe. The context issues come
into play in fallback scenarios where other architectures do not have
instructions that can perform the same things as x86.

> Now the reason is of course that -rt changes some things, even when
> using migrate_disable() it might be multiple processes might try and
> access the per-cpu variable, needing serialization.

On x86 these operations are rt safe by the pure fact that all these
operations are the same interrupt safe instruction. The difficulties come in for other
architectures. In those cases preemption or interrupts need to be
disabled.

> Even for mainline such validation is useful, suppose you intended the
> variable to only be accessed by task context, and thus disabling
> preemption is plenty to fully serialize things. However unbeknown to the
> original author someone adds usage from IRQ context, and voila things
> start breaking.

Right.

> The point of course is, how are we going to go about doing this, I'm
> sure adding a proper conditional to each and every per-cpu op is going
> to be a herculean task, and most of it utterly boring.

Basically we need to track the contexts in which references to a certain
per cpu variable are established. Then constraints can be enforced. For
example:

1. A variable used in an interupt context with __this_cpu ops requires
irqsafe_cpu_xxx when used in context where interrupts are enabled.

2. A variable used in a non-preemptible context with __this_cpu ops
requires this_cpu ops in a preemptible context.

