Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab2K2DHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 22:07:06 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:39436 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499Ab2K2DHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 22:07:04 -0500
Message-ID: <50B6D14E.8020509@linux.vnet.ibm.com>
Date: Thu, 29 Nov 2012 11:06:54 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: VMX: fix memory order between loading vmcs and
 clearing vmcs
References: <50B6093B.7040404@linux.vnet.ibm.com> <50B60976.7020905@linux.vnet.ibm.com> <20121129000428.GA17264@amt.cnet>
In-Reply-To: <20121129000428.GA17264@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12112903-2674-0000-0000-000006EA6F63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 08:04 AM, Marcelo Tosatti wrote:
> On Wed, Nov 28, 2012 at 08:54:14PM +0800, Xiao Guangrong wrote:
>> vmcs->cpu indicates whether it exists on the target cpu, -1 means the vmcs
>> does not exist on any vcpu
>>
>> If vcpu load vmcs with vmcs.cpu = -1, it can be directly added to cpu's percpu
>> list. The list can be corrupted if the cpu prefetch the vmcs's list before
>> reading vmcs->cpu. Meanwhile, we should remove vmcs from the list before
>> making vmcs->vcpu == -1 be visible
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/vmx.c |   17 +++++++++++++++++
>>  1 files changed, 17 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index 29e8f42..6056d88 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -1002,6 +1002,15 @@ static void __loaded_vmcs_clear(void *arg)
>>  	if (per_cpu(current_vmcs, cpu) == loaded_vmcs->vmcs)
>>  		per_cpu(current_vmcs, cpu) = NULL;
>>  	list_del(&loaded_vmcs->loaded_vmcss_on_cpu_link);
>> +
>> +	/*
>> +	 * we should ensure updating loaded_vmcs->loaded_vmcss_on_cpu_link
>> +	 * is before setting loaded_vmcs->vcpu to -1 which is done in
>> +	 * loaded_vmcs_init. Otherwise, other cpu can see vcpu = -1 fist
>> +	 * then adds the vmcs into percpu list before it is deleted.
>> +	 */
>> +	smp_wmb();
>> +
> 
> Neither loads nor stores are reordered with like operations (see
> section 8.2.3.2 of intel's volume 3). This behaviour makes the barrier
> not necessary.

Ouch, yes, you are right. My memory is wrong. It seems only later-read
can be reordered with early-write.

But if 'read vs read' and 'write vs write' can be guaranteed by CPU, smp_wmb()
and smp_rmb() should act as a complier barrier, so i think we can add the barriers
to improve the readable and the portable.

And anyway, the current code missed complier-barrier.

> 
> However, i agree access to loaded_vmcs is not obviously safe. I can't
> tell its safe with vmm_exclusive = 0 (where vcpu->cpu can change at any
> time).

If vmm_exclusive = 0, the vmcs can removed from percpu list when vcpu is scheduled
out. The list is not broken.



