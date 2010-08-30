Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab0H3G7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 02:59:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab0H3G7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 02:59:12 -0400
Message-ID: <4C7B56BA.4060306@redhat.com>
Date: Mon, 30 Aug 2010 09:59:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM: MMU: lower the aduit frequency
References: <4C78FA00.8090606@cn.fujitsu.com> <4C78FAF4.4070302@cn.fujitsu.com> <4C7A263F.1060407@redhat.com> <4C7B1486.7010502@cn.fujitsu.com>
In-Reply-To: <4C7B1486.7010502@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/30/2010 05:16 AM, Xiao Guangrong wrote:
> On 08/29/2010 05:19 PM, Avi Kivity wrote:
>>   On 08/28/2010 03:03 PM, Xiao Guangrong wrote:
>>> The audit is very high overhead, so we need lower the frequency to
>>> assure the guest running
>>>
>>>
>>>     */
>>>
>>>    #include<linux/debugfs.h>
>>> +#include<linux/ratelimit.h>
>>>
>>>    static struct dentry *debugfs_file;
>>>    static bool mmu_debug;
>>> @@ -233,6 +234,11 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
>>>
>>>    static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, const
>>> char *msg)
>>>    {
>>> +    static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
>>> +
>>> +    if (!__ratelimit(&ratelimit_state))
>>> +        return;
>>> +
>>>        audit_msg = msg;
>>>        audit_all_active_sps(vcpu->kvm);
>>>        audit_vcpu_spte(vcpu);
>> This means we see a bug long after it happened, so we can't correlate it
>> to the cause.
>>
>> It's fine as an option (even the default) but I'd like to be able to
>> audit after every operation.  Perhaps a partial audit that only looks at
>> the gfns and vaddrs that were affected in the last operation?
>>
> Audit checks all the active shadow pages and all vcpu's page table, so the
> overload is very high :-)
>
> During my test, if enable the aduit, the guest mostly hung, it means the guest
> not do anything.
> (Host: Intel(R) Xeon(R) X3430  @ 2.40GHz * 4 + 4G memory
>   GUest: x2VCPU + 1G memory
> )

You're right, I remember that from the last time I used audit many years 
ago.

> I'll set the 'ratelimit' as a module parameter, then if the user's machine is
> fast enough, the ratelimit can be disabled.

It's only useful in very special cases - low memory and a very fast 
reproducer.  I think we can live without the parameter, if someone has 
this special case they can hack the code.

-- 
error compiling committee.c: too many arguments to function

