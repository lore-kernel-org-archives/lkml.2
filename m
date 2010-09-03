Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab0ICHIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:08:39 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:54288 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0ICHIi convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Fri, 3 Sep 2010 03:08:38 -0400
Message-Id: <4C80BB1502000078000141D7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 03 Sep 2010 08:08:37 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Fenghua Yu" <fenghua.yu@intel.com>
Cc: "r.marek@assembler.cz" <r.marek@assembler.cz>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] x86/hwmon: fix configuration and initialization of
	 coretemp and pkgtemp
References: <4C7FB8370200007800013F40@vpn.id2.novell.com>
 <20100902212505.GA31811@fenghua-desk.sc.intel.com>
In-Reply-To: <20100902212505.GA31811@fenghua-desk.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.09.10 at 23:25, Fenghua Yu <fenghua.yu@intel.com> wrote:
>> --- linux-2.6.36-rc3/arch/x86/include/asm/cpufeature.h
>> +++ 2.6.36-rc3-x86-hwmon/arch/x86/include/asm/cpufeature.h
>> @@ -168,6 +168,7 @@
>>  #define X86_FEATURE_XSAVEOPT	(7*32+ 4) /* Optimized Xsave */
>>  #define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
>>  #define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
>> +#define X86_FEATURE_DTS		(7*32+31) /* Digital Thermal Sensor */
> 
> Is there any paticular reason to chose 7*32+31 instead of 7*32+7?

Oh, right, I actually wanted to changes this before final submission
(I coded it this way locally to avoid eventual collisions until I would
get to submit this).

>> --- linux-2.6.36-rc3/drivers/hwmon/coretemp.c
>> +++ 2.6.36-rc3-x86-hwmon/drivers/hwmon/coretemp.c
>> @@ -423,9 +423,18 @@ static int __cpuinit coretemp_device_add
>>  	int err;
>>  	struct platform_device *pdev;
>>  	struct pdev_entry *pdev_entry;
>> -#ifdef CONFIG_SMP
>>  	struct cpuinfo_x86 *c = &cpu_data(cpu);
>> -#endif
>> +
>> +	/*
>> +	 * CPUID.06H.EAX[0] indicates whether the CPU has thermal
>> +	 * sensors. We check this bit only, all the early CPUs
>> +	 * without thermal sensors will be filtered out.
>> +	 */
>> +	if (!cpu_has(c, X86_FEATURE_DTS)) {
>> +		printk(KERN_INFO DRVNAME ": CPU (model=0x%x)"
>> +		       " has no thermal sensor.\n", c->x86_model);
>> +		return 0;
> 
> Return an error (e.g. -ENODEV) could be better because there is no device for
> this driver. Then caller may handle this error accordingly (no caller 
> handles
> the error currently, though).

No, the intention of the change is for the code to remain logically
the same as it was - since the failed check previously only resulted
in a message getting printed, returning an error indication
(irrespective of there not being a check at the call sites) didn't
seem right to me.

Jan

