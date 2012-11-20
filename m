Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab2KTX2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 18:28:10 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:37833 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab2KTX2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 18:28:08 -0500
Message-ID: <50AC1200.8070402@linux.vnet.ibm.com>
Date: Wed, 21 Nov 2012 07:28:00 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/5] KVM: MMU: move adjusting softmmu pte access to FNAME(page_fault)
References: <5097AC70.1080904@linux.vnet.ibm.com> <5097AD17.4010001@linux.vnet.ibm.com> <20121120222749.GC31427@amt.cnet>
In-Reply-To: <20121120222749.GC31427@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12112023-8256-0000-0000-0000051B5585
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 06:27 AM, Marcelo Tosatti wrote:

>> @@ -544,6 +544,21 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
>>  		return 0;
>>  	}
>>
>> +	if (write_fault && !(walker.pte_access & ACC_WRITE_MASK) &&
>> +	      !is_write_protection(vcpu) && !user_fault) {
>> +		walker.pte_access |= ACC_WRITE_MASK;
>> +		walker.pte_access &= ~ACC_USER_MASK;
>> +
>> +		/*
>> +		 * If we converted a user page to a kernel page,
>> +		 * so that the kernel can write to it when cr0.wp=0,
>> +		 * then we should prevent the kernel from executing it
>> +		 * if SMEP is enabled.
>> +		 */
>> +		if (kvm_read_cr4_bits(vcpu, X86_CR4_SMEP))
>> +			walker.pte_access &= ~ACC_EXEC_MASK;
>> +	}
>> +
> 
> What about sync_page path?

The sync_page and other prefetch paths only do read-prefetch, means
they call set_spte with write_fault = 0.

