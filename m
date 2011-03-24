Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab1CXQVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:21:49 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:36813 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab1CXQVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 12:21:48 -0400
Date: Thu, 24 Mar 2011 21:51:31 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: Len Brown <lenb@kernel.org>, arjan@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, peterz@infradead.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 5/5] cpuidle: cpuidle driver for apm
Message-ID: <20110324162131.GA16408@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123336.28725.29810.stgit@tringupt.in.ibm.com>
 <20110323121458.ec7cdaf9.sfr@canb.auug.org.au>
 <4D89CA7D.8080108@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231623450.12911@x980>
 <4D8B550D.5000409@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4D8B550D.5000409@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Trinabh Gupta <trinabh@linux.vnet.ibm.com> [2011-03-24 19:58:29]:

> 
> 
> On 03/24/2011 02:02 AM, Len Brown wrote:
> >>>Also wondering why you would ever have a different idle routine on
> >>>different cpus?
> >>
> >>Yes, this is an ongoing debate. Apparently it is a possibility
> >>because of ACPI bugs. CPU's can have asymmetric C-states
> >>and overall different idle routines on different cpus. Please
> >>refer to http://lkml.org/lkml/2009/9/24/132 and
> >>https://lkml.org/lkml/2011/2/10/37 for a discussion around this.
> >
> >Althought the ACPI specification allows the BIOS to tell the OS
> >about different C-states per-processor, I know of zero system
> >in the field and zero systems in development that require that
> >capability.  That isn't a guarantee that capability will never
> >be used, but I'm not holding my breath.
> >
> >If there are systems with broken tables that make them
> >appear asymetric, then we should have a workaround that handles
> >that case, rather than complicating the normal code for
> >the broken case.
> >
> >So I recommend deleting the extra per-cpu registration stuff
> >unless there is some other architecture that requires it
> >and can't hadle the asymmetry in another way.

Hi Len,

The fear of breaking legacy hardware is what is holding us.  Arjan
also pointed that there are systems that has asymmetric C-States
either intentionally or due to a bug.  I agree with you that we should
remove per-cpu registration at this point and move forward with
a single registration.  We can workaround the corner cases.

> Yes, lets go forward with removal of per-cpu registration
> and handle rare case of asymmetry in some other may.

Yes.  Lets discuss the design/problems on the other patch series.
(http://lkml.org/lkml/2011/3/22/161)

> Using intersection or union of C-states for each cpu may
> be a solution. Using intersection or lowest common C-state
> has the corner case that we could have packages/cores
> supporting a new lower C-state in case of thermal limit and
> they would want OS to go to this state. Using intersection
> or lowest common C-state may prevent this.
> 
> Another option is to use union of C-states;
> but I am not sure what happens if a CPU uses a state that
> is not reported for it???
> 
> Maybe there is some other way to handle asymmetry ??

The simplest method will be a union of all C-States.  Basically let
the CPU that reports the maximum C-States to register or override the
current setup.  During boot-up allow the first CPU to do the
registration, but later override if another CPU comes up with more
C-States.

This will work assuming that calling a new (deeper) C-State on CPUs
that did not report them will cause no harm.  It should degenerate to
closest supported C-State.

> >
> >>I have posted a patch series that does global registration
> >>i.e same idle routines for each cpu. Please check
> >>http://lkml.org/lkml/2011/3/22/161 . That series applies on
> >>top of this series. Global registration significantly
> >>simplifies the design, but still we are not sure about the
> >>direction to take.
> >
> >I'll review that.
> Thanks; please review especially the data structure changes
> https://lkml.org/lkml/2011/3/22/162

Single registration will allow us to combine struct cpuidle_device and
struct cpuidle_driver, and simplify the framework for large systems.
AFAIK other archs like powerpc or ARM would not need per-cpu
definitions.

--Vaidy

