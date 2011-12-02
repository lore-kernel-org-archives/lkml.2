Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab1LBPP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 10:15:28 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:34491 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab1LBPP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 10:15:27 -0500
Message-ID: <4ED8EB7D.5070802@linux.vnet.ibm.com>
Date: Fri, 02 Dec 2011 20:45:09 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Borislav Petkov <bp@amd64.org>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: fix error paths in microcode_init()
References: <4ED8E2270200007800065120@nat28.tlf.novell.com> <20111202143517.GA16690@gere.osrc.amd.com> <4ED8F46E0200007800065178@nat28.tlf.novell.com>
In-Reply-To: <4ED8F46E0200007800065178@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120215-5564-0000-0000-00000059CC4D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 08:23 PM, Jan Beulich wrote:

>>>> On 02.12.11 at 15:35, Borislav Petkov <bp@amd64.org> wrote:
>> Hi,
>>
>> On Fri, Dec 02, 2011 at 01:35:19PM +0000, Jan Beulich wrote:
>>> After failure of platform_device_register_simple(), microcode_dev_exit()
>>> got called without the call to microcode_dev_init() already having taken
>>> place.
>>>
>>> After failure of microcode_dev_init(), no cleanup of previously carried
>>> out setup was done at all.
>>>
>>> As a result, microcode_dev_exit() can now get __exit tagged on it.
>>>
>>> (Noticed while looking at the code, not because of having experienced
>>> an actual problem.)
>>>
>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>>
>>> ---
>>>  arch/x86/kernel/microcode_core.c |   18 +++++++++++++-----
>>>  1 file changed, 13 insertions(+), 5 deletions(-)
>>>
>>> --- 3.2-rc4/arch/x86/kernel/microcode_core.c
>>> +++ 3.2-rc4-x86-ucode-init-eh/arch/x86/kernel/microcode_core.c
>>> @@ -256,7 +256,7 @@ static int __init microcode_dev_init(voi
>>>  	return 0;
>>>  }
>>>  
>>> -static void microcode_dev_exit(void)
>>> +static void __exit microcode_dev_exit(void)
>>>  {
>>>  	misc_deregister(&microcode_dev);
>>>  }
>>> @@ -519,10 +519,8 @@ static int __init microcode_init(void)
>>>  
>>>  	microcode_pdev = platform_device_register_simple("microcode", -1,
>>>  							 NULL, 0);
>>> -	if (IS_ERR(microcode_pdev)) {
>>> -		microcode_dev_exit();
>>> +	if (IS_ERR(microcode_pdev))
>>>  		return PTR_ERR(microcode_pdev);
>>> -	}
>>>  
>>>  	get_online_cpus();
>>>  	mutex_lock(&microcode_mutex);
>>> @@ -538,8 +536,18 @@ static int __init microcode_init(void)
>>>  	}
>>>  
>>>  	error = microcode_dev_init();
>>> -	if (error)
>>> +	if (error) {
>>> +		get_online_cpus();
>>> +		mutex_lock(&microcode_mutex);
>>> +
>>> +		sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
>>> +
>>> +		mutex_unlock(&microcode_mutex);
>>> +		put_online_cpus();
>>> +
>>> +		platform_device_unregister(microcode_pdev);
>>>  		return error;
>>> +	}
>>
>> Actually, Srivatsa made a similar patch already which I sent to x86
>> guys (I don't think they've pulled yet) but yours is additionally more
>> careful to do proper locking before doing sysdev_driver_unregister().
>>
>> Would you like to add that part ontop of Srivatsa's patch at the
>> out_sysdev_driver label and resend?
> 
> Why shouldn't this one be taken in its entirety instead?
> 


Link to my patch: https://lkml.org/lkml/2011/11/7/136

Your patch fixes the issue more properly than mine, but adding your part
on top of my patch makes the code look better. For example,
platform_device_unregister() wouldn't need to be called twice; and we 
can use the quite popular way of handling error path via goto statements,
which makes the code flow much more comprehensible and intuitive.

[Btw, in addition to that, since Boris has already asked Ingo to pull my
patch, perhaps it also makes it easier that way. But I definitely see a
plus point in putting your part on top of mine, for code clarity reasons.]

Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

