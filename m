Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab0KYGwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 01:52:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:52451 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab0KYGwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 01:52:38 -0500
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
 label key entries
From: Peter Zijlstra <peterz@infradead.org>
To: michael@ellerman.id.au
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, linux-kernel@vger.kernel.org
In-Reply-To: <1290652762.18088.4.camel@concordia>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com>
	 <1290586809.2072.424.camel@laptop> <20101124145401.GA2815@redhat.com>
	 <1290611478.2072.482.camel@laptop> <20101124151936.GB2815@redhat.com>
	 <1290612245.2072.486.camel@laptop>  <20101124154200.GD2815@redhat.com>
	 <1290613997.30543.529.camel@gandalf.stny.rr.com>
	 <1290652762.18088.4.camel@concordia>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 07:52:30 +0100
Message-ID: <1290667950.2072.545.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 13:39 +1100, Michael Ellerman wrote:
> > > arch/powerpc/lib/code-patching.c:
> > > 
> > > void patch_instruction(unsigned int *addr, unsigned int instr)
> > > {
> > >         *addr = instr;
> > >         asm ("dcbst 0, %0; sync; icbi 0,%0; sync; isync" : : "r"
> > > (addr));
> > > }
> > 
> > Is this ever called outside of boot up? After SMP is enabled? (besides
> > for creating trampolines, before they are used).
> 
> It is now :)
> 
> AFAIK it works fine, the icbi invalidates across all processors. The
> only issue is that it's not precise, ie. another CPU might not see the
> update immediately, but as soon as it takes an interrupt or something it
> will.

Ooh, nice, so the CPUs won't get all confused because you change code
from under their ifetch cache?

How expensive is this icbi ins?

> What would suit us would be to have an arch callback that is called
> after all the transforms for a particular jump label key have been made.
> That way we could optimise the individual patches, and do a sync step at
> the end, ie. when we want the effect of the patching to be globally
> visible. 

I think such a sync-barrier is desired (possibly only on the enable
path) so we can actually say the tracepoints are on.

Which would mean sending IPIs to all CPUs and waiting for them to
acknowledge them. Which, while not quite as expensive as stop_machine,
its not really cheap either.


