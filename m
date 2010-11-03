Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0KCJn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 05:43:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51533 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab0KCJn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 05:43:26 -0400
Message-ID: <4CD12FC9.9070902@cn.fujitsu.com>
Date: Wed, 03 Nov 2010 17:47:53 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH v2 7/7] KVM: KVM: don't break vcpu 'halt' state due
 to apfs
References: <4CCE8143.3090105@cn.fujitsu.com> <4CCE82BC.3090000@cn.fujitsu.com> <20101101125551.GD31722@redhat.com>
In-Reply-To: <20101101125551.GD31722@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-03 17:43:56,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-03 17:43:57,
	Serialize complete at 2010-11-03 17:43:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 08:55 PM, Gleb Natapov wrote:

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2cfdf2d..f7aed95 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5295,8 +5295,9 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>  			{
>  				switch(vcpu->arch.mp_state) {
>  				case KVM_MP_STATE_HALTED:
> -					vcpu->arch.mp_state =
> -						KVM_MP_STATE_RUNNABLE;
> +					if (list_empty_careful(&vcpu->async_pf.done))
> +						vcpu->arch.mp_state =
> +							KVM_MP_STATE_RUNNABLE;
>  				case KVM_MP_STATE_RUNNABLE:
>  					vcpu->arch.apf.halted = false;
>  					break;
> @@ -6279,6 +6280,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>  		vcpu->arch.fault.error_code = 0;
>  		vcpu->arch.fault.address = work->arch.token;
>  		kvm_inject_page_fault(vcpu);
> +		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>  	}
>  }
>  

Tested with full virtualization guests, it works well for me. Thanks!
