Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab2FGWYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:24:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:37007 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933212Ab2FGWYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:24:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153155985"
Subject: Re: [PATCH 7/8] x86/apic: Make cpu_mask_to_apicid() operations
 return error code
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Thu, 07 Jun 2012 15:24:05 -0700
In-Reply-To: <20120607131559.GF4759@dhcp-26-207.brq.redhat.com>
References: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
	 <20120606082231.GD5991@gmail.com>
	 <20120607131559.GF4759@dhcp-26-207.brq.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339107848.28766.104.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 15:15 +0200, Alexander Gordeev wrote:
> Current cpu_mask_to_apicid() and cpu_mask_to_apicid_and()
> implementations have few shortcomings:
> 
> 1. A value returned by cpu_mask_to_apicid() is written to hardware
> registers unconditionally. Should BAD_APICID get ever returned it will
> be written to a hardware too. But the value of BAD_APICID is not
> universal across all hardware in all modes and might cause unexpected
> results, i.e. interrupts might get routed to CPUs that are not
> configured to receive it.
> 
> 2. Because the value of BAD_APICID is not universal it is counter-
> intuitive to return it for a hardware where it does not make sense
> (i.e. x2apic).
> 
> 3. cpu_mask_to_apicid_and() operation is thought as an complement to
> cpu_mask_to_apicid() that only applies a AND mask on top of a cpumask
> being passed. Yet, as consequence of 18374d8 commit the two operations
> are inconsistent in that of:
>   cpu_mask_to_apicid() should not get a offline CPU with the cpumask
>   cpu_mask_to_apicid_and() should not fail and return BAD_APICID
> These limitations are impossible to realize just from looking at the
> operations prototypes.
> 
> Most of these shortcomings are resolved by returning a error code
> instead of BAD_APICID. As the result, faults are reported back early
> rather than possibilities to cause a unexpected behaviour exist (in case
> of [1]).
> 
> The only exception is setup_timer_IRQ0_pin() routine. Although obviously
> controversial to this fix, its existing behaviour is preserved to not
> break the fragile check_timer() and would better addressed in a separate
> fix.
> 

I am ok with these changes. But even better would be to remove the
cpu_mask_to_apicid() and just use cpu_mask_to_apicid_and() instead.

Looks like there are only two places cpu_mask_to_apicid() being used
anyways. So instead of patches 7 and 8, can you remove
cpu_mask_to_apicid() in patch-7 and fixup the return value of
cpu_mask_to_apicid_and() in patch-8

thanks,
suresh

