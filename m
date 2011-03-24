Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab1CXONw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:13:52 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54529 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1CXONu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:13:50 -0400
Message-ID: <4D8B5197.2060306@linux.vnet.ibm.com>
Date: Thu, 24 Mar 2011 19:43:43 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>, arjan@linux.intel.com, peterz@infradead.org
CC: suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 2/5] cpuidle: list based cpuidle driver registration
 and selection
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com> <20110322123233.28725.92874.stgit@tringupt.in.ibm.com> <alpine.LFD.2.02.1103222254420.10549@x980> <4D89BBDD.5090505@linux.vnet.ibm.com> <alpine.LFD.2.02.1103231633030.12911@x980>
In-Reply-To: <alpine.LFD.2.02.1103231633030.12911@x980>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/24/2011 02:21 AM, Len Brown wrote:
>> The goal of the patch series is to remove exported pm_idle function
>> pointer (see http://lkml.org/lkml/2009/8/28/43 and
>> http://lkml.org/lkml/2009/8/28/50 for problems related to pm_idle).
>> The first patch in the series removes pm_idle for x86 and we
>> now directly call cpuidle_idle_call as suggested by Arjan
>> (https://lkml.org/lkml/2010/10/19/453).
>
> So the problem statement with "pm_idle" is that it is visible to modules
> and thus potentially racey and unsafe?
>
> Any reason we can't delete his line today to address most of the concern?

Hi Len,

I think there are other problems too, related to saving and restoring
of pm_idle pointer. For example, cpuidle itself saves current value
of pm_idle, flips it and then restores the saved value. There is
no guarantee that the saved function still exists. APM does exact
same thing (though it may not be used these days).

The problem also is that a number of architectures have copied the
same design based on pm_idle; so its spreading.

>
> EXPORT_SYMBOL(pm_idle);
>
>> But we also have to replace the functionality provided by pm_idle,
>> i.e. call default_idle for platforms where no better idle routine
>> exists, call mwait for pre-nehalem platforms, use intel_idle or
>> acpi_idle for nehalem architectures etc. To manage all this
>> we need a registration mechanism which is conveniently provided
>> by cpuidle.
>
> It isn't immediately clear to me that all of these options
> need to be preserved.

So what do you suggest can be removed?
>
> Are we suggesting that x86 must always build with cpuidle?
> I'm sure that somebody someplace will object to that.

Arjan argued that since almost everyone today runs cpuidle
it may be best to include it in the kernel
(https://lkml.org/lkml/2010/10/20/243). But yes, we agreed
that we would have to make cpuidle lighter incrementally.
Making ladder governor optional could be one way for example.
>
> OTOH, if cpuidle is included, I'd like to see the
> non-cpuidle code excluded, since nobody will run it...
>
>> In theory I agree that we can maybe do without list based
>> registration i.e probe and pick the best for the platform, but things
>> may become less predictable and difficult to manage as
>> we have more and more platforms and drivers.
>> By directly calling into cpuidle, we already have arch default
>> other than intel_idle and acpi_idle. Then APM and xen (though
>> it uses default_idle) also have their own idle routines.
>> List based management and selection based on priority would provide
>
> Does anybody actually use the latest kernel in APM mode?
> I'm not even sure the last version of Windows that would talk to APM,
> it was whatever was before Windows-95, I think.
>
> But don't get me wrong, I agree that pm_idle should go.
> I agree that cpuidle should have a default other than
> the polling loop it currently uses.

Sure, thanks

-Trinabh
