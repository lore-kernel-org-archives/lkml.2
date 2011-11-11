Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1KKLmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 06:42:11 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:46808 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab1KKLmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 06:42:08 -0500
Message-ID: <4EBD09FF.4030002@linux.vnet.ibm.com>
Date: Fri, 11 Nov 2011 17:11:51 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, len.brown@intel.com,
        tglx@linutronix.de, jeremy@goop.org, hpa@zytor.com, bp@alien8.de,
        tj@kernel.org, trenn@suse.de, mingo@redhat.com,
        xen-devel@lists.xensource.com, stable@kernel.org
Subject: Re: [PATCH 1/3] cpuidle: If disable_cpuidle() is called, set pm_idle
 to default_idle.
References: <1320786914-10541-1-git-send-email-konrad.wilk@oracle.com> <1320786914-10541-2-git-send-email-konrad.wilk@oracle.com> <4EBA53C5.9040603@linux.vnet.ibm.com> <20111109144440.GB8410@phenom.dumpdata.com>
In-Reply-To: <20111109144440.GB8410@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11111111-7282-0000-0000-000003A87344
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wednesday 09 November 2011 08:14 PM, Konrad Rzeszutek Wilk wrote:
> . snip..
>>>
>>>      ..scribble on pm_idle and access default_idle,
>>>     have it simply disable_cpuidle() so acpi_idle will not load and
>>>     architecture default HLT will be used.
>>>
>>> .. but the default HLT does not get used. Instead we end up in the
> 
> Hey Deepthi,
> 
>>> +	if (cpuidle_disabled()) {
>>> +		pm_idle = default_idle;
>>> +		return;
>>> +	}
>>
>>
>> The above check is needed to initialise pm_idle to default_idle if
>> cpuidle is disabled but this requirement here is Zen specific. 
>> On other architectures, if cpuidle is disabled on boot then we 
>> rather would want mwait_idle or amd_e400_idle to be enabled than 
>> default_idle. Can we make this check Zen specific ? 
> 
> We do? Why? I would have thought that if you want to disable the cpuidle
> you would want the default_idle. 

Well I was with a view that if cpuidle is disabled, mwait and arm_e400
would take precedence over default_idle. But if is ok to have default_idle instead,
then go ahead. 

> Perhaps there is another way do this is:
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index becd6d9..04b10a4 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -38,6 +38,7 @@ int cpuidle_disabled(void)
>  void disable_cpuidle(void)
>  {
>  	off = 1;
> +	pm_idle = default_idle;
>  }
> 
Brining pm_idle pointer back to cpuidle code is going a step back coz
we wanted to complete remove using pm_idle going forward. As having 
a pointer exported into various files is not a good thing. That's the 
reason we started the clean up in the first place :) 

> which would do almost the same thing as this patch (well, except
> that if you run cpuidle.off=1 you still end up with amd_e400_idle
> instead of default_idle, so it is not the complete solution).
> 
>>
>> ...  if(ZEN_ARCH && cpuidle_disabled()) ... 
> 
> That would not work very well. For one thing you would need to call
> 'xen_domain()', and pull in a lots of header files. Second of, it
> looks quite ugly and kernel folks like pretty code.
> 
Yes, I agree to this. 

