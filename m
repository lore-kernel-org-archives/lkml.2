Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab1AFD66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 22:58:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56365 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754754Ab1AFD65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 22:58:57 -0500
Message-ID: <4D253E01.6030006@cn.fujitsu.com>
Date: Thu, 06 Jan 2011 11:58:57 +0800
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
 2011-01-06 11:58:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-06 11:58:36,
	Serialize complete at 2011-01-06 11:58:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 05:48 PM, Avi Kivity wrote:
> On 01/05/2011 11:38 AM, Xiao Guangrong wrote:
>> We can interrupt the vcpu only when it's running in guest mode
>> to reduce IPI.
>>
>> It looks like only ia64 and x86 need to send IPI to other vcpus, so
>> i only add the implementation of 'vcpu->guest_mode' in ia64, but i
>> don't know ia64 well, please point out the right way for me if the
>> implementation is incorrect
>>
>> And ia64 is not tested since i don't have ia64 box
>>
>> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
>> ---
>>   arch/ia64/kvm/kvm-ia64.c |    2 ++
>>   virt/kvm/kvm_main.c      |    3 ++-
>>   2 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
>> index 70d224d..15c11b2 100644
>> --- a/arch/ia64/kvm/kvm-ia64.c
>> +++ b/arch/ia64/kvm/kvm-ia64.c
>> @@ -662,6 +662,7 @@ again:
>>           goto vcpu_run_fail;
>>
>>       srcu_read_unlock(&vcpu->kvm->srcu, idx);
>> +    atomic_set(&vcpu->guest_mode, 1);
>>       kvm_guest_enter();
> 
> I think it needs an smp_wmb() (technically x86 needs it too, but x86 is strongly ordered)
> 

Hi Avi,

After read the code of ia64 more carefully, i noticed ia64 doesn't check 'vcpu->requests'
before go to guest mode, so it means we no need memory barrier here? right?

Certainly, we need an smb_mb between setting vcpu->mode and checking vcpu->request in x86.
