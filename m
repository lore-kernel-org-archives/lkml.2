Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab1LBOxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:53:23 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:34960 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab1LBOxW convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 2 Dec 2011 09:53:22 -0500
Message-Id: <4ED8F46E0200007800065178@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Dec 2011 14:53:18 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Borislav Petkov" <bp@amd64.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix error paths in microcode_init()
References: <4ED8E2270200007800065120@nat28.tlf.novell.com>
 <20111202143517.GA16690@gere.osrc.amd.com>
In-Reply-To: <20111202143517.GA16690@gere.osrc.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.12.11 at 15:35, Borislav Petkov <bp@amd64.org> wrote:
> Hi,
> 
> On Fri, Dec 02, 2011 at 01:35:19PM +0000, Jan Beulich wrote:
>> After failure of platform_device_register_simple(), microcode_dev_exit()
>> got called without the call to microcode_dev_init() already having taken
>> place.
>> 
>> After failure of microcode_dev_init(), no cleanup of previously carried
>> out setup was done at all.
>> 
>> As a result, microcode_dev_exit() can now get __exit tagged on it.
>> 
>> (Noticed while looking at the code, not because of having experienced
>> an actual problem.)
>> 
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> 
>> ---
>>  arch/x86/kernel/microcode_core.c |   18 +++++++++++++-----
>>  1 file changed, 13 insertions(+), 5 deletions(-)
>> 
>> --- 3.2-rc4/arch/x86/kernel/microcode_core.c
>> +++ 3.2-rc4-x86-ucode-init-eh/arch/x86/kernel/microcode_core.c
>> @@ -256,7 +256,7 @@ static int __init microcode_dev_init(voi
>>  	return 0;
>>  }
>>  
>> -static void microcode_dev_exit(void)
>> +static void __exit microcode_dev_exit(void)
>>  {
>>  	misc_deregister(&microcode_dev);
>>  }
>> @@ -519,10 +519,8 @@ static int __init microcode_init(void)
>>  
>>  	microcode_pdev = platform_device_register_simple("microcode", -1,
>>  							 NULL, 0);
>> -	if (IS_ERR(microcode_pdev)) {
>> -		microcode_dev_exit();
>> +	if (IS_ERR(microcode_pdev))
>>  		return PTR_ERR(microcode_pdev);
>> -	}
>>  
>>  	get_online_cpus();
>>  	mutex_lock(&microcode_mutex);
>> @@ -538,8 +536,18 @@ static int __init microcode_init(void)
>>  	}
>>  
>>  	error = microcode_dev_init();
>> -	if (error)
>> +	if (error) {
>> +		get_online_cpus();
>> +		mutex_lock(&microcode_mutex);
>> +
>> +		sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
>> +
>> +		mutex_unlock(&microcode_mutex);
>> +		put_online_cpus();
>> +
>> +		platform_device_unregister(microcode_pdev);
>>  		return error;
>> +	}
> 
> Actually, Srivatsa made a similar patch already which I sent to x86
> guys (I don't think they've pulled yet) but yours is additionally more
> careful to do proper locking before doing sysdev_driver_unregister().
> 
> Would you like to add that part ontop of Srivatsa's patch at the
> out_sysdev_driver label and resend?

Why shouldn't this one be taken in its entirety instead?

Jan

