Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0FPIFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 04:05:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab0FPIFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 04:05:15 -0400
Message-ID: <4C18870C.9070707@redhat.com>
Date: Wed, 16 Jun 2010 16:10:52 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/17] Fix deep C-state TSC desynchronization
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-5-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> When CPUs with unstable TSCs enter deep C-state, TSC may stop
> running.  This causes us to require resynchronization.  Since
> we can't tell when this may potentially happen, we assume the
> worst by forcing re-compensation for it at every point the VCPU
> task is descheduled.
>
>   
Is there any method to do the compensation on host TSC when recovering
from C-state? It should be simpler than do it on guest TSC.
> Signed-off-by: Zachary Amsden <zamsden@redhat.com>
> ---
>  arch/x86/kvm/x86.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c8289d0..618c435 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1822,7 +1822,18 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
>  	kvm_x86_ops->vcpu_put(vcpu);
>  	kvm_put_guest_fpu(vcpu);
> +
>  	vcpu->arch.last_host_tsc = native_read_tsc();
> +
> +	/*
> +	 * When potentially leaving a CPU with unstable TSCs, we risk
> +	 * that the CPU enters deep C-state.  If it does, the TSC may
> +	 * go out of sync but we will not recalibrate because the test
> +	 * vcpu->cpu != cpu can not detect this condition.  So set
> +	 * vcpu->cpu = -1 to force the recalibration above.
> +	 */
> +	if (check_tsc_unstable())
> +		vcpu->cpu = -1;
>  }
>  
>  static int is_efer_nx(void)
>   

