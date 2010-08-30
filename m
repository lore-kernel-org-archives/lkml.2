Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0H3CMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 22:12:24 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57545 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab0H3CMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 22:12:23 -0400
Message-ID: <4C7B1486.7010502@cn.fujitsu.com>
Date: Mon, 30 Aug 2010 10:16:38 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM: MMU: lower the aduit frequency
References: <4C78FA00.8090606@cn.fujitsu.com> <4C78FAF4.4070302@cn.fujitsu.com> <4C7A263F.1060407@redhat.com>
In-Reply-To: <4C7A263F.1060407@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2010 05:19 PM, Avi Kivity wrote:
>  On 08/28/2010 03:03 PM, Xiao Guangrong wrote:
>> The audit is very high overhead, so we need lower the frequency to
>> assure the guest running
>>
>>
>>    */
>>
>>   #include<linux/debugfs.h>
>> +#include<linux/ratelimit.h>
>>
>>   static struct dentry *debugfs_file;
>>   static bool mmu_debug;
>> @@ -233,6 +234,11 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
>>
>>   static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, const
>> char *msg)
>>   {
>> +    static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
>> +
>> +    if (!__ratelimit(&ratelimit_state))
>> +        return;
>> +
>>       audit_msg = msg;
>>       audit_all_active_sps(vcpu->kvm);
>>       audit_vcpu_spte(vcpu);
> 
> This means we see a bug long after it happened, so we can't correlate it
> to the cause.
> 
> It's fine as an option (even the default) but I'd like to be able to
> audit after every operation.  Perhaps a partial audit that only looks at
> the gfns and vaddrs that were affected in the last operation?
> 

Audit checks all the active shadow pages and all vcpu's page table, so the
overload is very high :-)

During my test, if enable the aduit, the guest mostly hung, it means the guest
not do anything.
(Host: Intel(R) Xeon(R) X3430  @ 2.40GHz * 4 + 4G memory
 GUest: x2VCPU + 1G memory
)

I'll set the 'ratelimit' as a module parameter, then if the user's machine is
fast enough, the ratelimit can be disabled.
