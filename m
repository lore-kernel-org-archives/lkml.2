Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab2BPBvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 20:51:17 -0500
Received: from ozlabs.org ([203.10.76.45]:56413 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab2BPBvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 20:51:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/12] arch/mips: remove references to cpu_*_map.
In-Reply-To: <4F3B78C2.7040709@linux.vnet.ibm.com>
References: <1329281884.26321.rusty@rustcorp.com.au> <4F3B78C2.7040709@linux.vnet.ibm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 16 Feb 2012 10:29:24 +1030
Message-ID: <87hayrbqcj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012 14:50:02 +0530, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> > -		cpu_clear(smp_processor_id(), mask);
> > -		for_each_cpu_mask(cpu, mask)
> > -			if (cpu_context(cpu, mm))
> > +		for_each_online_cpu(cpu) {
> > +			if (cpu != smp_processor_id() && cpu_context(cpu, mm))
> >  				cpu_context(cpu, mm) = 0;
> > +		}
> 
> 
> Strictly speaking, this one is not a mere cleanup. It causes a subtle change in
> behaviour: earlier, it used to iterate over a local copy of cpu_online_mask, which
> wouldn't change. However, with this patch, it will iterate directly over
> cpu_online_mask, which can change underneath. (The preempt_disable() won't stop
> new CPUs from coming in.. it only prevents CPUs from going offline, that too
> provided that we use stop_machine stuff for CPU offline, which we do currently.)

There's a preempt_disable() around this whole function, so online_mask
can't change.

Same with the others.
> > +		mask = *cpu_online_mask;
> > +	cpumask_clear(&mask, cpu);
> 
> 
> This should be cpumask_clear_cpu(cpu, &mask);

Good catch.  I copied the bitmask ops, and continually regret it.

I've rolled all these together with your fixes, added your ia64 patch,
and am rebasing to -next now, so I can hand this all across to akpm.

Thanks,
Rusty.
