Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1GUNDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 09:03:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53596 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1GUNDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 09:03:43 -0400
Date: Thu, 21 Jul 2011 15:03:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prasad <prasad@linux.vnet.ibm.com>, Will Deacon <will.deacon@arm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 3/6] x86: Allow the user not to build hw_breakpoints
Message-ID: <20110721130334.GA16081@somewhere>
References: <1310655837-328-1-git-send-email-fweisbec@gmail.com>
 <1310655837-328-4-git-send-email-fweisbec@gmail.com>
 <4E1F5EF3.6050601@zytor.com>
 <20110721072656.GF9216@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721072656.GF9216@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 09:26:56AM +0200, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 07/14/2011 08:03 AM, Frederic Weisbecker wrote:
> > > So that hw_breakpoints and perf can be not built on
> > > specific embedded systems.
> > 
> > I want to emphasize I am very, very unhappy about this.  It should 
> > be possible to not build perf while still have breakpoints 
> > available... breakpoints are way more important than perf.
> 
> What we could indeed do is to separate out a 'core perf' portion that 
> is necessary for hw-breakpoints to work fine, thus allowing for 
> example the PMU drivers to be disabled.

That would still require a big chunk of perf.

> 
> Otherwise we have expressed hw breakpoint APIs via perf events and 
> that model is working well. Making hw-breakpoints a separate 
> subsystem again with isolated (and partly duplicated) infrastructure 
> would be a step back really.

I actually don't think it's working well. What we have with the current
design is the dependency to perf as a big midlayer that is apparently
convenient but actually induce some nasty things.

Just look how we need those ptrace_get_breakpoints() protection to deal
with perf exit path implementation for example. Or the need for archs
to translate arch ptrace breakpoint info into generic perf attrs.

I think we had to try the current design just to see if that could plug
nicely. But now that we have this for several releases, I can only conclude
that we should revert back to the design Prasad proposed, consisting in
having breakpoints a service used by perf but not the opposite.

For ptrace, all it takes is a generic hook in the preempt notifiers to
activate/deactivate breakpoints. I much prefer that to a big dependency
on a perf core midlayer.
