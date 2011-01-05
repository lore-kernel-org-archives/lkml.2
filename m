Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1AEKIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:08:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49376 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab1AEKI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:08:28 -0500
Message-ID: <4D24431F.2030205@cn.fujitsu.com>
Date: Wed, 05 Jan 2011 18:08:31 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: make make_all_cpus_request() lockless
References: <4D243B95.3070203@cn.fujitsu.com> <4D243C7B.8060205@cn.fujitsu.com> <4D243FEF.6090105@redhat.com>
In-Reply-To: <4D243FEF.6090105@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-05 18:08:08,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-05 18:08:09,
	Serialize complete at 2011-01-05 18:08:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 05:54 PM, Avi Kivity wrote:

>> +        kvm_make_request(req, vcpu);
>>           cpu = vcpu->cpu;
>>           if (cpus != NULL&&  cpu != -1&&  cpu != me&&
>>           atomic_read(&vcpu->guest_mode))
>> @@ -163,7 +161,7 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
>>           smp_call_function_many(cpus, ack_flush, NULL, 1);
>>       else
>>           called = false;
>> -    raw_spin_unlock(&kvm->requests_lock);
>> +    put_cpu();
>>       free_cpumask_var(cpus);
>>       return called;
>>   }
> 
> Maybe we can drop 'cpu != me' and then we don't need to disable preemption?
> 

Preemption should be disabled in the caller site of smp_call_function_many():

......

 * You must not call this function with disabled interrupts or from a
 * hardware interrupt handler or from a bottom half handler. Preemption
 * must be disabled when calling this function.
 */
void smp_call_function_many(const struct cpumask *mask,
			    smp_call_func_t func, void *info, bool wait)
{

......

