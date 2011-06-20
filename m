Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab1FTEsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 00:48:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44746 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1FTEsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 00:48:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFED0FD.6060701@jp.fujitsu.com>
Date: Mon, 20 Jun 2011 13:47:57 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 2/8] x86, mce: remove redundant mce_available() checks
References: <4DFB1242.90404@jp.fujitsu.com> <4DFB1359.9000204@jp.fujitsu.com> <20110617143947.GH18054@aftab>
In-Reply-To: <20110617143947.GH18054@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/17 23:39), Borislav Petkov wrote:
>> @@ -1418,8 +1414,15 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
>>  	if (__mcheck_cpu_ancient_init(c))
>>  		return;
>>  
>> -	if (!mce_available(c))
>> +	if (!mce_available(c)) {
>> +		/*
>> +		 * Asymmetric configurations are not supported today.
>> +		 * If mce_banks is allocated there must be a cpu passed here.
>> +		 */
>> +		WARN_ON(!mce_disabled && mce_banks);
>> +		mce_disabled = 1;
>>  		return;
>> +	}
> 
> I don't think this will ever happen so why complicate the code
> needlessly? This can only be executed if at least one of the cores on
> the system has CPUID(1)_EDX, bits 7 and 14 cleared and that's just
> silly.

This is a guard against such silly situation, isn't it?
I don't think it looks so complicated and needless.

I think this code will not run on systems with single socket as
long as the processor vendors are in the right mind.
But in cases when it is numa with strange nodes or when it is
migrated to/from misconfigured virtual machine I can't say that
with certainty.

> 
> Besides, mcheck_init_device() already confirms we don't support
> MCE-asymmetric configs:
> 
>         if (!mce_available(&boot_cpu_data))
>                 return -EIO;

Without above check, mcheck_init_device() will not notice the
issue when boot cpu is mce capable but others are not.

Maybe I should have another patch to do well with silly
configurations, and let this patch to a simple cleanup.


Thanks,
H.Seto

