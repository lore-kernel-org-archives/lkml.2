Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab0KRNDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:03:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261Ab0KRNDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:03:52 -0500
Date: Thu, 18 Nov 2010 15:03:37 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Gregory Haskins <ghaskins@novell.com>,
        Chris Lalancette <clalance@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: fast-path msi injection with irqfd
Message-ID: <20101118130337.GA2254@redhat.com>
References: <20101117221254.GA8296@redhat.com>
 <20101118105741.GA31261@redhat.com>
 <4CE50810.3090502@redhat.com>
 <20101118111037.GB31261@redhat.com>
 <4CE51C17.4000108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE51C17.4000108@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 02:29:11PM +0200, Avi Kivity wrote:
> On 11/18/2010 01:10 PM, Michael S. Tsirkin wrote:
> >>  I guess I should create an empty Documentation/kvm/locking.txt and
> >>  force everyone else to update it.
> >
> >Comments near the relevant fields not better?
> >
> 
> Not an either/or.  You can't understand the system from random
> source comments.
> 
> >diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >index a055742..d13ced3 100644
> >--- a/include/linux/kvm_host.h
> >+++ b/include/linux/kvm_host.h
> >@@ -16,6 +16,7 @@
> >  #include<linux/mm.h>
> >  #include<linux/preempt.h>
> >  #include<linux/msi.h>
> >+#include<linux/rcupdate.h>
> >  #include<asm/signal.h>
> >
> >  #include<linux/kvm.h>
> >@@ -206,6 +207,8 @@ struct kvm {
> >
> >  	struct mutex irq_lock;
> >  #ifdef CONFIG_HAVE_KVM_IRQCHIP
> >+	/* Update side is protected by irq_lock and,
> >+	 * if configured, irqfds.lock. */
> 
> /*
>  * kernel style comment
>  * here and elsewhere
>  */
> 
> 
> 
> >  	struct kvm_irq_routing_table __rcu *irq_routing;
> >  	struct hlist_head mask_notifier_list;
> >  	struct hlist_head irq_ack_notifier_list;
> >@@ -462,6 +465,8 @@ void kvm_get_intr_delivery_bitmask(struct kvm_ioapic *ioapic,
> >  				   unsigned long *deliver_bitmask);
> >  #endif
> >  int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level);
> >+int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
> >+		int irq_source_id, int level);
> 
> No point in the level argument for an msi specific function.

This is an existing function I made non-static.
We have per-gsi callbacks so level is required there to match.
I could add a wrapper I guess:

int kvm_set_msi(struct kvm_kernel_irq_routing_entry *irq_entry, struct kvm *kvm,
		int irq_source_id, int level)
{
	if (!level)
		return -1;
	return kvm_send_msi(irq_entry, kvm, irq_source_id);
}

This results in less code for irqfd but more code for ioctl injection
... is it worth it?

> >
> >  #else
> >@@ -614,6 +620,12 @@ static inline int kvm_irqfd(struct kvm *kvm, int fd, int gsi, int flags)
> >  }
> >
> >  static inline void kvm_irqfd_release(struct kvm *kvm) {}
> 
> blank line
> 

There's no line before kvm_eventfd_init either ...
I added one.

> >+static inline void kvm_irq_routing_update(struct kvm *kvm,
> >+					  struct kvm_irq_routing_table *irq_rt)
> >+{
> >+	rcu_assign_pointer(kvm->irq_routing, irq_rt);
> >+}
> >+
> >  static inline int kvm_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
> >  {
> >  	return -ENOSYS;
> 
> Apart from these minor issues, looks good.


Something we should consider improving is the loop over all VCPUs that
kvm_irq_delivery_to_apic invokes.  I think that (for non-broadcast
interrupts) it should be possible to precompute an store the CPU
in question as part of the routing entry.

Something for a separate patch ... comments?

> -- 
> error compiling committee.c: too many arguments to function
