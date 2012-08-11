Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab2HKDNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 23:13:19 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:33368 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2HKDNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 23:13:16 -0400
Message-ID: <5025CDC6.2050704@linux.vnet.ibm.com>
Date: Sat, 11 Aug 2012 11:13:10 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 11/12] KVM: x86: introduce set_mmio_exit_info
References: <5020E423.9080004@linux.vnet.ibm.com> <5020E5E2.4080603@linux.vnet.ibm.com> <20120810180348.GB12477@amt.cnet>
In-Reply-To: <20120810180348.GB12477@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12081103-4790-0000-0000-000004163502
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2012 02:03 AM, Marcelo Tosatti wrote:

>>  int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
>>  			void *val, unsigned int bytes,
>>  			struct x86_exception *exception,
>> @@ -3870,14 +3881,10 @@ int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
>>  		return rc;
>>
>>  	gpa = vcpu->mmio_fragments[0].gpa;
>> -
>>  	vcpu->mmio_needed = 1;
>>  	vcpu->mmio_cur_fragment = 0;
>>
>> -	vcpu->run->mmio.len = vcpu->mmio_fragments[0].len;
>> -	vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
>> -	vcpu->run->exit_reason = KVM_EXIT_MMIO;
>> -	vcpu->run->mmio.phys_addr = gpa;
>> +	set_mmio_exit_info(vcpu, &vcpu->mmio_fragments[0], ops->write);
>>
>>  	return ops->read_write_exit_mmio(vcpu, gpa, val, bytes);
>>  }
>> @@ -5486,7 +5493,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>>   */
>>  static int complete_mmio(struct kvm_vcpu *vcpu)
>>  {
>> -	struct kvm_run *run = vcpu->run;
>>  	struct kvm_mmio_fragment *frag;
>>  	int r;
>>
>> @@ -5497,7 +5503,7 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
>>  		/* Complete previous fragment */
>>  		frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment++];
>>  		if (!vcpu->mmio_is_write)
>> -			memcpy(frag->data, run->mmio.data, frag->len);
>> +			memcpy(frag->data, vcpu->run->mmio.data, frag->len);
>>  		if (vcpu->mmio_cur_fragment == vcpu->mmio_nr_fragments) {
>>  			vcpu->mmio_needed = 0;
>>  			if (vcpu->mmio_is_write)
>> @@ -5507,12 +5513,7 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
>>  		}
>>  		/* Initiate next fragment */
>>  		++frag;
>> -		run->exit_reason = KVM_EXIT_MMIO;
>> -		run->mmio.phys_addr = frag->gpa;
>> -		if (vcpu->mmio_is_write)
>> -			memcpy(run->mmio.data, frag->data, frag->len);
>> -		run->mmio.len = frag->len;
>> -		run->mmio.is_write = vcpu->mmio_is_write;
>> +		set_mmio_exit_info(vcpu, frag, vcpu->mmio_is_write);
>>  		return 0;
>>
>>  	}
>> -- 
>> 1.7.7.6
> 
> IMO having a function is unnecessary (it makes it harder the code).

Okay, i will drop this patch.


