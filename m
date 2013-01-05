Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3AEHUg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 02:20:36 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:43030 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab3AEHUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 02:20:34 -0500
Message-ID: <50E7D438.60709@linux.vnet.ibm.com>
Date: Sat, 05 Jan 2013 15:20:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 3/5] KVM: x86: clean up reexecute_instruction
References: <50E6DEDC.7040800@linux.vnet.ibm.com> <50E6DF5C.2000103@linux.vnet.ibm.com> <20130104222135.GA13481@amt.cnet>
In-Reply-To: <20130104222135.GA13481@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010507-5816-0000-0000-0000061E4FAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2013 06:21 AM, Marcelo Tosatti wrote:
> On Fri, Jan 04, 2013 at 09:55:40PM +0800, Xiao Guangrong wrote:
>> Little cleanup for reexecute_instruction, also use gpa_to_gfn in
>> retry_instruction
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/x86.c |   13 ++++++-------
>>  1 files changed, 6 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 1c9c834..ad39018 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -4761,19 +4761,18 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
>>  	if (tdp_enabled)
>>  		return false;
>>
>> +	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
>> +	if (gpa == UNMAPPED_GVA)
>> +		return true; /* let cpu generate fault */
>> +
> 
> Why change from _system to _read here? Purely cleanup patch should
> have no logical changes.

Ouch, my mistake, will drop this change.

> 
> BTW, there is not much logic in using reexecute_instruction() at
> for x86_decode_insn (checks in reexecute_instruction() assume 
> write to the cr2, for instance).
> Fault propagation for x86_decode_insn seems completly broken
> (which is perhaps why reexecute_instruction() there survived).

Currently, reexecute_instruction can work only if it is called on page
fault path where cr2 is valid. On other paths, cr2 is 0 which is always
not be mapped on guest since it is NULL pointer, so reexecute_instruction
always retry the instruction.

Yes, as you point it out, it is better if the fault address can be got
from x86_decode_insn. I will consider it later.


