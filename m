Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab0H3Pvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 11:51:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778Ab0H3Pvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:51:52 -0400
Date: Mon, 30 Aug 2010 12:47:19 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] KVM: MMU: lower the aduit frequency
Message-ID: <20100830154719.GB12707@amt.cnet>
References: <4C78FA00.8090606@cn.fujitsu.com>
 <4C7B867D.9080500@cn.fujitsu.com>
 <4C7B8759.60900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7B8759.60900@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 06:26:33PM +0800, Xiao Guangrong wrote:
> The audit is very high overhead, so we need lower the frequency to assure the guest running
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu_audit.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu_audit.c b/arch/x86/kvm/mmu_audit.c
> index 3bde186..bd2b1be 100644
> --- a/arch/x86/kvm/mmu_audit.c
> +++ b/arch/x86/kvm/mmu_audit.c
> @@ -17,6 +17,8 @@
>   *
>   */
>  
> +#include <linux/ratelimit.h>
> +
>  static const char *audit_msg;
>  
>  typedef void (*inspect_spte_fn) (struct kvm_vcpu *vcpu, u64 *sptep, int level);
> @@ -228,6 +230,11 @@ static void audit_vcpu_spte(struct kvm_vcpu *vcpu)
>  
>  static void kvm_mmu_audit(void *ignore, struct kvm_vcpu *vcpu, int audit_point)
>  {
> +	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
> +
> +	if (!__ratelimit(&ratelimit_state))
> +		return;
> +
>  	audit_msg = audit_point_name[audit_point];
>  	audit_all_active_sps(vcpu->kvm);
>  	audit_vcpu_spte(vcpu);
> -- 
> 1.7.0.4

Well, as Avi said this makes it difficult to trace back to offender (the
audit points are placed around modifications to the shadow page tree 
for that reason).

I've always seen progress from the guest while running with audit
enabled (its slow, but its not supposed to be fast anyway). 

Did you experience a freeze? 

