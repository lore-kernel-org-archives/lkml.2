Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2F1QtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:49:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab2F1QtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:49:14 -0400
Message-ID: <4FEC8AFB.8060606@redhat.com>
Date: Thu, 28 Jun 2012 19:48:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 16/18] KVM: add kvm_arch_vcpu_prevent_run to prevent
 VM ENTER when NMI is received
References: <20120628060719.19298.43879.stgit@localhost.localdomain> <20120628060842.19298.14653.stgit@localhost.localdomain>
In-Reply-To: <20120628060842.19298.14653.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 09:08 AM, Tomoki Sekiyama wrote:
> Since NMI can not be disabled around VM enter, there is a race between
> receiving NMI to kick a guest and entering the guests on slave CPUs.If the
> NMI is received just before entering VM, after the NMI handler is invoked,
> it continues entering the guest and the effect of the NMI will be lost.
> 
> This patch adds kvm_arch_vcpu_prevent_run(), which causes VM exit right
> after VM enter. The NMI handler uses this to ensure the execution of the
> guest is cancelled after NMI.
> 
>  
> +/*
> + * Make VMRESUME fail using preemption timer with timer value = 0.
> + * On processors that doesn't support preemption timer, VMRESUME will fail
> + * by internal error.
> + */
> +static void vmx_prevent_run(struct kvm_vcpu *vcpu, int prevent)
> +{
> +	if (prevent)
> +		vmcs_set_bits(PIN_BASED_VM_EXEC_CONTROL,
> +			      PIN_BASED_PREEMPTION_TIMER);
> +	else
> +		vmcs_clear_bits(PIN_BASED_VM_EXEC_CONTROL,
> +				PIN_BASED_PREEMPTION_TIMER);
> +}

This may interrupt another RMW sequence, which will then overwrite the
control.  So it needs to be called only if inside the entry sequence
(otherwise can just set a KVM_REQ_IMMEDIATE_EXIT in vcpu->requests).

-- 
error compiling committee.c: too many arguments to function


