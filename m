Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534Ab1CWUvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 16:51:44 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:53464 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323Ab1CWUvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 16:51:42 -0400
Date: Wed, 23 Mar 2011 16:51:22 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: arjan@linux.intel.com, peterz@infradead.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 2/5] cpuidle: list based cpuidle driver registration
 and selection
In-reply-to: <4D89BBDD.5090505@linux.vnet.ibm.com>
Message-id: <alpine.LFD.2.02.1103231633030.12911@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123233.28725.92874.stgit@tringupt.in.ibm.com>
 <alpine.LFD.2.02.1103222254420.10549@x980>
 <4D89BBDD.5090505@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The goal of the patch series is to remove exported pm_idle function
> pointer (see http://lkml.org/lkml/2009/8/28/43 and
> http://lkml.org/lkml/2009/8/28/50 for problems related to pm_idle).
> The first patch in the series removes pm_idle for x86 and we
> now directly call cpuidle_idle_call as suggested by Arjan
> (https://lkml.org/lkml/2010/10/19/453).

So the problem statement with "pm_idle" is that it is visible to modules
and thus potentially racey and unsafe?

Any reason we can't delete his line today to address most of the concern?

EXPORT_SYMBOL(pm_idle);

> But we also have to replace the functionality provided by pm_idle,
> i.e. call default_idle for platforms where no better idle routine
> exists, call mwait for pre-nehalem platforms, use intel_idle or
> acpi_idle for nehalem architectures etc. To manage all this
> we need a registration mechanism which is conveniently provided
> by cpuidle.

It isn't immediately clear to me that all of these options
need to be preserved.

Are we suggesting that x86 must always build with cpuidle?
I'm sure that somebody someplace will object to that.

OTOH, if cpuidle is included, I'd like to see the
non-cpuidle code excluded, since nobody will run it...

> In theory I agree that we can maybe do without list based
> registration i.e probe and pick the best for the platform, but things
> may become less predictable and difficult to manage as
> we have more and more platforms and drivers.
> By directly calling into cpuidle, we already have arch default
> other than intel_idle and acpi_idle. Then APM and xen (though
> it uses default_idle) also have their own idle routines.
> List based management and selection based on priority would provide

Does anybody actually use the latest kernel in APM mode?
I'm not even sure the last version of Windows that would talk to APM,
it was whatever was before Windows-95, I think.

But don't get me wrong, I agree that pm_idle should go.
I agree that cpuidle should have a default other than
the polling loop it currently uses.
I just don't think we should spend a lot of code and time preserving
every conceivable option and feature.  We should first
do some spring cleaning to see if we can simplify the problem.

thanks,
-Len Brown, Intel Open Source Technology Center


