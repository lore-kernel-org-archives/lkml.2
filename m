Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab2K0DN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 22:13:26 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:33881 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab2K0DNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 22:13:24 -0500
Message-ID: <50B42FC7.2080805@linux.vnet.ibm.com>
Date: Tue, 27 Nov 2012 11:13:11 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: x86: let reexecute_instruction work for tdp
References: <50AAC77C.8040505@linux.vnet.ibm.com> <50AAC7CE.2050506@linux.vnet.ibm.com> <20121126223712.GA10634@amt.cnet>
In-Reply-To: <20121126223712.GA10634@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12112703-4790-0000-0000-000005BF20CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 06:37 AM, Marcelo Tosatti wrote:
> On Tue, Nov 20, 2012 at 07:59:10AM +0800, Xiao Guangrong wrote:
>> Currently, reexecute_instruction refused to retry all instructions. If
>> nested npt is used, the emulation may be caused by shadow page, it can
>> be fixed by dropping the shadow page
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/x86.c |   14 ++++++++------
>>  1 files changed, 8 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 7be8452..5fe72cc 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4469,17 +4469,19 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu)
>>  	return r;
>>  }
>>
>> -static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
>> +static bool reexecute_instruction(struct kvm_vcpu *vcpu, unsigned long cr2)
>>  {
>> -	gpa_t gpa;
>> +	gpa_t gpa = cr2;
>>  	pfn_t pfn;
>>
>> -	if (tdp_enabled)
>> +	if (!ACCESS_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
>>  		return false;
> 
> How is indirect_shadow_pages protected? Why is ACCESS_ONCE() being used
> to read it?

Hi Marcelo,

It is protected by mmu-lock for it only be changed when mmu-lock is hold. And
ACCESS_ONCE is used on read path avoiding magic optimization from compiler.

