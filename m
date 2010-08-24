Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab0HXJhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:37:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab0HXJhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:37:09 -0400
Message-ID: <4C73928A.4040601@redhat.com>
Date: Tue, 24 Aug 2010 12:36:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v5 12/12] Send async PF when guest is not in userspace
 too.
References: <1279553462-7036-1-git-send-email-gleb@redhat.com> <1279553462-7036-13-git-send-email-gleb@redhat.com>
In-Reply-To: <1279553462-7036-13-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/19/2010 06:31 PM, Gleb Natapov wrote:
> If guest indicates that it can handle async pf in kernel mode too send
> it, but only if interrupt are enabled.
>
> Reviewed-by: Rik van Riel<riel@redhat.com>
> Signed-off-by: Gleb Natapov<gleb@redhat.com>
> ---
>   arch/x86/kvm/mmu.c |    8 +++++++-
>   1 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 12d1a7b..ed87b1c 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2361,7 +2361,13 @@ static bool can_do_async_pf(struct kvm_vcpu *vcpu)
>   	if (!vcpu->arch.apf_data || kvm_event_needs_reinjection(vcpu))
>   		return false;
>
> -	return !!kvm_x86_ops->get_cpl(vcpu);
> +	if (vcpu->arch.apf_send_user_only)
> +		return !!kvm_x86_ops->get_cpl(vcpu);

cpl is not a bool.  Compare it with 0.

> +
> +	if (!kvm_x86_ops->interrupt_allowed(vcpu))
> +		return false;
> +
> +	return true;
>   }

Should have commented before, but get_cpl() is not accurate when doing 
nested virtualization.  When L1 intercepts page faults, being in L2 is 
equivalent to CPL 3.  But we need to get the apf information to L1 somehow.

-- 
error compiling committee.c: too many arguments to function

