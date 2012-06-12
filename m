Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2FLXCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 19:02:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab2FLXCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 19:02:52 -0400
Date: Tue, 12 Jun 2012 19:43:10 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: peterz@infradead.org, mingo@elte.hu, avi@redhat.com,
        raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Subject: Re: [PATCH v2 1/7] KVM Guest: Add VCPU running/pre-empted state for
 guest
Message-ID: <20120612224310.GC1973@amt.cnet>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
 <20120604050547.4560.48709.stgit@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604050547.4560.48709.stgit@abhimanyu.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 10:36:05AM +0530, Nikunj A. Dadhania wrote:
> The patch adds guest code for msr between guest and hypervisor. The
> msr will export the vcpu running/pre-empted information to the guest
> from host. This will enable guest to intelligently send ipi to running
> vcpus and set flag for pre-empted vcpus. This will prevent waiting for
> vcpus that are not running.
> 
> Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/kvm_para.h |   10 ++++++++++
>  arch/x86/kernel/kvm.c           |   33 +++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 77266d3..f57b5cc 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -24,6 +24,7 @@
>  #define KVM_FEATURE_ASYNC_PF		4
>  #define KVM_FEATURE_STEAL_TIME		5
>  #define KVM_FEATURE_PV_UNHALT		6
> +#define KVM_FEATURE_VCPU_STATE          7
>  
>  /* The last 8 bits are used to indicate how to interpret the flags field
>   * in pvclock structure. If no bits are set, all flags are ignored.
> @@ -39,6 +40,7 @@
>  #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
>  #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
>  #define MSR_KVM_STEAL_TIME  0x4b564d03
> +#define MSR_KVM_VCPU_STATE  0x4b564d04
>  
>  struct kvm_steal_time {
>  	__u64 steal;
> @@ -51,6 +53,14 @@ struct kvm_steal_time {
>  #define KVM_STEAL_VALID_BITS ((-1ULL << (KVM_STEAL_ALIGNMENT_BITS + 1)))
>  #define KVM_STEAL_RESERVED_MASK (((1 << KVM_STEAL_ALIGNMENT_BITS) - 1 ) << 1)
>  
> +struct kvm_vcpu_state {
> +	__u32 state;
> +	__u32 pad[15];
> +};
> +
> +#define KVM_VCPU_STATE_ALIGN_BITS 5
> +#define KVM_VCPU_STATE_VALID_BITS ((-1ULL << (KVM_VCPU_STATE_ALIGN_BITS + 1)))
> +
>  #define KVM_MAX_MMU_OP_BATCH           32
>  
>  #define KVM_ASYNC_PF_ENABLED			(1 << 0)
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 98f0378..bb686a6 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -64,6 +64,9 @@ static DEFINE_PER_CPU(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
>  static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
>  static int has_steal_clock = 0;
>  
> +DEFINE_PER_CPU(struct kvm_vcpu_state, vcpu_state) __aligned(64);
> +static int has_vcpu_state;
> +
>  /*
>   * No need for any "IO delay" on KVM
>   */
> @@ -291,6 +294,22 @@ static void kvm_register_steal_time(void)
>  		cpu, __pa(st));
>  }
>  
> +static void kvm_register_vcpu_state(void)
> +{
> +	int cpu = smp_processor_id();
> +	struct kvm_vcpu_state *v_state;
> +
> +	if (!has_vcpu_state)
> +		return;
> +
> +	v_state = &per_cpu(vcpu_state, cpu);
> +	memset(v_state, 0, sizeof(*v_state));
> +
> +	wrmsrl(MSR_KVM_VCPU_STATE, (__pa(v_state) | KVM_MSR_ENABLED));
> +	printk(KERN_INFO "kvm-vcpustate: cpu %d, msr %lu\n",
> +		cpu, __pa(v_state));
> +}
> +
>  void __cpuinit kvm_guest_cpu_init(void)
>  {
>  	if (!kvm_para_available())
> @@ -310,6 +329,9 @@ void __cpuinit kvm_guest_cpu_init(void)
>  
>  	if (has_steal_clock)
>  		kvm_register_steal_time();
> +
> +	if (has_vcpu_state)
> +		kvm_register_vcpu_state();
>  }
>  
>  static void kvm_pv_disable_apf(void *unused)
> @@ -361,6 +383,14 @@ void kvm_disable_steal_time(void)
>  	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
>  }
>  
> +void kvm_disable_vcpu_state(void)
> +{
> +	if (!has_vcpu_state)
> +		return;
> +
> +	wrmsr(MSR_KVM_VCPU_STATE, 0, 0);
> +}
> +
>  #ifdef CONFIG_SMP
>  static void __init kvm_smp_prepare_boot_cpu(void)
>  {
> @@ -379,6 +409,7 @@ static void __cpuinit kvm_guest_cpu_online(void *dummy)
>  
>  static void kvm_guest_cpu_offline(void *dummy)
>  {
> +	kvm_disable_vcpu_state();
>  	kvm_disable_steal_time();
>  	kvm_pv_disable_apf(NULL);
>  	apf_task_wake_all();
> @@ -433,6 +464,8 @@ void __init kvm_guest_init(void)
>  		pv_time_ops.steal_clock = kvm_steal_clock;
>  	}
>  
> +	has_vcpu_state = 1;
> +

Should be checking for a feature bit, see kvm_para_has_feature() 
examples above in the function.
