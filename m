Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab0E1A7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:59:23 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:45516 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab0E1A7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:59:21 -0400
Date: Thu, 27 May 2010 20:59:07 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Thomas Renninger <trenn@suse.de>
Cc: linux-pm@lists.linux-foundation.org, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] idle-test patches queued for upstream
In-reply-to: <201005271045.33500.trenn@suse.de>
Message-id: <alpine.LFD.2.00.1005272023510.24823@localhost.localdomain>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
 <201005271045.33500.trenn@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > ... we think we can do better than ACPI.

> Why exactly? Is there any info missing in the ACPI tables?
> Or is this just to be more independent from OEMs?

ACPI has a few fundmental flaws here.  One is that it reports
exit latency instead of break-even power duration.
The other is that it requires a BIOS writer to
get the tables right.

Both of these are fatal flaws.

There are also more subtle problems, like bogus ACPI implementations
mapping LAPIC breaking C-states to ACPI-C2, causing Linux to need
to assume the LAPIC is always broken in in C2 -- which is erroneous.

I'll be speaking on this topic at length at Linuxcon this summer.

> > Indeed, on my (production level commerically available) Nehalem desktop
> > the ACPI tables are broken and an ACPI OS idles at 100W.  With this
> > driver the box idles at 85W.

> What exactly was broken there?

Dell's BIOS developer botched a bug fix immediately before the system
went to market and disabled support for all ACPI C-states except C1.
After several month of shipping systems, they still were unable
to ship them with a fixed BIOS.

Of course, besides a 15% idle power hit,the other effect of that BIOS issue
was to disable all Turbo frequencies -- which is a somewhat important
feature on a Core-i7 desktop...

> IMO this is a step backward.

I don't dispute your right to have an opinion:-)

> CPUfreq runs rather well on nearly every machine supporting it without
> tons of static frequency tables in kernel. Even powernow-k8 might get merged
> into acpi-cpufreq.

There are a couple of important differences between cpufreq and idle
state enumeration.  p-states are per-bin within each model.
Idle states not only span bins within a model, they span multiple
models which span multiple years.  Note also the idle tables are
validated at run-time by CPUID.MWAIT, which means the same
table can be used for multiple parts -- the parts themselves
know which states they have -- and they can tell us.

So I don't expect a proliferation of idle tables in intel_idle.

I do expect to tune some of the latencies based on some of
the information that Intel instructs BIOS writers to convey,
but they fail to convey.  In particular, the actual latencies
and power break-even points of the same model in different
configurations are actually different.  I've not seen a single
BIOS get that part rigiht.

I expect a new table to cover sandy bridge plus the generation after it.

> Intel set up a huge ACPI API for this and now it's not used anymore?!?
> Will these parts get obsoleted in a future spec?

Both p-states and c-states will be moving to a more native enumeration
method - but there will still be BIOS ACPI support wrapping that
enumeration as long as somebody wants to run a legacy ACPI OS that
knows nothing else.

> While for C-states there are not that many static entries needed, another
> drawback could be that OEMs will disable/hide C-states on purpose.

Yes, there is a real possibility that a system has a device in it
that malfunctions when a deep C-state is used.  On Linux, we
invented PM_QOS to address exactly this problem.

The number of devices requiring PM_QOS users is still quite small.

> Using ACPI table based C-states by default and using intel_idle.enable=1
> or similar for workarounds sounds safer.
> At least as long as the driver is experimental.

I plan to remove the EXPERIMENTAL in 1 release.

> Does Windows use ACPI C-state info for idle?

Yes, Windows uses ACPI.
On the Dell above, that is why Linux consumes 15% less idle power
and why Linux can take advantage of turbo mode and Windows can not.

cheers,
Len Brown, Intel Open Source Technology Center
