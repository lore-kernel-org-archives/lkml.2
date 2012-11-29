Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879Ab2K2AXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:23:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932745Ab2K2AXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:23:23 -0500
Date: Wed, 28 Nov 2012 22:04:28 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: VMX: fix memory order between loading vmcs and
 clearing vmcs
Message-ID: <20121129000428.GA17264@amt.cnet>
References: <50B6093B.7040404@linux.vnet.ibm.com>
 <50B60976.7020905@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B60976.7020905@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 08:54:14PM +0800, Xiao Guangrong wrote:
> vmcs->cpu indicates whether it exists on the target cpu, -1 means the vmcs
> does not exist on any vcpu
> 
> If vcpu load vmcs with vmcs.cpu = -1, it can be directly added to cpu's percpu
> list. The list can be corrupted if the cpu prefetch the vmcs's list before
> reading vmcs->cpu. Meanwhile, we should remove vmcs from the list before
> making vmcs->vcpu == -1 be visible
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/vmx.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 29e8f42..6056d88 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -1002,6 +1002,15 @@ static void __loaded_vmcs_clear(void *arg)
>  	if (per_cpu(current_vmcs, cpu) == loaded_vmcs->vmcs)
>  		per_cpu(current_vmcs, cpu) = NULL;
>  	list_del(&loaded_vmcs->loaded_vmcss_on_cpu_link);
> +
> +	/*
> +	 * we should ensure updating loaded_vmcs->loaded_vmcss_on_cpu_link
> +	 * is before setting loaded_vmcs->vcpu to -1 which is done in
> +	 * loaded_vmcs_init. Otherwise, other cpu can see vcpu = -1 fist
> +	 * then adds the vmcs into percpu list before it is deleted.
> +	 */
> +	smp_wmb();
> +

Neither loads nor stores are reordered with like operations (see
section 8.2.3.2 of intel's volume 3). This behaviour makes the barrier
not necessary.

However, i agree access to loaded_vmcs is not obviously safe. I can't
tell its safe with vmm_exclusive = 0 (where vcpu->cpu can change at any
time).

