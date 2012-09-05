Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab2IEO5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 10:57:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61487 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab2IEO5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 10:57:52 -0400
Message-ID: <5047686D.8060606@redhat.com>
Date: Wed, 05 Sep 2012 17:57:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: mst@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/2] kvm: On Ack, De-assert & Notify KVM_IRQFD extension
References: <20120821190800.24958.74812.stgit@bling.home> <20120821192911.24958.38609.stgit@bling.home>
In-Reply-To: <20120821192911.24958.38609.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 10:29 PM, Alex Williamson wrote:
> For VFIO based device assignment we'd like a mechanism to allow level
> triggered interrutps to be directly injected into KVM.  KVM_IRQFD
> already allows this for edge triggered interrupts, but for level, we
> need to watch for acknowledgement of the interrupt from the guest to
> provide us a hint when to test the device and allow it to re-assert
> if necessary.  To do this, we create a new KVM_IRQFD mode called
> "On Ack, De-assert & Notify", or OADN.  In this mode, an interrupt
> injection provides only a gsi assertion.  We then hook into the IRQ
> ACK notifier, which when triggered de-asserts the gsi and notifies
> via another eventfd.  It's then the responsibility of the user to
> re-assert the interrupt is service is still required.
> 
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index bf33aaa..87d7321 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1946,6 +1946,19 @@ the guest using the specified gsi pin.  The irqfd is removed using
>  the KVM_IRQFD_FLAG_DEASSIGN flag, specifying both kvm_irqfd.fd
>  and kvm_irqfd.gsi.
>  
> +With KVM_CAP_IRQFD_OADN, KVM_IRQFD supports an "On Ack, De-assert &
> +Notify" option that allows emulation of level-triggered interrupts.
> +When kvm_irqfd.fd is triggered, the requested gsi is asserted and
> +remains asserted until interaction with the irqchip indicates the
> +VM has acknowledged the interrupt, such as an EOI.  On acknoledgement
> +the gsi is automatically de-asserted and the user is notified via
> +kvm_irqfd.notifyfd.  The user is then required to re-assert the
> +interrupt if the associated device still requires service.  To enable
> +this mode, configure the KVM_IRQFD using the KVM_IRQFD_FLAG_OADN flag
> +and specify kvm_irqfd.notifyfd.  Note that closing kvm_irqfd.notifyfd
> +while configured in this mode does not disable the irqfd.  The
> +KVM_IRQFD_FLAG_OADN flag is only necessary on assignment.

Under my suggested naming, this would be called a "resampling irqfd",
with resampling requested via kvm_irqfd.resamplefd.

> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 2245cfa..dfdb5b2 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -43,6 +43,23 @@
>   * --------------------------------------------------------------------
>   */
>  
> +/*
> + * OADN irqfds (On Ack, De-assert & Notify) are a special variety of
> + * irqfds that assert an interrupt to the irqchip on eventfd trigger,
> + * receieve notification when userspace acknowledges the interrupt,
> + * automatically de-asserts the irqchip level, and notifies userspace
> + * via the oadn_eventfd.  This object helps to provide one-to-many
> + * deassert-to-notify so we can share a single irq source ID per OADN.
> + */
> +struct _irqfd_oadn {
> +	struct kvm *kvm;
> +	int irq_source_id; /* IRQ source ID shared by these irqfds */
> +	struct list_head irqfds; /* list of irqfds using this object */
> +	struct kvm_irq_ack_notifier notifier; /* IRQ ACK notification */
> +	struct kref kref; /* Race-free removal */
> +	struct list_head list;
> +};


Why do you need per-gsi irq source IDs?  irq source ids only matter
within a gsi.  For example KVM_IRQ_LINE shares one source ID for all
lines (with result that userspace is forced to manage the ORing of
shared inputs itself).




-- 
error compiling committee.c: too many arguments to function
