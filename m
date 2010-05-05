Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab0EEU5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:57:16 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:43244 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab0EEU5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:57:14 -0400
X-SpamScore: -27
X-BigFish: VPS-27(zz1432P98dN936eM9371P10d1Iab9bhzz1202hzz6ff19hz32i2a8h63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0L1YSV4-01-5JF-02
X-M-MSG: 
Message-ID: <4BE1DB9C.7000405@amd.com>
Date: Wed, 5 May 2010 22:57:00 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Roedel, Joerg" <Joerg.Roedel@amd.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] KVM: SVM: Allow EFER.LMSLE to be set with nested
 svm
References: <1273068285-3105-1-git-send-email-joerg.roedel@amd.com> <1273068285-3105-5-git-send-email-joerg.roedel@amd.com> <4BE184E3.1010508@redhat.com>
In-Reply-To: <4BE184E3.1010508@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 May 2010 20:57:03.0926 (UTC) FILETIME=[83D0C560:01CAEC95]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> On 05/05/2010 05:04 PM, Joerg Roedel wrote:
>> This patch enables setting of efer bit 13 which is allowed
>> in all SVM capable processors. This is necessary for the
>> SLES11 version of Xen 4.0 to boot with nested svm.
>>    
> 
> Interesting, why does it require it?
It does not. Best is you check the patch, which has just been posted 
yesterday on xen-devel for upstream inclusion:
http://lists.xensource.com/archives/html/xen-devel/2010-05/msg00096.html
Basically it _tries_ to set the bit via safe_wrmsr() to detect whether 
its legal (in replacement of the missing CPUID check). Afterwards it 
resets it. If it available, it allows _guests_ to enable it. AFAIK the 
only user of this feature is VMware with binary translation running 
64bit guests, as they rely on segment limits to protect their hypervisor 
code from being read from the guest.
If I understood this correctly, there is a bug somewhere, maybe even in 
KVM's nested SVM implementation. Xen is fine with this bit-set provoking 
a #GP. I haven't had time yet to further investigate this, though.

> Obviously it isn't needed since it manages to run on Intel without it.
VMware's binary translation relies on VMX for running 64bit guests, on 
AMD you don't need SVM if you had a K8RevE (dual core 90nm) with this 
feature. In fact you should not be able to run VMware with 64bit guests 
inside a KVM guest on an Intel box (without nested VMX, that is).
On AMD you can either use nested SVM or this feature.

Regards,
Andre.

> 
>>   /* Intel MSRs. Some also available on other CPUs */
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index 74f7b9d..bc087c7 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -610,7 +610,7 @@ static __init int svm_hardware_setup(void)
>>
>>   	if (nested) {
>>   		printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
>> -		kvm_enable_efer_bits(EFER_SVME);
>> +		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
>>   	}
>>
>>   	for_each_possible_cpu(cpu) {
>>    
> 
> What if the host doesn't have it?
> 
> Why enable it only for the nested case?  It's not svm specific (it's 
> useful for running non-hvm Xen in non-nested mode).
> 
> Isn't there a cpuid bit for it?  If so, it should be exposed to 
> userspace, and the feature should depend on it.
> 

-- 
Andre Przywara
AMD-OSRC (Dresden)
Tel: x29712

