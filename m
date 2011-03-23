Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab1CWKZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:25:11 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:42848 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab1CWKZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:25:08 -0400
Message-ID: <4D89CA7D.8080108@linux.vnet.ibm.com>
Date: Wed, 23 Mar 2011 15:55:01 +0530
From: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc11 Thunderbird/3.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: arjan@linux.intel.com, peterz@infradead.org, lenb@kernel.org,
        suresh.b.siddha@intel.com, benh@kernel.crashing.org, venki@google.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [RFC PATCH V4 5/5] cpuidle: cpuidle driver for apm
References: <20110322123208.28725.30945.stgit@tringupt.in.ibm.com> <20110322123336.28725.29810.stgit@tringupt.in.ibm.com> <20110323121458.ec7cdaf9.sfr@canb.auug.org.au>
In-Reply-To: <20110323121458.ec7cdaf9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Thanks for reviewing.

On 03/23/2011 06:44 AM, Stephen Rothwell wrote:
> Hi,
>
> On Tue, 22 Mar 2011 18:03:40 +0530 Trinabh Gupta<trinabh@linux.vnet.ibm.com>  wrote:
>>
>> +static int apm_setup_cpuidle(int cpu)
>> +{
>> +	struct cpuidle_device *dev = kzalloc(sizeof(struct cpuidle_device),
>> +					GFP_KERNEL);
>
> Same as xen comments: no NULL check.
>
>> +	int count = CPUIDLE_DRIVER_STATE_START;
>> +	dev->cpu = cpu;
>> +	dev->drv =&apm_idle_driver;
>
> Also wondering why you would ever have a different idle routine on
> different cpus?

Yes, this is an ongoing debate. Apparently it is a possibility
because of ACPI bugs. CPU's can have asymmetric C-states
and overall different idle routines on different cpus. Please
refer to http://lkml.org/lkml/2009/9/24/132 and
https://lkml.org/lkml/2011/2/10/37 for a discussion around this.

I have posted a patch series that does global registration
i.e same idle routines for each cpu. Please check
http://lkml.org/lkml/2011/3/22/161 . That series applies on
top of this series. Global registration significantly
simplifies the design, but still we are not sure about the
direction to take.

>
>> +
>> +	dev->states[count] = state_apm_idle;
>> +	count++;
>> +
>> +	dev->state_count = count;
>> +
>> +	if (cpuidle_register_device(dev))
>> +		return -EIO;
>
> And we leak dev.
>
>> +static void apm_idle_exit(void)
>> +{
>> +	cpuidle_unregister_driver(&apm_idle_driver);
>
> Do we leak the per cpu device structure here?

I will see how we can save
per cpu device structure pointers so that we can free them.

>
>> +	return;
>
> Unnecessary return statement.
>

Thanks,
-Trinabh
