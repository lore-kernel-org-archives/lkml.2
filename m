Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab2HONPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 09:15:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47707 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab2HONPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 09:15:18 -0400
Date: Wed, 15 Aug 2012 15:15:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120815131514.GC4409@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Alex Shi <alex.shi@intel.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	vincent.guittot@linaro.org, svaidy@linux.vnet.ibm.com,
	Ingo Molnar <mingo@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
References: <5028F12C.7080405@intel.com>
 <1345028738.31459.82.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1345028738.31459.82.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 01:05:38PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-08-13 at 20:21 +0800, Alex Shi wrote:
> > Since there is no power saving consideration in scheduler CFS, I has a
> > very rough idea for enabling a new power saving schema in CFS.
> 
> Adding Thomas, he always delights poking holes in power schemes.
> 
> > It bases on the following assumption:
> > 1, If there are many task crowd in system, just let few domain cpus
> > running and let other cpus idle can not save power. Let all cpu take the
> > load, finish tasks early, and then get into idle. will save more power
> > and have better user experience.
> 
> I'm not sure this is a valid assumption. I've had it explained to me by
> various people that race-to-idle isn't always the best thing. It has to
> do with the cost of switching power states and the duration of execution
> and other such things.

I think what he means here is that we might want to let all cores on
the node (i.e., domain) finish and then power down the whole node which
should bring much more power savings than letting a subset of the cores
idle. Alex?

[ … ]

> So I'd leave the currently implemented scheme as performance, and I
> don't think the above describes the current state.
> 
> > 			} else if (schedule policy == power)
> > 				move tasks from busiest group to
> > 				idlest group until busiest is just full
> > 				of capacity.
> > 				//the busiest group can balance
> > 				//internally after next time LB,
> 
> There's another thing we need to do, and that is collect tasks in a
> minimal amount of power domains.

Yep.

Btw, what heuristic would tell here when a domain overflows and another
needs to get woken? Combined load of the whole domain?

And if I absolutely positively don't want a node to wake up, do I
hotplug its cores off or are we going to have a way to tell the
scheduler to overcommit the non-idle domains and spread the tasks only
among them.

I'm thinking of short bursts here where it would be probably beneficial
to let the tasks rather wait runnable for a while then wake up the next
node and waste power...

Thanks.

-- 
Regards/Gruss,
Boris.
