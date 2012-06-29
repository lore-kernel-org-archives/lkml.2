Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab2F2J0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 05:26:16 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39259 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab2F2J0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 05:26:13 -0400
X-AuditID: b753bd60-914c2ba0000047ca-5e-4fed74b3458a
X-AuditID: b753bd60-914c2ba0000047ca-5e-4fed74b3458a
Message-ID: <4FED74B9.3020308@hitachi.com>
Date: Fri, 29 Jun 2012 18:26:17 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com, mtosatti@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 16/18] KVM: add kvm_arch_vcpu_prevent_run to prevent
 VM ENTER when NMI is received
References: <20120628060719.19298.43879.stgit@localhost.localdomain> <20120628060842.19298.14653.stgit@localhost.localdomain> <4FEC8AFB.8060606@redhat.com>
In-Reply-To: <4FEC8AFB.8060606@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/06/29 1:48, Avi Kivity wrote:
> On 06/28/2012 09:08 AM, Tomoki Sekiyama wrote:
>> Since NMI can not be disabled around VM enter, there is a race between
>> receiving NMI to kick a guest and entering the guests on slave CPUs.If the
>> NMI is received just before entering VM, after the NMI handler is invoked,
>> it continues entering the guest and the effect of the NMI will be lost.
>>
>> This patch adds kvm_arch_vcpu_prevent_run(), which causes VM exit right
>> after VM enter. The NMI handler uses this to ensure the execution of the
>> guest is cancelled after NMI.
>>
>>  
>> +/*
>> + * Make VMRESUME fail using preemption timer with timer value = 0.
>> + * On processors that doesn't support preemption timer, VMRESUME will fail
>> + * by internal error.
>> + */
>> +static void vmx_prevent_run(struct kvm_vcpu *vcpu, int prevent)
>> +{
>> +	if (prevent)
>> +		vmcs_set_bits(PIN_BASED_VM_EXEC_CONTROL,
>> +			      PIN_BASED_PREEMPTION_TIMER);
>> +	else
>> +		vmcs_clear_bits(PIN_BASED_VM_EXEC_CONTROL,
>> +				PIN_BASED_PREEMPTION_TIMER);
>> +}
> 
> This may interrupt another RMW sequence, which will then overwrite the
> control.  So it needs to be called only if inside the entry sequence
> (otherwise can just set a KVM_REQ_IMMEDIATE_EXIT in vcpu->requests).
> 

I agree. I will add the check whether it is in the entry sequence.

Thanks,
-- 
Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory

