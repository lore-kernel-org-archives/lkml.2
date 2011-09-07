Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1IGQrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:47:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:49338 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab1IGQrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:47:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="46053000"
Message-ID: <4E6776BD.4040402@linux.intel.com>
Date: Wed, 07 Sep 2011 21:50:53 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 5/5] mce: recover from "action required" errors reported
 in data path in usermode
References: <4e5eb50721061dbb1b@agluck-desktop.sc.intel.com> <4E6709B2.7020401@linux.intel.com> <20110907132500.GA8928@aftab>
In-Reply-To: <20110907132500.GA8928@aftab>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 9/7/2011 9:25 PM, Borislav Petkov 写道:
> On Wed, Sep 07, 2011 at 02:05:38AM -0400, Chen Gong wrote:
>
> [..]
>
>>> +	/* known AR MCACODs: */
>>> +	MCESEV(
>>> +		KEEP, "HT thread notices Action required: data load error",
>>> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|0x0134),
>>> +		MCGMASK(MCG_STATUS_EIPV, 0)
>>> +		),
>>> +	MCESEV(
>>> +		AR, "Action required: data load error",
>>> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|0x0134),
>>> +		USER
>>> +		),
>>
>> I don't think *AR* makes sense here because the following codes have a
>> assumption that it means *user space* condition. If so, in the future a
>> new *AR* severity for kernel usage is created, we can't distinguish
>> which one can call "memory_failure" as below. At least, it should have a
>> suffix such as AR_USER/AR_KERN:
>>
>> enum severity_level {
>>           MCE_NO_SEVERITY,
>>           MCE_KEEP_SEVERITY,
>>           MCE_SOME_SEVERITY,
>>           MCE_AO_SEVERITY,
>>           MCE_UC_SEVERITY,
>>           MCE_AR_USER_SEVERITY,
>> 	MCE_AR_KERN_SEVERITY,
>>           MCE_PANIC_SEVERITY,
>> };
>
> Are you saying you need action required handling for when the data load
> error happens in kernel space? If so, I don't see how you can replay the
> data load (assuming this is a data load from DRAM). In that case, we're
> fatal and need to panic. If it is a different type of data load coming
> from a lower cache level, then we could be able to recover...?
>
> [..]
>

Yep, what I talk is data load error in kenel space. In fact, I'm not 
sure what we can do except panic :-), IIRC, Tony ever said in some 
situations kernel can be recovered. If it is true, we must distinguish
these two different scenarios. In *user space* case, memory_failure can
be called, but on the contrary, it can't.

>>> +	if (worst == MCE_AR_SEVERITY) {
>>> +		unsigned long pfn = m.addr>>   PAGE_SHIFT;
>>> +
>>> +		pr_err("Uncorrected hardware memory error in user-access at %llx",
>>> +			m.addr);
>>
>> print in the MCE handler maybe makes a deadlock ? say, when other CPUs
>> are printing something, suddently they received MCE broadcast from
>> Monarch CPU, when Monarch CPU runs above codes, a deadlock happens ?
>> Please fix me if I miss something :-)
>
> sounds like it can happen if the other CPUs have grabbed some console
> semaphore/mutex (I don't know what exactly we're using there) and the
> monarch tries to grab it.
>
>>> +		if (__memory_failure(pfn, MCE_VECTOR, 0)<   0) {
>>> +			pr_err("Memory error not recovered");
>>> +			force_sig(SIGBUS, current);
>>> +		} else
>>> +			pr_err("Memory error recovered");
>>> +	}
>>
>> as you mentioned in the comment, the biggest concern is that when
>> __memory_failure runs too long, if another MCE happens at the same
>> time, (assuming this MCE is happened on its sibling CPU which has the
>> same banks), the 2nd MCE will crash the system. Why not delaying the
>> process in a safer context, such as using user_return_notifer ?
>
> The user_return_notifier won't work, as we concluded in the last
> discussion round: http://marc.info/?l=linux-kernel&m=130765542330349
>
> AFAIR, we want to have a realtime thread dealing with that recovery
> so that we exit #MC context as fast as possible. The code then should
> be able to deal with a follow-up #MC. Tony, whatever happened to that
> approach?
>
> Thanks.
>

