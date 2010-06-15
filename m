Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab0FOIJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 04:09:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab0FOIJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 04:09:36 -0400
Message-ID: <4C17353F.5020006@redhat.com>
Date: Tue, 15 Jun 2010 11:09:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Zachary Amsden <zamsden@redhat.com>
CC: mtosatti@redhat.com, glommer@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/17] Fix deep C-state TSC desynchronization
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-5-git-send-email-zamsden@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 10:34 AM, Zachary Amsden wrote:
> When CPUs with unstable TSCs enter deep C-state, TSC may stop
> running.  This causes us to require resynchronization.  Since
> we can't tell when this may potentially happen, we assume the
> worst by forcing re-compensation for it at every point the VCPU
> task is descheduled.
>
> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
> ---
>   arch/x86/kvm/x86.c |   11 +++++++++++
>   1 files changed, 11 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c8289d0..618c435 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1822,7 +1822,18 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>   {
>   	kvm_x86_ops->vcpu_put(vcpu);
>   	kvm_put_guest_fpu(vcpu);
> +
>   	vcpu->arch.last_host_tsc = native_read_tsc();
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
>   }
>    

That will cause us to miss a vmclear later on.  Also it invalidates an 
invariant that the per-cpu list vcpus_on_cpu has all the vcpus with 
vcpu->cpu == cpu on this cpu (try saything that fast).

-- 
error compiling committee.c: too many arguments to function

