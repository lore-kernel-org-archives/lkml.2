Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1CYRtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:49:05 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:45740 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab1CYRtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:49:02 -0400
Date: Fri, 25 Mar 2011 23:18:31 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: Trinabh Gupta <trinabh@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>, peterz@infradead.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V1 1/2] cpuidle: Data structure changes for global
 cpuidle device
Message-ID: <20110325174831.GB19214@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20110322124724.29408.12885.stgit@tringupt.in.ibm.com>
 <20110322124750.29408.17788.stgit@tringupt.in.ibm.com>
 <alpine.LFD.2.02.1103250330470.32565@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1103250330470.32565@x980>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Len Brown <lenb@kernel.org> [2011-03-25 04:12:03]:

> I agree it is silly to allocate a cpuidle_device
> for every cpu in the system as we do today.
> 
> Yes, splitting the counters out of cpuidle_device
> is a necessary part of fixing that.
> 
> However, cpuidle_device.cpuidle_state[] is currently not per-driver,
> it is per-cpu, and it is writable.
> 
> In particular, the cpuidle_device->prepare() mechanism
> causes updates to the cpuidle_state[].flags,
> setting and clearing CPUIDLE_FLAG_IGNORE to
> tell the governor not to chose a state
> on a per-cpu basis at run-time.
> 
> I don't like that mechanism.
> I'd like to see it replaced, and when replaced,
> cpuidle_state[] can be per system-wide driver.

Thanks for the detailed review.  I agree that we should rework
handling of the cpuidle_state[].flags.  However, is the prepare()
mechanism used at all?  Can we remove the option completely?

> I think the real problem that prepare() was trying to solve
> is that the driver today does not have the ability to over-rule
> the choice made by the governor.  The driver may discover
> in the course of trying to satisfy the request of the governor
> that it needs to demote to a shallower state; or it may
> do its best to satisfy the governor's request, and the hardware
> may demote its request to a shallower state.
> 
> Unfortunately, when this happens, the driver dutifully
> returns the time spent in the state to cpuidle_idle_call(),
> who then updates the wrong last_residency, time, and usage counters.

I did not get this scenario.  Are you saying 

target_state->enter(dev, target_state) can enter a different state
than the one suggested by target_state?  

I understand the hardware demotion part, but can we really detect the
target 'demoted' state in that case?  I guess not.

> Sure is ironic for the driver to allocate the data structures and
> then hand the timer to the uppper layer, just to have the upper layer
> update the wrong data structures...
> 
> Surely the driver enter routine should update the counters
> that the driver was obligated to allocate, and it should return
> the state actually entered (for tracing), rather than the time spent
> there.

Can we do something like this:

last_state = target_state->enter(dev, target_state)

dev->last_state and dev->last_residency are updated inside
target_state->enter() 

The returned last_state is just for tracing, actual data is already
updated in the cpuidle_dev structure and used for sysfs display.

> The generic cpuidle code should simply handle where the counters live
> in the sysfs namespace, not updating the counters.
> This needs to be addressed before cpuidle_device.cpuidle_state[]
> can be made one/system.

Agreed.

Thanks again for the recommendations.

--Vaidy

