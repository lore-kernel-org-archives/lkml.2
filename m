Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141Ab1BJHB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 02:01:59 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:47558 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1BJHB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 02:01:58 -0500
Date: Thu, 10 Feb 2011 12:30:31 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Trinabh Gupta <trinabh@linux.vnet.ibm.com>, arjan@linux.intel.com,
        lenb@kernel.org, suresh.b.siddha@intel.com, benh@kernel.crashing.org,
        venki@google.com, ak@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V3 2/3] cpuidle: list based cpuidle driver
 registration and selection
Message-ID: <20110210070031.GA5448@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <20110208105146.9998.22103.stgit@tringupt.in.ibm.com>
 <20110208105203.9998.35678.stgit@tringupt.in.ibm.com>
 <1297250263.13327.159.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1297250263.13327.159.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-02-09 12:17:43]:

> On Tue, 2011-02-08 at 16:22 +0530, Trinabh Gupta wrote:
> > A cpuidle_driver is global in nature as it provides routines
> > for all the CPUS. Each CPU registered with the cpuidle subsystem is
> > represented as a cpuidle_device. A cpuidle_device structure
> > points to the low level idle routines for that CPU provided by
> > a certain driver. In other words, a cpuidle driver creates a
> > cpuidle_device structure for each CPU that it registers with the
> > cpuidle subsystem. Whenever cpuidle idle loop is called, the cpuidle
> > subsystem picks the cpuidle_device structure for that cpu and
> > calls one of the low level idle routines through that structure. 
> 
> Why all this per-cpu nonsense? I thought we all agreed that ACPI tables
> specifying non-uniform C states were considered buggy and we should
> simply use the intersection of all cpus.

Hi Peter,

We discussed this in the previous posts.  On ppc64 we would like to
have single global registration, but for x86 Arjan recommended that we
keep the per-cpu registration or else we may break legacy or buggy
devices.

Ref: http://lkml.org/lkml/2009/10/7/210

One corner case that was against using lowest common C-State is that
we could have cores/packages sporting a new lower C-State if they are
at a thermal limit and want the OS to go to much lower C-State and
sacrifice performance.  Our global design will prevent that cpu from
going to a state lower than the rest of the system.

This is only a remote possibility, but could happen on battery
operated devices, under low battery mode etc.  Basically we would have
to keep our design open to allow individual CPUs to goto 'their'
deepest allowed sleep state even in a asymmetric case.

Having a design to allow global registration as long as C-States are
symmetric (non-x86 or boot param) and use per-cpu for asymmetric
C-States (x86) case will be ideal.

This patch series is only the first step to remove pm_idle() from x86
and incrementally from all other architectures.  Once we get this
working, tested and accepted, we could remove the per-cpu data
structures and have a global states table.

Thanks for the review.

--Vaidy

