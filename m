Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab1CYIMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 04:12:33 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:53597 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab1CYIM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 04:12:28 -0400
Date: Fri, 25 Mar 2011 04:12:03 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, peterz@infradead.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V1 1/2] cpuidle: Data structure changes for global
 cpuidle device
In-reply-to: <20110322124750.29408.17788.stgit@tringupt.in.ibm.com>
Message-id: <alpine.LFD.2.02.1103250330470.32565@x980>
References: <20110322124724.29408.12885.stgit@tringupt.in.ibm.com>
 <20110322124750.29408.17788.stgit@tringupt.in.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree it is silly to allocate a cpuidle_device
for every cpu in the system as we do today.

Yes, splitting the counters out of cpuidle_device
is a necessary part of fixing that.

However, cpuidle_device.cpuidle_state[] is currently not per-driver,
it is per-cpu, and it is writable.

In particular, the cpuidle_device->prepare() mechanism
causes updates to the cpuidle_state[].flags,
setting and clearing CPUIDLE_FLAG_IGNORE to
tell the governor not to chose a state
on a per-cpu basis at run-time.

I don't like that mechanism.
I'd like to see it replaced, and when replaced,
cpuidle_state[] can be per system-wide driver.

I think the real problem that prepare() was trying to solve
is that the driver today does not have the ability to over-rule
the choice made by the governor.  The driver may discover
in the course of trying to satisfy the request of the governor
that it needs to demote to a shallower state; or it may
do its best to satisfy the governor's request, and the hardware
may demote its request to a shallower state.

Unfortunately, when this happens, the driver dutifully
returns the time spent in the state to cpuidle_idle_call(),
who then updates the wrong last_residency, time, and usage counters.

Sure is ironic for the driver to allocate the data structures and
then hand the timer to the uppper layer, just to have the upper layer
update the wrong data structures...

Surely the driver enter routine should update the counters
that the driver was obligated to allocate, and it should return
the state actually entered (for tracing), rather than the time spent
there.

The generic cpuidle code should simply handle where the counters live
in the sysfs namespace, not updating the counters.

This needs to be addressed before cpuidle_device.cpuidle_state[]
can be made one/system.

cheers,
Len Brown, Intel Open Source Technology Center

