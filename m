Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1JUQM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 12:12:58 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:56142 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab1JUQM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 12:12:57 -0400
Date: Fri, 21 Oct 2011 19:12:54 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Michal Marek <mmarek@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Please revert "debug: Make CONFIG_EXPERT select
 CONFIG_DEBUG_KERNEL to unhide debug options"
Message-ID: <20111021161254.GA23047@localhost.pp.htv.fi>
References: <20110930155012.GC9049@localhost.pp.htv.fi>
 <20111010072946.GA29035@elte.hu>
 <20111010084811.GG4586@localhost.pp.htv.fi>
 <20111010102116.GA26901@elte.hu>
 <20111010121340.GA3731@localhost.pp.htv.fi>
 <20111012083801.GA27853@elte.hu>
 <20111020214149.GF9819@localhost.pp.htv.fi>
 <4EA12B11.5090809@suse.cz>
 <20111021092249.GG9819@localhost.pp.htv.fi>
 <4EA16779.7060006@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4EA16779.7060006@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 02:37:13PM +0200, Michal Marek wrote:
> On 21.10.2011 11:22, Adrian Bunk wrote:
> > On Fri, Oct 21, 2011 at 10:19:29AM +0200, Michal Marek wrote:
> >> On 20.10.2011 23:41, Adrian Bunk wrote:
> >>> Ingo, would you accept if I would go through the Kconfig files and 
> >>> monitor future changes to Kconfig files in the kernel (or if Michal does 
> >>> it, I don't insist that it has to be me if someone else wants to do it)?
> >>
> >> What kind of changes do you have in mind? Sorry, I haven't followed the
> >> whole thread.
> > 
> > Checking the correctness and making things more robust.
> > 
> > An example:
> > 
> > config KVM
> >         tristate "Kernel-based Virtual Machine (KVM) support"
> > 	...
> >         # for TASKSTATS/TASK_DELAY_ACCT:
> >         depends on NET
> > 	...
> >         select TASKSTATS
> >         select TASK_DELAY_ACCT
> > 
> > That breaks if anyone touches the dependencies of TASKSTATS
> > or TASK_DELAY_ACCT.
> > 
> > It should be solved better, my first thought would be introducing
> > something like a TASK_DELAY_ACCT_AVAILABLE variable.
> 
> Right, but that's a deficiency of the kconfig solver. Catalin Marinas
> has patched it to at least print a warning if a dependency of a
> select-ed symbol is not set. Ideally, we should get a better solver.

I have heared that claim already 4-5 years ago, but I don't think
it is true.

Do you have a semantics how a better solver could handle all cases
100% correctly?

Take these dependencies as an example:

Originally (commit c9aaa895) only the select of TASK_DELAY_ACCT was
added, let's look at that initial state.

The select of TASKSTATS and the dependency on NET were later
discovered by randconfig testings, your solver would have to
handle that automatically.

The dependency on NET is outside of people doing randconfig runs of 
little interest, since NET=y is set basically everywhere.

The dependency of TASK_DELAY_ACCT on TASKSTATS is more interesting:

You can automatically deduct that KVM select's TASK_DELAY_ACCT and 
TASK_DELAY_ACCT depends on TASKSTATS, and therefore KVM needs to
automatically get a dependency on TASKSTATS.
That fixes all build problems.
For people trying to enable KVM in their kernel that would be a disaster.

And you cannot blindly enable all dependencies, think e.g. of some code 
depending on 64BIT=n.

I came to the conclusion that there is not "a deficiency of the kconfig 
solver", but that select'ing of options with dependencies is an evil 
thing that should be avoided whenever possible, and needs manual
attention when it is unavoidable.

> Michal

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

