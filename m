Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab1DBADY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 20:03:24 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:37176 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1DBADX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 20:03:23 -0400
Date: Fri, 01 Apr 2011 20:03:10 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Trinabh Gupta <trinabh@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>, peterz@infradead.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V1 1/2] cpuidle: Data structure changes for global
 cpuidle device
In-reply-to: <20110325174831.GB19214@dirshya.in.ibm.com>
Message-id: <alpine.LFD.2.02.1104011954000.3461@x980>
References: <20110322124724.29408.12885.stgit@tringupt.in.ibm.com>
 <20110322124750.29408.17788.stgit@tringupt.in.ibm.com>
 <alpine.LFD.2.02.1103250330470.32565@x980>
 <20110325174831.GB19214@dirshya.in.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think the real problem that prepare() was trying to solve
> > is that the driver today does not have the ability to over-rule
> > the choice made by the governor.  The driver may discover
> > in the course of trying to satisfy the request of the governor
> > that it needs to demote to a shallower state; or it may
> > do its best to satisfy the governor's request, and the hardware
> > may demote its request to a shallower state.
> > 
> > Unfortunately, when this happens, the driver dutifully
> > returns the time spent in the state to cpuidle_idle_call(),
> > who then updates the wrong last_residency, time, and usage counters.
> 
> I did not get this scenario.  Are you saying 
> 
> target_state->enter(dev, target_state) can enter a different state
> than the one suggested by target_state?  

Yes.

> I understand the hardware demotion part, but can we really detect the
> target 'demoted' state in that case?  I guess not.

In addition to HW demotion, SW may also notice at the last minute
that some criteria for entering a state is not met, and need
to demote in SW.

Effectively it is the same as HW demotion, except SW can see
that it is going to happen ahead of time.

The example is MRST S0i3, where a number of dependencies on
SOC device state must be met to enter the state, and those
dependencies can change state at any time.

> > Sure is ironic for the driver to allocate the data structures and
> > then hand the timer to the uppper layer, just to have the upper layer
> > update the wrong data structures...
> > 
> > Surely the driver enter routine should update the counters
> > that the driver was obligated to allocate, and it should return
> > the state actually entered (for tracing), rather than the time spent
> > there.
> 
> Can we do something like this:
> 
> last_state = target_state->enter(dev, target_state)
> 
> dev->last_state and dev->last_residency are updated inside
> target_state->enter() 
> 
> The returned last_state is just for tracing, actual data is already
> updated in the cpuidle_dev structure and used for sysfs display.

dev->last_state and
dev->last_residency
seem like part of hacky support for run-time changing of c-states.

I think if we move the couter incrementing into the driver,
then the upper layer shouldn't need to care about it.
The driver will always have a better idea of what happened
than cpuidle_idle_call().

> > The generic cpuidle code should simply handle where the counters live
> > in the sysfs namespace, not updating the counters.
> > This needs to be addressed before cpuidle_device.cpuidle_state[]
> > can be made one/system.
> 
> Agreed.

thanks,
Len Brown, Intel Open Source Technolgy Center

