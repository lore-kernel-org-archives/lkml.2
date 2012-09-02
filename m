Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2IBKMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 06:12:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab2IBKMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 06:12:40 -0400
Date: Sun, 2 Sep 2012 13:12:35 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH RFC 1/1] kvm: Use vcpu_id as pivot instead of last
 boosted vcpu in PLE handler
Message-ID: <20120902101234.GB27250@redhat.com>
References: <20120829192100.22412.92575.sendpatchset@codeblue>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120829192100.22412.92575.sendpatchset@codeblue>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 12:51:01AM +0530, Raghavendra K T wrote:
>  The idea of starting from next vcpu (source of yield_to + 1) seem to work
>  well for overcomitted guest rather than using last boosted vcpu. We can also
>  remove per VM variable with this approach.
>  
>  Iteration for eligible candidate after this patch starts from vcpu source+1
>  and ends at source-1 (after wrapping)
>  
>  Thanks Nikunj for his quick verification of the patch.
>  
>  Please let me know if this patch is interesting and makes sense.
> 
This last_boosted_vcpu thing caused us trouble during attempt to
implement vcpu destruction. It is good to see it removed from this POV.

> ====8<====
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> 
>  Currently we use next vcpu to last boosted vcpu as starting point
>  while deciding eligible vcpu for directed yield.
> 
>  In overcomitted scenarios, if more vcpu try to do directed yield,
>  they start from same vcpu, resulting in wastage of cpu time (because of
>  failing yields and double runqueue lock).
>  
>  Since probability of same vcpu trying to do directed yield is already
>  prevented by improved PLE handler, we can start from next vcpu from source
>  of yield_to.
> 
> Suggested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
> 
>  include/linux/kvm_host.h |    1 -
>  virt/kvm/kvm_main.c      |   12 ++++--------
>  2 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index b70b48b..64a090d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -275,7 +275,6 @@ struct kvm {
>  #endif
>  	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>  	atomic_t online_vcpus;
> -	int last_boosted_vcpu;
>  	struct list_head vm_list;
>  	struct mutex lock;
>  	struct kvm_io_bus *buses[KVM_NR_BUSES];
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2468523..65a6c83 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1584,7 +1584,6 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>  {
>  	struct kvm *kvm = me->kvm;
>  	struct kvm_vcpu *vcpu;
> -	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
>  	int yielded = 0;
>  	int pass;
>  	int i;
> @@ -1594,21 +1593,18 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>  	 * currently running, because it got preempted by something
>  	 * else and called schedule in __vcpu_run.  Hopefully that
>  	 * VCPU is holding the lock that we need and will release it.
> -	 * We approximate round-robin by starting at the last boosted VCPU.
> +	 * We approximate round-robin by starting at the next VCPU.
>  	 */
>  	for (pass = 0; pass < 2 && !yielded; pass++) {
>  		kvm_for_each_vcpu(i, vcpu, kvm) {
> -			if (!pass && i <= last_boosted_vcpu) {
> -				i = last_boosted_vcpu;
> +			if (!pass && i <= me->vcpu_id) {
> +				i = me->vcpu_id;
>  				continue;
> -			} else if (pass && i > last_boosted_vcpu)
> +			} else if (pass && i >= me->vcpu_id)
>  				break;
> -			if (vcpu == me)
> -				continue;
>  			if (waitqueue_active(&vcpu->wq))
>  				continue;
>  			if (kvm_vcpu_yield_to(vcpu)) {
> -				kvm->last_boosted_vcpu = i;
>  				yielded = 1;
>  				break;
>  			}

--
			Gleb.
