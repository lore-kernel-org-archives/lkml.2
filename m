Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318Ab2FUKZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 06:25:25 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:39644 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759308Ab2FUKZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 06:25:23 -0400
Message-ID: <4FE2F62A.9090804@linux.vnet.ibm.com>
Date: Thu, 21 Jun 2012 15:53:38 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: handle last_boosted_vcpu = 0 case
References: <20120619202047.26191.40429.sendpatchset@codeblue> <20120619165104.2a4574f8@annuminas.surriel.com> <20120621064358.GS6533@redhat.com>
In-Reply-To: <20120621064358.GS6533@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12062100-1618-0000-0000-000001E41392
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 12:13 PM, Gleb Natapov wrote:
> On Tue, Jun 19, 2012 at 04:51:04PM -0400, Rik van Riel wrote:
>> On Wed, 20 Jun 2012 01:50:50 +0530
>> Raghavendra K T<raghavendra.kt@linux.vnet.ibm.com>  wrote:
>>
>>>
>>> In ple handler code, last_boosted_vcpu (lbv) variable is
>>> serving as reference point to start when we enter.
>>
>>> Also statistical analysis (below) is showing lbv is not very well
>>> distributed with current approach.
>>
>> You are the second person to spot this bug today (yes, today).
>>
>> Due to time zones, the first person has not had a chance yet to
>> test the patch below, which might fix the issue...
>>
>> Please let me know how it goes.
>>
>> ====8<====
>>
>> If last_boosted_vcpu == 0, then we fall through all test cases and
>> may end up with all VCPUs pouncing on vcpu 0.  With a large enough
>> guest, this can result in enormous runqueue lock contention, which
>> can prevent vcpu0 from running, leading to a livelock.
>>
>> Changing<  to<= makes sure we properly handle that case.
>>
>> Signed-off-by: Rik van Riel<riel@redhat.com>
>> ---
>>   virt/kvm/kvm_main.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 7e14068..1da542b 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1586,7 +1586,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>>   	 */
>>   	for (pass = 0; pass<  2&&  !yielded; pass++) {
>>   		kvm_for_each_vcpu(i, vcpu, kvm) {
>> -			if (!pass&&  i<  last_boosted_vcpu) {
>> +			if (!pass&&  i<= last_boosted_vcpu) {
>>   				i = last_boosted_vcpu;
>>   				continue;
>>   			} else if (pass&&  i>  last_boosted_vcpu)
>>
> Looks correct. We can simplify this by introducing something like:
>
> #define kvm_for_each_vcpu_from(idx, n, vcpup, kvm) \
>          for (n = atomic_read(&kvm->online_vcpus); \
>               n&&  (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
>               n--, idx = (idx+1) % atomic_read(&kvm->online_vcpus))
>

Thumbs up for this simplification. This really helps in all the places
where we want to start iterating from middle.

