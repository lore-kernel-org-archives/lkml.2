Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab1FTEsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 00:48:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45926 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab1FTEsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 00:48:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DFED112.50903@jp.fujitsu.com>
Date: Mon, 20 Jun 2011 13:48:18 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 5/8] x86, mce: introduce mce_sysdev_init()
References: <4DFB1242.90404@jp.fujitsu.com> <4DFB1438.3030504@jp.fujitsu.com> <20110617163241.GE20010@aftab>
In-Reply-To: <20110617163241.GE20010@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/18 1:32), Borislav Petkov wrote:
>> @@ -1953,6 +1953,39 @@ static __cpuinit void mce_sysdev_remove(unsigned int cpu)
>>  	cpumask_clear_cpu(cpu, mce_sysdev_initialized);
>>  }
>>  
>> +static __init int mce_sysdev_init(void)
>> +{
>> +	int err, i;
>> +
>> +	zalloc_cpumask_var(&mce_sysdev_initialized, GFP_KERNEL);
>> +
>> +	/* init attributes for each mce_banks */
>> +	for (i = 0; i < banks; i++) {
>> +		struct mce_bank *b = &mce_banks[i];
>> +		struct sysdev_attribute *a = &b->attr;
>> +
>> +		sysfs_attr_init(&a->attr);
>> +		a->attr.name	= b->attrname;
>> +		snprintf(b->attrname, ATTR_LEN, "bank%d", i);
>> +
>> +		a->attr.mode	= 0644;
>> +		a->show		= show_bank;
>> +		a->store	= set_bank;
>> +	}
>> +
>> +	err = sysdev_class_register(&mce_sysdev_class);
>> +	if (err)
>> +		return err;
>> +
>> +	for_each_online_cpu(i) {
>> +		err = mce_sysdev_create(i);
>> +		if (err)
>> +			return err;
>> +	}
> 
> Yeah, let's handle the error case here and unwind to a sane state:
> 
> 	if (err)
> 		goto sysdev_unwind;
> ...
> 
> sysdev_unwind:
> 	while (--i > 0)
> 		mce_sysdev_remove(i);
> 

Nice!
I'll do it.


Thanks,
H.Seto

