Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0IBAfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 20:35:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38198 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab0IBAfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 20:35:41 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C7EF175.1090005@np.css.fujitsu.com>
Date: Thu, 02 Sep 2010 09:36:05 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, "Brown, Len" <len.brown@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@linux.jf.intel.com>,
        LKLM <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        mingo Redhat <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch-next] Trival fixes in thermal_throttle_add_dev().
References: <4C75D3C4.6040802@np.css.fujitsu.com>	<20100826060822.GA15021@fenghua-desk.sc.intel.com>	<4C7625D1.4060201@np.css.fujitsu.com>	<20100827152007.27636fa5@hyperion.delvare>	<4C7B64A8.2030208@np.css.fujitsu.com>	<493994B35A117E4F832F97C4719C4C04A111EEDF@orsmsx505.amr.corp.intel.com>	<4C7C5314.7090404@np.css.fujitsu.com>	<20100831010251.GA28885@fenghua-desk.sc.intel.com>	<20100831090725.5d83eedb@hyperion.delvare>	<20100831170443.GA30454@fenghua-desk.sc.intel.com> <20100831213002.73e2f57d@hyperion.delvare>
In-Reply-To: <20100831213002.73e2f57d@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean and Fenghua,

Sorry for replying late.

(2010/09/01 4:30), Jean Delvare wrote:
> On Tue, 31 Aug 2010 10:04:43 -0700, Fenghua Yu wrote:
>> On Tue, Aug 31, 2010 at 12:07:25AM -0700, Jean Delvare wrote:
>>> On Mon, 30 Aug 2010 18:02:52 -0700, Fenghua Yu wrote:
>>>> On Mon, Aug 30, 2010 at 05:55:48PM -0700, Jin Dongming wrote:
>>>>> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
>>>>> index d9368ee..79d563a 100644
>>>>> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
>>>>> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
>>>>> @@ -216,14 +216,27 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
>>>>>  		err = sysfs_add_file_to_group(&sys_dev->kobj,
>>>>>  					      &attr_core_power_limit_count.attr,
>>>>>  					      thermal_attr_group.name);
>>>>> -	if (cpu_has(c, X86_FEATURE_PTS))
>>>>> +	if (err)
>>>>> +		goto error;
>>>>> +
>>>>> +	if (cpu_has(c, X86_FEATURE_PTS)) {
>>>>>  		err = sysfs_add_file_to_group(&sys_dev->kobj,
>>>>>  					      &attr_package_throttle_count.attr,
>>>>>  					      thermal_attr_group.name);
>>>>> +		if (err)
>>>>> +			goto error;
>>>>> +
>>>>>  		if (cpu_has(c, X86_FEATURE_PLN))
>>>>>  			err = sysfs_add_file_to_group(&sys_dev->kobj,
>>>>>  					&attr_package_power_limit_count.attr,
>>>>>  					thermal_attr_group.name);
>>>>> +		if (err)
>>>>> +			goto error;
>>>>> +	}
>>>>> +
>>>>> +	return 0;
>>>>> +error:
>>>>> +	sysfs_remove_group(&sys_dev->kobj, &thermal_attr_group);
>>>>>  
>>>>>  	return err;
>>>>>  }
>>>>
>>>> This fix is incorrect. In this patch, a previous error prevents from adding any
>>>> further devices. There shouldn't be such dependency among the devices.
>>>
>>> I don't quite follow you. Did you mean to write that a previous error
>>> prevents from creating further _attributes_ for the same device? This
>>> would be true.
>>>
>>> Now I don't think this is a problem because 1* such errors should never
>>> happen anyway and 2* if they do happen then further attempts to create
>>> the other attributes are unlikely to succeed either.
>>
>> I don't think there is dependency among the count files, i.e. failure to add a
>> count file to the group shouldn't impact other files. Other filles can still be
>> added to the group. In this case, user application only sees part of count
>> numbers. And kernel may just warn on the failure instead of providing nothing
>> to user.
>>
>> In the patch, any failure to add a file will remove the whole group. This is
>> too strict. Kernel doesn't provide any count number to user application.
> 
> Oh, my bad. I missed the call to sysfs_remove_group() when reviewing
> the code. I agree with you that it shouldn't be added.
> 
>> Agree with you that such errors should never happen anyway. So original code
>> works fine.
> 
> The original code works indeed (except for the missing curly braces)
> but is confusing for the reader (which is why I raised the point and we
> are discussing it now). If you are voluntarily ignoring errors, you
> should add a comment saying so. And it is also a good practice to use a
> dummy variable to store the error value you'll ignore, so that the
> intent is clear.
> 
I agree with your option. So I will cancel error handling of this patch and
resend a patch just for missing { and } only.

And I think Fenghua could make a new patch for a comment.

Best Regards,
Jin Dongming

>> If to be picky to the error handling, a patch may just ignore returning errors
>> from sysfs_add_file_to_group.
> 
> This is an option, yes. Unfortunately this also means that such errors
> won't be even logged, while I think this would be desirable.
> 
>> Or use err |= sysfs_add_file_to_group to collect
>> all errors and return err but without calling sysfs_remove_group.
> 
> Please never use |= on non-bitwise values, it can only lead to bugs and
> confusion.
> 


