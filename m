Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0F3KHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 06:07:45 -0400
Received: from claw.goop.org ([74.207.240.146]:57742 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab0F3KHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 06:07:42 -0400
Message-ID: <4C2B1769.5090107@goop.org>
Date: Wed, 30 Jun 2010 12:07:37 +0200
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>, ksrinivasan <ksrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 2/4, v2] x86: enlightenment for ticket spin locks - Xen
  implementation
References: <4C2A200F02000078000089E4@vpn.id2.novell.com>
In-Reply-To: <4C2A200F02000078000089E4@vpn.id2.novell.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 04:32 PM, Jan Beulich wrote:
> Use the (alternative instructions based) callout hooks to the ticket
> spinlock code to enlighten ticket locks when running fully virtualized
> on Xen. Ultimately, this code might also be a candidate to be used
> when running para-virtualized.
>   

I'm not sure what the gain is by making this independent of all the rest
of the Xen support in the kernel.  Stefano is working on a series
(posted a few times now) to add more paravirtual features for Xen HVM
guests, and this work is conceptually very similar.

Also, I'm not very keen on adding yet another kind of patching mechanism
to the kernel.  While they're easy enough to get working in the first
place, they do tend to be fragile when other changes get introduced
(like changes to how the kernel is mapped RO/NX, etc), and this one will
be exercised relatively rarely.  I don't see why the pvops mechanism
couldn't be reused, especially now that each set of ops can be
individually configured on/off.

This is especially acute in the case where you are using a full
pvops-using PV kernel, where it ends up using two mechanisms to put
paravirtualizations in place.

> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Cc: KY Srinivasan <ksrinivasan@novell.com>
>
> ---
>  arch/x86/include/asm/hypervisor.h     |    1 
>  arch/x86/include/asm/spinlock_types.h |   17 +-
>  arch/x86/include/asm/xen/cpuid.h      |   68 ++++++++
>  arch/x86/kernel/cpu/Makefile          |    2 
>  arch/x86/kernel/cpu/hypervisor.c      |    1 
>  arch/x86/kernel/cpu/xen.c             |  269 ++++++++++++++++++++++++++++++++++
>  6 files changed, 355 insertions(+), 3 deletions(-)
>
> --- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/include/asm/hypervisor.h
> +++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/hypervisor.h
> @@ -45,5 +45,6 @@ extern const struct hypervisor_x86 *x86_
>  /* Recognized hypervisors */
>  extern const struct hypervisor_x86 x86_hyper_vmware;
>  extern const struct hypervisor_x86 x86_hyper_ms_hyperv;
> +extern const struct hypervisor_x86 x86_hyper_xen;
>  
>  #endif
> --- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/include/asm/spinlock_types.h
> +++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/spinlock_types.h
> @@ -5,11 +5,24 @@
>  # error "please don't include this file directly"
>  #endif
>  
> +#include <asm/types.h>
> +
>  typedef struct arch_spinlock {
> -	unsigned int slock;
> +	union {
> +		unsigned int slock;
> +#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
> +		struct {
> +# if CONFIG_NR_CPUS < 256
> +			u8 cur, seq;
> +# else
> +			u16 cur, seq;
> +# endif
> +		};
> +#endif
> +	};
>  } arch_spinlock_t;
>  
> -#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
> +#define __ARCH_SPIN_LOCK_UNLOCKED	{ { 0 } }
>  
>  typedef struct {
>  	unsigned int lock;
> --- /dev/null
> +++ 2.6.35-rc3-virt-spinlocks/arch/x86/include/asm/xen/cpuid.h
> @@ -0,0 +1,68 @@
> +/******************************************************************************
> + * arch-x86/cpuid.h
> + *
> + * CPUID interface to Xen.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a copy
> + * of this software and associated documentation files (the "Software"), to
> + * deal in the Software without restriction, including without limitation the
> + * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
> + * sell copies of the Software, and to permit persons to whom the Software is
> + * furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> + * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
> + * DEALINGS IN THE SOFTWARE.
> + *
> + * Copyright (c) 2007 Citrix Systems, Inc.
> + *
> + * Authors:
> + *    Keir Fraser <keir.fraser@citrix.com>
> + */
> +
> +#ifndef __XEN_PUBLIC_ARCH_X86_CPUID_H__
> +#define __XEN_PUBLIC_ARCH_X86_CPUID_H__
> +
> +/* Xen identification leaves start at 0x40000000. */
> +#define XEN_CPUID_FIRST_LEAF 0x40000000
> +#define XEN_CPUID_LEAF(i)    (XEN_CPUID_FIRST_LEAF + (i))
> +
> +/*
> + * Leaf 1 (0x40000000)
> + * EAX: Largest Xen-information leaf. All leaves up to an including @EAX
> + *      are supported by the Xen host.
> + * EBX-EDX: "XenVMMXenVMM" signature, allowing positive identification
> + *      of a Xen host.
> + */
> +#define XEN_CPUID_SIGNATURE_EBX 0x566e6558 /* "XenV" */
> +#define XEN_CPUID_SIGNATURE_ECX 0x65584d4d /* "MMXe" */
> +#define XEN_CPUID_SIGNATURE_EDX 0x4d4d566e /* "nVMM" */
> +
> +/*
> + * Leaf 2 (0x40000001)
> + * EAX[31:16]: Xen major version.
> + * EAX[15: 0]: Xen minor version.
> + * EBX-EDX: Reserved (currently all zeroes).
> + */
> +
> +/*
> + * Leaf 3 (0x40000002)
> + * EAX: Number of hypercall transfer pages. This register is always guaranteed
> + *      to specify one hypercall page.
> + * EBX: Base address of Xen-specific MSRs.
> + * ECX: Features 1. Unused bits are set to zero.
> + * EDX: Features 2. Unused bits are set to zero.
> + */
> +
> +/* Does the host support MMU_PT_UPDATE_PRESERVE_AD for this guest? */
> +#define _XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD 0
> +#define XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD  (1u<<0)
> +
> +#endif /* __XEN_PUBLIC_ARCH_X86_CPUID_H__ */
> --- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/kernel/cpu/Makefile
> +++ 2.6.35-rc3-virt-spinlocks/arch/x86/kernel/cpu/Makefile
> @@ -14,7 +14,7 @@ CFLAGS_common.o		:= $(nostackp)
>  
>  obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
>  obj-y			+= proc.o capflags.o powerflags.o common.o
> -obj-y			+= vmware.o hypervisor.o sched.o mshyperv.o
> +obj-y			+= vmware.o xen.o hypervisor.o sched.o mshyperv.o
>  
>  obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
>  obj-$(CONFIG_X86_64)	+= bugs_64.o
> --- 2.6.35-rc3-virt-spinlocks.orig/arch/x86/kernel/cpu/hypervisor.c
> +++ 2.6.35-rc3-virt-spinlocks/arch/x86/kernel/cpu/hypervisor.c
> @@ -43,6 +43,7 @@ static const __initconst struct hypervis
>  {
>  	&x86_hyper_vmware,
>  	&x86_hyper_ms_hyperv,
> +	&x86_hyper_xen,
>  };
>  
>  const struct hypervisor_x86 *x86_hyper;
> --- /dev/null
> +++ 2.6.35-rc3-virt-spinlocks/arch/x86/kernel/cpu/xen.c
> @@ -0,0 +1,269 @@
> +#define __XEN_INTERFACE_VERSION__ 0x00030207
> +#include <linux/bootmem.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/percpu.h>
> +#include <linux/slab.h>
> +#include <linux/smp.h>
> +#include <linux/spinlock.h>
> +#include <linux/stringify.h>
> +#include <asm/sync_bitops.h>
> +#include <asm/hypervisor.h>
> +#include <asm/xen/cpuid.h>
> +#include <asm/xen/hypercall.h>
> +#include <xen/interface/event_channel.h>
> +#include <xen/interface/memory.h>
> +#include <xen/interface/vcpu.h>
> +
> +#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
> +struct spinning {
> +	struct arch_spinlock *lock;
> +	unsigned int ticket;
> +	struct spinning *prev;
> +};
> +
> +static struct shared_info *__read_mostly xen_shared_info;
> +EXPORT_SYMBOL_GPL(xen_shared_info);
> +
> +static DEFINE_PER_CPU(struct vcpu_runstate_info, runstate);
> +static DEFINE_PER_CPU(evtchn_port_t, poll_evtchn);
> +static DEFINE_PER_CPU(struct spinning *, _spinning);
> +/*
> + * Protect removal of objects: Insertion can be done lockless, and even
> + * removal itself doesn't need protection - what needs to be prevented is
> + * removed objects going out of scope (as they're living on the stack).
> + */
> +static DEFINE_PER_CPU(arch_rwlock_t, spinning_rm_lock) = __ARCH_RW_LOCK_UNLOCKED;
> +
> +static unsigned int __read_mostly spin_count = 1000;
> +static int __init setup_spin_count(char *s)
> +{
> +	if (!s)
> +		return -EINVAL;
> +	spin_count = simple_strtoul(s, &s, 0);
> +	return !*s ? 0 : -EINVAL;
> +}
> +early_param("spin_count", setup_spin_count);
> +
> +#ifndef CONFIG_XEN
> +__asm__(".pushsection .text, \"ax\", @progbits\n"
> +	".p2align " __stringify(PAGE_SHIFT) "\n"
> +	"hypercall_page:\n"
> +	".skip 1 << " __stringify(PAGE_SHIFT) "\n"
> +	".popsection");
> +#endif
> +
> +static void xen_set_cpu_features(struct cpuinfo_x86 *);
> +
> +static void xen_spin_lock(struct arch_spinlock *lock, unsigned int token)
> +{
> +	arch_rwlock_t *rm_lock;
> +	unsigned long flags;
> +	unsigned int count;
> +	struct spinning spinning;
> +
> +	if (unlikely(percpu_read(runstate.state) != RUNSTATE_running))
> +		xen_set_cpu_features(&__get_cpu_var(cpu_info));
> +
> +#if TICKET_SHIFT == 8
> +	token >>= TICKET_SHIFT;
> +#endif
> +	spinning.ticket = token;
> +	spinning.lock = lock;
> +	spinning.prev = percpu_read(_spinning);
> +	smp_wmb();
> +	percpu_write(_spinning, &spinning);
> +
> +	sync_clear_bit(percpu_read(poll_evtchn),
> +		       xen_shared_info->evtchn_pending);
> +
> +	for (count = spin_count; ({ barrier(); lock->cur != token; }); )
> +		if (likely(cpu_online(raw_smp_processor_id()))
> +		    && unlikely(!--count)) {
> +			struct sched_poll sched_poll;
> +
> +			set_xen_guest_handle(sched_poll.ports,
> +					     &__get_cpu_var(poll_evtchn));
> +			sched_poll.nr_ports = 1;
> +			sched_poll.timeout = 0;
> +			HYPERVISOR_sched_op(SCHEDOP_poll, &sched_poll);
> +			count = spin_count;
> +		} else
> +			cpu_relax();
> +
> +	/*
> +	 * If we interrupted another spinlock while it was blocking, make
> +	 * sure it doesn't block (again) without re-checking the lock.
> +	 */
> +	if (spinning.prev)
> +		sync_set_bit(percpu_read(poll_evtchn),
> +			     xen_shared_info->evtchn_pending);
> +
> +	percpu_write(_spinning, spinning.prev);
> +	rm_lock = &__get_cpu_var(spinning_rm_lock);
> +	raw_local_irq_save(flags);
> +	arch_write_lock(rm_lock);
> +	arch_write_unlock(rm_lock);
> +	raw_local_irq_restore(flags);
> +}
> +
> +static void xen_spin_unlock(struct arch_spinlock *lock, unsigned int token)
> +{
> +	unsigned int cpu;
> +
> +	token &= (1U << TICKET_SHIFT) - 1;
> +	for_each_online_cpu(cpu) {
> +		arch_rwlock_t *rm_lock;
> +		unsigned long flags;
> +		struct spinning *spinning;
> +
> +		if (cpu == raw_smp_processor_id())
> +			continue;
> +
> +		rm_lock = &per_cpu(spinning_rm_lock, cpu);
> +		raw_local_irq_save(flags);
> +		arch_read_lock(rm_lock);
> +
> +		spinning = per_cpu(_spinning, cpu);
> +		smp_rmb();
> +		if (spinning
> +		    && (spinning->lock != lock || spinning->ticket != token))
> +			spinning = NULL;
> +
> +		arch_read_unlock(rm_lock);
> +		raw_local_irq_restore(flags);
> +
> +		if (unlikely(spinning)) {
> +			struct evtchn_send send;
> +
> +			send.port = per_cpu(poll_evtchn, cpu);
> +			HYPERVISOR_event_channel_op(EVTCHNOP_send, &send);
> +			return;
> +		}
> +	}
> +}
> +
> +static void __init _prepare_shared_info_page(void)
> +{
> +	struct xen_add_to_physmap xatp;
> +
> +	xen_shared_info = slab_is_available()
> +			  ? (void *)get_zeroed_page(GFP_KERNEL)
> +			  : alloc_bootmem_pages(PAGE_SIZE);
> +
> +	xatp.domid = DOMID_SELF;
> +	xatp.idx = 0;
> +	xatp.space = XENMAPSPACE_shared_info;
> +	xatp.gpfn = __pa(xen_shared_info) >> PAGE_SHIFT;
> +	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
> +		BUG();
> +}
> +
> +static void __ref prepare_shared_info_page(void)
> +{
> +	_prepare_shared_info_page();
> +}
> +#endif
> +
> +static bool __cpuinit xen_platform(void)
> +{
> +	unsigned int first = XEN_CPUID_FIRST_LEAF;
> +
> +#if 0 /* So far, Xen sets this only for PV guests. */
> +	if (!cpu_has_hypervisor)
> +		return false;
> +#endif
> +
> +	while (first < XEN_CPUID_LEAF(0x10000)) {
> +		unsigned int eax, ebx, ecx, edx;
> +
> +		cpuid(first, &eax, &ebx, &ecx, &edx);
> +		if (ebx == XEN_CPUID_SIGNATURE_EBX
> +		    && ecx == XEN_CPUID_SIGNATURE_ECX
> +		    && edx == XEN_CPUID_SIGNATURE_EDX) {
> +			if (!smp_processor_id()) {
> +				cpuid(first + 1, &eax, &ebx, &ecx, &edx);
> +				printk(KERN_INFO "Running on Xen %u.%u\n",
> +				       eax >> 16, eax & 0xffff);
> +			}
> +			return true;
> +		}
> +		first += 0x100;
> +	}
> +
> +	return false;
> +}
> +
> +static void xen_set_cpu_features(struct cpuinfo_x86 *c)
> +{
> +#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
> +	unsigned int msr, eax, ebx, ecx, edx;
> +	unsigned int first = XEN_CPUID_FIRST_LEAF;
> +	int ret;
> +	struct vcpu_register_runstate_memory_area vrrma;
> +
> +	if (num_possible_cpus() <= 1
> +	    || !spin_count
> +	    || (c != &boot_cpu_data
> +		&& !boot_cpu_has(X86_FEATURE_SPINLOCK_YIELD)))
> +		return;
> +
> +	while (first < XEN_CPUID_LEAF(0x10000)) {
> +		cpuid(first, &eax, &ebx, &ecx, &edx);
> +		if (ebx == XEN_CPUID_SIGNATURE_EBX
> +		    && ecx == XEN_CPUID_SIGNATURE_ECX
> +		    && edx == XEN_CPUID_SIGNATURE_EDX)
> +			break;
> +		first += 0x100;
> +	}
> +	BUG_ON(first >= XEN_CPUID_LEAF(0x10000));
> +
> +	cpuid(first + 2, &eax, &msr, &ecx, &edx);
> +	BUG_ON(!eax);
> +	wrmsrl(msr, __pa_symbol(hypercall_page));
> +
> +	if (!xen_shared_info)
> +		prepare_shared_info_page();
> +
> +	memset(&vrrma, 0, sizeof(vrrma));
> +	set_xen_guest_handle(vrrma.addr.h, &__get_cpu_var(runstate));
> +	ret = HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
> +				 c->cpu_index, &vrrma);
> +	if (ret) {
> +		printk(KERN_WARNING
> +		       "Could not register runstate area for CPU%u: %d\n",
> +		       c->cpu_index, ret);
> +		BUG_ON(boot_cpu_has(X86_FEATURE_SPINLOCK_YIELD));
> +		return;
> +	}
> +
> +	if (c != &boot_cpu_data || !percpu_read(poll_evtchn)) {
> +		struct evtchn_bind_ipi bind_ipi;
> +
> +		bind_ipi.vcpu = c->cpu_index;
> +		ret = HYPERVISOR_event_channel_op(EVTCHNOP_bind_ipi,
> +						  &bind_ipi);
> +		if (ret) {
> +			printk(KERN_WARNING
> +			       "Could not bind event channel for CPU%u: %d\n",
> +			       c->cpu_index, ret);
> +			BUG_ON(boot_cpu_has(X86_FEATURE_SPINLOCK_YIELD));
> +			return;
> +		}
> +		sync_set_bit(bind_ipi.port, xen_shared_info->evtchn_mask);
> +		percpu_write(poll_evtchn, bind_ipi.port);
> +		printk(KERN_INFO "CPU%u spinlock poll event channel: %u\n",
> +		       c->cpu_index, bind_ipi.port);
> +	}
> +
> +	virt_spin_lock = xen_spin_lock;
> +	virt_spin_unlock = xen_spin_unlock;
> +	set_cpu_cap(c, X86_FEATURE_SPINLOCK_YIELD);
> +#endif
> +}
> +
> +const __refconst struct hypervisor_x86 x86_hyper_xen = {
> +	.name			= "Xen",
> +	.detect			= xen_platform,
> +	.set_cpu_features	= xen_set_cpu_features
> +};
>
>
>   

