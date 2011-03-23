Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1CWJWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:22:45 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:34207 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab1CWJWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:22:44 -0400
Message-ID: <4D89BBDD.5090505@linux.vnet.ibm.com>
Date: Wed, 23 Mar 2011 14:52:37 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: arjan@linux.intel.com, peterz@infradead.org, suresh.b.siddha@intel.com,
        benh@kernel.crashing.org, venki@google.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 2/5] cpuidle: list based cpuidle driver registration
 and selection
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com> <20110322123233.28725.92874.stgit@tringupt.in.ibm.com> <alpine.LFD.2.02.1103222254420.10549@x980>
In-Reply-To: <alpine.LFD.2.02.1103222254420.10549@x980>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

The goal of the patch series is to remove exported pm_idle function
pointer (see http://lkml.org/lkml/2009/8/28/43 and
http://lkml.org/lkml/2009/8/28/50 for problems related to pm_idle).
The first patch in the series removes pm_idle for x86 and we
now directly call cpuidle_idle_call as suggested by Arjan
(https://lkml.org/lkml/2010/10/19/453).

But we also have to replace the functionality provided by pm_idle,
i.e. call default_idle for platforms where no better idle routine
exists, call mwait for pre-nehalem platforms, use intel_idle or
acpi_idle for nehalem architectures etc. To manage all this
we need a registration mechanism which is conveniently provided
by cpuidle.

In theory I agree that we can maybe do without list based
registration i.e probe and pick the best for the platform, but things
may become less predictable and difficult to manage as
we have more and more platforms and drivers.
By directly calling into cpuidle, we already have arch default
other than intel_idle and acpi_idle. Then APM and xen (though
it uses default_idle) also have their own idle routines.
List based management and selection based on priority would provide
a cleaner solution.

Thanks,
-Trinabh

On 03/23/2011 08:29 AM, Len Brown wrote:
> the original cpuidle prototype supported multiple driver registration,
> but no production use for it could be imagined, and so it was deleted.
>
> Subsequently on x86, we added intel_idle to replace acpi_idle
> and a typical kernel will have them both built in.
> We still don't allow mutliple registrations, we just arrange
> affairs such that the preferred intel_idle probes before
> the backup, acpi_idle.  If intel_idle recognizes the platform,
> its probe succeeds, else acpi_idle gets a go.
> If there is a problem with intel_idle, or a comparison needs to be made,
> a bootparam is available to tell intel_idle not to probe.
>
> This mechanism takes approximately 10 lines of code -- the bootparam
> to disable the preferred driver.
>
> What is the benefit of all the code to support the feature of run-time
> multiple driver registration and switching?
>
> thanks,
> Len Brown, Intel Open Source Technology Center
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
