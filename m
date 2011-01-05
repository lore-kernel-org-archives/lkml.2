Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab1AEKFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:05:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58761 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab1AEKFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:05:35 -0500
Message-ID: <4D24426F.5090000@cn.fujitsu.com>
Date: Wed, 05 Jan 2011 18:05:35 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: send IPI to vcpu only when it's in guest mode
References: <4D243B95.3070203@cn.fujitsu.com> <4D243C05.7060307@cn.fujitsu.com> <4D243E69.60603@redhat.com>
In-Reply-To: <4D243E69.60603@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-05 18:05:13,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-05 18:05:13,
	Serialize complete at 2011-01-05 18:05:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 05:48 PM, Avi Kivity wrote:

>>       srcu_read_unlock(&vcpu->kvm->srcu, idx);
>> +    atomic_set(&vcpu->guest_mode, 1);
>>       kvm_guest_enter();
> 
> I think it needs an smp_wmb() (technically x86 needs it too, but x86 is strongly ordered)

......

>> -        if (cpus != NULL&&  cpu != -1&&  cpu != me)
>> +        if (cpus != NULL&&  cpu != -1&&  cpu != me&&
>> +              atomic_read(&vcpu->guest_mode))
>>               cpumask_set_cpu(cpu, cpus);
> 
> and smp_rmb() before the atomic_read().

Yeah, you're right, i'll fix these in the next version.

> 
>>       }
>>       if (unlikely(cpus == NULL))
> 
> Not sure if this is an optimization.  On one hand it removes an expensive IPI for the fraction of time the cpu is out of guest mode.  On the other hand it adds an unconditional cacheline bounce (and bounce back).
> 
> Hm. I see that ->guest_mode and ->requests are in fact in the same cache line.  So this is likely really an optimization.  We should probably reorganize kvm_vcpu so that this is made explicit.
> 

OK, will do it in the separate patch in the future, thanks!
