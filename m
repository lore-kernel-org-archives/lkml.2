Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab1CaCRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 22:17:55 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:57004 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab1CaCRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 22:17:54 -0400
Date: Wed, 30 Mar 2011 22:17:43 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Trinabh Gupta <trinabh@linux.vnet.ibm.com>, arjan@linux.intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>, peterz@infradead.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: cpuidle asymmetry (was Re: [RFC PATCH V4 5/5] cpuidle: cpuidle driver
 for apm)
In-reply-to: <20110325180156.GC19214@dirshya.in.ibm.com>
Message-id: <alpine.LFD.2.02.1103302203490.1920@x980>
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com>
 <20110322123336.28725.29810.stgit@tringupt.in.ibm.com>
 <20110323121458.ec7cdaf9.sfr@canb.auug.org.au>
 <4D89CA7D.8080108@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103231623450.12911@x980>
 <4D8B550D.5000409@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1103250321480.32565@x980>
 <20110325180156.GC19214@dirshya.in.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Maybe there is some other way to handle asymmetry ??

I mis-spoke on asymmetry.

Moorestown is already an example of an asymmetric system,
since its deepest c-state is available on cpu0, but not on cpu1.
So it needs different tables for each cpu.

I think what would work is a default c-state table for the system,
and the ability of a per-cpu override table.  I think that would
gracefully handle the case of many identical cpus, and also systems
with different tables per cpu.

The same goes for write-access to the tables.
In the typical case, a single table can be shared for the entire system
and nobody will be writing to it.  However, with the governor changes
to call dev->prepare and sift through all the states to find the
legal one with the lowest power_usage... There is software today
out of tree that updates that power_usage entry from prepare().

As I mentioned, I'm not fond of that mechanism - it looks racey
to me.  I'd rather see the capability of a drivers idle handler
to demote to another handler in the driver and for the accounting
to not get messed up when that happens.  I think the way to do that
is to let the driver do the accounting rather than doing it in
the cpuidle caller.

cheers,
-Len Brown, Intel Open Source Technology Center

