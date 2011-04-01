Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1DAHCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 03:02:13 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:49193 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab1DAHCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 03:02:11 -0400
Message-ID: <4D957869.3050607@linux.vnet.ibm.com>
Date: Fri, 01 Apr 2011 12:32:01 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, arjan@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, peterz@infradead.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: cpuidle asymmetry (was Re: [RFC PATCH V4 5/5] cpuidle: cpuidle
 driver for apm)
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com> <20110322123336.28725.29810.stgit@tringupt.in.ibm.com> <20110323121458.ec7cdaf9.sfr@canb.auug.org.au> <4D89CA7D.8080108@linux.vnet.ibm.com> <alpine.LFD.2.02.1103231623450.12911@x980> <4D8B550D.5000409@linux.vnet.ibm.com> <alpine.LFD.2.02.1103250321480.32565@x980> <20110325180156.GC19214@dirshya.in.ibm.com> <alpine.LFD.2.02.1103302203490.1920@x980>
In-Reply-To: <alpine.LFD.2.02.1103302203490.1920@x980>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/31/2011 07:47 AM, Len Brown wrote:
>>>> Maybe there is some other way to handle asymmetry ??
>
> I mis-spoke on asymmetry.
>
> Moorestown is already an example of an asymmetric system,
> since its deepest c-state is available on cpu0, but not on cpu1.
> So it needs different tables for each cpu.
>
> I think what would work is a default c-state table for the system,
> and the ability of a per-cpu override table.  I think that would
> gracefully handle the case of many identical cpus, and also systems
> with different tables per cpu.

Hi Len,

What would happen if a cpu enters a state which wasn't
reported for it? I am wondering if an approach like union
of states of each would work.

Can we handle asymmetry through checking and demotion inside the
routine itself; just like you are proposing as dev->prepare
alternative? But I guess this may not be efficient if this
happens often.

I am not sure if having a per-cpu override would be very tidy
(ideas ?); and much better than per-cpu stuff. So just want to check
what would be the best way forward?

>
> The same goes for write-access to the tables.
> In the typical case, a single table can be shared for the entire system
> and nobody will be writing to it.  However, with the governor changes
> to call dev->prepare and sift through all the states to find the
> legal one with the lowest power_usage... There is software today
> out of tree that updates that power_usage entry from prepare().
>
> As I mentioned, I'm not fond of that mechanism - it looks racey
> to me.  I'd rather see the capability of a drivers idle handler
> to demote to another handler in the driver and for the accounting
> to not get messed up when that happens.  I think the way to do that
> is to let the driver do the accounting rather than doing it in
> the cpuidle caller.

I agree with this; we should move update of statistics inside the
driver routines (enter routines). They already take device/stats
structure as parameter.

Thanks,
-Trinabh
