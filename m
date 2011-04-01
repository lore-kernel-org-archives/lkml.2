Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab1DADEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 23:04:11 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:33517 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab1DADEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 23:04:10 -0400
Date: Thu, 31 Mar 2011 23:03:40 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, venki@google.com,
        ak@linux.intel.com, suresh.b.siddha@intel.com, sfr@canb.auug.org.au,
        peterz@infradead.org, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        arjan@linux.intel.com, Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: [RFC PATCH V4 4/5] cpuidle: driver for xen
In-reply-to: <4D95020A.30807@goop.org>
Message-id: <alpine.LFD.2.02.1103312300320.2797@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123324.28725.3131.stgit@tringupt.in.ibm.com>
 <20110322145054.GB26952@dumpdata.com> <4D89C40B.4020809@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231659210.12911@x980>
 <20110324120522.GB29294@dumpdata.com> <4D8CA902.7090907@goop.org>
 <alpine.LFD.2.02.1103302159010.1920@x980>
 <alpine.LFD.2.02.1103311724100.9662@x980> <4D95020A.30807@goop.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>> xen_arch_setup() does this:
> >>>>>
> >>>>>         pm_idle = default_idle;
> >>>>>         boot_option_idle_override = IDLE_HALT;
> > What happens on a Xen kernel if these lines are not there?
> > Does Xen export the C-states tables to Dom0 kernel, and the Dom0
> > kernel has an acpi processor driver, and thus it would try to
> > use all the C-states?
> 
> If they're no there it tries to use the Intel cpuidle driver, which
> fails (just hangs forever in idle, I think).
> 
> > If yes, must Xen show those tables to Dom?
> > If it did not, then the lines above would not be necessary,
> > as in the absence of any C-states, the kernel should
> > use halt by default.
> 
> The dom0 kernel gets all the ACPI state so it can get all the juicy
> goodness from it.  It does extract the C state info, but passes it back
> to Xen rather than use it itself.  We don't generally try to filter the
> ACPI state before letting dom0 see it (DMAR being the exception, since
> dom0 really has no business knowing about that).
> 
> (We have this basic problem that neither Xen nor dom0 are the ideal
> owners of ACPI.  In principle Xen should own ACPI as the most privileged
> "OS", but it really only cares about things like power states, interrupt
> routing, system topology, busses, etc.  But dom0 cares about lid
> switches, magic keyboard keys, volume controls, video output switching,
> etc, etc.  At the moment it seems to work best if dom0 do all ACPI
> processing then pass Xen the parts it needs, which are generally
> fixed-at-startup config info items.)

Okay.
Since a Xen kernel can also boot on bare iron, and thus
includes cpuidle, acpi_idle, intel_idle; and when
in Dom0 mode it simply wants to run HLT in idle...

I think what we want to do is simply disable cpuidle
when booted in Dom0 mode.  That will allow it to
fall back to default_idle w/o xen_setup needing to
tinker with installing an idle driver.

I'll send a patch in the next series.
If you can try it out, that would be great.

thanks,
-Len


