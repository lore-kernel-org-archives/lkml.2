Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905Ab2B1KUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:20:14 -0500
Received: from goliath.siemens.de ([192.35.17.28]:32071 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab2B1KUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:20:12 -0500
Message-ID: <4F4CAA43.3020805@siemens.com>
Date: Tue, 28 Feb 2012 11:19:47 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [PATCH] kvm: notify host when guest paniced
References: <4F4AF1FB.6000903@cn.fujitsu.com> <4F4B9C57.3010407@siemens.com> <4F4C8EEB.8040709@cn.fujitsu.com> <4F4C9F8C.1060901@siemens.com> <4F4CA17F.4020504@cn.fujitsu.com>
In-Reply-To: <4F4CA17F.4020504@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-28 10:42, Wen Congyang wrote:
> At 02/28/2012 05:34 PM, Jan Kiszka Wrote:
>> On 2012-02-28 09:23, Wen Congyang wrote:
>>> At 02/27/2012 11:08 PM, Jan Kiszka Wrote:
>>>> On 2012-02-27 04:01, Wen Congyang wrote:
>>>>> We can know the guest is paniced when the guest runs on xen.
>>>>> But we do not have such feature on kvm. This patch implemnts
>>>>> this feature, and the implementation is the same as xen:
>>>>> register panic notifier, and call hypercall when the guest
>>>>> is paniced.
>>>>>
>>>>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>>>>> ---
>>>>>  arch/x86/kernel/kvm.c    |   12 ++++++++++++
>>>>>  arch/x86/kvm/svm.c       |    8 ++++++--
>>>>>  arch/x86/kvm/vmx.c       |    8 ++++++--
>>>>>  arch/x86/kvm/x86.c       |   13 +++++++++++--
>>>>>  include/linux/kvm.h      |    1 +
>>>>>  include/linux/kvm_para.h |    1 +
>>>>>  6 files changed, 37 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>>>> index f0c6fd6..b928d1d 100644
>>>>> --- a/arch/x86/kernel/kvm.c
>>>>> +++ b/arch/x86/kernel/kvm.c
>>>>> @@ -331,6 +331,17 @@ static struct notifier_block kvm_pv_reboot_nb = {
>>>>>  	.notifier_call = kvm_pv_reboot_notify,
>>>>>  };
>>>>>  
>>>>> +static int
>>>>> +kvm_pv_panic_notify(struct notifier_block *nb, unsigned long code, void *unused)
>>>>> +{
>>>>> +	kvm_hypercall0(KVM_HC_GUEST_PANIC);
>>>>> +	return NOTIFY_DONE;
>>>>> +}
>>>>> +
>>>>> +static struct notifier_block kvm_pv_panic_nb = {
>>>>> +	.notifier_call = kvm_pv_panic_notify,
>>>>> +};
>>>>> +
>>>>
>>>> You should split up host and guest-side changes.
>>>>
>>>>>  static u64 kvm_steal_clock(int cpu)
>>>>>  {
>>>>>  	u64 steal;
>>>>> @@ -417,6 +428,7 @@ void __init kvm_guest_init(void)
>>>>>  
>>>>>  	paravirt_ops_setup();
>>>>>  	register_reboot_notifier(&kvm_pv_reboot_nb);
>>>>> +	atomic_notifier_chain_register(&panic_notifier_list, &kvm_pv_panic_nb);
>>>>>  	for (i = 0; i < KVM_TASK_SLEEP_HASHSIZE; i++)
>>>>>  		spin_lock_init(&async_pf_sleepers[i].lock);
>>>>>  	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF))
>>>>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>>>>> index 0b7690e..38b4705 100644
>>>>> --- a/arch/x86/kvm/svm.c
>>>>> +++ b/arch/x86/kvm/svm.c
>>>>> @@ -1900,10 +1900,14 @@ static int halt_interception(struct vcpu_svm *svm)
>>>>>  
>>>>>  static int vmmcall_interception(struct vcpu_svm *svm)
>>>>>  {
>>>>> +	int ret;
>>>>> +
>>>>>  	svm->next_rip = kvm_rip_read(&svm->vcpu) + 3;
>>>>>  	skip_emulated_instruction(&svm->vcpu);
>>>>> -	kvm_emulate_hypercall(&svm->vcpu);
>>>>> -	return 1;
>>>>> +	ret = kvm_emulate_hypercall(&svm->vcpu);
>>>>> +
>>>>> +	/* Ignore the error? */
>>>>> +	return ret == 0 ? 0 : 1;
>>>>
>>>> Why can't kvm_emulate_hypercall return the right value?
>>>
>>> kvm_emulate_hypercall() will call kvm_hv_hypercall(), and
>>> kvm_hv_hypercall() will return 0 when vcpu's CPL > 0.
>>> If vcpu's CPL > 0, does kvm need to exit and tell it to
>>> qemu?
>>
>> No, there is currently no exit to userspace due to hypercalls, neither
>> of HV nor KVM kind.
>>
>> The point is that the return code of kvm_emulate_hypercall is unused so
>> far, so you can easily redefine it to encode continue vs. exit to
>> userspace. Once someone has different needs, this could still be
>> refactored again.
> 
> So, it is OK to change the return value of kvm_hv_hypercall() if vcpu's
> CPL > 0?

Yes, change it to encode what vendor modules need to return to their
callers.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
