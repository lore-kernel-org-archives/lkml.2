Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab0FUN51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:57:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab0FUN5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:57:25 -0400
Date: Mon, 21 Jun 2010 16:56:59 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com
Subject: Re: [PATCH V2 3/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
Message-ID: <20100621135659.GL4689@redhat.com>
References: <1277112703.2096.511.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277112703.2096.511.camel@ymzhang.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 05:31:43PM +0800, Zhang, Yanmin wrote:
> The 3rd patch is to implement para virt perf at host kernel.
> 
> Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> 
> ---
> 
> --- linux-2.6_tip0620/arch/x86/include/asm/kvm_para.h	2010-06-21 15:19:38.992999849 +0800
> +++ linux-2.6_tip0620perfkvm/arch/x86/include/asm/kvm_para.h	2010-06-21 15:21:39.308999849 +0800
> @@ -2,6 +2,7 @@
>  #define _ASM_X86_KVM_PARA_H
>  
>  #include <linux/types.h>
> +#include <linux/list.h>
>  #include <asm/hyperv.h>
>  
>  /* This CPUID returns the signature 'KVMKVMKVM' in ebx, ecx, and edx.  It
> @@ -19,7 +20,8 @@
>  /* This indicates that the new set of kvmclock msrs
>   * are available. The use of 0x11 and 0x12 is deprecated
>   */
> -#define KVM_FEATURE_CLOCKSOURCE2        3
> +#define KVM_FEATURE_CLOCKSOURCE2	3
> +#define KVM_FEATURE_PV_PERF		4
>  
>  /* The last 8 bits are used to indicate how to interpret the flags field
>   * in pvclock structure. If no bits are set, all flags are ignored.
> @@ -33,7 +35,14 @@
>  #define MSR_KVM_WALL_CLOCK_NEW  0x4b564d00
>  #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
>  
> -#define KVM_MAX_MMU_OP_BATCH           32
> +#define KVM_MAX_MMU_OP_BATCH		32
> +
> +/* Operations for KVM_PERF_OP */
> +#define KVM_PERF_OP_OPEN		1
> +#define KVM_PERF_OP_CLOSE		2
> +#define KVM_PERF_OP_ENABLE		3
> +#define KVM_PERF_OP_DISABLE		4
> +#define KVM_PERF_OP_READ		5
>  
>  /* Operations for KVM_HC_MMU_OP */
>  #define KVM_MMU_OP_WRITE_PTE            1
> @@ -64,6 +73,85 @@ struct kvm_mmu_op_release_pt {
>  #ifdef __KERNEL__
>  #include <asm/processor.h>
>  
> +/*
> + * data communication area about perf_event between
> + * Host kernel and guest kernel
> + */
> +struct guest_perf_event {
> +	u64 count;
> +	atomic_t overflows;
> +};
> +
> +/*
> + * In host kernel, perf_event->host_perf_shadow points to
> + * host_perf_shadow which records some information
> + * about the guest.
> + */
> +struct host_perf_shadow {
> +	/* guest perf_event id passed from guest os */
> +	int id;
> +	/*
> +	 * Host kernel saves data into data member counter firstly.
> +	 * kvm will get data from this counter and calls kvm functions
> +	 * to copy or add data back to guets os before entering guest os
> +	 * next time
> +	 */
> +	struct guest_perf_event counter;
> +	/* guest_event_addr is gpa_t pointing to guest os guest_perf_event*/
> +	__u64 guest_event_addr;
> +
> +	/*
> +	 * Link to  of kvm.kvm_arch.shadow_hash_table
> +	 */
> +	struct list_head shadow_entry;
> +	struct kvm_vcpu *vcpu;
> +
> +	struct perf_event *host_event;
> +	/*
> +	 * Below counter is to prevent malicious guest os to try to
> +	 * close/enable event at the same time.
> +	 */
> +	atomic_t ref_counter;
> +};
> +
> +/*
> + * In guest kernel, perf_event->guest_shadow points to
> + * guest_perf_shadow which records some information
> + * about the guest.
> + */
> +struct guest_perf_shadow {
> +	/* guest perf_event id passed from guest os */
> +	int id;
> +	/*
> +	 * Host kernel kvm saves data into data member counter
> +	 */
> +	struct guest_perf_event counter;
> +};
> +
> +/*
> + * guest_perf_attr is used when guest calls hypercall to
> + * open a new perf_event at host side. Mostly, it's a copy of
> + * perf_event_attr and deletes something not used by host kernel.
> + */
> +struct guest_perf_attr {
> +	__u32			type;
> +	__u64			config;
> +	__u64			sample_period;
> +	__u64			sample_type;
> +	__u64			read_format;
> +	__u64			flags;
> +	__u32			bp_type;
> +	__u64			bp_addr;
> +	__u64			bp_len;
> +};
> +
> +struct guest_perf_event_param {
> +	__u64 attr_addr;
> +	__u64 guest_event_addr;
> +	/* In case there is an alignment issue, we put id as the last one */
> +	int id;
> +};
> +
>  extern void kvmclock_init(void);
>  
>  
> --- linux-2.6_tip0620/arch/x86/include/asm/kvm_host.h	2010-06-21 15:19:39.019999849 +0800
> +++ linux-2.6_tip0620perfkvm/arch/x86/include/asm/kvm_host.h	2010-06-21 15:21:39.308999849 +0800
> @@ -24,6 +24,7 @@
>  #include <asm/desc.h>
>  #include <asm/mtrr.h>
>  #include <asm/msr-index.h>
> +#include <asm/perf_event.h>
>  
>  #define KVM_MAX_VCPUS 64
>  #define KVM_MEMORY_SLOTS 32
> @@ -360,6 +361,18 @@ struct kvm_vcpu_arch {
>  
>  	/* fields used by HYPER-V emulation */
>  	u64 hv_vapic;
> +
> +	/*
> +	 * Fields used by PARAVIRT perf interface:
> +	 *
> +	 * kvm checks overflow_events before entering guest os,
> +	 * and copy data back to guest os.
> +	 * event_mutex is to avoid a race between NMI perf event overflow
> +	 * handler, event close, and enable/disable.
> +	 */
> +	struct mutex event_mutex;
> +	int overflows;
> +	struct perf_event *overflow_events[X86_PMC_IDX_MAX];
>  };
>  
>  struct kvm_mem_alias {
> @@ -377,6 +390,9 @@ struct kvm_mem_aliases {
>  	int naliases;
>  };
>  
> +#define KVM_PARAVIRT_PERF_EVENT_ENTRY_BITS	(10)
> +#define KVM_PARAVIRT_PERF_EVENT_ENTRY_NUM	(1<<KVM_PARAVIRT_PERF_EVENT_ENTRY_BITS)
> +
>  struct kvm_arch {
>  	struct kvm_mem_aliases *aliases;
>  
> @@ -415,6 +431,15 @@ struct kvm_arch {
>  	/* fields used by HYPER-V emulation */
>  	u64 hv_guest_os_id;
>  	u64 hv_hypercall;
> +
> +	/*
> +	 * fields used by PARAVIRT perf interface:
> +	 * Used to organize all host perf_events representing guest
> +	 * perf_event on a specific kvm instance
> +	 */
> +	atomic_t kvm_pv_event_num;
> +	spinlock_t shadow_lock;
> +	struct list_head *shadow_hash_table;
>  };
>  
>  struct kvm_vm_stat {
> @@ -561,6 +586,9 @@ int emulator_write_phys(struct kvm_vcpu 
>  			  const void *val, int bytes);
>  int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
>  		  gpa_t addr, unsigned long *ret);
> +int kvm_pv_perf_op(struct kvm_vcpu *vcpu, int op_code, unsigned long a1,
> +		   unsigned long a2, unsigned long *result);
> +
>  u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
>  
>  extern bool tdp_enabled;
> --- linux-2.6_tip0620/include/linux/kvm_para.h	2010-06-21 15:19:53.309999849 +0800
> +++ linux-2.6_tip0620perfkvm/include/linux/kvm_para.h	2010-06-21 15:21:39.312999849 +0800
> @@ -17,6 +17,7 @@
>  
>  #define KVM_HC_VAPIC_POLL_IRQ		1
>  #define KVM_HC_MMU_OP			2
> +#define KVM_PERF_OP			3
>  
>  /*
>   * hypercalls use architecture specific
> --- linux-2.6_tip0620/arch/x86/kvm/vmx.c	2010-06-21 15:19:39.322999849 +0800
> +++ linux-2.6_tip0620perfkvm/arch/x86/kvm/vmx.c	2010-06-21 15:21:39.310999849 +0800
> @@ -3647,6 +3647,7 @@ static int vmx_handle_exit(struct kvm_vc
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	u32 exit_reason = vmx->exit_reason;
>  	u32 vectoring_info = vmx->idt_vectoring_info;
> +	int ret;
>  
>  	trace_kvm_exit(exit_reason, vcpu);
>  
> @@ -3694,12 +3695,17 @@ static int vmx_handle_exit(struct kvm_vc
>  
>  	if (exit_reason < kvm_vmx_max_exit_handlers
>  	    && kvm_vmx_exit_handlers[exit_reason])
> -		return kvm_vmx_exit_handlers[exit_reason](vcpu);
> +		ret = kvm_vmx_exit_handlers[exit_reason](vcpu);
>  	else {
>  		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
>  		vcpu->run->hw.hardware_exit_reason = exit_reason;
> +		ret = 0;
>  	}
> -	return 0;
> +
> +	/* sync paravirt perf event to guest */
> +	kvm_sync_events_to_guest(vcpu);
> +
> +	return ret;
>  }
>  
>  static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
> --- linux-2.6_tip0620/arch/x86/kvm/x86.c	2010-06-21 15:19:39.315999849 +0800
> +++ linux-2.6_tip0620perfkvm/arch/x86/kvm/x86.c	2010-06-21 16:49:58.182999849 +0800
> @@ -6,12 +6,14 @@
>   * Copyright (C) 2006 Qumranet, Inc.
>   * Copyright (C) 2008 Qumranet, Inc.
>   * Copyright IBM Corporation, 2008
> + * Copyright Intel Corporation, 2010
>   *
>   * Authors:
>   *   Avi Kivity   <avi@qumranet.com>
>   *   Yaniv Kamay  <yaniv@qumranet.com>
>   *   Amit Shah    <amit.shah@qumranet.com>
>   *   Ben-Ami Yassour <benami@il.ibm.com>
> + *   Yanmin Zhang <yanmin.zhang@intel.com>
>   *
>   * This work is licensed under the terms of the GNU GPL, version 2.  See
>   * the COPYING file in the top-level directory.
> @@ -1618,6 +1620,7 @@ int kvm_dev_ioctl_check_extension(long e
>  	case KVM_CAP_PCI_SEGMENT:
>  	case KVM_CAP_DEBUGREGS:
>  	case KVM_CAP_X86_ROBUST_SINGLESTEP:
> +	case KVM_CAP_PV_PERF:
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> @@ -1993,7 +1996,9 @@ static void do_cpuid_ent(struct kvm_cpui
>  		entry->eax = (1 << KVM_FEATURE_CLOCKSOURCE) |
>  			     (1 << KVM_FEATURE_NOP_IO_DELAY) |
>  			     (1 << KVM_FEATURE_CLOCKSOURCE2) |
> +			     (1 << KVM_FEATURE_PV_PERF) |
>  			     (1 << KVM_FEATURE_CLOCKSOURCE_STABLE_BIT);
> +
>  		entry->ebx = 0;
>  		entry->ecx = 0;
>  		entry->edx = 0;
> @@ -4052,10 +4057,21 @@ static unsigned long kvm_get_guest_ip(vo
>  	return ip;
>  }
>  
> +int kvm_notify_event_overflow(void)
> +{
> +	if (percpu_read(current_vcpu)) {
> +		kvm_inject_nmi(percpu_read(current_vcpu));
> +		return 0;
> +	}
> +
> +	return -1;
> +}
> +
>  static struct perf_guest_info_callbacks kvm_guest_cbs = {
>  	.is_in_guest		= kvm_is_in_guest,
>  	.is_user_mode		= kvm_is_user_mode,
>  	.get_guest_ip		= kvm_get_guest_ip,
> +	.copy_event_to_shadow	= kvm_copy_event_to_shadow,
>  };
>  
>  void kvm_before_handle_nmi(struct kvm_vcpu *vcpu)
> @@ -4138,15 +4154,6 @@ int kvm_emulate_halt(struct kvm_vcpu *vc
>  }
>  EXPORT_SYMBOL_GPL(kvm_emulate_halt);
>  
> -static inline gpa_t hc_gpa(struct kvm_vcpu *vcpu, unsigned long a0,
> -			   unsigned long a1)
> -{
> -	if (is_long_mode(vcpu))
> -		return a0;
> -	else
> -		return a0 | ((gpa_t)a1 << 32);
> -}
> -
>  int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  {
>  	u64 param, ingpa, outgpa, ret;
> @@ -4245,6 +4252,9 @@ int kvm_emulate_hypercall(struct kvm_vcp
>  	case KVM_HC_MMU_OP:
>  		r = kvm_pv_mmu_op(vcpu, a0, hc_gpa(vcpu, a1, a2), &ret);
>  		break;
> +	case KVM_PERF_OP:
> +		r = kvm_pv_perf_op(vcpu, a0, a1, a2, &ret);
> +		break;
>  	default:
>  		ret = -KVM_ENOSYS;
>  		break;
> @@ -5334,6 +5344,8 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *
>  	}
>  	vcpu->arch.mcg_cap = KVM_MAX_MCE_BANKS;
>  
> +	mutex_init(&vcpu->arch.event_mutex);
> +
>  	return 0;
>  fail_free_lapic:
>  	kvm_free_lapic(vcpu);
> @@ -5360,6 +5372,8 @@ void kvm_arch_vcpu_uninit(struct kvm_vcp
>  struct  kvm *kvm_arch_create_vm(void)
>  {
>  	struct kvm *kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
> +	struct list_head *hash_table;
> +	int i;
>  
>  	if (!kvm)
>  		return ERR_PTR(-ENOMEM);
> @@ -5369,6 +5383,18 @@ struct  kvm *kvm_arch_create_vm(void)
>  		kfree(kvm);
>  		return ERR_PTR(-ENOMEM);
>  	}
> +	hash_table = kmalloc(sizeof(struct list_head) *
> +			KVM_PARAVIRT_PERF_EVENT_ENTRY_NUM,
> +			GFP_KERNEL);
> +	if (!hash_table) {
> +		kfree(kvm->arch.aliases);
> +		kfree(kvm);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	for (i = 0; i < KVM_PARAVIRT_PERF_EVENT_ENTRY_NUM; i++)
> +		INIT_LIST_HEAD(&hash_table[i]);
> +	kvm->arch.shadow_hash_table = hash_table;
> +	spin_lock_init(&kvm->arch.shadow_lock);
>  
>  	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
>  	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
> @@ -5416,6 +5442,8 @@ void kvm_arch_sync_events(struct kvm *kv
>  
>  void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
> +	kvm_remove_all_perf_events(kvm);
> +
>  	kvm_iommu_unmap_guest(kvm);
>  	kvm_free_pit(kvm);
>  	kfree(kvm->arch.vpic);
> @@ -5427,6 +5455,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm
>  	if (kvm->arch.ept_identity_pagetable)
>  		put_page(kvm->arch.ept_identity_pagetable);
>  	cleanup_srcu_struct(&kvm->srcu);
> +	kfree(kvm->arch.shadow_hash_table);
>  	kfree(kvm->arch.aliases);
>  	kfree(kvm);
>  }
> --- linux-2.6_tip0620/arch/x86/kvm/x86.h	2010-06-21 15:19:39.311999849 +0800
> +++ linux-2.6_tip0620perfkvm/arch/x86/kvm/x86.h	2010-06-21 15:21:39.312999849 +0800
> @@ -72,7 +72,20 @@ static inline struct kvm_mem_aliases *kv
>  			|| lockdep_is_held(&kvm->slots_lock));
>  }
>  
> +static inline gpa_t hc_gpa(struct kvm_vcpu *vcpu, unsigned long a0,
> +			   unsigned long a1)
> +{
> +	if (is_long_mode(vcpu))
> +		return a0;
> +	else
> +		return a0 | ((gpa_t)a1 << 32);
> +}
> +
>  void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
>  void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
> +int kvm_notify_event_overflow(void);
> +void kvm_copy_event_to_shadow(struct perf_event *event, int overflows);
> +void kvm_sync_events_to_guest(struct kvm_vcpu *vcpu);
> +void kvm_remove_all_perf_events(struct kvm *kvm);
>  
>  #endif
> --- linux-2.6_tip0620/arch/x86/kvm/Makefile	2010-06-21 15:19:39.311999849 +0800
> +++ linux-2.6_tip0620perfkvm/arch/x86/kvm/Makefile	2010-06-21 15:21:39.310999849 +0800
> @@ -11,7 +11,7 @@ kvm-y			+= $(addprefix ../../../virt/kvm
>  kvm-$(CONFIG_IOMMU_API)	+= $(addprefix ../../../virt/kvm/, iommu.o)
>  
>  kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
> -			   i8254.o timer.o
> +			   i8254.o timer.o kvmperf_event.o
>  kvm-intel-y		+= vmx.o
>  kvm-amd-y		+= svm.o
>  
> --- linux-2.6_tip0620/arch/x86/kvm/kvmperf_event.c	1970-01-01 08:00:00.000000000 +0800
> +++ linux-2.6_tip0620perfkvm/arch/x86/kvm/kvmperf_event.c	2010-06-21 16:49:29.509999849 +0800
> @@ -0,0 +1,471 @@
> +/*
> + * Performance events x86 kvm para architecture code
> + *
> + * Copyright (C) 2010 Intel Inc.
> + *     Zhang Yanmin <yanmin.zhang@intel.com>
> + *
> + *  For licencing details see kernel-base/COPYING
> + */
> +
> +#include <linux/perf_event.h>
> +#include <linux/capability.h>
> +#include <linux/notifier.h>
> +#include <linux/hardirq.h>
> +#include <linux/kprobes.h>
> +#include <linux/module.h>
> +#include <linux/kdebug.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> +#include <linux/slab.h>
> +#include <linux/highmem.h>
> +#include <linux/cpu.h>
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <linux/file.h>
> +#include <linux/syscalls.h>
> +#include <linux/init.h>
> +#include <linux/hash.h>
> +
> +#include <asm/apic.h>
> +#include <asm/stacktrace.h>
> +#include <asm/nmi.h>
> +#include <asm/compat.h>
> +
> +#include "x86.h"
> +
> +#define KVM_MAX_PARAVIRT_PERF_EVENT		(1024)
> +
> +static inline u32 shadow_hash_id(int id)
> +{
> +	u32 hash_value = id;
> +
> +	hash_value = hash_32(hash_value, KVM_PARAVIRT_PERF_EVENT_ENTRY_BITS);
> +	return hash_value;
> +}
> +
> +static int kvm_add_host_event(struct kvm_vcpu *vcpu,
> +		struct host_perf_shadow *host_shadow)
> +{
> +	long unsigned flags;
> +	u32 index = shadow_hash_id(host_shadow->id);
> +	struct kvm_arch *arch = &vcpu->kvm->arch;
> +	struct list_head *head = &arch->shadow_hash_table[index];
> +	struct list_head *pos;
> +	struct host_perf_shadow *tmp;
> +
> +	spin_lock_irqsave(&arch->shadow_lock, flags);
> +	list_for_each(pos, head) {
> +		tmp = container_of(pos, struct host_perf_shadow, shadow_entry);
> +		WARN(tmp->id == host_shadow->id, "%s called when there is an"
> +			" item with the same id [%d] in hash table,",
> +			__func__, host_shadow->id);
> +	}
> +	list_add(&host_shadow->shadow_entry, head);
> +	spin_unlock_irqrestore(&arch->shadow_lock, flags);
> +	return 0;
> +}
> +
> +static struct perf_event *
> +kvm_find_get_host_event(struct kvm_vcpu *vcpu, int id, int need_delete)
> +{
> +	long unsigned flags;
> +	u32 index = shadow_hash_id(id);
> +	struct kvm_arch *arch = &vcpu->kvm->arch;
> +	struct list_head *head = &arch->shadow_hash_table[index];
> +	struct list_head *pos;
> +	struct host_perf_shadow *tmp = NULL;
> +	int found = 0;
> +
> +	spin_lock_irqsave(&arch->shadow_lock, flags);
> +	list_for_each(pos, head) {
> +		tmp = container_of(pos, struct host_perf_shadow, shadow_entry);
> +		if (tmp->id == id) {
> +			found = 1;
> +			if (need_delete)
> +				list_del_init(&tmp->shadow_entry);
> +			else
> +				atomic_inc(&tmp->ref_counter);
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&arch->shadow_lock, flags);
> +
> +	if (found)
> +		return tmp->host_event;
> +	else
> +		return NULL;
> +}
> +
> +static void kvm_vcpu_add_event_overflow_ref(struct perf_event *event)
> +{
> +	struct host_perf_shadow *host_shadow = event->host_perf_shadow;
> +	struct kvm_vcpu *vcpu = host_shadow->vcpu;
> +	int ret;
> +
> +	/*
> +	 * Use trylock as it's in NMI handler. We don't care
> +	 * too much to lose reporting once of one event to guets os,
> +	 * because host saves overflows counter in host_perf_shadow.
> +	 * Next time when a new overflow of the event happens and if
> +	 * there is no contention, host could push overflows to guest
> +	 * and guest could process also saved overflows.
> +	 */
> +	ret = mutex_trylock(&vcpu->arch.event_mutex);
> +	if (!ret)
> +		return;
> +	if (vcpu->arch.overflows < X86_PMC_IDX_MAX) {
> +		vcpu->arch.overflow_events[vcpu->arch.overflows] = event;
> +		vcpu->arch.overflows++;
> +	}
> +	mutex_unlock(&vcpu->arch.event_mutex);
> +}
> +
> +static int kvm_vcpu_remove_event_overflow_ref(struct host_perf_shadow *shadow)
> +{
> +	struct kvm_vcpu *vcpu = shadow->vcpu;
> +	int i;
> +
> +	if (!vcpu || !vcpu->arch.overflows)
> +		return -1;
> +
> +	mutex_lock(&vcpu->arch.event_mutex);
> +	for (i = 0; i < vcpu->arch.overflows; i++) {
> +		if (vcpu->arch.overflow_events[i] == shadow->host_event)
> +			vcpu->arch.overflow_events[i] = NULL;
> +	}
> +	mutex_unlock(&vcpu->arch.event_mutex);
> +	return 0;
> +}
> +
> +void kvm_copy_event_to_shadow(struct perf_event *event, int overflows)
> +{
> +	struct host_perf_shadow *shadow = event->host_perf_shadow;
> +
> +	shadow->counter.count = local64_read(&event->count);
> +	atomic_add(overflows, &shadow->counter.overflows);
> +	kvm_vcpu_add_event_overflow_ref(event);
> +	/* Inject NMI to guest os */
> +	kvm_notify_event_overflow();
> +}
> +
> +static void kvm_perf_event_overflow(struct perf_event *event, int nmi,
> +		struct perf_sample_data *data, struct pt_regs *regs)
> +{
> +	BUG_ON(event->host_perf_shadow == NULL);
> +	kvm_copy_event_to_shadow(event, 1);
> +}
> +
> +static void kvm_put_host_event(struct perf_event *host_event)
> +{
> +	struct host_perf_shadow *shadow = host_event->host_perf_shadow;
> +	if (!atomic_dec_return(&shadow->ref_counter)) {
> +		/*
> +		 * detach it in case guest os doesn't disables it
> +		 * before closing
> +		 */
> +		perf_event_detach(host_event);
> +		kvm_vcpu_remove_event_overflow_ref(shadow);
> +
> +		perf_event_release_kernel(host_event);
> +		kfree(shadow);
> +		atomic_dec(&shadow->vcpu->kvm->arch.kvm_pv_event_num);
> +	}
> +}
> +
> +static void kvm_copy_event_to_guest(struct kvm_vcpu *vcpu,
> +			struct perf_event *host_event)
> +{
> +	struct host_perf_shadow *shadow = host_event->host_perf_shadow;
> +	struct guest_perf_event counter;
> +	int ret;
> +	s32 overflows;
> +
> +	ret = kvm_read_guest(vcpu->kvm, shadow->guest_event_addr,
> +				&counter, sizeof(counter));
> +	if (ret < 0)
> +		return;
> +
> +again:
> +	overflows = atomic_read(&shadow->counter.overflows);
> +	if (atomic_cmpxchg(&shadow->counter.overflows, overflows, 0) !=
> +			overflows)
> +		goto again;
> +
> +	counter.count = shadow->counter.count;
> +	atomic_add(overflows, &counter.overflows);
> +
> +	kvm_write_guest(vcpu->kvm,
> +			shadow->guest_event_addr,
> +			&counter,
> +			sizeof(counter));
Those kind of interfaces worry me since the can cause bugs that are
very hard to catch.  What if guest enables some events and crashes into
kdump kernel (or kexec new kernel) without reseting HW. Now host may
write over guest memory without guest expecting it. Do you handle this
scenario in a guest side? I think you need to register reboot notify
and disable events from there.

> +	return;
> +}
> +
> +/*
> + * called by KVM to copy both perf_event->count and overflows to guest
> + * after host NMI handler detects guest perf_event overflows
> + */
> +void kvm_sync_events_to_guest(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +
> +	if (vcpu->arch.overflows == 0)
> +		return;
> +
> +	mutex_lock(&vcpu->arch.event_mutex);
> +	for (i = 0; i < vcpu->arch.overflows; i++) {
> +		if (vcpu->arch.overflow_events[i]) {
> +			kvm_copy_event_to_guest(vcpu,
> +				vcpu->arch.overflow_events[i]);
> +		}
> +	}
> +	vcpu->arch.overflows = 0;
> +	mutex_unlock(&vcpu->arch.event_mutex);
> +}
> +EXPORT_SYMBOL_GPL(kvm_sync_events_to_guest);
> +
> +/* Just copy perf_event->count to guest. Don't copy overflows to guest */
> +static void
> +kvm_copy_count_to_guest(struct kvm_vcpu *vcpu, struct perf_event *host_event)
> +{
> +	struct host_perf_shadow *shadow = host_event->host_perf_shadow;
> +
> +	shadow->counter.count = local64_read(&host_event->count);
> +	kvm_write_guest(vcpu->kvm,
> +			shadow->guest_event_addr,
> +			&shadow->counter.count,
> +			sizeof(shadow->counter.count));
> +	return;
> +}
> +
> +static int
> +kvm_pv_perf_op_open(struct kvm_vcpu *vcpu, gpa_t addr)
> +{
> +	int ret = 0;
> +	struct perf_event *host_event = NULL;
> +	struct host_perf_shadow *shadow = NULL;
> +	struct guest_perf_event_param param;
> +	struct guest_perf_attr *guest_attr = NULL;
> +	struct perf_event_attr *attr = NULL;
> +	int next_count;
> +
> +	next_count = atomic_read(&vcpu->kvm->arch.kvm_pv_event_num);
> +	if (next_count >= KVM_MAX_PARAVIRT_PERF_EVENT) {
> +		WARN_ONCE(1, "guest os wants to open more than %d events\n",
> +			KVM_MAX_PARAVIRT_PERF_EVENT);
> +		return -ENOENT;
> +	}
> +	atomic_inc(&vcpu->kvm->arch.kvm_pv_event_num);
> +
> +	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
> +	if (!attr) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	guest_attr = kzalloc(sizeof(*guest_attr), GFP_KERNEL);
> +	if (!attr) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	ret = kvm_read_guest(vcpu->kvm, addr, &param, sizeof(param));
> +	if (ret < 0)
> +		goto out;
> +
> +	host_event = kvm_find_get_host_event(vcpu, param.id, 0);
> +	if (host_event) {
> +		kvm_put_host_event(host_event);
> +		return -EEXIST;
> +	}
> +
> +	ret = kvm_read_guest(vcpu->kvm, param.attr_addr,
> +			     guest_attr, sizeof(*guest_attr));
> +	if (ret < 0)
> +		goto out;
> +
> +	attr->type = guest_attr->type;
> +	attr->config = guest_attr->config;
> +	attr->sample_period = guest_attr->sample_period;
> +	attr->read_format = guest_attr->read_format;
> +	attr->flags = guest_attr->flags;
> +	attr->bp_type = guest_attr->bp_type;
> +	attr->bp_addr = guest_attr->bp_addr;
> +	attr->bp_len = guest_attr->bp_len;
> +	/*
> +	 * By default, we disable the host event. Later on, guets os
> +	 * triggers a perf_event_attach to enable it
> +	 */
> +	attr->disabled = 1;
> +	attr->inherit = 0;
> +	attr->enable_on_exec = 0;
> +	/*
> +	 * We don't support exclude mode of user and kernel for guest os,
> +	 * which mean we always collect both user and kernel for guest os
> +	 */
> +	attr->exclude_user = 0;
> +	attr->exclude_kernel = 0;
> +
> +	shadow = kzalloc(sizeof(*shadow), GFP_KERNEL);
> +	if (!shadow) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	shadow->id = param.id;
> +	shadow->guest_event_addr = param.guest_event_addr;
> +	shadow->vcpu = vcpu;
> +	INIT_LIST_HEAD(&shadow->shadow_entry);
> +
> +	/* We always create a cpu context host perf event */
> +	host_event = perf_event_create_kernel_counter(attr, -1,
> +				current->pid, kvm_perf_event_overflow);
> +
> +	if (IS_ERR(host_event)) {
> +		host_event = NULL;
> +		ret = -1;
> +		goto out;
> +	}
> +	host_event->host_perf_shadow = shadow;
> +	shadow->host_event = host_event;
> +	atomic_set(&shadow->ref_counter, 1);
> +	kvm_add_host_event(vcpu, shadow);
> +
> +out:
> +	if (!host_event)
> +		kfree(shadow);
> +
> +	kfree(attr);
> +	kfree(guest_attr);
> +
> +	if (ret)
> +		atomic_dec(&vcpu->kvm->arch.kvm_pv_event_num);
> +
> +	return ret;
> +}
> +
> +static int kvm_pv_perf_op_close(struct kvm_vcpu *vcpu, int id)
> +{
> +	struct perf_event *host_event;
> +
> +	/* Find and delete the event from the hashtable */
> +	host_event = kvm_find_get_host_event(vcpu, id, 1);
> +	if (!host_event)
> +		return -1;
> +	kvm_put_host_event(host_event);
> +	return 0;
> +}
> +
> +static int kvm_pv_perf_op_enable(struct kvm_vcpu *vcpu, int id)
> +{
> +	struct perf_event *event;
> +	struct host_perf_shadow *shadow;
> +
> +	event = kvm_find_get_host_event(vcpu, id, 0);
> +	if (!event)
> +		return -1;
> +
> +	shadow = event->host_perf_shadow;
> +	if (shadow->vcpu != vcpu) {
> +		kvm_vcpu_remove_event_overflow_ref(event->host_perf_shadow);
> +		shadow->vcpu = vcpu;
> +	}
> +
> +	perf_event_attach(event);
> +	kvm_put_host_event(event);
> +
> +	return 0;
> +}
> +
> +static int kvm_pv_perf_op_disable(struct kvm_vcpu *vcpu, int id)
> +{
> +	struct perf_event *host_event = kvm_find_get_host_event(vcpu, id, 0);
> +	if (!host_event)
> +		return -1;
> +	perf_event_detach(host_event);
> +	/* We sync count to guest as we delay the guest count update */
> +	kvm_copy_count_to_guest(vcpu, host_event);
> +	kvm_put_host_event(host_event);
> +
> +	return 0;
> +}
> +
> +static int kvm_pv_perf_op_read(struct kvm_vcpu *vcpu, int id)
> +{
> +	u64 enabled, running;
> +	struct perf_event *host_event = kvm_find_get_host_event(vcpu, id, 0);
> +
> +	if (!host_event)
> +		return -1;
> +	if (host_event->state == PERF_EVENT_STATE_ACTIVE)
> +		perf_event_read_value(host_event, &enabled, &running);
> +	kvm_copy_count_to_guest(vcpu, host_event);
> +	kvm_put_host_event(host_event);
> +	return 0;
> +}
> +
> +int kvm_pv_perf_op(struct kvm_vcpu *vcpu, int op_code, unsigned long a1,
> +		unsigned long a2, unsigned long *result)
> +{
> +	unsigned long ret;
> +	gpa_t addr;
> +	int id;
> +
> +	switch (op_code) {
> +	case KVM_PERF_OP_OPEN:
> +		addr = hc_gpa(vcpu, a1, a2);
> +		ret = (unsigned long) kvm_pv_perf_op_open(vcpu, addr);
> +		break;
> +	case KVM_PERF_OP_CLOSE:
> +		id = (int) a1;
> +		ret = kvm_pv_perf_op_close(vcpu, id);
> +		break;
> +	case KVM_PERF_OP_ENABLE:
> +		id = (int) a1;
> +		ret = kvm_pv_perf_op_enable(vcpu, id);
> +		break;
> +	case KVM_PERF_OP_DISABLE:
> +		id = (int) a1;
> +		ret = kvm_pv_perf_op_disable(vcpu, id);
> +		break;
> +	case KVM_PERF_OP_READ:
> +		id = (int) a1;
> +		ret = kvm_pv_perf_op_read(vcpu, id);
> +		break;
> +	default:
> +		ret = -KVM_ENOSYS;
> +	}
> +
> +	*result = ret;
> +	return 0;
> +}
> +
> +void kvm_remove_all_perf_events(struct kvm *kvm)
> +{
> +	long unsigned flags;
> +	struct kvm_arch *arch = &kvm->arch;
> +	LIST_HEAD(total_events);
> +	struct list_head *head;
> +	struct list_head *pos, *next;
> +	struct host_perf_shadow *tmp;
> +	int i;
> +
> +	spin_lock_irqsave(&arch->shadow_lock, flags);
> +	for (i = 0; i < KVM_PARAVIRT_PERF_EVENT_ENTRY_NUM; i++) {
> +		head = &arch->shadow_hash_table[i];
> +		list_for_each_safe(pos, next, head) {
> +			tmp = container_of(pos, struct host_perf_shadow,
> +					shadow_entry);
> +			list_del(&tmp->shadow_entry);
> +			list_add(&tmp->shadow_entry, &total_events);
> +		}
> +	}
> +	spin_unlock_irqrestore(&arch->shadow_lock, flags);
> +	head = &total_events;
> +	list_for_each_safe(pos, next, head) {
> +		tmp = container_of(pos, struct host_perf_shadow, shadow_entry);
> +		list_del(&tmp->shadow_entry);
> +		kvm_put_host_event(tmp->host_event);
> +	}
> +
> +	return;
> +}
> +
> --- linux-2.6_tip0620/include/linux/kvm.h	2010-06-21 15:19:52.605999849 +0800
> +++ linux-2.6_tip0620perfkvm/include/linux/kvm.h	2010-06-21 15:21:39.312999849 +0800
> @@ -524,6 +524,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_PPC_OSI 52
>  #define KVM_CAP_PPC_UNSET_IRQ 53
>  #define KVM_CAP_ENABLE_CAP 54
> +#define KVM_CAP_PV_PERF 57
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> 

--
			Gleb.
