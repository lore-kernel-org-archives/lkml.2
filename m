Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab1FVKHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:07:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35037 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab1FVKHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:07:09 -0400
Date: Wed, 22 Jun 2011 11:06:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
Message-ID: <20110622100635.GA9449@n2100.arm.linux.org.uk>
References: <4DFF5F29.2000904@ti.com> <4E005F92.8030208@ti.com> <20110621100057.GB23802@n2100.arm.linux.org.uk> <4E006FA0.7050508@ti.com> <20110621101900.GC23802@n2100.arm.linux.org.uk> <4E00708C.6050108@ti.com> <20110621102600.GD23802@n2100.arm.linux.org.uk> <4E00FC2F.1010400@codeaurora.org> <20110621231035.GE23802@n2100.arm.linux.org.uk> <4E013222.6080208@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E013222.6080208@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 05:06:58PM -0700, Stephen Boyd wrote:
> On 06/21/2011 04:10 PM, Russell King - ARM Linux wrote:
> > On Tue, Jun 21, 2011 at 01:16:47PM -0700, Stephen Boyd wrote:
> >> On 06/21/2011 03:26 AM, Russell King - ARM Linux wrote:
> >>> On Tue, Jun 21, 2011 at 03:51:00PM +0530, Santosh Shilimkar wrote:
> >>>> On 6/21/2011 3:49 PM, Russell King - ARM Linux wrote:
> >>>>> I won't be committing the init/calibrate.c change to a git tree - it
> >>>>> isn't ARM stuff so it goes in patch form.
> >>>> Patches with change log would be fine as well.
> >>> The answer is not at the moment, but maybe soon.
> >> Should we send those two patches to the stable trees as well? They seem
> >> to fix issues with cpu onlining that have existed for a long time.
> > Looks to me like the problem was introduced for 2.6.39-rc1, so we
> > should probably get the fix into the 2.6.39-stable tree too.
> 
> Are we talking about the loops_per_jiffy problem or the cpu_active
> problem? I would think the cpu_active problem has been there since SMP
> support was added to ARM and the loops_per_jiffy problem has been there
> (depending on the compiler) since 8a9e1b0 ([PATCH] Platform SMIs and
> their interferance with tsc based delay calibration, 2005-06-23).

The cpu_active problem hasn't actually caused any symptoms on ARM, so
it's low priority.  It's only a problem which should be sorted in
-stable _if_ someone reports that it has caused a problem.  Up until
Santosh's patch, no one has done so, and I've not seen any problems
on any of my ARM SMP platforms coming from it.

As for the loops_per_jiffy, it isn't a problem before the commit ID
I pointed out - I've checked the assembly, and the compiler optimizes
away the initialization of loops_per_jiffy to zero - the first write
is when its set to (1<<12).  Take a moment to think about this:

	if ((loops_per_jiffy = 0) == 0) {
	} else {
		loops_per_jiffy = 1<<12;
		...
	}

Any compiler worth talking about is going to optimize away the initial
constant write to loops_per_jiffy there provided loops_per_jiffy is not
volatile.

So, although its not desirable for older kernels to have their lpj
overwritten in this way, it doesn't cause the spinlock debugging code
to explode.

This can be shown to be correct because there hasn't been any problem
with ARM secondary CPU bringup until recently.

Plus, the previous version of the code requires significant changes to
sort the problem out.

So, the lpj patch will only sensibly apply to 2.6.39-rc1 and later,
and so it's only going to be submitted for 2.6.39-stable.  Previous
kernels, the risks of changing it outweighs by several orders of
magnitude any benefit coming from the change.
