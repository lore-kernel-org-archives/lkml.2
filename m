Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab1AGN2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:28:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab1AGN2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:28:19 -0500
Date: Fri, 7 Jan 2011 09:55:27 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] KVM: send IPI to vcpu only when it's in guest mode
Message-ID: <20110107115527.GA13196@amt.cnet>
References: <4D26C4D4.30303@cn.fujitsu.com>
 <4D26C527.9090403@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D26C527.9090403@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 03:47:51PM +0800, Xiao Guangrong wrote:
> We can interrupt the vcpu only when it's running in guest mode
> to reduce IPI
> 
> It looks like only ia64 and x86 need to send IPI to other vcpus, so
> i only add the implementation of 'vcpu->guest_mode' in ia64, but i
> don't know ia64 well, please point out the right way for me if the
> implementation is incorrect
> 
> Also reorganize struct kvm_vcpu to make ->guest_mode and ->requests
> in the same cache line explicitly.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/ia64/kvm/kvm-ia64.c |    2 ++
>  arch/x86/kvm/x86.c       |    6 +++++-
>  include/linux/kvm_host.h |    9 +++++----
>  virt/kvm/kvm_main.c      |    7 ++++++-
>  4 files changed, 18 insertions(+), 6 deletions(-)
> 

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b1b6cbb..a475264 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -153,7 +153,12 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
>  		if (kvm_make_check_request(req, vcpu))
>  			continue;
>  		cpu = vcpu->cpu;
> -		if (cpus != NULL && cpu != -1 && cpu != me)
> +
> +		/* Set ->requests bit before we read ->guest_mode */
> +		smp_mb();
> +
> +		if (cpus != NULL && cpu != -1 && cpu != me &&
> +		      atomic_read(&vcpu->guest_mode))
>  			cpumask_set_cpu(cpu, cpus);

Don't think this is safe, since guest_mode does not imply that a vcpu
has received the IPI, only that IPI has been sent (see kvm_vcpu_kick).

And make_all_cpus_request must guarantee all target vcpus are out of
guest mode before it returns.

