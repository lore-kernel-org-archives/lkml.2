Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab2GLEME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 00:12:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57654 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab2GLEMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 00:12:01 -0400
Message-ID: <4FFE4E8D.90606@gmail.com>
Date: Wed, 11 Jul 2012 22:11:57 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <20120709141904.GC7298@redhat.com> <1341843844.3462.75.camel@twins> <4FFAED16.7050204@redhat.com> <4FFAEF13.7010108@gmail.com> <1341845396.3462.81.camel@twins> <4FFAEFF1.9000706@redhat.com> <1341845999.3462.86.camel@twins> <4FFCBD00.1030109@gmail.com> <20120711071006.GF23898@redhat.com> <1342000187.3462.134.camel@twins> <20120711095337.GJ23898@redhat.com>
In-Reply-To: <20120711095337.GJ23898@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/12 3:53 AM, Gleb Natapov wrote:
> On Wed, Jul 11, 2012 at 11:49:47AM +0200, Peter Zijlstra wrote:
>> On Wed, 2012-07-11 at 10:10 +0300, Gleb Natapov wrote:
>>
>>> Looks like Avi is right about the overshoot. Can you test something like this?
>>>
>>> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
>>> index 166546e..5fb371a 100644
>>> --- a/arch/x86/kernel/cpu/perf_event_intel.c
>>> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
>>> @@ -1374,8 +1374,11 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr)
>>>   	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
>>>   	arr[0].host = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
>>>   	arr[0].guest = x86_pmu.intel_ctrl & ~cpuc->intel_ctrl_host_mask;
>>> +	arr[1].msr = MSR_IA32_PEBS_ENABLE;
>>> +	arr[1].host = cpuc->pebs_enabled;
>>> +	arr[1].guest = 0;
>>> +	*nr = 2;
>>>
>>> -	*nr = 1;
>>>   	return arr;
>>>   }
>>

So far the 64-bit Fedora 10 VM with both a Fedora 10 stock kernel and a 
2.6.38 kernel have not faired well - and that's the only VM I have tried 
at the moment. Using -e cycles:pp I have been able to lock up the VM 3 
times out of 3 series of tests with perf-kvm that includes network 
traffic (e.g., netperf), disk I/O (dd based to create a file with dsync 
flag) and pure userspace cpu bound (openssl speed). May or may not be 
related.

Also, I noted that 'perf kvm --guest record -e cycles:pp' does not 
generate a whole lot of samples -- like < 100 in a 20-second sample -- 
despite the fact that the guest is rather busy.

I won't have much time over the next few days to run much in the way of 
tests; I'll come back to it Sunday night.

David

>>
>> You also need to clear TR, BTS, BTINT from MSR_IA32_DEBUGCTLMSR and
>> ideally you'd also clear MSR_IA32_DS_AREA so that any write will be a
>> proper NULL deref or such.
> Yes. With the patch above :pp modifier does not crash guest for me, but
> in theory it should since BTS are still written to DS. May be BTS writes do
> not overshoot guest entry. Will have to ask Intel for clarification.
