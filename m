Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1FNWMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 18:12:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56530 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab1FNWMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 18:12:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Subject: Re: [PATCH 0/3] CPU PM notifiers
Date: Wed, 15 Jun 2011 00:12:57 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1307925825-28566-1-git-send-email-ccross@android.com> <201106142334.09362.rjw@sisk.pl> <BANLkTino9JopSw-vxHOsV3SqS+0UT1q_3w@mail.gmail.com>
In-Reply-To: <BANLkTino9JopSw-vxHOsV3SqS+0UT1q_3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106150012.57459.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 14, 2011, Colin Cross wrote:
> On Tue, Jun 14, 2011 at 2:34 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Tuesday, June 14, 2011, Colin Cross wrote:
> >> On Tue, Jun 14, 2011 at 2:00 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Monday, June 13, 2011, Colin Cross wrote:
> >> >> On Mon, Jun 13, 2011 at 11:37 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> >> > On Monday, June 13, 2011, Colin Cross wrote:
> >> >> >> This patch set tries to address Russell's concerns with platform
> >> >> >> pm code calling into the driver for every block in the Cortex A9s
> >> >> >> during idle, hotplug, and suspend.  The first patch adds cpu pm
> >> >> >> notifiers that can be called by platform code, the second uses
> >> >> >> the notifier to save and restore the GIC state, and the third
> >> >> >> saves the VFP state.
> >> >> >>
> >> >> >> The notifiers are used for two types of events, CPU PM events and
> >> >> >> CPU complex PM events.  CPU PM events are used to save and restore
> >> >> >> per-cpu context when a single CPU is preparing to enter or has
> >> >> >> just exited a low power state.  For example, the VFP saves the
> >> >> >> last thread context, and the GIC saves banked CPU registers.
> >> >> >>
> >> >> >> CPU complex events are used after all the CPUs in a power domain
> >> >> >> have been prepared for the low power state.  The GIC uses these
> >> >> >> events to save global register state.
> >> >> >>
> >> >> >> Platforms that call the cpu_pm APIs must select
> >> >> >> CONFIG_ARCH_USES_CPU_PM
> >> >> >>
> >> >> >> L2 cache is not covered by this patch set, as the determination
> >> >> >> of when the L2 is reset and when it is retained is
> >> >> >> platform-specific, and most of the APIs necessary are already
> >> >> >> present.
> >> >> >>
> >> >> >>  arch/arm/Kconfig              |    7 ++
> >> >> >>  arch/arm/common/gic.c         |  212 +++++++++++++++++++++++++++++++++++++++++
> >> >> >>  arch/arm/include/asm/cpu_pm.h |   54 +++++++++++
> >> >> >>  arch/arm/kernel/Makefile      |    1 +
> >> >> >>  arch/arm/kernel/cpu_pm.c      |  181 +++++++++++++++++++++++++++++++++++
> >> >> >
> >> >> > Is there any reason why this has to be ARM-specific?  There are other
> >> >> > architectures where this kind of feature might make sense (SH and
> >> >> > powerpc at least).
> >> >>
> >> >> Nothing other than there are currently no adaptations for any drivers
> >> >> besides ARM, but I can move it somewhere outside ARM.  Any suggestions
> >> >> where?
> >> >
> >> > Well, there is kernel/cpu.c.  It contains mostly CPU hotplug and PM
> >> > code at the moment, so it looks like a good place.
> >>
> >> OK, I'll look at moving it there.
> >>
> >> >> > Besides, is there any overlap between this feature and the CPU hotplug
> >> >> > notifiers?
> >> >>
> >> >> I don't think so - the hotplug notifiers are used when a CPU is being
> >> >> removed from the system, so no saving and restoring is necessary - the
> >> >> CPU will be rebooted from scratch.  They are used by systems outside
> >> >> the CPU that need to know that a CPU no longer exists.
> >> >>
> >> >> CPU PM notifiers are used when a CPU is going through reset in a way
> >> >> that should be transparent to most of the system.
> >> >
> >> > Do I guess correctly that you mean cpuidle?
> >>
> >> cpuidle is the major user, but primary CPUs in suspend have to save
> >> and restore the same blocks, and tend to use the same platform sleep
> >> code as idle, so it's logical to use the notifiers for both.  On the
> >> other hand, some drivers that would use cpu_pm notifiers already use
> >> syscore ops to handle suspend and resume (like vfp) - maybe these
> >> notifiers should only be used in cpuidle, and syscore ops added to the
> >> gic driver?  I could also convert the notifiers to new syscore_ops -
> >> cpu_idle, cpu_unidle, cpu_cluster_idle, cpu_cluster_unidle, but I
> >> don't know how well that fits in to the intention for syscore.
> >
> > Basically, syscore_ops deal with the situation during system suspend
> > when all CPUs but one have been switched off (through CPU hotplug)
> > and interrupts are off on the only active CPU.  If there's anything
> > you need to do at this point, syscore_ops is the right thing to use.
> > And analogously for system resume.
> >
> > Moreover, for system suspend switching off the "boot" CPU (i.e. the only one
> > that remains active through the whole sequence) should really be the last
> > thing done, everything else should have been handled through syscore_ops
> > before.
> 
> Yes, but what to do with idle, which generally needs to do the exact
> same things as handled in some syscore ops?  Extend syscore ops, or
> add the new notifier, and each driver can implement both syscore and
> cpu_pm listeners (and probably call the same helper function to handle
> both)?

Good question.  I don't think I have a good answer to it at the moment, need
to ponder that a bit more.
